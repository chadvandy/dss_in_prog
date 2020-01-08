-- Overwrite some details in the data-assembled dss/tables.
-- This is half done to show a usage of the API, and half done so I don't have to constantly edit within the dss/tables files every update

local dss = get_dynamic_skins_manager()

-- set wood elves as the original owner of Laurelorn
dss:overwrite_original_owner("wh2_main_laurelorn_forest_laurelorn_forest", "wh_dlc05_sc_wef_wood_elves")

-- prevent robust logging. Can be enabled/disabled at any time
dss:set_log_enabled(false)