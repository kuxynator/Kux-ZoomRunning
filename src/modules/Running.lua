require "modules.PlayerMemory"
require "modules.Settings"

local this = nil

Running = {
	moduleName = "Running",

    -- TODO recalculate on equipment changed, on inhibit_movement_bonus changed
    -- or on player.character.moving is changed from false to true 
    -- are there events?
    -- DRAWBACK the battery is also consumed when the player is running slowly    
--[[
    game.players[1].character.character_running_speed_modifier
    game.players[1].character.character_running_speed
]]--

    refreshAfterEvent= function(event)
        if not event.player_index then
            for playerIndex, player in pairs(game.players) do
                if(not player.valid) then goto next end
                if(not player.character) then goto next end
                local pm = PlayerMemory.get(playerIndex)
                this.onZoomFactorChanged({
                    tick = event.tick,
                    zoomFactor = pm.lastGameZoomLevel or 1,
                    renderMode = pm.player.render_mode,
                    playerIndex = playerIndex
                })
                ::next::
            end
        else
            local playerIndex = event.player_index
            if not playerIndex then return end
            local pm = PlayerMemory.get(playerIndex)
            this.onZoomFactorChanged({
                tick = event.tick,
                zoomFactor = pm.lastGameZoomLevel or 1,
                renderMode = pm.player.render_mode,
                playerIndex = playerIndex
            })
        end
    end,

    onZoomFactorChanged = function(event)
        local zoomFactor = event.zoomFactor
        local renderMode = event.renderMode
        local playerIndex = event.playerIndex

        --print("onZoomFactorChanged",zoomFactor,renderMode)
        --log("onZoomFactorChanged({"..zoomFactor..", "..renderMode.."})")
        local player = game.players[playerIndex]
        local pm = PlayerMemory.get(player)
        -- pm.renderMode = renderMode
        -- pm.zoomFactor = zoomFactor

        if not player.character or renderMode ~= defines.render_mode.game then return end
        
        -- player-character.grid.generator_energy
        -- player.character.grid.battery_capacity
        -- player.character.grid.available_in_batteries
        -- player.character.character_running_speed

        local possibleBonus = Tools.getMovementBonus(player)

        local maxCharacterRunningSpeed = 0.15 * (possibleBonus+1) -- w/o character_running_speed_modifier
        local maxCharacterRunningSpeedModified = 0.15 * (possibleBonus+1) * (player.character_running_speed_modifier+1)
        local actualBonus = (player.character.character_running_speed / 0.15 / (player.character_running_speed_modifier+1))-1

        local currentBonus = possibleBonus
        if player.character.grid ==nil or player.character.grid.inhibit_movement_bonus == true then currentBonus = 0 end
        if actualBonus < currentBonus then currentBonus = 0 end --< maybe no power, then trim too

        local modifier = (1/zoomFactor) * Settings.getZoomSpeedModificator(player)
        -- UPS adjustments 
        modifier = modifier * Settings.getUpsAdjustment(player)
         -- neutralize the equipment movement bonus, so player speed depends only on zoom (and tile speed)
        modifier = modifier / (currentBonus+1)
        -- shift the range to -1..0..∞
        modifier = modifier -1
        -- limit the modifier if not in cheat mode
        if (Settings.getCheatMode(player)~=true) and (modifier > 0) then modifier = 0 end

        --[[
        log("\n"..
            "  zoomFactor:  "..zoomFactor.."\n"..
            "  modifier:    "..modifier.."\n"..
            "  currentBonus:"..currentBonus.."\n"..
            "  actualBonus: "..actualBonus.."\n"
        )
        --]]

        pm.speedModifier = modifier
        if Settings.getDisableRunningSpeedModifier(player) ~= true then
            player.character_running_speed_modifier = pm.speedModifier
            --log("onZoomFactorChanged: "..zoomFactor..", character_running_speed_modifier:"..modifier..", player:"..event.playerIndex)
            --player.print("onZoomFactorChanged: "..zoomFactor..", character_running_speed_modifier:"..modifier)
        end
        --print("character_running_speed_modifier", pm.speedModifier)
    end,
}

this = Running -- init local this