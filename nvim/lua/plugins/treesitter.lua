return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "lua", "javascript", "typescript", "python", "json", "html", "css",
      })
    end,
  },
}
