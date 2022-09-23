local QBCore = exports['qb-core']:GetCoreObject()

local jobStarted = false
local jobCanceled = false
local jobFinished = false

local ped = nil
local veh = nil
local goPostDeliveryBlip = nil
local drawMarkerForLocation = false
local numberOfStops = 0
local currentStop = nil

local function spawnPed()
    RequestModel(Config.Ped.Model)
    while not HasModelLoaded(Config.Ped.Model) do
        Wait(100)
    end
    ped = CreatePed(0,Config.Ped.Model,Config.Ped.Location,false,false)
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

local function cleanupAfterJob()
    jobCanceled = false
    jobStarted  = false
    jobFinished = false

    if veh then
        DeleteVehicle(veh)
        DeleteWaypoint()
        removePostalBlip()
    end
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

local function displayGoPostalBlip()
    local goPostal = AddBlipForCoord(Config.GoPostalJobBlip.location)
    SetBlipSprite(goPostal, Config.GoPostalJobBlip.blip)
    SetBlipColour(goPostal, Config.GoPostalJobBlip.color)
    SetBlipScale (goPostal, 1.0)
    SetBlipAsShortRange(goPostal, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("GoPostal post delivery")
    EndTextCommandSetBlipName(goPostal)
end

local function drawMarkerOnLocation(loc)
    CreateThread(function()
        while drawMarkerForLocation == true do
            Citizen.Wait(0)
            DrawMarker(0, loc.x, loc.y, loc.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 1.0, 255, 191, 0, 50, false, true, 2, nil, nil, false)
        end
        drawMarkerForLocation = true
    end)
end

local function displayBlipOnLocation(loc,displayText)
    if goPostDeliveryBlip then RemoveBlip(goPostDeliveryBlip) end
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
    if goPostDeliveryBlip then
        SetBlipRoute(goPostDeliveryBlip, false)
        RemoveBlip(goPostDeliveryBlip)
    end
end

local function DrawBoxForDelivery(stop)
    local itemToDeliver = Config.DeliveryTypes[math.random(#Config.DeliveryTypes)];
    local labelTxt = tostring("Deliver " .. itemToDeliver .. "")
    local rnd = 0
    exports['qb-target']:AddBoxZone("gopostal_"..rnd, vector3(stop.location.x, stop.location.y, stop.location.z), 1, 1, {
        name = "gopostal_"..rnd,
        heading = stop.location.w,
        debugPoly = false,
        minZ = stop.location.z - 1,
        maxZ = stop.location.z + 1
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
                        TriggerEvent('prdx-gopostal:client:NextRoute')
                        drawMarkerForLocation = false
                        exports['qb-target']:RemoveZone("gopostal_"..rnd)
                    end, function() -- Cancel
                        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    end)
                end,
            }
        },
        distance = 2.0
    })
end

RegisterNetEvent('prdx-gopostal:client:requestpaycheck', function()
    cleanupAfterJob()
    QBCore.Functions.Notify("GoPostal vehicle returned")
    TriggerServerEvent('prdx-gopostal:server:server:PayShift')
end)

RegisterNetEvent('prdx-gopostal:client:CancelShift', function()
    TriggerServerEvent('prdx-gopostal:server:CancelShift')
    cleanupAfterJob()
    removePostalBlip()
    DeleteVehicle(veh)
    DeleteWaypoint()
end)

RegisterNetEvent('prdx-gopostal:client:NewShift', function()
    spawnGoPostVeh()
    QBCore.Functions.TriggerCallback('prdx-gopostal:server:NewShift', function(shouldContinue, firstStop, totalStops)
        numberOfStops = totalStops
        drawMarkerForLocation = true
        drawMarkerOnLocation(firstStop.location)
        displayBlipOnLocation(firstStop.location,"Package Delivery")
        currentStop = firstStop
        DrawBoxForDelivery(currentStop)
    end)
end)

RegisterNetEvent('prdx-gopostal:client:NextRoute', function()
    QBCore.Functions.TriggerCallback('prdx-gopostal:server:NextRoute', function(nextStop, lastStop)
        if lastStop == false then
            drawMarkerOnLocation(nextStop.location)
            displayBlipOnLocation(nextStop.location,"Package Delivery")
            currentStop = nextStop
            DrawBoxForDelivery(currentStop)

            local playerPos = GetEntityCoords(PlayerPedId())
            local targetPos = vector3(nextStop.location.x, nextStop.location.y, nextStop.location.z)
            local distance = #(playerPos - targetPos)
            TriggerServerEvent('prdx-gopostal:server:AddMilesToRoute', math.floor(distance))
        else
            QBCore.Functions.Notify("Good job! Time to back to GoPostal" , "success")
            SetNewWaypoint(Config.PostalRoutes.GoPostalHQ.x, Config.PostalRoutes.GoPostalHQ.y)
        end
    end)
end)

RegisterNetEvent('prdx-gopostal:client:MainMenu', function()
    QBCore.Functions.TriggerCallback('prdx-gopostal:server:GetJobStatus', function(started, finished, canceled)
        if started  == nil then jobStarted  = false else jobStarted  = started  end
        if finished == nil then jobFinished = false else jobFinished = finished end
        if canceled == nil then jobCanceled = false else jobCanceled = canceled end
    end)

    local MainMenu = {
        {
            isMenuHeader = true,
            header = "GoPostal - Postal service job"
        },
        {
            header = "Finish job",
            txt = "Request your payment and return vehicle",
            hidden = not jobFinished,
            params = {
                event = 'prdx-gopostal:client:requestpaycheck',
            }
        },
        {
            header = "Start GoPost job",
            txt = "Request a postal route",
            hidden = jobStarted,
            params = {
                event = 'prdx-gopostal:client:NewShift',
            }
        },
        {
            header = "Cancel current job",
            txt = "Cancel this postal route",
            hidden = not jobStarted,
            params = {
                event = 'prdx-gopostal:client:CancelShift',
            }
        }
    }

    exports['qb-menu']:openMenu(MainMenu)
end)

-- Spawn ped/Remove

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        spawnPed()
        displayGoPostalBlip()
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        DeleteVehicle(veh)
        DeleteWaypoint()
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    spawnPed()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    DeletePed(ped)
end)