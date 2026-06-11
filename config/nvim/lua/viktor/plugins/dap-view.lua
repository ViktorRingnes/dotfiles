return {
	{
		"igorlfs/nvim-dap-view",
		dependencies = {
			"mfussenegger/nvim-dap",
			"Jorenar/nvim-dap-disasm",
		},
		config = function()
			local dap = require("dap")
			local dapview = require("dap-view")

			dapview.setup({
				winbar = {
					sections = { "watches", "scopes", "breakpoints", "threads", "disassembly", "repl", "console" },
					default_section = "scopes",
				},
			})

			dap.listeners.after.event_initialized["dapview_config"] = function()
				dapview.open()
			end
			dap.listeners.before.event_terminated["dapview_config"] = function()
				dapview.close()
			end
			dap.listeners.before.event_exited["dapview_config"] = function()
				dapview.close()
			end

			vim.keymap.set("n", "<leader>du", function()
				dapview.toggle()
			end, { desc = "DAP view toggle" })
			vim.keymap.set("n", "<leader>dw", "<cmd>DapViewWatch<CR>", { desc = "Watch expression under cursor" })
		end,
	},
	{
		"Jorenar/nvim-dap-disasm",
		dependencies = { "igorlfs/nvim-dap-view" },
		opts = {},
	},
}
