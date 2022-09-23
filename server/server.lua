--Paycheck something
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('prdx-gopostal:server:server:PayShift', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CitizenId = Player.PlayerData.citizenid
    Player.Functions.AddMoney("bank", 1000 , 'garbage-payslip')
    print("payed?")
end)