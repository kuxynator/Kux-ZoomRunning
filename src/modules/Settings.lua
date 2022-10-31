local this = nil

--- Settings module
-- @module settings
Settings = {

	validateAndFix = function(player)
		local maxWorldZoomOutLevel = this.getMaxWorldZoomOut(player)
	
		local defaultMapZoomLevel = this.getDefaultMapZoomLevel(player)
		if defaultMapZoomLevel >= maxWorldZoomOutLevel then
			local newValue = maxWorldZoomOutLevel - 0.0001
			player.print("Invalid settings! Default map zoom level (" .. defaultMapZoomLevel .. ") has to be lower than Max world zoom out level (" .. maxWorldZoomOutLevel .. "). Changed to " .. newValue)
			settings.get_player_settings(player.index)[ModPrefix.."_default-map-zoom-level"] = { value = newValue }
		end
	
		local quickZoomOutZoomLevel = this.getQuickZoomOutZoomLevel(player)
		if quickZoomOutZoomLevel >= maxWorldZoomOutLevel then
			local newValue = maxWorldZoomOutLevel - 0.0001
			player.print("Invalid settings! 'Quick zoom out' map zoom level (" .. quickZoomOutZoomLevel .. ") has to be lower than Max world zoom out level (" .. maxWorldZoomOutLevel .. "). Changed to " .. newValue)
			settings.get_player_settings(player.index)[ModPrefix.."_quick-zoom-out-zoom-level"] = { value = newValue }
		end
	
		local binocularsZoomLevel = this.getBinocularsZoomLevel(player)
		if binocularsZoomLevel < maxWorldZoomOutLevel then
			local newValue = maxWorldZoomOutLevel
			player.print("Invalid settings! Binoculars zoom level (" .. binocularsZoomLevel .. ") has to be greater or equal to Max world zoom out level (" .. maxWorldZoomOutLevel .. "). Changed to " .. newValue)
			settings.get_player_settings(player.index)[ModPrefix.."_binoculars-zoom-level"] = { value = newValue }
		end
	end,
	
	getZoomSensitivity = function(player)
		return player.mod_settings[ModPrefix.."_zoom-sensitivity"].value
	end,
	
	getMaxWorldZoomOut = function(player)
		return player.mod_settings[ModPrefix.."_max-world-zoom-out"].value
	end,
	
	getDefaultMapZoomLevel = function(player)
		return player.mod_settings[ModPrefix.."_default-map-zoom-level"].value
	end,
	
	getQuickZoomOutZoomLevel = function(player)
		return player.mod_settings[ModPrefix.."_quick-zoom-out-zoom-level"].value
	end,
	
	getBinocularsZoomLevel = function(player)
		return player.mod_settings[ModPrefix.."_binoculars-zoom-level"].value
	end,
	
	is_binoculars_double_action_enabled = function(player)
		return player.mod_settings[ModPrefix.."_binoculars-double-action-enabled"].value
	end,
	
	isDebugMode = function(player)
		return player.mod_settings[ModPrefix.."_debug"].value
	end,
	
	--[[ startup ]] --

	getCharacterHover = function()
		return settings.startup[ModName.."-CharacterHover"].value
	end,

	--[[ runtime-global ]] --

	getGlobalCheatMode= function()
		return settings.global[ModName.."-GlobalCheatMode"].value
	end,

	--[[ runtime-per-user ]] --

	getDefaultCharacterRunningSpeedModifier = function(player)
		return player.mod_settings[ModName.."-DefaultCharacterRunningSpeedModifier"].value
	end,
	setDefaultCharacterRunningSpeedModifier = function(player, value)
		player.mod_settings[ModName.."-DefaultCharacterRunningSpeedModifier"] = { value = value }
	end,

	getInitialSpeedFactor = function(player)
		local value = player.mod_settings[ModName.."-InitialSpeedFactor"].value
		value = value * this.getUpsAdjustment(player)
		return value
	end,

	--@return [double]
	getUpsAdjustment = function (player)
		local value = player.mod_settings[ModName.."-UpsAdjustment"].value
		if value > 10 then -- value in UPS, convert to factor
			value = 60/value
		end

		local slowerAdaption = player.mod_settings[ModName.."-SlowerGameSpeedAdaptation"].value
		local fasterAdaption = player.mod_settings[ModName.."-FasterGameSpeedAdaptation"].value

		if(slowerAdaption and game.speed < 1) then
			value = value / game.speed
		elseif(fasterAdaption and game.speed > 1) then
			value = value / game.speed
		end

		return value
	end,

	getZoomSpeedModificator = function(player)
		return player.mod_settings[ModName.."-ZoomSpeedModificator"].value
	end,

	getDisableRunningSpeedModifier = function(player)
		return player.mod_settings[ModName.."-DisableRunningSpeedModifier"].value
	end,

	getAllowMaxZoomOutForSatisfactorio = function(player)
		return player.mod_settings[ModName.."_AllowMaxZoomOutForSatisfactorio"].value
	end,

	getCheatMode = function(player)
		if (this.getGlobalCheatMode()~=true) and (player.admin==false) then return false end
		local value = player.mod_settings[ModName.."-CheatMode"].value==true
		return value
	end,

	--zoomSpeedOffset = function(player)
	--	return player.mod_settings[ModName.."-ZoomSpeedOffset"].value
	--end,
}
this = Settings