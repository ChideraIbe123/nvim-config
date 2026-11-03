return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown", "markdown_inline" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-mini/mini.icons",
  },
  opts = {
    render_modes = { "n", "c", "t" },
    code = {
      style = "full",
    },
    heading = {
      sign = true,
    },
  },
}
