return {
  -- Mason: LSP server installer
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  -- Mason-lspconfig bridge (auto-installs + auto-enables servers)
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "clangd",
        "rust_analyzer",
        "pyright",
        -- gopls installed manually (registry v0.21 requires Go 1.25+)
        "jdtls",
        "lua_ls",
      },
      automatic_enable = true,
    },
  },

  -- Lua LSP support for Neovim config editing
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {},
  },

  -- LSP config (data-only: provides lsp/*.lua defaults)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      -- Global defaults for all LSP clients
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- Per-server overrides
      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index" },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            checkOnSave = { command = "clippy" },
            cargo = { loadOutDirsFromCheck = true },
            procMacro = { enable = true },
          },
        },
      })

      -- Buffer-local keymaps on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local bufnr = ev.buf
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          -- gr mapped to Trouble lsp_references (see trouble.nvim config)
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<leader>ac", vim.lsp.buf.code_action, "Code action")
          map("x", "<leader>a", vim.lsp.buf.code_action, "Code action (selection)")
          map("n", "<leader>qf", function()
            vim.lsp.buf.code_action({
              filter = function(a) return a.isPreferred end,
              apply = true,
            })
          end, "Quick fix")
          map("n", "<space>o", function()
            require("telescope.builtin").lsp_document_symbols()
          end, "Document symbols")
          map("n", "<space>s", function()
            require("telescope.builtin").lsp_dynamic_workspace_symbols()
          end, "Workspace symbols")

          -- Highlight symbol under cursor
          if client and client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = bufnr,
              callback = vim.lsp.buf.document_highlight,
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = bufnr,
              callback = vim.lsp.buf.clear_references,
            })
          end
        end,
      })
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>af", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, desc = "Format" },
    },
    opts = {
      formatters_by_ft = {
        python = { "ruff_format" },
        rust = { "rustfmt" },
        go = { "gofmt", "goimports" },
        java = { "google-java-format" },
        c = { "clang-format" },
        cpp = { "clang-format" },
      },
    },
  },

  -- Linting (non-LSP linters)
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPost", "BufWritePost" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        python = { "ruff" },
        c = { "cppcheck" },
        cpp = { "cppcheck" },
      }
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },

  -- Diagnostics viewer (replaces basic loclist)
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<space>a", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<space>d", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<space>q", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
      { "<space>l", "<cmd>Trouble loclist toggle<cr>", desc = "Loclist (Trouble)" },
      { "gr", "<cmd>Trouble lsp_references toggle<cr>", desc = "LSP references (Trouble)" },
    },
    opts = {},
  },

  -- LSP progress indicator
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
}
