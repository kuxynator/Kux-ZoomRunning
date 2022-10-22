local constants = require("constants")
require("modules.PlayerMemory")
require("modules.Settings")

local binoculars_controler = {}

binoculars_controler.use = function(player, position)
    local double_action_enabled = Settings.is_binoculars_double_action_enabled(player)
    local zoom_level

    if double_action_enabled and player.render_mode == defines.render_mode.chart and PlayerMemory.getCurrentZoomLevel(player) < constants.MIN_MAP_ZOOM_LEVEL_WITH_LABELS_VISIBLE then
        zoom_level = constants.MIN_MAP_ZOOM_LEVEL_WITH_LABELS_VISIBLE
        player.open_map(position, zoom_level)
    else
        zoom_level = Settings.getBinocularsZoomLevel(player)
        player.zoom_to_world(position, zoom_level)
    end

    PlayerMemory.setCurrentZoomLevel(player, zoom_level)
    PlayerMemory.setLastKnownMapPosition(player, position)
end

return binoculars_controler
