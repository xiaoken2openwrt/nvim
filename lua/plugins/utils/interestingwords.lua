-- ~/.config/nvim/lua/plugins/utils/interestingwords.lua
return {
  "mr-lllll/interestingwords.nvim",
  
  keys = {
    { "<leader>i", mode = { "n", "v" } },
    { "<leader>I", mode = "n" },
    { "]i", mode = "n" },
    { "[i", mode = "n" },
    { "<leader>is", mode = "n" },
  },

  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    local interestingwords = require("interestingwords")

    -- 基础配置
    interestingwords.setup({
      -- 高亮颜色设置（最多6种）
      highlights = {
        { guifg = "#000000", guibg = "#ff7b72" },  -- 红色
        { guifg = "#000000", guibg = "#7ee2b8" },  -- 绿色
        { guifg = "#000000", guibg = "#bb9af7" },  -- 紫色
        { guifg = "#000000", guibg = "#f3b9cc" },  -- 粉色
        { guifg = "#000000", guibg = "#e5c890" },  -- 黄色
        { guifg = "#000000", guibg = "#8caaee" },  -- 蓝色
      },
      
      -- 是否随机分配颜色
      randomize_colors = false,
      
      -- 是否保存标记到会话
      persist = true,
    })

    -- ========== 快捷键映射 ==========
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- 1. 标记/取消标记当前光标下的单词
    map("n", "<leader>i", function()
      interestingwords.InterestingWord()
    end, { desc = "InterestingWords: 标记/取消标记当前单词" })

    -- 2. 可视模式下标记选中的文本
    map("v", "<leader>i", function()
      -- 先获取选中的文本
      vim.cmd("normal! y")  -- 复制选中内容
      local word = vim.fn.getreg('"')  -- 获取复制的文本
      if word and #word > 0 then
        -- 跳转到单词开头并标记
        vim.cmd("normal! /" .. vim.fn.escape(word, '/\\') .. "\r")
        interestingwords.InterestingWord()
        vim.cmd("nohlsearch")
      end
    end, { desc = "InterestingWords: 标记选中的文本" })

    -- 3. 清除所有标记
    map("n", "<leader>I", function()
      interestingwords.UncolorAllWords()
    end, { desc = "InterestingWords: 清除所有标记" })

    -- 4. 跳转到下一个标记词
    map("n", "]i", function()
      interestingwords.NavigateToWord(1)  -- 参数 1 表示下一个
    end, { desc = "InterestingWords: 下一个标记词" })

    -- 5. 跳转到上一个标记词
    map("n", "[i", function()
      interestingwords.NavigateToWord(-1)  -- 参数 -1 表示上一个
    end, { desc = "InterestingWords: 上一个标记词" })

    -- 6. 显示所有标记词的列表
    map("n", "<leader>is", function()
      local words = interestingwords.words or {}
      if not words or vim.tbl_isempty(words) then
        vim.notify("没有标记任何单词", vim.log.levels.INFO)
        return
      end
      
      -- 构建显示列表
      local items = {}
      for i, word in ipairs(words) do
        table.insert(items, string.format("%d: %s", i, word))
      end
      
      -- 使用 vim.ui.select 显示列表
      vim.ui.select(items, {
        prompt = "标记的单词",
        format_item = function(item) return item end,
      }, function(choice)
        if choice then
          -- 提取单词并跳转
          local word = choice:match("%d+:%s*(.*)")
          if word then
            vim.cmd("normal! /\\<" .. word .. "\\>\r")
            vim.cmd("nohlsearch")
          end
        end
      end)
    end, { desc = "InterestingWords: 显示所有标记词" })

    -- 可选：显示当前标记数量
    map("n", "<leader>ic", function()
      local count = interestingwords.capcity or 0
      vim.notify("当前标记词数量: " .. count, vim.log.levels.INFO)
    end, { desc = "InterestingWords: 显示标记数量" })

    -- 启动时显示成功信息
    vim.notify("InterestingWords 已加载，可用函数: " .. vim.inspect(interestingwords), vim.log.levels.INFO)
  end,
}
