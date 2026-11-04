-- Show git-ignored and hidden files in the file finder and live grep, so the
-- picker matches nvim-tree (which also shows ignored files). Toggle per search
-- with <a-i> (ignored) and <a-h> (hidden) inside any picker.
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true, ignored = true },
        grep = { hidden = true, ignored = true },
        explorer = { hidden = true, ignored = true },
      },
    },
  },
}
