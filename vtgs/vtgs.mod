return {
	run = function()
		fassert(
			rawget(_G, "new_mod"),
			"`VTGS` mod must be lower than Vermintide Mod Framework in your launcher's load order."
		)

		new_mod("VTGS", {
			mod_script       = "scripts/mods/vtgs/vtgs",
			mod_data         = "scripts/mods/vtgs/vtgs_data",
			mod_localization = "scripts/mods/vtgs/vtgs_localization",
		})
	end,
	packages = {
		"resource_packages/vtgs/vtgs",
	},
}
