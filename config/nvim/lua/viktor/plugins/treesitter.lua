return {
 "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    -- nvim-treesitter ships a Haskell parser, but not separate parsers for
    -- literate Haskell or Cabal files.
    vim.treesitter.language.register("haskell", "lhaskell")

    treesitter.setup({
      highlight = {
        enable = true,
        disable = { "markdown", "markdown_inline" },
      },
      -- Treesitter indent can override normal `o`/`O` newline indent behavior.
      indent = { enable = false },
      autotag = {
        enable = true,
      },
      ensure_installed = {
        "json",
        "javascript",
        "typescript",
        "tsx",
        "rust",
        "toml",
        "yaml",
        "html",
        "css",
        "prisma",
        "markdown",
        "markdown_inline",
        "svelte",
        "graphql",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
        "cpp",
        "haskell",
        "gdscript",
        "gdshader",
        "godot_resource",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end,
}
