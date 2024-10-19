local RSGCore = exports['rsg-core']:GetCoreObject()
local DeliverPrompt
local hasAlreadyEnteredMarker, lastZone
local currentZone = nil
local active = false
local pressed = false

----------------
--- PROMPT
----------------


function SetupDeliverPrompt()
    Citizen.CreateThread(function()
        local str = 'Ver Inventário'
        DeliverPrompt = PromptRegisterBegin()
        PromptSetControlAction(DeliverPrompt, "INPUT_CREATOR_ACCEPT")     -- 0xE8342FF2
        str = CreateVarString(10, 'LITERAL_STRING', str)
        PromptSetText(DeliverPrompt, str)
        PromptSetEnabled(DeliverPrompt, false)
        PromptSetVisible(DeliverPrompt, false)
        PromptSetHoldMode(DeliverPrompt, true)
        PromptRegisterEnd(DeliverPrompt)
    end)
end

--------------
-- - SE O PROMPT FICA VISIVEL OU NÃO
--------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if currentZone then
            if active == false then
                PromptSetEnabled(DeliverPrompt, true)
                PromptSetVisible(DeliverPrompt, true)
                active = true
            end
            if PromptHasHoldModeCompleted(DeliverPrompt) then
                PromptSetEnabled(DeliverPrompt, false)
                PromptSetVisible(DeliverPrompt, false)
                pressed = true
                active = false
                currentZone = nil
            end
        else
            Citizen.Wait(500)
        end
        -- end
    end
end)

--------------
-- - Locais que o PROMPT vai aparecer
--------------


Citizen.CreateThread(function()
        SetupDeliverPrompt()
        while true do
            Citizen.Wait(10)
            local player = PlayerPedId()
            local coords = GetEntityCoords(player)
            local isInMarker, currentZone = false
            local player, distance = RSGCore.Functions.GetClosestPlayer()

            -- if not IsPedRagdoll(cache.ped) then
                if player ~= -1 and distance < 2 then

                    local playerPed = GetPlayerPed(player)
                    local playerId = GetPlayerServerId(player)
                    local isdead = IsEntityDead(playerPed)
                    local cuffed = IsPedCuffed(playerPed)
                    local hogtied = Citizen.InvokeNative(0x3AA24CCC0D451379, playerPed)
                    local lassoed = Citizen.InvokeNative(0x9682F850056C9ADE, playerPed)
                    local ragdoll = IsPedRagdoll(playerPed)
                    if isdead or cuffed or hogtied or lassoed or ragdoll or IsEntityPlayingAnim(playerPed, "script_proc@robberies@homestead@lonnies_shack@deception", "hands_up_loop", 3) then
                        isInMarker  = true
                        currentZone = 'rob'
                        lastZone    = 'rob'
                    end
                end

            if isInMarker and not hasAlreadyEnteredMarker then
                hasAlreadyEnteredMarker = true
                TriggerEvent('btc-roberyplayer:inZone', currentZone)
            end

            if not isInMarker and hasAlreadyEnteredMarker then
                hasAlreadyEnteredMarker = false
                TriggerEvent('btc-roberyplayer:offZone', lastZone)
            end
        end
end)

AddEventHandler('btc-roberyplayer:inZone', function(zone)
    currentZone = zone
end)

AddEventHandler('btc-roberyplayer:offZone', function(zone)
    if active == true then
        PromptSetEnabled(DeliverPrompt, false)
        PromptSetVisible(DeliverPrompt, false)
        active = false
        pressed = false
    end
    currentZone = nil
end)
--------------
-- - Fazendo o Prompt Funcionar e charmar um trigger
--------------
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        -- if not IsPedRagdoll(cache.ped) then
            local player, distance = RSGCore.Functions.GetClosestPlayer()
            if player ~= -1 and distance < 2 then
                local playerPed = GetPlayerPed(player)
                local playerId = GetPlayerServerId(player)
                local isdead = IsEntityDead(playerPed)
                local cuffed = IsPedCuffed(playerPed)
                local hogtied = Citizen.InvokeNative(0x3AA24CCC0D451379, playerPed)
                local lassoed = Citizen.InvokeNative(0x9682F850056C9ADE, playerPed)
                local ragdoll = IsPedRagdoll(playerPed)
                if isdead or cuffed or hogtied or lassoed or ragdoll or IsEntityPlayingAnim(playerPed, "script_proc@robberies@homestead@lonnies_shack@deception", "hands_up_loop", 3) then
                    
                    if pressed then
                        TriggerServerEvent('btc-roberyplayer:RobPlayer')
                        pressed = false
                    end
                end
            end
        end
    -- end
end)

------------------
--- Roberyplayer
------------------

-- Citizen.CreateThread(function()
--     print('funcionei')
--     local group = "interaction"
--     local title = "Olhar inventário"
--     local keyLabel = "Roubar"
--     local key = "INPUT_ENTER"
--     local duration = 1000


--     while true do
--     Wait(10)
--     if not IsPedRagdoll(cache.ped) then
--         local player, distance = RSGCore.Functions.GetClosestPlayer()
--         if player ~= -1 and distance < Config.SearchDistance then
--             local playerPed = GetPlayerPed(player)
--             local playerId = GetPlayerServerId(player)
--             local isdead = IsEntityDead(playerPed)
--             local cuffed = IsPedCuffed(playerPed)
--             local hogtied = Citizen.InvokeNative(0x3AA24CCC0D451379, playerPed)
--             local lassoed = Citizen.InvokeNative(0x9682F850056C9ADE, playerPed)
--             local ragdoll = IsPedRagdoll(playerPed)
--             if isdead or cuffed or hogtied or lassoed or ragdoll or IsEntityPlayingAnim(playerPed, "script_proc@robberies@homestead@lonnies_shack@deception", "hands_up_loop", 3) then
--                 jo.prompt.create(group,keyLabel,key, duration)
--                 jo.displayGroup(group)
--                 if jo.prompt.isCompleted(group,key) then
--                     jo.prompt.deleteGroup(group)
--                     print('fui')
--                 TriggerServerEvent('btc-roberyplayer:RobPlayer')
--                 end
--             end
--         end
--     end
--     end
-- end)
