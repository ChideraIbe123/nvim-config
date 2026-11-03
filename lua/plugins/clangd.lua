-- macOS only: use Apple's clangd from the Xcode Command Line Tools instead of
-- Mason's build. It finds the Apple SDK headers natively and avoids the large
-- Mason download. On Linux this spec is a no-op and LazyVim uses Mason/apt clangd.
local apple_clangd = "/Library/Developer/CommandLineTools/usr/bin/clangd"
if vim.fn.has("mac") == 0 or vim.fn.executable(apple_clangd) == 0 then
  return {}
end
return {
  "neovim/nvim-lspconfig",
  opts = function(_, opts)
    opts.servers = opts.servers or {}
    local clangd = opts.servers.clangd or {}
    clangd.mason = false
    clangd.cmd = vim.deepcopy(clangd.cmd or { "clangd" })
    clangd.cmd[1] = apple_clangd
    opts.servers.clangd = clangd
  end,
}
