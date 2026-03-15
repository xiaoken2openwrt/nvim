--[[
-- ~/.config/nvim/lua/plugins/claude-code.lua
return {
  -- 官方推荐的 Claude Code Neovim 插件
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- 用于 Git 操作和工作目录管理
  },
  -- 懒加载：只在需要时加载，不影响启动速度
  cmd = {
    "ClaudeCode",
    "ClaudeCodeContinue",
    "ClaudeCodeResume",
    "ClaudeCodeVerbose"
  },
  keys = {
 { '<leader>c', nil, desc = 'Claude Code' },
      { '<leader>cc', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>cf', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>cr', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>cC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>cm', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
      { '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      {
        '<leader>cs',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
      },
      { '<leader>ca', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>cd', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
  config = function()
    -- 引入插件主模块
    local claude = require("claude-code")

    -- 基础配置（可根据你的喜好调整）
    claude.setup({
      -- 终端窗口的外观和行为
      window = {
        split_ratio = 0.3,      -- 窗口占比，0.3 表示占总高度的30%
        position = "botright",  -- 窗口位置: "botright" (底部), "topleft" (顶部), "vertical" (右侧垂直)
        enter_insert = true,    -- 打开终端后是否自动进入插入模式
        hide_numbers = true,    -- 隐藏终端窗口的行号
        hide_signcolumn = true, -- 隐藏终端窗口的符号列
      },
      -- 文件自动刷新：当 Claude Code 在外部修改文件时，Neovim 自动重载 [citation:5]
      refresh = {
        enable = true,
        updatetime = 100,        -- 当 Claude Code 激活时，Neovim 的更新检测间隔
        timer_interval = 1000,   -- 轮询文件系统检查变动的间隔（毫秒）
        show_notifications = true, -- 文件重载时是否显示通知
      },
      -- Git 集成：自动切换到 Git 项目根目录
      git = {
        use_git_root = true,
      },
      -- 命令行工具配置
      command = "claude",        -- 启动 Claude Code 的命令
      command_variants = {       -- 命令的变体，用于不同的启动模式
        continue = "--continue", -- 继续最近的对话
        resume = "--resume",     -- 显示对话历史选择器
        verbose = "--verbose",   -- 启用详细日志
      },
      -- 快捷键配置（通常保持默认即可）
      keymaps = {
        toggle = {
          normal = "<C-,>",       -- 普通模式下切换终端
          terminal = "<C-,>",     -- 终端模式下切换终端
          variants = {
            continue = "<leader>cC",
            verbose = "<leader>cV",
          },
        },
        window_navigation = true, -- 启用窗口导航快捷键 (<C-h/j/k/l>)
        scrolling = true,         -- 启用终端滚动快捷键 (<C-f/b>)
      }
    })

    -- ========== 额外自定义快捷键（ClClaudeCodeFocusaudeCodeFocus可选） ==========
    local map = vim.keymap.set
    local opts = { noremap = true, siClaudeCodeFocuslent = true }

    -- 如果你不喜欢 <C-,>，可以自定义一个更顺手的键位，例如 <leader>cc
    --    map("n", "<leader>c", "<cmd><CR>", { desc = " Claude Code" })
    --    map("n", "<leader>cc", "<cmd>ClaudeCode<CR>", { desc = "切换 Claude Code 终端" })
    --    map("n", "<leader>cf", "<cmd>ClaudeCodeFocuslent<CR>", { desc = "聚焦 Claude Code 终端" })
    --    map("n", "<leader>cr", "<cmd>ClaudeCode --resume<CR>", { desc = "Resume Claude Code 终端" })
    --    map("n", "<leader>cC", "<cmd>ClaudeCode --continue<CR>", { desc = "Continue Claude Code 终端" })
    --    map("n", "<leader>cm", "<cmd>ClaudeCodeSelectModel<CR>", { desc = "Select Claude model" })
    --    map("n", "<leader>cb", "<cmd>ClaudeCodeAdd %<CR>", { desc = "Add current buffer" })
    --    map("n", "<leader>cs", "<cmd>ClaudeCodeSend<CR>", { desc = "Send to Claude" })
    --    map("v", "<leader>cs", "<cmd>ClaudeCodeSend<CR>", { desc = "Send selected to Claude" })
    --    map("n", "<leader>ca", "<cmd>ClaudeCodeDiffAccept<CR>", { desc = "Accept diff" })
    --    map("n", "<leader>cd", "<cmd>ClaudeCodeDiffDeny<CR>", { desc = "Deny diff" })
    --
    -- 为 Claude Code 创建一个独立的浮动窗口（需要插件支持，这里是示例）
    -- map("n", "<leader>cf", function()
    --   vim.cmd("ClaudeCode") -- 先启动
    --   -- 可以在这里添加窗口尺寸调整等逻辑
    -- end, { desc = "浮动窗口模式打开 Claude Code" })
  end,
}
]]

return {
  {
    'coder/claudecode.nvim',
    dependencies = {
      'folke/snacks.nvim',
    },
    config = true,
    opts = {
      terminal = {
        snacks_win_opts = {
          wo = {
            winblend = 100,
            winhighlight = 'NormalFloat:MyTransparentGroup',
          },
        },
      },
    },
    terminal = { enabled = true },
    keys = {
      { '<leader>c', nil, desc = 'Claude Code' },
      { '<leader>cc', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>cf', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>cr', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>cC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>cm', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
      { '<leader>cb', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      {
        '<leader>cs',
        '<cmd>ClaudeCodeTreeAdd<cr>',
        desc = 'Add file',
        ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
      },
      { '<leader>ca', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>cd', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
  },
}
