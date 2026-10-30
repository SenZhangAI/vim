-- 只做代码阅读导航 (跳转/引用/悬浮文档/诊断): 代码交给 Claude 写,
-- 所以不装补全、格式化、lint, 也不自动安装服务器 —— PATH 里有哪个就启用哪个
local servers = {
  clangd = "clangd",
  rust_analyzer = "rust-analyzer",
  pyright = "pyright-langserver",
  gopls = "gopls",
  jdtls = "jdtls",
  lua_ls = "lua-language-server",
}

return {
  -- 需要时手动 :Mason 安装服务器
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {},
  },

  -- LSP config (data-only: provides lsp/*.lua defaults)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- mason 懒加载时不会把自己的 bin 加进 PATH, 这里补上, 已装过的服务器照常可用
      local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
      if vim.uv.fs_stat(mason_bin) and not vim.env.PATH:find(mason_bin, 1, true) then
        vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
      end

      vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index" },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
            cargo = { buildScripts = { enable = true } },
            procMacro = { enable = true },
          },
        },
      })

      for name, bin in pairs(servers) do
        if vim.fn.executable(bin) == 1 then
          vim.lsp.enable(name)
        end
      end

      -- Buffer-local keymaps on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
        callback = function(ev)
          local map = function(mode, lhs, rhs, desc, extra)
            vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { buffer = ev.buf, desc = desc }, extra or {}))
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gy", vim.lsp.buf.type_definition, "Go to type definition")
          map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
          -- nowait: 不等待 0.11 内置的 grr/grn/gra 等前缀映射
          map("n", "gr", function() Snacks.picker.lsp_references() end, "References", { nowait = true })
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<F2>", vim.lsp.buf.rename, "Rename symbol")
          map("n", "<leader>ac", vim.lsp.buf.code_action, "Code action")
          map("x", "<leader>a", vim.lsp.buf.code_action, "Code action (selection)")
          map("n", "<leader>qf", function()
            vim.lsp.buf.code_action({
              filter = function(a) return a.isPreferred end,
              apply = true,
            })
          end, "Quick fix")
          map({ "n", "x" }, "<leader>af", function() vim.lsp.buf.format({ async = true }) end, "Format")
          map("n", "<space>o", function() Snacks.picker.lsp_symbols() end, "Document symbols")
          map("n", "<space>s", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace symbols")
        end,
      })
    end,
  },
}
