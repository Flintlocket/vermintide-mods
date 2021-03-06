-- Vermintide Get-better-at-communicating System
local mod = get_mod("VTGS")

-- TODO: Fix text stuff for 2.0.3
mod.basic_gui = get_mod("BasicUI") -- For text_width
mod.simple_ui = get_mod("SimpleUI")

-- Simple key map for a simple guy
VTGS_SIMPLE_KEY_MAP = {
  win32 = {
    ["a"] = {"keyboard", "a", "pressed"},
  },
}
-- VTGS_SIMPLE_KEY_MAP.xb1 = VTGS_SIMPLE_KEY_MAP.win32

-- Wew variables
mod.command = ""
mod.last_key = nil
mod.activated = false
mod.list = {}
mod.list_keys = {}
mod.trigger_clear = false
mod.prepend_text = ""
mod.prepend_command = ""
-- Ah jeez that's a big table
mod.vtgs = {
  -- Command
  ["c"] = "[C] - Command *",
    ["cc"] = "[C] - Come here!",
    ["cd"] = "[D] - Do the thing!",
    ["cf"] = "[F] - Push forward!",
    ["ch"] = "[H] - Heal up",
    ["cp"] = "[P] - Pick Up *",
      ["cp>"] = "i Pick up the",
    ["cr"] = "[R] - Retreat!",
    ["cw"] = "[W] - Wait",
  -- Elite
  ["e"] = "[E] - Elite *",
    ["ea"] = "[A] - Archers!",
    ["eb"] = "[B] - Bestigors!",
    ["ec"] = "[C] - Chaos Warriors!",
    ["em"] = "[M] - Maulers!",
    ["ep"] = "[P] - Plague Monks!",
    ["es"] = "[S] - Savages!",
    ["ev"] = "[V] - Stormvermin!",
  -- General
  ["g"] = "[G] - General *",
    ["gb"] = "[B] - Bye",
    ["gh"] = "[H] - Hi",
    ["gn"] = "[N] - No",
    ["go"] = "[O] - Ooops",
    ["gq"] = "[Q] - Quiet!",
    ["gs"] = "[S] - SIGMAR",
    ["gw"] = "[W] - Woohoo!",
    ["gy"] = "[Y] - Yes",
  -- General Compliment
    ["gc"] = "[C] - Compliment *",
      ["gca"] = "[A] - Awesome!",
      ["gcg"] = "[G] - Good game",
      ["gcn"] = "[N] - Nice move!",
      ["gcs"] = "[S] - Great shot!",
      ["gcy"] = "[Y] - You rock!",
  -- General Response
    ["gr"] = "[R] - Response *",
      ["gra"] = "[A] - Any time",
      ["grd"] = "[D] - I don't know",
      ["grt"] = "[T] - Thanks",
      ["grw"] = "[W] - Wait",
  -- General Taunt
    ["gt"] = "[T] - Taunt *",
      ["gta"] = "[A] - Awww, that's too bad",
      ["gtb"] = "[B] - Is that the best you can do?",
      ["gtg"] = "[G] - I am the greatest!",
      ["gtm"] = "[M] - Maximum stacks!",
      ["gtt"] = "[T] - THAT was graceful",
      ["gtw"] = "[W] - When will you learn?",
  -- Hero
  -- This section uses a funky redirection system.
  -- A command ending in ">" will change the command to the first "word" of the value. In this case, "c" -> "Command"
  -- The rest of the string (excluding the space after the redirection) will be prepended to the output.
  -- If only the first letter of the redirected value is capitalised, it will be converted to lowercase.
  -- If the WHOLE value is capitalised, the prependation will be capitalised.
  -- e.g. ["hec"] = [VHEC] Kerillian, come here!
  -- e.g. ["hegs"] = [VHEGS] KERILLIAN, SIGMAR
  ["h"] = "[H] - Hero *",
    ["he"] = "[E] - Kerillian, Elf Waywatcher *",
        ["he>"] = "c Kerillian,",
    ["hd"] = "[D] - Bardin, Dwarf Ranger *",
        ["hd>"] = "c Bardin,",
    ["hs"] = "[S] - Saltzpyre, Witch Hunter *",
        ["hs>"] = "c Saltzpyre,",
    ["hk"] = "[K] - Kruber, Mercenary *",
        ["hk>"] = "c Kruber,",
    ["hb"] = "[B] - Sienna, Bright Wizard *",
        ["hb>"] = "c Sienna,",
  -- Item
  ["i"] = "[I] - Item *",
    ["ia"] = "[A] - Art",
    ["ib"] = "[B] - Barrel",
    ["ic"] = "[C] - Potion of concentration",
    ["id"] = "[D] - Healing draught",
    ["ie"] = "[E] - Bomb",
    ["if"] = "[F] - Incendiary bomb",
    ["ig"] = "[G] - Grimoire",
    ["ih"] = "[H] - Healing",
    ["im"] = "[M] - Medical supplies",
    ["ip"] = "[P] - Potion",
    ["iq"] = "[Q] - Potion of speed", -- The quicks
    ["is"] = "[S] - Potion of strength",
    ["it"] = "[T] - Tome",
    ["iw"] = "[W] - Essence chunk", -- The W is for weave I guess
  -- Monster
  ["m"] = "[M] - Monster *",
    ["mc"] = "[C] - Chaos spawn!",
    ["mm"] = "[M] - Minotaur!",
    ["mr"] = "[R] - Rat Ogre!",
    ["ms"] = "[S] - Storm Fiend!",
    ["mt"] = "[T] - Troll!",
  -- Need
  ["n"] = "[N] - Need *",
    ["nb"] = "[B] - I need a bomb",
    ["ne"] = "[E] - I need an escort",
    ["np"] = "[P] - I need a potion",
    ["nh"] = "[H] - I need healing",
    ["ns"] = "[S] - I need support",
  -- Patrol
  ["p"] = "[P] - Patrol *",
    ["pb"] = "[B] - Beastmen patrol!",
    ["pc"] = "[C] - Chaos patrol!",
    ["pp"] = "[P] - Patrol!", -- Haha PP
    ["ps"] = "[S] - Stormvermin patrol!",
  -- Special
  ["s"] = "[S] - Special *",
    ["sa"] = "[A] - Assassin!",
    ["sb"] = "[B] - Blightstormer!",
    ["sf"] = "[F] - Flag Wargor!", -- F means Flag probably
    ["sg"] = "[G] - Globadier!",
    ["sl"] = "[L] - Life Leech!",
    ["sp"] = "[P] - Packmaster!",
    ["sr"] = "[R] - Ratling Gunner!",
    ["ss"] = "[S] - Sack Rat!",
    ["sw"] = "[W] - Warpfire Thrower!",
  -- Question
  ["q"] = "[Q] - Question *",
    ["qb"] = "[B] - Are we getting books?",
    ["qg"] = "[G] - Are we getting grims?",
    ["qw"] = "[W] - Which way?",
  -- Talent
  ["t"] = "[T] - Talent *",
    ["tp"] = "[P] - I have proxy",
    ["th"] = "[H] - I have heal share",
    ["ts"] = "[S] - I have hand of Shallya",
    ["tn"] = "[N] - I have natural bond",
  -- Duplication
    ["td"] = "[D] - Duplication *",
      ["tdb"] = "[B] - I have bomb duplication",
      ["tdh"] = "[H] - I have healing duplication",
      ["tdp"] = "[P] - I have potion duplication",
  -- Mercenary Kruber
    ["tm"] = "[M] - Mercenary Kruber *",
      ["tmr"] = "[R] - My shout will revive you",
  -- Ranger Bardin
    ["tr"] = "[R] - Ranger Bardin Ammo *",
      ["tra"] = "[A] - I have more ammo per pouch",
      ["trs"] = "[S] - I get ammo when you pick it up",
      ["trb"] = "[B] - I have bomb and potion chance",
  -- Very-quick
  ["v"] = "[V] - Very Quick *",
    ["va"] = "[A] - Anytime",
    ["vc"] = "[C] - Cease fire!",
    ["vd"] = "[D] - I don't know",
    ["vh"] = "[H] - Help!",
    ["vm"] = "[M] - Move!",
    ["vn"] = "[N] - No",
    ["vs"] = "[S] - Sorry",
    ["vt"] = "[T] - Thanks",
    ["vv"] = "[V] - Look out!",
    ["vw"] = "[W] - Wait",
    ["vy"] = "[Y] - Yes",
  -- Warning
  ["w"] = "[W] - Warning *",
    ["wa"] = "[A] - Ambush!",
    ["wb"] = "[B] - Behind us!",
    ["we"] = "[E] - Incoming hostiles!",
    ["wh"] = "[H] - Horde!",
    ["wl"] = "[M] - Look out!",
    ["wm"] = "[M] - Monster!",
    ["ws"] = "[S] - Specials spawning!",
  -- Self (see "Hero" for redirection explanation)
  ["z"] = "[Z] - Self *",
    ["z>"] = "c I will",
}

