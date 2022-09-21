local QBCore = exports['qb-core']:GetCoreObject()
local jobDone = false
local startedJob = false
local jobCanceled = false

local numberOfStops = 0

local veh = nil
local endBlip = nil
local rnd = 0

local function SpawnJobPed()
    RequestModel(Config.Ped.Model)
    while not HasModelLoaded(Config.Ped.Model) do
        Wait(100)
    end
    local ped = CreatePed(0,Config.Ped.Model,Config.Ped.Locaton,false,false)
    FreezeEntityPosition(ped,true)
    SetEntityInvincible(ped,true)
    SetBlockingOfNonTemporaryEvents(ped, true)
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

local function SpawnGoPostVeh()
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

RegisterNetEvent('gprdx:gopostal:client:requestpaycheck', function()
    TriggerServerEvent('gprdx:gopostal:server:requestpaycheck')
end)

RegisterNetEvent('prdx-gopostal:client:StartPostalJob', function()

    SpawnGoPostVeh()

    local job = Config.PostalRoutes.Jobs[math.random(#Config.PostalRoutes.Jobs)]
    
    local currentRoute = nil
    startedJob  = true
    jobCanceled = false
    for i = 0, (#job.routes - 1) do
        currentRoute = job.routes[i]
        endBlip = vector2(currentRoute.location.x, currentRoute.location.y)
        rnd = math.random(1000)

        local itemToDeliver = Config.DeliveryTypes[math.random(#Config.DeliveryTypes)];
        local labelTxt = tostring("Deliver " .. itemToDeliver .. "")

        SetNewWaypoint(endBlip.x,endBlip.y)

        exports['qb-target']:AddBoxZone("gopostal_"..rnd, vector3(currentRoute.location.x, currentRoute.location.y, currentRoute.location.z), 1, 1, {
            name = "gopostal_"..rnd,
            heading = currentRoute.location.w,
            debugPoly = true,
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
        while jobDone == false do
            Citizen.Wait(1000)
        end

        if jobCanceled == true then
            jobDone = false
            jobCanceled = false
            startedJob = false
            DeleteWaypoint()
            break
        end

        jobDone = false
    end

    currentRoute = job.routes[#job.routes]

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
                event = 'prdx-gopostal:client:StartPostalJob',
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


RegisterCommand("startpostalroute",function()
    SpawnJobPed()
end, false)

RegisterCommand("nextroute",function()
    jobDone = true
end, false)