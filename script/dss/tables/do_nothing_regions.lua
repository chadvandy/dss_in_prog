-- settlements that should not have their display skins changed, for sake of strangeness or loreness

-- can be override with the API:
-- region_name is a string, if do_nothing is false it'll *remove* a region as do_nothing
-- dss:set_region_as_do_nothing(region_name, do_nothing)

local do_nothing_regions = {
--[[    -- Ulthuan gates
    wh2_main_eagle_gate = true,
    wh2_main_griffon_gate = true,
    wh2_main_phoenix_gate = true,
    wh2_main_unicorn_gate = true,

    wh2_main_vor_eagle_gate = true,
    wh2_main_vor_griffon_gate = true,
    wh2_main_vor_phoenix_gate = true,
    wh2_main_vor_unicorn_gate = true,

    -- Galleon's Graveyard
    wh2_main_the_galleons_graveyard = true,
    wh2_main_vor_the_galleons_graveyard = true,

    -- Black Pyramid of Nagash 
    wh2_main_vor_great_mortis_delta_black_pyramid_of_nagash = true,
    wh2_main_great_mortis_delta_black_pyramid_of_nagash = true]]
}

return do_nothing_regions