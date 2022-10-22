require "modules.PlayerMemory"
require "modules.Settings"

local this = nil

Running = {
	moduleName = "Running",

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

        local modifier = (1/zoomFactor) * Settings.getZoomSpeedModificator(player) * Settings.getUpsAdjustment(player) -1
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