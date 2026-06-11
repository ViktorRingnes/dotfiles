return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		local mason = require("mason")

		local mason_lspconfig = require("mason-lspconfig")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		local ensure_installed = {
			"ts_ls",
			"html",
			"cssls",
			"tailwindcss",
			"svelte",
			"lua_ls",
			"graphql",
			"emmet_ls",
			"pyright",
			"clangd",
			"rust_analyzer",
		}

		mason_lspconfig.setup({
			ensure_installed = ensure_installed,
		})
	end,
}
