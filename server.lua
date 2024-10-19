local RSGCore = exports['rsg-core']:GetCoreObject()

RegisterNetEvent('btc-roberyplayer:RobPlayer', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end
    local player, distance = RSGCore.Functions.GetClosestPlayer(src)
    if player ~= -1 and distance < 2 then
        local SearchedPlayer = RSGCore.Functions.GetPlayer(tonumber(player))
        if not SearchedPlayer then return end
        exports['rsg-inventory']:OpenInventoryById(src, tonumber(player))
    end
end)