return {
	{
		"nvim-mini/mini.ai",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
		config = function()
			local ai = require("mini.ai")
			ai.setup({
				n_lines = 200,
				custom_textobjects = {
					f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
					a = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
					-- Custom captures from after/queries/*/textobjects.scm:
					-- dam deletes a match arm, vau selects an unsafe block.
					m = ai.gen_spec.treesitter({ a = "@matcharm.outer", i = "@matcharm.inner" }),
					u = ai.gen_spec.treesitter({ a = "@unsafe.outer", i = "@unsafe.inner" }),
				},
			})
		end,
	},
	{
		"nvim-mini/mini.operators",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
}
