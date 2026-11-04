-- Python LSP tuning on top of LazyVim's python extra (enabled in lazyvim.json;
-- basedpyright/ruff selection lives in config/options.lua).
-- Division of labor: ruff owns lint/format/imports, basedpyright owns types/hover.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff = {
          init_options = {
            settings = {
              -- no import re-sorting: drop the "un-sorted imports" lint and
              -- the organize-imports code action
              organizeImports = false,
              lint = { ignore = { "I001" } },
            },
          },
        },
        basedpyright = {
          settings = {
            basedpyright = {
              -- ruff organizes imports; don't let both tools fight over it
              disableOrganizeImports = true,
              analysis = {
                -- "basic" keeps obvious type errors but stays quiet on
                -- untyped third-party code (old codebases light up
                -- "standard"+ with noise). Crank up per-project via
                -- pyrightconfig.json when working on typed code.
                typeCheckingMode = "basic",
                diagnosticSeverityOverrides = {
                  -- bare expressions are how you display values in notebooks
                  reportUnusedExpression = "none",
                  -- "might be None" / type-mismatch checks: the checker often can't
                  -- follow isinstance()/dict.get() guards in dynamic code, so these
                  -- false-alarm as red errors on code that runs fine. Keep them as
                  -- warnings (hidden inline, still listed in Trouble with <leader>xx).
                  reportOptionalMemberAccess = "warning",
                  reportOptionalSubscript = "warning",
                  reportOptionalOperand = "warning",
                  reportOptionalIterable = "warning",
                  reportOptionalCall = "warning",
                  reportArgumentType = "warning",
                  reportReturnType = "warning",
                  reportAttributeAccessIssue = "warning",
                  reportCallIssue = "warning",
                  reportIndexIssue = "warning",
                },
              },
            },
          },
        },
      },
    },
  },
}
