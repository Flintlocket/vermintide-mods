return {
	run = function()
		fassert(
			rawget(_G, "new_mod"),
			"`Give Me the Buff` mod must be lower than Vermintide Mod Framework in your launcher's load order."
		)

		new_mod("givebuff", {
			mod_script       = "scripts/mods/givebuff/givebuff",
			mod_data         = "scripts/mods/givebuff/givebuff_data",
			mod_localization = "scripts/mods/givebuff/givebuff_localization",
		})
	end,
	packages = {
		"resource_packages/givebuff/givebuff",
	},
}
