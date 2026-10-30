return {
  -- Core treesitter (main branch - new API)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    config = function()
      require("nvim-treesitter").setup()

      -- Install parsers if missing
      local ensure_installed = {
        "c", "cpp", "rust", "python", "go", "java",
        "markdown", "markdown_inline",
        "lua", "vim", "vimdoc",
        "json", "yaml", "toml", "bash",
        "html", "css", "javascript",
      }
      -- main 分支编译 parser 依赖 tree-sitter CLI (brew install tree-sitter-cli);
      -- 缺失时每次启动都会刷 18 条编译错误, 所以先检查
      local installed = require("nvim-treesitter").get_installed()
      local to_install = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, ensure_installed)
      if #to_install > 0 then
        if vim.fn.executable("tree-sitter") == 1 then
          require("nvim-treesitter").install(to_install)
        else
          vim.notify("tree-sitter CLI not found, skip parser install: brew install tree-sitter-cli", vim.log.levels.WARN)
        end
      end

      -- 有 parser 才开 treesitter 高亮 + 缩进; 没有 parser 的 filetype 保留原 indentexpr/cindent
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
