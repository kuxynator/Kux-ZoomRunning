ModName = "Kux-ZoomRunning"
local prefix = "Kux-ZoomRunning"
-- consuming: none|game-only (game-only: only script)
data:extend {
    {
        type = "custom-input",
        name = prefix.."_zoom-in",
        key_sequence = "",
        linked_game_control = "zoom-in",
        consuming = "none" -- "none"
    },
    {
        type = "custom-input",
        name = prefix.."_alt-zoom-in",
        key_sequence = "",
        linked_game_control = "alt-zoom-in",
        consuming = "none" -- "none"
    },
    {
        type = "custom-input",
        name = prefix.."_zoom-out",
        key_sequence = "",
        linked_game_control = "zoom-out",
        consuming = "none" -- "game-only"
    },
    {
        type = "custom-input",
        name = prefix.."_alt-zoom-out",
        key_sequence = "",
        linked_game_control = "alt-zoom-out",
        consuming = "none" -- "game-only"
    },
    {
        type = "custom-input",
        name = prefix.."_toggle-map",
        key_sequence = "",
        linked_game_control = "toggle-map",
        consuming = "game-only"
    },
    {
        type = "custom-input",
        name = prefix.."_quick-zoom-in",
        key_sequence = "UP"
    },
    {
        type = "custom-input",
        name = prefix.."_quick-zoom-out",
        key_sequence = "DOWN"
    },
}

data:extend {
    {
        type = "custom-input",
        name = prefix.."_move-down",
        key_sequence = "",
        linked_game_control = "move-down"
    },
    {
        type = "custom-input",
        name = prefix.."_move-left",
        key_sequence = "",
        linked_game_control = "move-left"
    },
    {
        type = "custom-input",
        name = prefix.."_move-right",
        key_sequence = "",
        linked_game_control = "move-right"
    },
    {
        type = "custom-input",
        name = prefix.."_move-up",
        key_sequence = "",
        linked_game_control = "move-up"
    },
    {
        type = "custom-input",
        name = prefix.."_drag-map",
        key_sequence = "",
        linked_game_control = "drag-map"
    }
}

data:extend {
    {
        type = "capsule",
        name = prefix.."_binoculars",
        subgroup = "tool",
        order = "z[binoculars]",
        icons = {
            {
                icon = "__"..ModName.."__/graphics/binoculars.png",
                icon_size = 32,
            }
        },
        capsule_action =
        {
            type = "artillery-remote",
            flare = "zoom-in-flare"
        },
        flags = {},
        stack_size = 1,
        stackable = false
    },
    {
        type = "recipe",
        name = prefix.."_binoculars-recipe",
        enabled = true,
        ingredients = {
            {"iron-plate", 1}
        },
        result = prefix.."_binoculars",
    },
    {
        type = "artillery-flare",
        name = "zoom-in-flare",
        flags = {"placeable-off-grid", "not-on-map"},
        map_color = {r=0, g=0, b=0},
        life_time = 1,
        shots_per_flare = 0,
        pictures =
        {
            {
                filename = "__"..ModName.."__/graphics/binoculars.png",
                width = 1,
                height = 1,
                scale = 0
            }
        }
    }
}
--- character  -------------------------------------------------------
if settings.startup[ModName.."-CharacterHover"].value then
	data.raw["character"]["character"].collision_box = {{0,0}, {0,0}}
	--thx to DellAquila
end