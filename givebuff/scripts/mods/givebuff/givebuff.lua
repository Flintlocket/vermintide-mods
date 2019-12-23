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

mod:command("givebuff", CMD_GIVEBUFF_HELP, function(template, ...)
  local args = table.concat({...}, " ")
  -- Check if the template is valid
  if template == "list" or BuffTemplates[template] == nil then
    -- Lettuce make a sorted list
    local templates = table.keys(BuffTemplates)
    table.sort(templates)
    template_list = table.concat(templates, "\n")
    -- Shall we... write to file?
    if template == "list" and not args == "" then
      local template_file, io_err, io_err_code = io.open(args, "w")
      if not template_file then
        mod:echo("Cannot open file '%s' - %s (%d)", args, io_err, io_err_code)
      else
        template_file:write(template_list)
        template_file:close()
        mod:echo("Wrote templates to '%s'", args)
      end
    else
      mod:echo("Valid templates:\n%s", template_list)
    end
    return
  end

  args = args or "false"
  if args == "true" then
    -- "Acquired" from vermintide-2-source-code\scripts\settings\twitch_vote_templates_buffs.lua
    mod:echo("Applying buff '%s' to team", template)
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
    mod:echo("Applying buff '%s' to self", template)
    local player = Managers.player:local_player()
    local unit = player.player_unit
    if Unit.alive(unit) then
      local buff_system = Managers.state.entity:system("buff_system")
      local server_controlled = false
      buff_system:add_buff(unit, template, unit, server_controlled)
    end
  end
end)
