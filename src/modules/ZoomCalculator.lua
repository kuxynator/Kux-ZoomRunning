local constants    = require("constants")
require("modules.PlayerMemory")
require("modules.Settings")

--- Zoom calculator module
-- @module zoomCalculator
local module = {}

function module.calculateZoomedInLevel(player)
	local zoomSensitivity = Settings.getZoomSensitivity(player)
	local zoomLevel = PlayerMemory.getCurrentZoomLevel(player)
	local newZoomLevel = zoomLevel * zoomSensitivity

	local maxZoomInLevel = constants.MaxWorldZoomInLevel
	if newZoomLevel > maxZoomInLevel then
		return zoomLevel -- do not zoom
	end

	PlayerMemory.setCurrentZoomLevel(player, newZoomLevel)
	return newZoomLevel
end

function module.calculateZoomedOutLevel(player)
	local zoomSensitivity = Settings.getZoomSensitivity(player)
	local zoomLevel = PlayerMemory.getCurrentZoomLevel(player)
	local newZoomLevel = zoomLevel / zoomSensitivity

	local maxZoomOutLevel = Settings.getMaxWorldZoomOut(player)
	if newZoomLevel < maxZoomOutLevel then
		return zoomLevel -- do not zoom
	end
	PlayerMemory.setCurrentZoomLevel(player, newZoomLevel)
	return newZoomLevel
end

function module.getShouldSwitchBackToMap(player)
	local currentZoomLevel = PlayerMemory.getCurrentZoomLevel(player)
	local maxWorldZoomOutLevel = Settings.getMaxWorldZoomOut(player)
	return player.render_mode == defines.render_mode.chart_zoomed_in and currentZoomLevel == maxWorldZoomOutLevel
end

function module.calculateZoomOut_backToMapView(player)
	local zoom_sensitivity = Settings.getZoomSensitivity(player)

	local newZoomLevel = PlayerMemory.getCurrentZoomLevel(player) / zoom_sensitivity
	local maxZoomOutLevel = constants.MAX_MAP_ZOOM_OUT_LEVEL

	if newZoomLevel < maxZoomOutLevel then
		newZoomLevel = maxZoomOutLevel
	end

	PlayerMemory.setCurrentZoomLevel(player, newZoomLevel)

	return PlayerMemory.getCurrentZoomLevel(player)
end

function module.calculateOpenMapZoomLevel(player)
	local zoomLevel = Settings.getDefaultMapZoomLevel(player)
	PlayerMemory.setCurrentZoomLevel(player, zoomLevel)
	return zoomLevel
end

function module.updateCurrentZoom_ByUserZoomingInOnMap(player)
	local zoomLevel = PlayerMemory.getCurrentZoomLevel(player)
	local newZoomLevel = zoomLevel * constants.BASE_GAME_ANY_MAP_ZOOM_SENSITIVITY
	if newZoomLevel < constants.BaseMapMaxZoomLevel then
		PlayerMemory.setCurrentZoomLevel(player, newZoomLevel)
		return newZoomLevel
	else
		return zoomLevel
	end
end

function module.updateCurrentZoom_ByUserZoomingOutOnMap(player)
	local zoomLevel = PlayerMemory.getCurrentZoomLevel(player)
	local newZoomLevel = zoomLevel / constants.BASE_GAME_ANY_MAP_ZOOM_SENSITIVITY
	if newZoomLevel > constants.BaseMapMinZoomLevel then
		PlayerMemory.setCurrentZoomLevel(player, newZoomLevel)
		return newZoomLevel
	else
	   return zoomLevel
	end
end

ZoomCalculator = module
