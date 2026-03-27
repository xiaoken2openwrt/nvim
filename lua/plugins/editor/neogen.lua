-- ~/.config/nvim/lua/plugins/neogen.lua
return {
  "danymat/neogen",
  version = "*",  -- 使用稳定版本
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",  -- 需要 Tree-sitter 解析器
    -- 可选：如果需要 snippet 跳转功能
    "L3MON4D3/LuaSnip",
  },
  config = function()
    require("neogen").setup({
      enabled = true,
      -- 自动跳转到生成的注释中（插入模式）
      input_after_comment = true,
      -- 使用 LuaSnip 作为 snippet 引擎
      snippet_engine = "luasnip",
    })

    -- ========== 快捷键映射 ==========
    local opts = { noremap = true, silent = true }

    -- 生成当前函数/类的注释
    vim.keymap.set("n", "<leader>nf", function()
      require("neogen").generate()
    end, { desc = "Neogen: 生成函数/类注释" })

    -- 强制生成文件注释（在文件开头）
    vim.keymap.set("n", "<leader>nF", function()
      require("neogen").generate({ type = "file" })
    end, { desc = "Neogen: 生成文件注释" })

    -- 生成类注释（光标在类上时）
    vim.keymap.set("n", "<leader>nc", function()
      require("neogen").generate({ type = "class" })
    end, { desc = "Neogen: 生成类注释" })

    -- 生成类型注释（typedef, struct, enum 等）
    vim.keymap.set("n", "<leader>nt", function()
      require("neogen").generate({ type = "type" })
    end, { desc = "Neogen: 生成类型注释" })

    -- 在生成的注释字段间跳转（如果使用 snippet）
    vim.keymap.set("i", "<C-j>", function()
      require("neogen").jump_next()
    end, { desc = "Neogen: 跳转到下一个注释字段" })
    vim.keymap.set("i", "<C-k>", function()
      require("neogen").jump_prev()
    end, { desc = "Neogen: 跳转到上一个注释字段" })
  end,
}
