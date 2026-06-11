return {
	"stevearc/conform.nvim",
	opts = {
		formatters_by_ft = {
			gdscript = { "gdscript-formatter", "gdformat" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			javascriptreact = { "prettierd", "prettier", stop_after_first = true },
			typescript = { "prettierd", "prettier", stop_after_first = true },
			typescriptreact = { "prettierd", "prettier", stop_after_first = true },
			json = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
		},
	},
	keys = {
		{
			"<leader>fm",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			desc = "Format file",
		},
	},
}
