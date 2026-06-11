return {
	"mrcjkb/rustaceanvim",
	version = "^6",
	lazy = false,
	init = function()
		vim.g.rustaceanvim = {
			server = {
				default_settings = {
					["rust-analyzer"] = {
						inlayHints = {
							typeHints = { enable = true },
							parameterHints = { enable = false },
							chainingHints = { enable = false },
							bindingModeHints = { enable = false },
							closureReturnTypeHints = { enable = "never" },
							lifetimeElisionHints = { enable = "never" },
							reborrowHints = { enable = false },
							closingBraceHints = { enable = false },
						},
					},
				},
			},
		}
	end,
}
