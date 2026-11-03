-- Use Apple's clangd from the Xcode Command Line Tools instead of Mason's build.
-- It ships with macOS dev tools, finds the Apple SDK headers natively, and
-- avoids the large Mason download. Keep LazyVim's clangd flags, swap only the binary.
return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    local clangd = opts.servers.clangd or {}
    clangd.mason = false
    clangd.cmd = vim.deepcopy(clangd.cmd or { "clangd" })
    clangd.cmd[1] = "/Library/Developer/CommandLineTools/usr/bin/clangd"
    opts.servers.clangd = clangd
  end,
}
