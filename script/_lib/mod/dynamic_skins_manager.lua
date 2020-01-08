-- only load the file if it's the campaign!
if __game_mode ~= __lib_type_campaign then
    return
end

dynamic_skins_manager = {
    log_enabled = false,
    log_made = false,
    log_path = "dss_log.txt",

    -- extern files to quickly grab lots of data
    region_to_original_owner = require("script/dss/tables/region_to_original_owner"),
    region_to_major_or_minor = require("script/dss/tables/region_to_major_or_minor"),
    subculture_to_group =      require("script/dss/tables/subculture_to_group"),
    do_nothing_regions =       require("script/dss/tables/do_nothing_regions"),

    current_displays = {}
} 

function dynamic_skins_manager:log(text)
    -- read if logs are enabled
    if not self.log_enabled then
        return
    end

    -- overwrite any existing log if one hasn't been made this session
	if not self.log_made then
		local file = io.open(self.log_path, "w+")
		file:write(text.."\n")
		file:close()
        self.log_made = true

    -- otherwise, write in the existing one
	else
		local file = io.open(self.log_path, "a")
		file:write(text.."\n")
		file:close()
	end
end

function dynamic_skins_manager:set_log_enabled(enabled)
    self.log_enabled = not not enabled
end

-- add a subculture key to a grouped key, needed for the cultural skins to work!
function dynamic_skins_manager:add_subculture_to_group(subculture_key, group_key)
    if not is_string(subculture_key) or not is_string(group_key) then
        self:log("add_subculture_to_group() called, but subculture_key or group_key wasn't a string and couldn't become a string. Investigate!")
        return
    end

    local valid_groups = {
        dwf = true, -- dwarfs
        emp = true, -- empire
        grn = true, -- greenskins
        vmp = true, -- vampire counts

        brt = true, -- bretonnia
        wef = true, -- wood elves
        nor = true, -- norsca

        def = true, -- dark elves
        hef = true, -- high elves
        lzd = true, -- lizardmen
        skv = true, -- ratboiz

        cst = true, -- vampire coast
        tmb = true  -- tomb kings
    }

    -- require only one of specific group_keys
    if not valid_groups[group_key] then
        self:log("Attempting to add subculture ["..subculture_key.."] to an invalid group key, ["..group_key.."].")
        self:log("Valid groups are: [dwf], [emp], [grn], [vmp], [brt], [wef], [nor], [def], [hef], [lzd], [skv], [cst], [tmb]")
        return
    end

    -- prevent overwriting any existing link for that subculture to a group!
    if self.subculture_to_group[subculture_key] == nil then
        self.subculture_to_group[subculture_key] = group_key        
    end    
end

-- set enable as "false" to, conversely, remove the region from "do_nothing" status
function dynamic_skins_manager:set_region_as_do_nothing(region_name, enable)
    if not is_string(region_name) then
        self:log("set_region_as_do_nothing() called, but the region_name is not a string or could not become a string. Investigate!")
        return
    end

    enable = not not enable

    self.do_nothing_regions[region_name] = enable
end

-- overwrite any DSS-defined original owners
-- please do the campaign-check on your side!
function dynamic_skins_manager:overwrite_original_owner(region_name, original_owning_subculture)
    if not is_string(region_name) or not is_string(original_owning_subculture) then
        self:log("overwrite_original_owner() called, but region_name or original_owning_subculture wasn't a string and couldn't become a string. Investigate!")
        return
    end

    if not self.region_to_original_owner[region_name] then
        self:log("overwrite_original_owner() called, but the region name ["..region_name.."] doesn't exist in the DSS tables. Investigate!")
        return
    end

    self.region_to_original_owner[region_name] = original_owning_subculture
    self:log("["..original_owning_subculture.."] set as the original owner for ["..region_name.."].")
end

function dynamic_skins_manager:get_current_display_for_region(region_name)
    if self.current_displays[region_name] == nil then
        self.current_displays[region_name] = ""
    end

    return self.current_displays[region_name]
end

function dynamic_skins_manager:is_region_do_nothing(region_name)
    return self.do_nothing_regions[region_name] or false
end

function dynamic_skins_manager:is_region_major(region_name)
    return self.region_to_major_or_minor[region_name]
end

-- build a string for the new_display
function dynamic_skins_manager:form_display_string(region_name, occupying_subculture)
    local new_display

    if not occupying_subculture then
        new_display = cm:get_region(region_name):settlement():primary_building_chain()
    else
        local original_subculture = self:get_original_subculture_with_region(region_name)
        local original_grouped_culture = self:get_grouped_culture(original_subculture)
        local occupying_grouped_culture = self:get_grouped_culture(occupying_subculture)
        
        local suffix --: string

        if self:is_region_unique(region_name) then
            suffix = region_name
        elseif self:is_region_major(region_name) then
            suffix = "major"
        else
            suffix = "minor"
        end

        new_display = original_grouped_culture .. "_" .. occupying_grouped_culture .. "_" .. suffix
    end

    return new_display
