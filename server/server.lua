--Paycheck something
local QBCore = exports['qb-core']:GetCoreObject()
local routes = {}

RegisterNetEvent('prdx-gopostal:server:PayShift', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    local routeData = routes[CitizenId]
    if routeData then
        local payout = routeData.travelDistance
        Player.Functions.AddMoney("bank", payout , 'gopostal-payslip')
    end
    
end)

RegisterNetEvent('prdx-gopostal:server:AddMilesToRoute', function(dist)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    routes[CitizenId].travelDistance = routes[CitizenId].travelDistance + dist
    print("Citizen travel dist" .. CitizenId, routes[CitizenId].travelDistance)
end)

RegisterNetEvent('prdx-gopostal:server:CancelShift', function(dist)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    routes[CitizenId] = {
        routes = nil,
        firstStop = nil,
        started = nil,
        canceled = nil,
        finished = nil,
        travelDistance = nil,
        totalStops = nil,
        currentRoute = nil
    }
    TriggerClientEvent('QBCore:Notify', source, "Job canceled", "success")
end)

QBCore.Functions.CreateCallback('prdx-gopostal:server:NewShift',function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    local route = Config.PostalRoutes.Jobs[math.random(#Config.PostalRoutes.Jobs)]

    routes[CitizenId] = {
        routes = route.routes,
        firstStop = route.routes[0],
        started = true,
        canceled = false,
        finished = false,
        travelDistance = 0,
        totalStops = #route.routes,
        currentRoute = 0
    }
    
    TriggerClientEvent('QBCore:Notify', source, "First route : " .. routes[CitizenId].firstStop.name, "success")
    TriggerClientEvent('QBCore:Notify', source, "Route assigned : " .. route.name, "success")
    
    cb(true, routes[CitizenId].firstStop,routes[CitizenId].totalStops)
end)

QBCore.Functions.CreateCallback('prdx-gopostal:server:NextRoute',function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    local currentStopNum = routes[CitizenId].currentRoute + 1
    routes[CitizenId].currentRoute = currentStopNum

    local currentStopName = routes[CitizenId].routes[currentStopNum].name
    local currentStop = routes[CitizenId].routes[currentStopNum]

    if currentStopNum > routes[CitizenId].totalStops - 1 then 
        routes[CitizenId].finished = true
    else
        routes[CitizenId].finished = false
        TriggerClientEvent('QBCore:Notify', source, "[" .. currentStopNum .. "/" .. routes[CitizenId].totalStops - 1 .. "]" .. " Drawing route : " .. currentStopName, "success")
    end
    cb(currentStop, routes[CitizenId].finished)

end)

QBCore.Functions.CreateCallback('prdx-gopostal:server:GetJobStatus',function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local CitizenId = Player.PlayerData.citizenid

    if routes[CitizenId] then
        local canceled = routes[CitizenId].canceled
        local started  = routes[CitizenId].started
        local finished = routes[CitizenId].finished
        print(started,finished,canceled)
        cb(started,finished,canceled)
    end

end)
