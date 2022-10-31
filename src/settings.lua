ModName = "Kux-ZoomRunning"
local prefix = "Kux-ZoomRunning";

data:extend({
    {
        type = "double-setting",
        name = prefix.."_zoom-sensitivity",
        setting_type = "runtime-per-user",
        default_value = 1.5,
        maximum_value = 5.0,
        minimum_value = 1.01,
        order = "01"
	},
    {
        type = "double-setting",
        name = prefix.."_max-world-zoom-out",
        setting_type = "runtime-per-user",
        default_value = 0.1,
        maximum_value = 1.0,
        minimum_value = 0.0001,
        order = "02"
    },
    {
        type = "double-setting",
        name = prefix.."_default-map-zoom-level",
        setting_type = "runtime-per-user",
        default_value = 0.03,
        maximum_value = 1.0,
        minimum_value = 0.0001,
        order = "03"
    },
    {
        type = "double-setting",
        name = prefix.."_quick-zoom-out-zoom-level",
        setting_type = "runtime-per-user",
        default_value = 0.01,
        maximum_value = 1.0,
        minimum_value = 0.0001,
        order = "04"
    },
    {
        type = "double-setting",
        name = prefix.."_binoculars-zoom-level",
        setting_type = "runtime-per-user",
        default_value = 0.3,
        maximum_value = 1.0,
        minimum_value = 0.0001,
        order = "05"
    },
    {
        type = "bool-setting",
        name = prefix.."_binoculars-double-action-enabled",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "06"
    },
    {
        type = "bool-setting",
        name = prefix.."_AllowMaxZoomOutForSatisfactorio",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "06"
    },
	{
        type = "bool-setting",
        name = prefix.."_debug",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "x00"
    }
})

--[[ startup ]]--
data:extend({
	{
		type = "bool-setting",
		name = ModName.."-CharacterHover",
		setting_type = "startup",
		default_value = false
	}
})


--[[ runtime-global ]]--
data:extend({
    {
        type = "bool-setting",
        name = ModName.."-GlobalCheatMode",
        setting_type = "runtime-global",
        default_value = false,
        order = "a00"
    },
})

--[[ runtime-per-user ]]--
data:extend({
    {
        type = "double-setting",
        name = ModName.."-UpsAdjustment",
        setting_type = "runtime-per-user",
        default_value = 1,
        maximum_value = 500,
        minimum_value = 0.1,
        order = "b05"
	},
	{
        type = "bool-setting",
        name = ModName.."-SlowerGameSpeedAdaptation",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "b06"
	},
	{
        type = "bool-setting",
        name = ModName.."-FasterGameSpeedAdaptation",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "b07"
	},
	{
        type = "double-setting",
        name = ModName.."-ZoomSpeedModificator",
        setting_type = "runtime-per-user",
        default_value = 3,
        maximum_value = 10,
        minimum_value = 0.1,
        order = "c01"
	},
    {
        type = "bool-setting",
        name = ModName.."-CheatMode",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "d00"
    },
    {
        type = "bool-setting",
        name = ModName.."-DisableRunningSpeedModifier",
        setting_type = "runtime-per-user",
        default_value = false,
        order = "z00"
    },
})
