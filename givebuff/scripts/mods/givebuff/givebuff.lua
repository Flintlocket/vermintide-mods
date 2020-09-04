-- Give Me the Buff!
local mod = get_mod("givebuff")

-- https://github.com/Vermintide-Mod-Framework/Vermintide-Mod-Framework/wiki/commands
local CMD_GIVEBUFF_HELP = [[ Grant yourself and your party a buff.
Enter a buff template name (e.g. 'speed_boost_potion') and you'll get that buff, including the sound and screen effects.
You may optionally submit "true" (or anything really) as a second argument to apply the buff to the whole party.
Usage: /givebuff <template> <apply to party?>

For a list of buffs, submit "list" as the template.
In this case, the second argument can be an absolute file path to save the list to.
If no path is given, the command will output to chat.
E.G.: /givebuff list "D:/cool_things/templates.txt"
]]

mod.buff_index = mod.buff_index or 1

mod.build_buff_lists = function(self)
	for buff_name, buff in pairs(BuffTemplates) do
		local categories = mod.buff_categories[buff_name]
		if categories then
			local num_cats = #categories
			for i = 1, num_cats do
				table.insert(mod[categories[i] .. "_buffs"], buff_name)
			end
			table.insert(mod["all_buffs"], buff_name)
		-- else
			-- mod:echo("[GiveBuff]: Unknown buff '" .. buff_name .. "'")
		end
	end
	local num_cats = #mod.buff_category_names
	for i = 1, num_cats do
		table.sort(mod[mod.buff_category_names[i] .. "_buffs"], function(buff1, buff2) return mod:localize(buff1) < mod:localize(buff2) end)
	end
end

mod.next_buff = function(self)
	if #(mod[mod:get("gb_list")]) < 1 then
		return
	end
	mod.buff_index = mod.buff_index + 1
	if mod.buff_index > #(mod[mod:get("gb_list")]) then
		mod.buff_index = 1
	end
end
mod.prev_buff = function(self)
	if #(mod[mod:get("gb_list")]) < 1 then
		return
	end
	mod.buff_index = mod.buff_index - 1
	if mod.buff_index < 1 then
		mod.buff_index = #(mod[mod:get("gb_list")])
	end
end

mod.handle_next_buff = function(self)
	mod:next_buff()
	mod:echo("[GiveBuff]: >> " .. mod:localize(mod[mod:get("gb_list")][mod.buff_index]))
end
mod.handle_prev_buff = function(self)
	mod:prev_buff()
	mod:echo("[GiveBuff]: >> " .. mod:localize(mod[mod:get("gb_list")][mod.buff_index]))
end
mod.handle_give_buff = function(self)
	mod:handle_command_givebuff(mod[mod:get("gb_list")][mod.buff_index], mod:get("gb_team"))
end
mod.handle_fav_loadout = function(self)
end
mod.handle_toggle_team_buff = function(self, suppress)
	mod:set("gb_team", not mod:get("gb_team"), false)
	if suppress then
		return
	end

	if mod:get("gb_team") then
		mod:echo("[GiveBuff]: Will buff team by default")
	else
		mod:echo("[GiveBuff]: Will only buff self by default")
	end
end

mod.handle_fav_concanter = function(self, suppress)
	local team = mod:get("gb_team")
	mod:give_buff("cooldown_reduction_potion_increased", team, true)
	mod:give_buff("damage_boost_potion_increased", team, true)
	mod:give_buff("speed_boost_potion_increased", team, true)
	if suppress then
		return
	end
	if team then
		mod:echo("[GiveBuff]: Giving Concanter to team")
	else
		mod:echo("[GiveBuff]: Giving Concanter to self")
	end
end

mod.handle_fav_regen = function(self, suppress)
	-- mod:give_twitch_buff("twitch_vote_full_temp_hp", mod:get("gb_team"), suppress)
	mod:give_buff("twitch_health_regen", mod:get("gb_team"), suppress)
end

mod.handle_fav_invincible = function(self, suppress)
	mod:give_buff("twitch_vote_buff_invincibility", mod:get("gb_team"), suppress)
end

mod.handle_fav_panic = function(self, self)
	mod:handle_fav_concanter(true)
	mod:handle_fav_regen(true)
	mod:handle_fav_invincible(true)
	mod:echo("[GiveBuff]: Panic!")
end

-- mod.give_twitch_buff = function(self, template, suppress)
-- 	if not suppress then
-- 		mod:echo("[GiveBuff]: Activating " .. mod:localize(template))
-- 	end
-- 	local player = Managers.player:local_player()
-- 	if TwitchVoteTemplates[template] == nil then
-- 		mod:echo("[GiveBuff]: Error: Unknown Twitch template '%s'", template)
-- 	else
-- 		TwitchVoteTemplates[template].on_success(player.is_server)
-- 	end
-- end

-- mod.give_item = function(self, template, team, suppress)
-- 	suppress = suppress or false
-- 	team = team or false
-- 	local me = Managers.player:local_player()
-- 	local is_server = me.is_server
-- 	local players = Managers.player:human_and_bot_players()
-- 	if team then
-- 		for _, player in pairs(players) do
-- 			local unit = player.player_unit
-- 			if Unit.alive(unit) then
-- 				mod:add_item(is_server, unit, mod.twitch_buffs_item_map[template])
-- 			end
-- 		end
-- 	else
-- 		local unit = me.player_unit
-- 		if Unit.alive(unit) then
-- 			mod:add_item(is_server, unit, mod.twitch_buffs_item_map[template])
-- 		end
-- 	end
-- 	if not suppress then
-- 		if team then
-- 			mod:echo("[GiveBuff]: Giving item " .. mod:localize(template) .. " to team")
-- 		else
-- 			mod:echo("[GiveBuff]: Giving item " .. mod:localize(template) .. " to self")
-- 		end
-- 	end
-- end

