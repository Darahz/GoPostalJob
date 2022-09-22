local QBCore = exports['qb-core']:GetCoreObject()

local jobDone = false
local startedJob = false
local jobCanceled = false

local ped = nil

local numberOfStops = 0

local veh = nil
local endBlip = nil
local goPostDeliveryBlip = nil
local rnd = 0

local function spawnPed()
    RequestModel(Config.Ped.Model)
    while not HasModelLoaded(Config.Ped.Model) do
        Wait(100)
    end
    ped = CreatePed(0,Config.Ped.Model,Config.Ped.Locaton,false,false)
    FreezeEntityPosition(ped,true)
    SetEntityInvincible(ped,true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    TaskStartScenarioInPlace(ped, Config.Ped.scenario, true, true)
    exports['qb-target']:AddTargetEntity(ped, {
        options = {
            {
                label = "Talk to GoPostal worker",
                icon = 'fa-solid fa-mailbox',
                event = 'prdx-gopostal:client:MainMenu',
            }
        },
        distance = 2.0
    })
end

local function deletePed()
    DeletePed(ped)
end

local function cleanupAfterJob()
    jobDone = false
    jobCanceled = false
    startedJob = false
    DeleteVehicle(veh)
    DeleteWaypoint()
    removePostalBlip()
end

local function spawnGoPostVeh()
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        veh = NetToVeh(netId)
        SetVehicleNumberPlateText(veh, Config.VehicleOptions.VehiclePlate .. tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        exports['qb-menu']:closeMenu()
        SetEntityAsMissionEntity(veh, true, true)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
    end, Config.VehicleOptions.VehicleHash, Config.VehicleOptions.VehicleSpawnPos, true)
end

local function drawMarkerOnLocation(loc)
    CreateThread(function()
        while jobDone == false do
            Citizen.Wait(0)
            DrawMarker(0, loc.x, loc.y, loc.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 191, 0, 50, false, true, 2, nil, nil, false)
        end
    end)
end

local function displayBlipOnLocation(loc,displayText)
    goPostDeliveryBlip = AddBlipForCoord(loc)
    SetBlipSprite(goPostDeliveryBlip, 501)
    SetBlipColour(goPostDeliveryBlip, 0)
    SetBlipScale (goPostDeliveryBlip, 0.7)
    SetBlipAsShortRange(goPostDeliveryBlip, true)
    
    SetBlipRoute(goPostDeliveryBlip, true)
    SetBlipRouteColour(goPostDeliveryBlip, 3)
    
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(displayText)
    EndTextCommandSetBlipName(goPostDeliveryBlip)
end

local function removePostalBlip()
    SetBlipRoute(goPostDeliveryBlip, false)
    RemoveBlip(goPostDeliveryBlip)
end

RegisterNetEvent('gprdx:gopostal:client:requestpaycheck', function()
    cleanupAfterJob()
    TriggerServerEvent('gprdx:gopostal:server:requestpaycheck')
end)

RegisterNetEvent('prdx-gopostal:client:canceljob', function()
    removePostalBlip()
    DeleteVehicle(veh)
    DeleteWaypoint()
    cleanupAfterJob()
end)

RegisterNetEvent('prdx-gopostal:client:startpostaljob', function()
    local job = Config.PostalRoutes.Jobs[math.random(#Config.PostalRoutes.Jobs)]
    local currentRoute = nil

    startedJob  = true
    jobCanceled = false

    spawnGoPostVeh()

    for i = 0, (#job.routes - 1) do
        currentRoute = job.routes[i]
        endBlip = vector2(currentRoute.location.x, currentRoute.location.y)
        rnd = math.random(1000)

        local itemToDeliver = Config.DeliveryTypes[math.random(#Config.DeliveryTypes)];
        local labelTxt = tostring("Deliver " .. itemToDeliver .. "")

        exports['qb-target']:AddBoxZone("gopostal_"..rnd, vector3(currentRoute.location.x, currentRoute.location.y, currentRoute.location.z), 1, 1, {
            name = "gopostal_"..rnd,
            heading = currentRoute.location.w,
            debugPoly = false,
            minZ = currentRoute.location.z - 1,
            maxZ = currentRoute.location.z + 1
        }, {
            options = {
                {
                    label = labelTxt,
                    icon = 'fa-solid fa-mailbox',
                    action = function()
                        TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
                        QBCore.Functions.Progressbar("deliver_mail", "Delivering " .. itemToDeliver, math.random(5000, 10000), false, true, {
                            disableMovement = true,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {}, {}, {}, function() -- Done
                            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                            jobDone = true
                            exports['qb-target']:RemoveZone("gopostal_"..rnd)
                        end, function() -- Cancel
                            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                        end)
                    end,
                }
            },
            distance = 2.0
        })
        
        QBCore.Functions.Notify("[" .. i .. "/" .. #job.routes -1 .. "]" .. " Drawing route : " .. job.routes[i].name , "success")

        displayBlipOnLocation(currentRoute.location,"Package Delivery")
        drawMarkerOnLocation(currentRoute.location)
        while jobDone == false do
            Citizen.Wait(1000)
        end
        removePostalBlip()
        if jobCanceled == true then
            cleanupAfterJob()
            break
        end

        jobDone = false
    end

    currentRoute = job.routes[#job.routes] -- Return to GoPostal HQ

    QBCore.Functions.Notify("Good job! Time to back to GoPostal" , "success")
    SetNewWaypoint(currentRoute.location.x, currentRoute.location.y)
    numberOfStops = #job.routes
end)

RegisterNetEvent('prdx-gopostal:client:MainMenu', function()
    local MainMenu = {
        {
            isMenuHeader = true,
            header = "GoPostal - Postal service job"
        },
        {
            header = "Collect Paycheck",
            txt = "Return truck and collect paycheck here!",
            params = {
                event = 'prdx-gopostal:client:RequestPaycheck',
            }
        },
        {
            header = "Start GoPost job",
            txt = "Request a postal route",
            hidden = startedJob,
            params = {
                event = 'prdx-gopostal:client:startpostaljob',
            }
        },
        {
            header = "Cancel current job",
            txt = "Cancel this postal route",
            hidden = not startedJob,
            params = {
                event = 'prdx-gopostal:client:canceljob',
            }
        }
    }

    exports['qb-menu']:openMenu(MainMenu)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        spawnPed()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    DeleteVehicle(veh)
    DeleteWaypoint()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    print("Ped spawned")
    spawnPed()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    print("Ped removed")
    deletePed()
end)

RegisterCommand("nextroute",function()
    jobDone = true
end, false)

RegisterCommand("spawngopostalped",function()
    spawnPed()
end, false)