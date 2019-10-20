local mod = get_mod("VTGS")

return {
	name = "VTGS",
	description = mod:localize("mod_description"),
  is_togglable = true,
  options = {
    widgets = {
      {
        setting_id      = "vtgs_keybind",
        type            = "keybind",
        default_value   = {"v"},
        keybind_trigger = "pressed",
        keybind_type    = "function_call",
        function_name   = "activate",
      },
      {
        setting_id      = "vtgs_prepend_command",
        type            = "checkbox",
        default_value   = true,
      },
    }
  }
}
