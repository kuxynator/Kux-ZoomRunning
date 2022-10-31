modules = {}

ModPrefix="Kux-ZoomRunning"
ModName="Kux-ZoomRunning"

require("modules.PlayerMemory")
require("modules.Settings")
require("modules.ZoomCalculator")
local binoculars_controler = require("modules/binoculars_controler")
local constants            = require("constants")
local debug                = require("lib/debug")
local interface            = require("modules/interface")

if script.active_mods["gvv"] then require("__gvv__.gvv")() end

local function syncZoomLevel(player)
    local zoomLevel = nil
    local lastRenderModee = PlayerMemory.getLastRenderMode(player)
    local wasInSync = nil

    if player.render_mode == 1 and lastRenderModee ~= 1 then
        zoomLevel = PlayerMemory.getLastGameZoomLevel(player)
        --debug.trace("getLastGameZoomLevel: ",PlayerMemory.getLastGameZoomLevel(player))
        wasInSync = false
    elseif player.render_mode ~= 1 and lastRenderModee == 1 then
        zoomLevel = PlayerMemory.getLastChartZoomLevel(player)
        if zoomLevel > constants.BaseMapWorldThreshold then zoomLevel = constants.BaseMapWorldThreshold end
        --debug.trace("getLastChartZoomLevel: ",PlayerMemory.getLastChartZoomLevel(player))
        wasInSync = false
    else
        zoomLevel = PlayerMemory.getCurrentZoomLevel(player)zoomLevel = PlayerMemory.getCurrentZoomLevel(player)
        wasInSync = true
    end

	if wasInSync == false then
		PlayerMemory.setHasMapMoved(player, true) -- maybe not moved but no warranty, so we set it to true
        PlayerMemory.setCurrentZoomLevel(player, zoomLevel)
        debug.trace("zoomLevel: ",zoomLevel," (",player.render_mode,"<",PlayerMemory.getLastRenderMode(player),")")
    end

    return zoomLevel
end

local function zoomIn(player, tick)
    -- prevents double-zoom-in when user has the same key assigned to both actions (in such case both events have the same tick)
    if tick == PlayerMemory.getLastZoomInTick(player) then return
    else PlayerMemory.setLastZoomInTick(player, tick) end

    local zoomLevel = syncZoomLevel(player)
    local renderMode = player.render_mode

	if player.render_mode == defines.render_mode.game then	
        zoomLevel = ZoomCalculator.calculateZoomedInLevel(player)
        player.zoom = zoomLevel
        debug.trace("zoomLevel: "..zoomLevel)
		--player.character_running_speed_modifier = 1 / zoomLevel
	else
		zoomLevel = ZoomCalculator.updateCurrentZoom_ByUserZoomingInOnMap(player)
        --player.open_map(PlayerMemory.getLastKnownMapPosition(player), zoomLevel)
        debug.trace("zoomLevel: "..zoomLevel)
        --player.character_running_speed_modifier = 1 / zoomLevel
    end

    PlayerMemory.setLastRenderMode(player, renderMode)
    if renderMode == defines.render_mode.game then
        PlayerMemory.setLastGameZoomLevel(player, zoomLevel)
    else
        PlayerMemory.setLastChartZoomLevel(player, zoomLevel)
	end
	interface.onZoomFactorChanged_raise(player, zoomLevel, renderMode)
end

local function zoomOut(player, tick)
    --debug.trace(ModPrefix.."_alt-zoom-out");

    local zoomLevel = syncZoomLevel(player)
    local renderMode = player.render_mode

    local shouldSwitchBackToMap = ZoomCalculator.getShouldSwitchBackToMap(player)
    local zoomLevel = 1

--[[
    if shouldSwitchBackToMap then
            local mapZoomLevel = ZoomCalculator.calculateZoomOut_backToMapView(player)
            player.open_map(PlayerMemory.getLastKnownMapPosition(player), mapZoomLevel)
        return
    end
]]--
    if player.render_mode == defines.render_mode.game then
        zoomLevel = ZoomCalculator.calculateZoomedOutLevel(player)
		player.zoom = zoomLevel		
        debug.trace("zoomLevel: "..zoomLevel)
		--player.character_running_speed_modifier = 1 / zoomLevel
	else
		zoomLevel = ZoomCalculator.updateCurrentZoom_ByUserZoomingOutOnMap(player)
        --zoomLevel = ZoomCalculator.calculateZoomedOutLevel(player)
        --player.open_map(PlayerMemory.getLastKnownMapPosition(player), zoomLevel)
        debug.trace("zoomLevel: "..zoomLevel)
    end

    PlayerMemory.setLastRenderMode(player, renderMode)
    if renderMode == defines.render_mode.game then
        PlayerMemory.setLastGameZoomLevel(player, zoomLevel)
    else
        PlayerMemory.setLastChartZoomLevel(player, zoomLevel)
	end
	interface.onZoomFactorChanged_raise(player, zoomLevel, renderMode)
end

local function toggleMap(player)
    local zoomLevel = PlayerMemory.getCurrentZoomLevel(player)
    local renderMode = player.render_mode

    if player.render_mode == defines.render_mode.game then
        PlayerMemory.setLastGameZoomLevel(player, zoomLevel) -- store current zoom level

        -- toggle to map
        zoomLevel = ZoomCalculator.calculateOpenMapZoomLevel(player)
        player.open_map(player.position, zoomLevel)
        renderMode = defines.render_mode.chart
        PlayerMemory.setLastKnownMapPosition(player, player.position)
        PlayerMemory.setLastChartZoomLevel(player, zoomLevel)

        debug.trace("zoomLevel: "..zoomLevel.." map")
    else
        PlayerMemory.setLastChartZoomLevel(player, zoomLevel) -- store current zoom level

        -- toogle to game
        player.close_map()
        renderMode = defines.render_mode.game
        zoomLevel = 1
        player.zoom = zoomLevel
        PlayerMemory.setLastGameZoomLevel(player, zoomLevel)

        debug.trace("zoomLevel: "..zoomLevel.." game")
        --player.character_running_speed_modifier = 1
    end
    PlayerMemory.setCurrentZoomLevel(player, zoomLevel)
	PlayerMemory.setLastRenderMode(player, renderMode)
	interface.onZoomFactorChanged_raise(player, zoomLevel, renderMode)
