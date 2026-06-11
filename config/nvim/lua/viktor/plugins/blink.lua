return {
	"saghen/blink.cmp",
	version = "1.*",
	event = "InsertEnter",
	dependencies = {
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			dependencies = { "rafamadriz/friendly-snippets" },
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
	},
	opts = {
		snippets = { preset = "luasnip" },
		keymap = { preset = "enter" },
		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 200 },
			list = { selection = { preselect = false, auto_insert = true } },
		},
		signature = { enabled = true },
		appearance = { nerd_font_variant = "mono" },
	},
}
