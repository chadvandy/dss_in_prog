-- Overwrite some details in the data-assembled dss/tables.
-- This is half done to show a usage of the API, and half done so I don't have to constantly edit within the dss/tables files every update

local dss = get_dynamic_skins_manager()

-- set wood elves as the original owner of Laurelorn
dss:overwrite_original_owner("wh2_main_laurelorn_forest_laurelorn_forest", "wh_dlc05_sc_wef_wood_elves")

---- Set the following regions as "do nothing" regions, so they are unaffected by the mod

-- Ulthuan gates
dss:set_region_as_do_nothing("wh2_main_eagle_gate", true)
dss:set_region_as_do_nothing("wh2_main_griffon_gate", true)
dss:set_region_as_do_nothing("wh2_main_phoenix_gate", true)
dss:set_region_as_do_nothing("wh2_main_unicorn_gate", true)

dss:set_region_as_do_nothing("wh2_main_vor_eagle_gate", true)
dss:set_region_as_do_nothing("wh2_main_vor_griffon_gate", true)
dss:set_region_as_do_nothing("wh2_main_vor_phoenix_gate", true)
dss:set_region_as_do_nothing("wh2_main_vor_unicorn_gate", true)

-- Gates
dss:set_region_as_do_nothing("wh2_main_fort_bergbres", true)
dss:set_region_as_do_nothing("wh2_main_fort_helmgart", true)
dss:set_region_as_do_nothing("wh2_main_fort_soll", true)

-- Galleon's Graveyard
dss:set_region_as_do_nothing("wh2_main_the_galleons_graveyard", true)
dss:set_region_as_do_nothing("wh2_main_vor_the_galleons_graveyard", true)

-- Black Pyramid of Nagash
dss:set_region_as_do_nothing("wh2_main_great_mortis_delta_black_pyramid_of_nagash", true)
dss:set_region_as_do_nothing("wh2_main_vor_great_mortis_delta_black_pyramid_of_nagash", true)

-- Athel Loren
dss:set_region_as_do_nothing("wh_main_athel_loren_crag_halls", true)
dss:set_region_as_do_nothing("wh_main_athel_loren_vauls_anvil", true)
dss:set_region_as_do_nothing("wh_main_athel_loren_waterfall_palace", true)
dss:set_region_as_do_nothing("wh_main_athel_loren_yn_edryl_korian", true)
dss:set_region_as_do_nothing("wh_main_yn_edri_eternos_the_oak_of_ages", true)

-- Skavenblight & Hell Pit
dss:set_region_as_do_nothing("wh2_main_skavenblight_skavenblight", true)
dss:set_region_as_do_nothing("wh2_main_hell_pit_hell_pit", true)


-- MCT compat
core:add_listener(
    "mct_init",
    "MctInitialized",
    true,
    function(context)
        local mct = context:mct()
        local mct_mod = mct:get_mod_by_key("dynamic_settlement_skins")

        local option = mct_mod:get_option_by_key("disable_dwarfs")
        local setting = option:get_finalized_setting()

        dss.disable_dwarfs = setting
        dss:dwarf_disable()

        do
            local option = mct_mod:get_option_by_key("enable_logging")
            local setting = option:get_finalized_setting()

            dss:set_log_enabled(setting)
        end
    end,
    true
)

core:add_listener(
    "mct_finalized",
    "MctFinalized",
    true,
    function(context)
        local mct = context:mct()
        local mct_mod = mct:get_mod_by_key("dynamic_settlement_skins")

        local option = mct_mod:get_option_by_key("disable_dwarfs")
        local setting = option:get_finalized_setting()

        dss.disable_dwarfs = setting
        dss:dwarf_disable()
        
        do
            local option = mct_mod:get_option_by_key("enable_logging")
            local setting = option:get_finalized_setting()

            dss:set_log_enabled(setting)
        end
    end,
    true
)







--- blank lines for T&T patch :)