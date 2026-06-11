return {
	"cbochs/grapple.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		scope = "git_branch",
		icons = true,
	},
	keys = {
		{ "<leader>m", "<cmd>Grapple toggle<CR>", desc = "Grapple toggle tag" },
		{ "<leader>,", "<cmd>Grapple toggle_tags<CR>", desc = "Grapple tags window" },
		{ "<leader>1", "<cmd>Grapple select index=1<CR>", desc = "Grapple file 1" },
		{ "<leader>2", "<cmd>Grapple select index=2<CR>", desc = "Grapple file 2" },
		{ "<leader>3", "<cmd>Grapple select index=3<CR>", desc = "Grapple file 3" },
		{ "<leader>4", "<cmd>Grapple select index=4<CR>", desc = "Grapple file 4" },
	},
}
