return {
	-- Installed for its textobject queries, which mini.ai and the custom
	-- after/queries objects consume. The move/swap modules are not used; the
	-- legacy master branch broke against current treesitter. Function and
	-- parameter motions live in core/ts_motions.lua instead.
	"nvim-treesitter/nvim-treesitter-textobjects",
	branch = "master",
	dependencies = { { "nvim-treesitter/nvim-treesitter", branch = "master" } },
	event = { "BufReadPre", "BufNewFile" },
}
