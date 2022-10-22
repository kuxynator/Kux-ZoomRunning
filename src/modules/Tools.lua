Tools = {}

Tools.deepcopy = function(orig)
	local origType = type(orig)
	local copy
	if origType == 'table' then
		copy = {}
		for orig_key, orig_value in next, orig, nil do
			copy[Tools.deepcopy(orig_key)] = Tools.deepcopy(orig_value)
		end
		setmetatable(copy, Tools.deepcopy(getmetatable(orig)))
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

--- Gets the equipment movement bonus
-- @param player LuaPlayer
Tools.getMovementBonus = function(player)
	local armorInventory = player.get_inventory(defines.inventory.character_armor)

	if armorInventory == nil then return 0 end
	local armor = armorInventory[1]
	if armor==nil or  armor.valid_for_read==false or armor.grid== nil then return 0 end

	local bonus = 0
	for _, equipment in pairs(armor.grid.equipment) do
		bonus = bonus + equipment.movement_bonus
	end
	return bonus
end

--- Get the tile speed modifier
-- @param obj LuaPlayer or LuaTile
Tools.getTileSpeedModifier = function (obj)
	if obj.object_name == "LuaPlayer" then return obj.character.surface.get_tile(obj.position).prototype.walking_speed_modifier end
	if obj.object_name == "LuaTile" then return obj.prototype.walking_speed_modifier end
	error("Argument out of range. name:obj ",serpent.block(obj))
end