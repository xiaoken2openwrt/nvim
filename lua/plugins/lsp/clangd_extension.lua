-- ~/.config/nvim/lua/plugins/clangd_extensions.lua
return {
  "p00f/clangd_extensions.nvim",
  
  -- 依赖：需要你的 clangd 已经通过 lspconfig 配置好
  dependencies = {
    "neovim/nvim-lspconfig",  -- 依赖 lspconfig
  },
  
  -- 懒加载：在需要用到其命令时再加载
  cmd = {
    "ClangdAST",
    "ClangdTypeHierarchy",
    "ClangdSymbolInfo",
    "ClangdMemoryUsage",
    "ClangdSwitchSourceHeader",
  },
  
  -- 配置函数
  config = function()
    -- 基础配置（可根据需要调整）
    require("clangd_extensions").setup({
      -- AST 查看窗口的图标设置
      ast = {
        -- 角色图标（语法树中的角色）
        role_icons = {
          type = "🄣",
          declaration = "🄓",
          expression = "🄔",
          statement = ";",
          specifier = "🄢",
          ["template argument"] = "🆃",
        },
        -- 节点类型图标
        kind_icons = {
          Compound = "🄲",
          Recovery = "🅁",
          TranslationUnit = "🅄",
          PackExpansion = "🄿",
          TemplateTypeParm = "🅃",
          TemplateTemplateParm = "🅃",
          TemplateParamObject = "🅃",
        },
        -- 高亮设置
        highlights = {
          detail = "Comment",
        },
      },
      
      -- 内存使用窗口的边框样式
      memory_usage = {
        border = "none",  -- 可选 "single", "double", "rounded", "none"
      },
      
      -- 符号信息窗口的边框样式
      symbol_info = {
        border = "none",
      },
      
      -- 内联提示设置（需 clangd 支持）
      inlay_hints = {
        inline = vim.fn.has("nvim-0.10") == 1,  -- Neovim 0.10+ 支持内联提示
        -- 是否只显示当前行的提示
        only_current_line = false,
        -- 触发提示刷新的事件
        only_current_line_autocmd = { "CursorHold" },
        -- 是否显示参数提示
        show_parameter_hints = true,
        -- 参数提示前缀
        parameter_hints_prefix = "<- ",
        -- 其他提示前缀（类型提示等）
        other_hints_prefix = "=> ",
        -- 提示颜色
        highlight = "Comment",
      },
    })

    -- ========== 常用快捷键映射 ==========
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- 1. 头文件/源文件切换
    map("n", "<leader>ch", "<cmd>ClangdSwitchSourceHeader<CR>", 
        { desc = "Clangd: 切换头文件/源文件" })

    -- 2. 查看当前光标所在代码的 AST
    map("n", "<leader>ca", "<cmd>ClangdAST<CR>", 
        { desc = "Clangd: 查看 AST" })
    -- 可视模式下查看选中范围的 AST
    map("v", "<leader>ca", ":'<,'>ClangdAST<CR>", 
        { desc = "Clangd: 查看选中范围的 AST" })

    -- 3. 查看当前符号的类型层级
    map("n", "<leader>ct", "<cmd>ClangdTypeHierarchy<CR>", 
        { desc = "Clangd: 类型层级" })

    -- 4. 查看当前符号的详细信息
    map("n", "<leader>ci", "<cmd>ClangdSymbolInfo<CR>", 
        { desc = "Clangd: 符号信息" })

    -- 5. 查看 clangd 内存使用情况
    map("n", "<leader>cm", "<cmd>ClangdMemoryUsage<CR>", 
        { desc = "Clangd: 内存使用" })
    -- 展开预编译头详细信息的版本
    map("n", "<leader>cM", "<cmd>ClangdMemoryUsage expand_preamble<CR>", 
        { desc = "Clangd: 内存使用（展开预编译头）" })

    -- 6. 内联提示开关（如果启用内联提示）
    map("n", "<leader>cH", function()
      require("clangd_extensions.inlay_hints").toggle_inlay_hints()
    end, { desc = "Clangd: 切换内联提示" })
  end,
}
