local mct_mod = mct:register_mod("dynamic_settlement_skins")
mct_mod:set_title("Tiny Little Cities: Dynamic Settlement Skins")
mct_mod:set_author("GCCM and Vandy")
mct_mod:set_description("Welcome to the TLC mod!")

local disable_dwarfs = mct_mod:add_new_option("disable_dwarfs", "checkbox")
disable_dwarfs:set_default_value(true)

disable_dwarfs:set_text("Disable Dwarf Skins")
disable_dwarfs:set_tooltip_text("Disable skin changes on dwarf-base settlements. This is set to disabled due to some rotation issues right now. Don't recommend enabling them, but it's your life.")

local enable_logging = mct_mod:add_new_option("enable_logging", "checkbox")
enable_logging:set_default_value(false)

enable_logging:set_text("Enable Robust Logging")
enable_logging:set_tooltip_text("Enable script logging. Especially helpful when you're trying to debug an issue, please send us the script log here. If enabled, there will be a new file made on your PC, called \"dss_log.txt\" in the same folder as your TW:WH2 .exe.")