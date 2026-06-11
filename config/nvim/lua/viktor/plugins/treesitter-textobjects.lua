return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "master",
	dependencies = { { "nvim-treesitter/nvim-treesitter", branch = "master" } },
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("nvim-treesitter.configs").setup({
			textobjects = {
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["]f"] = "@function.outer",
						["]a"] = "@parameter.inner",
						["]m"] = "@matcharm.outer",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[a"] = "@parameter.inner",
						["[m"] = "@matcharm.outer",
					},
				},
				swap = {
					enable = true,
					swap_next = { ["g>"] = "@parameter.inner" },
					swap_previous = { ["g<"] = "@parameter.inner" },
				},
			},
		})
	end,
}