end

-------------------------------------------------------------------------------

script.on_event(ModPrefix.."_alt-zoom-out", function(event)
    zoomOut(game.players[event.player_index], event.tick)
end)

script.on_event(ModPrefix.."_zoom-in", function(event)
    zoomIn(game.players[event.player_index], event.tick)
end)

script.on_event(ModPrefix.."_alt-zoom-in", function(event)
    zoomIn(game.players[event.player_index], event.tick)
end)

script.on_event(ModPrefix.."_toggle-map", function(event)
    toggleMap(game.players[event.player_index])
end)

script.on_event(defines.events.on_selected_entity_changed, function(event)
	--print("on_selected_entity_changed")
	local player = game.get_player(event.player_index)
	--print("on_selected_entity_changed "..tostring(player).." "..tostring(event.player_index))
    if player.render_mode == defines.render_mode.chart_zoomed_in and player.selected then
        PlayerMemory.setLastKnownMapPosition(player, player.selected.position)
    end
end)

script.on_event(ModPrefix.."_quick-zoom-in", function(event)
    local player = game.players[event.player_index]
    local zoomLevel = Settings.getMaxWorldZoomOut(player)

    if player.render_mode == defines.render_mode.chart_zoomed_in and not player.selected then
       player.zoom = zoomLevel
    else
        -- if player selected something, then last_known_map_position has been already updated to its position
        player.zoom_to_world(PlayerMemory.getLastKnownMapPosition(player), zoomLevel)
    end

    PlayerMemory.setCurrentZoomLevel(player, zoomLevel)
end)

script.on_event(ModPrefix.."_quick-zoom-out", function(event)
    local player = game.players[event.player_index]
    local zoom_level = Settings.getQuickZoomOutZoomLevel(player)

    player.open_map({0, 0}, zoom_level)

    -- do not reset last_known_map_position to allow to use quick-zoom-in to go back to it
    PlayerMemory.setCurrentZoomLevel(player, zoom_level)
end)

script.on_event(defines.events.on_player_used_capsule, function(event)
    if event.item.name == ModPrefix.."_binoculars" then
        local player = game.players[event.player_index]
        binoculars_controler.use(player, event.position)
    end
end)

script.on_event(ModPrefix.."_move-down", function(event)
    local player = game.players[event.player_index]
    if(player.render_mode ~= defines.render_mode.game) then
        PlayerMemory.setHasMapMoved(player, true)
    end
end)

script.on_event(ModPrefix.."_move-left", function(event)
    local player = game.players[event.player_index]
    if(player.render_mode ~= defines.render_mode.game) then
        PlayerMemory.setHasMapMoved(player, true)
    end
end)

script.on_event(ModPrefix.."_move-right", function(event)
    local player = game.players[event.player_index]
    if(player.render_mode ~= defines.render_mode.game) then
        PlayerMemory.setHasMapMoved(player, true)
    end
end)

script.on_event(ModPrefix.."_move-up", function(event)
    local player = game.players[event.player_index]
    if(player.render_mode ~= defines.render_mode.game) then
        PlayerMemory.setHasMapMoved(player, true)
    end
end)

script.on_event(ModPrefix.."_drag-map", function(event)
    local player = game.players[event.player_index]
    if(player.render_mode ~= defines.render_mode.game) then
        PlayerMemory.setHasMapMoved(player, true)
    end
end)



-- This is called once when a new save game is created 
-- or once when a save file is loaded that previously didn't contain the mod. 
-- This is always called before other event handlers 
-- and is meant for setting up initial values that a mod will use for its lifetime.
script.on_init(function ()
	--game.print("on_init")
	interface.onInit()
end)

-- This is called every time a save file is loaded 
-- *except* for the instance when a mod is loaded into a save file that it previously wasn't part of. 
-- Additionally this is called when connecting to any other game in a multiplayer session and should never change the game state.
script.on_load(function ()
	--game.print("on_load")
	interface.onLoad()
end)

script.on_configuration_changed(function ()
	--game.print("on_load")
	interface.onConfigurationChanged()
end)

--[[
-- MP ERROR
-- mod-Kux-Zooming was not registered for the following nth_ticks when
-- the map was saved but has registered them as a result of loading: 60
script.on_nth_tick(60, function(tickEvent)
	script.on_nth_tick(nil)
	-- game.print("Start")
end)
]]

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
	if event.player_index == nil then return end -- changed by a script
	Settings.validateAndFix(game.players[event.player_index])
	debug.onSettingsChanged()
    Running.refreshAfterEvent(event)
end)

script.on_event(defines.events.on_player_armor_inventory_changed, function(event)
	Running.refreshAfterEvent(event)
end)

-- no player, maybe slows performance if run on multiplayer
script.on_nth_tick(60, function(event)
    --log("on_nth_tick")
    Running.refreshAfterEvent(event)
end)

--[[ slows performance
script.on_event(defines.events.on_player_changed_position, function(event)
	Running.refreshAfterEvent(event)
end)
]]--
-- on_player_changed_surface
-- on_player_placed_equipment ==> on_player_armor_inventory_changed
-- on_player_removed_equipment ==> on_player_armor_inventory_changed
-- on_runtime_mod_setting_changed