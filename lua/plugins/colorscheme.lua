-- Match Ghostty: Catppuccin Latte on a light terminal, Mocha on a dark one.
-- Neovim detects the terminal background at startup and sets vim.o.background;
-- catppuccin's "auto" flavour follows that, so both switch together.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = {
      flavour = "auto",
      background = { light = "latte", dark = "mocha" },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
