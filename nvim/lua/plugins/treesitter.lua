-- nvim-treesitter on the master branch (the version lazy.nvim installs by
-- default). The new `main` branch uses a different API; mixing them is what
-- caused the startup errors. Stick to master + nvim-treesitter.configs.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash",
        "javascript", "typescript", "tsx",
        "python", "json", "yaml", "toml",
        "html", "css", "markdown", "markdown_inline",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
