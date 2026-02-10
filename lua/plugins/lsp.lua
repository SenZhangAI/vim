return {
  -- Mason: LSP server installer
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  -- Mason-lspconfig bridge
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "clangd",
        "rust_analyzer",
        "pyright",
        "gopls",
        "jdtls",
      },
    },
  },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition, "Go to definition")
        map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
        map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
        map("n", "gr", vim.lsp.buf.references, "Find references")
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
      end

      local servers = {
        clangd = {
          cmd = { "clangd", "--background-index" },
        },
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = { command = "clippy" },
              cargo = { loadOutDirsFromCheck = true },
              procMacro = { enable = true },
            },
          },
        },
        pyright = {},
        gopls = {},
        jdtls = {},
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        lspconfig[server].setup(config)
      end
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
}