end

-- internal func to actually override the display chain
function dynamic_skins_manager:override_chain_display(region_name, occupying_subculture)
    local old_display = cm:get_region(region_name):settlement():display_primary_building_chain()
    local new_display = self:form_display_string(region_name, occupying_subculture)

    self:log("Old Display Key: [" .. old_display .. "]")
    self:log("Current Display Key: [" .. self:get_current_display_for_region(region_name) .. "]")
    self:log("New Display Key: [" .. new_display .. "]")

    cm:override_building_chain_display(old_display, new_display, region_name)

    self.current_displays[region_name] = new_display
end


function dynamic_skins_manager:is_region_unique(region_name)
    -- TODO build this to read from unique_settlements.lua when that is setup
    return false
end

-- convert the subculture key to the grouped key        
function dynamic_skins_manager:get_grouped_culture(subculture_key)
    for sc, base in pairs(self.subculture_to_group) do
        if sc == subculture_key then
            return base
        end
    end

    return ""
end

function dynamic_skins_manager:get_original_subculture_with_region(region_name)
    local subculture = self.region_to_original_owner[region_name]
    return subculture
end

function dynamic_skins_manager:is_subculture_occupying(region_name, occupying_subculture)
    local original_subculture = self:get_original_subculture_with_region(region_name)
    local original_subculture_group = self:get_grouped_culture(original_subculture)

    local occupying_subculture_group = self:get_grouped_culture(occupying_subculture)

    local test_string = self:form_display_string(region_name, occupying_subculture)
    local current_display = self:get_current_display_for_region(region_name)

    if occupying_subculture == "rebels" then
        return false
    end
    
    if test_string == current_display then
        return false
    elseif original_subculture_group ~= occupying_subculture_group then
        return true
    else
        return false
    end
end

-- only run once, on the very first use of this mod
function dynamic_skins_manager:init()
    local region_list = cm:model():world():region_manager():region_list()

    self:log("------ BEGINNING THE FIRST TURN LOOP.")
    for i = 0, region_list:num_items() - 1 do
        local current_region = region_list:item_at(i)
        local current_owner_subculture = current_region:owning_faction():subculture()

        if self:is_region_do_nothing(current_region:name()) then
            -- skip!
        else
            if self:is_subculture_occupying(current_region:name(), current_owner_subculture) then
                self:log("[" .. current_region:name() .. "] is being occupied by [" .. current_owner_subculture .. "], beginning override!") 
                self:override_chain_display(current_region:name(), current_owner_subculture)
            end
        end
    end
    self:log("------- ENDING THE FIRST TURN LOOP.")

    cm:set_saved_value("dss_init", true)
end

-- main loop for the mod
function dynamic_skins_manager:main()
    self:log("DSS - main loop beginning.")

    if not cm:get_saved_value("dss_init") then 
        self:log("DSS starting the new game procedures.")
        local ok, err = pcall(function()
            self:init()
        end)
        if not ok then
            self:log(err)
        end
    end

    core:add_listener(
        "DssCheckChangeOwnership",
        "RegionTurnStart",
        function(context)
            local region_name = context:region():name()
            if self:is_region_do_nothing(region_name) then
                return false
            end
            local owning_subculture = context:region():owning_faction():subculture()
            return self:is_subculture_occupying(region_name, owning_subculture)
        end,
        function(context)
            local region_name = context:region():name()
            local occupying_subculture = context:region():owning_faction():subculture()

            self:log("RegionTurnStart beginning override of [".. region_name .."] with new culture [".. occupying_subculture .."]")

            self:override_chain_display(region_name, occupying_subculture)
        end,
        true
    )
end

function get_dynamic_skins_manager()
    return dynamic_skins_manager
end

_G.get_dynamic_skins_manager = get_dynamic_skins_manager

cm:add_first_tick_callback(function()
    dynamic_skins_manager:main()
end)


-- save/load the current displays table, to save inter-turn performance.
-- it's a big table - might be better to save it as a .txt separately or some shit, we'll see
cm:add_saving_game_callback(
    function(context)
        cm:save_named_value("dss_current_displays", dynamic_skins_manager.current_displays, context)
    end
)

cm:add_loading_game_callback(
    function(context)
        dynamic_skins_manager.current_displays = cm:load_named_value("dss_current_displays", {}, context)
    end
)