-- Build a list of commands that can be entered next
-- Also calculates pixel width of the list and sorts keys
mod.get_command = function ()
  if mod.vtgs[mod.command .. ">"] then
    -- Redirection
    local temp_val = mod.vtgs[mod.command .. ">"]
    mod.prepend_command = mod.prepend_command .. mod.command
    local i = 0
    local prepend_fields = {}
    for s in string.gmatch(temp_val, "%S+") do
      if i == 0 then
        mod.command = s
      else
        table.insert(prepend_fields, s)
      end
      i = i + 1
    end
    if mod.prepend_text == "" then
      mod.prepend_text = table.concat(prepend_fields, " ")
    else
      mod.prepend_text = mod.prepend_text .. " " .. string.lower(table.concat(prepend_fields, " "))
    end
  end
  local default_font = mod.simple_ui.fonts:get("default")
  mod.list = {}
  mod.list_keys = {}
  mod.list_count = 0
  mod.list_width = 0

  for k, v in pairs(mod.vtgs) do
    if string.len(k) == string.len(mod.command) + 1 and string.match(k, mod.command .. "%a") then
      -- We use len in addition to match because when command is empty "%a" matches all entries
      mod.list_count = mod.list_count + 1
      mod.list[k] = v
      mod.list_keys[#mod.list_keys + 1] = k

      -- Get pixel width of largest line
      local value_width = mod.basic_gui:text_width(v, default_font.material, default_font:font_size())
      if value_width > mod.list_width then
        mod.list_width = value_width
      end
    end
  end

  -- Put the list in alphabetical order
  table.sort(mod.list_keys)
end

-- Create an input service so we can be blocked etc.
mod.input_service = nil
mod.on_all_mods_loaded = function ()
  Managers.input:create_input_service("vtgs_service", "VTGS_SIMPLE_KEY_MAP")
  Managers.input:map_device_to_service("vtgs_service", "keyboard")
  -- Managers.input:map_device_to_service("vtgs_service", "mouse")
  -- Managers.input:map_device_to_service("vtgs_service", "gamepad")
  mod.input_service = Managers.input:get_service("vtgs_service")
  -- mod:echo("VTGS Loaded")
end

-- I use the update function instead of using a View because I don't want to hide other UI elements
mod.update = function(dt)
  -- Gotta be active to do the thing!!!
  if mod.activated then
    -- We use the trigger_clear flag to unblock input the frame AFTER we read any_pressed
    -- If we don't, the input will be propagated e.g. if the last key pressed is 'F' the player will use their ult
    if mod.trigger_clear then
      mod.clear()
    else
      -- I feel reading from Keyboard is better than 500 if-else on an input service event list
      local key_index = Keyboard.any_pressed()
      if key_index then
        -- Don't read the same key without a frame of not-being-pressed between
        if key_index ~= mod.last_key then
          -- Add character to our string
          mod.command = mod.command .. Keyboard.button_name(key_index)
          -- Check that the command exists (partial commands must exist in the table!)
          if mod.vtgs[mod.command] then
            -- Build the list of "next" commands
            mod.get_command()
            -- If there are no "next" commands, our command is the end of the chain
            if mod.list_count == 0 then
              mod.send_command()
              mod.trigger_clear = true
            -- Otherwise rebuild the window and show new options
            else
              mod.refresh_window()
            end
          -- Invalid keys close the window immediately (well, after a frame) to avoid embarassment
          else
            mod.trigger_clear = true
          end
        else
          mod.trigger_clear = true
        end
      end
      mod.last_key = key_index
    end
  end
end

-- UI window stuff
mod.show_window = function ()
  -- Scaling is done based on 16:9 width and ultrawides will look a bit off UNLESS
  local screen_width, screen_height = UIResolution()
  local x_factor = screen_width / 1920 -- haha
  -- local y_factor = screen_height / 1080

  -- Wew magic numbers
  local window_size = {(mod.list_width / x_factor) + 20, (mod.list_count * 20) + 40 }

  -- Positioned horizontally 2/3 and vertically center
  local window_position = {(1920 * 0.66), (1080 / 2) - (window_size[2] / 2)}
  mod.window = mod.simple_ui:create_window("vtgs_main", window_position, window_size)

  -- We use the "default" font instead of "hell_shark" because hell_shark ignores font size and uses screen_width / 100
  local vtgs_title = mod.window:create_title("vtgs_title", "VTGS", 15)
  vtgs_title.theme.font = "default"
  local label_pos = {10, window_size[2] - 40}

  -- I don't think this actually affects anything lol
  local label_size = {5,5}

  -- Show the "next" commands as labels
  for _, k in pairs(mod.list_keys) do
    local label = mod.window:create_label("vtgs_" .. k, label_pos, label_size, nil, mod.list[k])
    label.theme.font = "default"
    label.theme.text_alignment = "top_left"
    label_pos[2] = label_pos[2] - 20
  end

  -- Do the thing!
  mod.window:init()
end

-- Get rid of it
mod.hide_window = function ()
  if mod.window then
    mod.window:destroy()
    mod.window = nil
  end
end

-- Rebuild the window
mod.refresh_window = function ()
  mod.hide_window()
  mod.show_window()
end

-- Block other input devices so we can do the thing without worrying about other keybinds
mod.activate = function ()
  Managers.input:block_device_except_service("vtgs_service", "keyboard", 1, "keybind")
  -- Managers.input:block_device_except_service("vtgs_service", "mouse", 1, "keybind")
  -- Managers.input:block_device_except_service("vtgs_service", "gamepad", 1, "keybind")
  mod.activated = true
  mod.get_command()
  mod.show_window()
end

-- Reset vars and unblock inputs
mod.clear = function ()
  mod.hide_window()
  mod.command = ""
  mod.last_key = nil
  mod.activated = false
  mod.trigger_clear = false
  mod.prepend_text = ""
  mod.prepend_command = ""
  Managers.input:device_unblock_all_services("keyboard", 1)
  -- Managers.input:device_unblock_all_services("mouse", 1)
  -- Managers.input:device_unblock_all_services("gamepad", 1)
end

-- Grab command and put it in chat (also checks settings variables etc.)
mod.send_command = function ()
  local command_text = string.sub(mod.vtgs[mod.command], 7)

  -- Prepend text if command calls for it
  if mod.prepend_text ~= "" then
    mod.command = string.sub(mod.prepend_command, 1, -1) .. string.sub(mod.command, 2)
    local first_two = string.sub(command_text, 1, 2)
    if string.upper(command_text) == command_text then
      command_text = string.upper(mod.prepend_text) .. " " .. command_text
    elseif string.upper(first_two) ~= first_two then
      command_text =
        mod.prepend_text ..
        " " ..
        string.lower(string.sub(command_text, 1, 1)) ..
        string.sub(command_text, 2)
    else
      command_text = mod.prepend_text .. " " .. command_text
    end
  end

  -- Prepend command if set
  local prepend = mod:get("vtgs_prepend_command")
  if prepend then
    command_text = "[V" .. string.upper(mod.command) .. "] " .. command_text
  end

  -- Send it out
  Managers.chat:send_chat_message(1, 1, command_text)
end
