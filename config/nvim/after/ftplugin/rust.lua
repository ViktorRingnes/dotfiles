local opts = { buffer = true, silent = true }

vim.keymap.set("n", "<leader>ca", function()
	vim.cmd.RustLsp("codeAction")
end, vim.tbl_extend("force", opts, { desc = "Rust grouped code actions" }))

vim.keymap.set("n", "<leader>ce", function()
	vim.cmd.RustLsp("explainError")
end, vim.tbl_extend("force", opts, { desc = "Explain rustc error" }))

vim.keymap.set("n", "<leader>cd", function()
	vim.cmd.RustLsp("renderDiagnostic")
end, vim.tbl_extend("force", opts, { desc = "Render full diagnostic" }))

vim.keymap.set("n", "<leader>cm", function()
	vim.cmd.RustLsp("expandMacro")
end, vim.tbl_extend("force", opts, { desc = "Expand macro recursively" }))

vim.keymap.set("n", "<leader>cR", function()
	vim.cmd.RustLsp("runnables")
end, vim.tbl_extend("force", opts, { desc = "Rust runnables" }))
