return {
	"MagicDuck/grug-far.nvim",
	keys = {
		{ "<leader>sr", "<cmd>GrugFar<CR>", desc = "Project search and replace" },
		{
			"<leader>sw",
			function()
				require("grug-far").open({ prefills = { search = vim.fn.expand("<cword>") } })
			end,
			desc = "Search and replace word under cursor",
		},
	},
	opts = {},
}