mod.give_buff = function(self, template, team, suppress)
	suppress = suppress or false
	team = team or false
	-- if mod:get("gb_list") == "twitch_buffs" then
	-- 	mod.give_twitch_buff(template, suppress)
	-- 	return
	-- end
	if not template then
		if not suppress then
			mod:echo("[GiveBuff]: No template")
		end
		return
	elseif BuffTemplates[template] == nil and mod.buff_categories[template] == nil then
		if not suppress then
			mod:echo("[GiveBuff]: Error: Unknown buff template '%s'", template)
		end
		return
	end
	if team then
		-- "Acquired" from vermintide-2-source-code\scripts\settings\twitch_vote_templates_buffs.lua
		if not suppress then
			mod:echo("[GiveBuff]: Applying buff '%s' to team", mod:localize(template))
		end
		local players = Managers.player:human_and_bot_players()
		for _, player in pairs(players) do
			local unit = player.player_unit
			if Unit.alive(unit) then
				local buff_system = Managers.state.entity:system("buff_system")
				local server_controlled = false
				buff_system:add_buff(unit, template, unit, server_controlled)
			end
		end
	else
		-- Just me
		if not suppress then
			mod:echo("[GiveBuff]: Applying buff '%s' to self", mod:localize(template))
		end
		local player = Managers.player:local_player()
		local unit = player.player_unit
		if Unit.alive(unit) then
			local buff_system = Managers.state.entity:system("buff_system")
			local server_controlled = false
			buff_system:add_buff(unit, template, unit, server_controlled)
		end
	end
end

mod.on_setting_changed = function(self, setting_name)
	if setting_name == "gb_list" then
		mod.buff_index = 1
		if #(mod[mod:get("gb_list")]) < 1 then
			mod:echo("[GiveBuff]: >> List is empty (blame Veg)")
		else
			mod:echo("[GiveBuff]: >> " .. mod:localize(mod[mod:get("gb_list")][mod.buff_index]))
		end
	end
end

-- mod.get_buff_type = function(self, template)
-- 	if mod.twitch_buffs_single[template] == true then
-- 		return "twitch_single"
-- 	-- elseif mod.twitch_buffs_item[template] == true then
-- 	-- 	return "twitch_item"
-- 	else
-- 		local num_twitch = #mod.twitch_buffs
-- 		for i = 1, num_twitch do
-- 			if mod.twitch_buffs[i] == template then
-- 				return "twitch_other"
-- 			end
-- 		end
-- 		return "none"
-- 	end
-- end

mod.handle_command_givebuff = function(self, template, args)
	-- Check if the template is valid
	if template == "list" then
		-- Lettuce make a sorted list
		local templates = table.keys(BuffTemplates)
		table.sort(templates)
		template_list = table.concat(templates, "\n")
		-- Shall we... write to file?
		if not args == "" then
			local template_file, io_err, io_err_code = io.open(args, "w")
			if not template_file then
				mod:echo("[GiveBuff]: Cannot open file '%s' - %s (%d)", args, io_err, io_err_code)
			else
				template_file:write(template_list)
				template_file:close()
				mod:echo("[GiveBuff]: Wrote templates to '%s'", args)
			end
		else
			mod:echo("[GiveBuff]: Valid templates:\n%s", template_list)
		end
		return
	end

	args = args or "false"
	local team = false
	if args == "true" or args == "1" or args == true then
		team = true
	end

	-- local buff_type = mod:get_buff_type(template)

	mod:give_buff(template, team, false)
	-- if buff_type == "twitch_item" then
	-- 	mod:give_item(template, team, false)
	-- if buff_type == "twitch_other" then
	-- 	mod:give_twitch_buff(template, false)
	-- else
	-- 	mod:give_buff(template, team, false)
	-- end
	-- if args == "true" or args == 1 then
	-- 	-- "Acquired" from vermintide-2-source-code\scripts\settings\twitch_vote_templates_buffs.lua
	-- 	mod:echo("[GiveBuff]: Applying buff '%s' to team", template)
	-- 	local players = Managers.player:human_and_bot_players()
	-- 	for _, player in pairs(players) do
	-- 		local unit = player.player_unit
	-- 		if Unit.alive(unit) then
	-- 			local buff_system = Managers.state.entity:system("buff_system")
	-- 			local server_controlled = false
	-- 			buff_system:add_buff(unit, template, unit, server_controlled)
	-- 		end
	-- 	end
	-- else
	-- 	-- Just me
	-- 	mod:echo("[GiveBuff]: Applying buff '%s' to self", template)
	-- 	local player = Managers.player:local_player()
	-- 	local unit = player.player_unit
	-- 	if Unit.alive(unit) then
	-- 		local buff_system = Managers.state.entity:system("buff_system")
	-- 		local server_controlled = false
	-- 		buff_system:add_buff(unit, template, unit, server_controlled)
	-- 	end
	-- end
end

-- Text input
mod:command("givebuff", CMD_GIVEBUFF_HELP, function(template, args)
	mod:handle_command_givebuff(template, args)
end)

-- Startup
mod:build_buff_lists()
