local severity = vim.diagnostic.severity

vim.diagnostic.config({
	severity_sort = true,
	update_in_insert = false,
	-- Only Warn and Error get an undercurl. rust-analyzer and ts_ls emit a lot
	-- of hints; squiggling all of them is the main source of visual noise.
	underline = { severity = { min = severity.WARN } },
	signs = {
		text = {
			[severity.ERROR] = " ",
			[severity.WARN] = " ",
			[severity.INFO] = " ",
			[severity.HINT] = "󰠠 ",
		},
		numhl = {
			[severity.ERROR] = "DiagnosticSignError",
			[severity.WARN] = "DiagnosticSignWarn",
		},
	},
	-- tiny-inline-diagnostic owns end-of-line rendering.
	virtual_text = false,
	virtual_lines = false,
	float = {
		border = "rounded",
		source = "if_many",
		header = "",
		max_width = 80,
		prefix = function(diag)
			local labels = { "Error", "Warn", "Info", "Hint" }
			return "● ", "Diagnostic" .. labels[diag.severity]
		end,
		suffix = function(diag)
			return diag.code and (" [" .. diag.code .. "]") or ""
		end,
	},
})

-- Toggle the native multiline view for a gnarly trait error you cannot read at
-- end of line, swapping tiny-inline out while it is on.
vim.keymap.set("n", "<leader>dl", function()
	local showing = not vim.diagnostic.config().virtual_lines
	vim.diagnostic.config({ virtual_lines = showing or false })
	local ok, tiny = pcall(require, "tiny-inline-diagnostic")
	if ok then
		tiny[showing and "disable" or "enable"]()
	end
end, { desc = "Toggle multiline diagnostics" })
