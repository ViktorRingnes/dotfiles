return {
	"rachartier/tiny-inline-diagnostic.nvim",
	event = "VeryLazy",
	priority = 1000,
	config = function()
		require("tiny-inline-diagnostic").setup({
			preset = "powerline",
			transparent_bg = false,
			options = {
				show_source = { enabled = true, if_many = true },
				use_icons_from_diagnostic = true,
				set_arrow_to_diag_color = true,
				softwrap = 30,
				multilines = { enabled = true, always_show = false },
				show_all_diags_on_cursorline = false,
				enable_on_insert = false,
				throttle = 20,
			},
		})
	end,
}
