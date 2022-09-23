--Paycheck something
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('prdx-gopostal:server:server:PayShift', function(dist)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    Player.Functions.AddMoney("bank", dist , 'gopostal-payslip')
    print("payed?")
end)