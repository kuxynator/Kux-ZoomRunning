-------------------------------------------------------------------------------
-- MODULE: PlayerMemory
-- USAGE: require "modules.PlayerMemory"
-------------------------------------------------------------------------------
require "modules.Tools"

local this = nil
local dataVersion = 1 -- increment if playerMemory_prototype changed
local playerMemory_prototype = {
	dataVersion          = dataVersion,
	tableName            = "playerMemory",
	player               = nil,

	-- zooming --
	lastKnownMapPosition = nil,
	currentZoom = 1,
	mapZoomOutEnabled = true,
	lastZoomInTick = 0,
	lastRenderMode = defines.render_mode.game,
	lastGameZoomLevel = 1,
	lastChartZoomLevel = 1,
	hasMapMoved = false,

	-- running --
	hasCharakter         = false,
	isWalking            = true,  -- true to trigger the initialization at first tick
	movementBonus = 0,
}

local getPlayerMemoryTable=function ()
	global.playerMemoryTable = global.playerMemoryTable or {tableName="playerMemoryTable"}
	return global.playerMemoryTable
end

local new = function (player)
	local pm = Tools.deepcopy(playerMemory_prototype)
	pm.dataVersion          = dataVersion
	pm.player               = player
	-- zooming --
	pm.lastKnownMapPosition = player.position
	pm.currentZoom = 1
	pm.mapZoomOutEnabled = true
	pm.lastZoomInTick = 0
	pm.lastRenderMode = defines.render_mode.game
	pm.lastGameZoomLevel = 1
	pm.lastChartZoomLevel = Settings.getDefaultMapZoomLevel(player)
	pm.hasMapMoved = false
	-- running --
	pm.movementBonus        = Tools.getMovementBonus(player)
	return pm
end

local migrate = function (table, default)
	for name, value in pairs(default) do
		if(table[name] == nil) then table[name] = value end
	end
end

--- Player memory module
-- @module playerMemory
PlayerMemory = {
	moduleName = "playerMemory",
	table = nil, -- initialized in get(), because 'global' is requiered

	--- Gets the memory for the specified player
	--@param player  LuaPlayer or player index
	--@return PlayerMemory table {tableName = "playerMemory",...}
	get = function (player)
		if type(player) == "number" then player = game.get_player(player) end
		if this.table == nil then this.table = getPlayerMemoryTable() end
		this.table[player.index] = this.table[player.index] or new(player)
		local pm = this.table[player.index]
		pm.player = player

		--migration
		if pm.dataVersion < dataVersion then
			local default = new(player)
			migrate(pm, default) -- adds new properties only
			pm.dataVersion = dataVersion
		end

		return pm
	end,

	getLastKnownMapPosition = function (player) return this.get(player).lastKnownMapPosition end,
	setLastKnownMapPosition = function (player, position) this.get(player).lastKnownMapPosition = position end,

	getCurrentZoomLevel = function (player) return this.get(player).currentZoom end,
	setCurrentZoomLevel = function (player, zoomLevel) this.get(player).currentZoom = zoomLevel end,

	getLastZoomInTick = function (player) return this.get(player).lastZoomInTick end,
	setLastZoomInTick = function (player, tick) this.get(player).lastZoomInTick = tick end,

	getLastRenderMode = function (player) return this.get(player).lastRenderMode end,
	setLastRenderMode = function (player, renderMode) this.get(player).lastRenderMode = renderMode end,

	getLastChartZoomLevel = function (player) return this.get(player).lastChartZoomLevel end,
	setLastChartZoomLevel = function (player, zoomLevel) this.get(player).lastChartZoomLevel = zoomLevel end,

	getLastGameZoomLevel = function (player) return this.get(player).lastGameZoomLevel end,
	setLastGameZoomLevel = function (player, zoomLevel) this.get(player).lastGameZoomLevel = zoomLevel end,

	getHasMapMoved = function (player) return this.get(player).hasMapMoved end,
	setHasMapMoved = function (player, hasMapMoved) this.get(player).hasMapMoved = hasMapMoved end,
}
this = PlayerMemory -- init local this