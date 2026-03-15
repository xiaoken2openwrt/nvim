--LSP配置文件
--=================================说明=========================================
--[[
    Neovim-LSP服务简单介绍
    1. 设置整个LSP的语言配置对照表，供给给nvim-lspconfig与mason-lspconfig使用
    2. mason-lspconfig的配置无需太多的配置，只需要lsp的名字与一些文档中的其他配置，不使用lsp的自定义配置
    3. nvim-lspconfig的配置需要mason-lspconfig充当桥梁,将lsp服务器注册到nvim-lspconfig简化配置
    总结：首先安装mason.nvim管理安装lsp服务器，使用mason-lspconfig将lsp注册到nvim-lspconfig，
        之后将lsp的配置给到nvim内置的lsp客户端完成代码补全之类的功能

    补充：维护本文件的lsp服务器列表，打开neovim后即可自动下载，
        也可不写入列表直接使用MasonInstall 安装相关的lsp服务器。
        格式化工具安装进入"plugins/lsp/config/formatters.lua"文件中维护格式化工具列表。
        lsp安装进入"plugins/lsp/config/servers.lua"文件中维护lsp列表。
]]
-- =============================================================================
return {
	"neovim/nvim-lspconfig",
	event = "VeryLazy",
	-- event = { "BufReadPre", "BufNewFile" },
	config = function()
		vim.diagnostic.config({
			-- virtual_lines = true, -- 诊断提示虚拟行
			virtual_text = true,

			signs = {
				active = true,
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.INFO] = "",
					[vim.diagnostic.severity.HINT] = "💡",
				},
			},
			update_in_insert = true, -- 是否实时显示诊断信息
			-- update_in_insert = false,
			underline = true,
			severity_sort = true,
			float = {
				border = "rounded",
			},
		})

		local servers = require("plugins.lsp.config.servers")

		-- 定义通用的 on_attach 函数，用于绑定 LSP 快捷键和设置客户端行为
		local on_attach = function(client, bufnr)
			-- 打印信息用于调试，了解哪个 LSP 客户端连接了
			-- vim.notify("已连接 LSP 客户端: " .. client.name, vim.log.levels.INFO)
			-- 内联提示
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			-- 这里两个禁止lsp的格式化，只是用格式化工具提供的格式化，防止lsp与格式化的冲突
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
		end

		-- 配置 nvim-lspconfig 如何处理每个 LSP 服务器 (核心自动化部分)
		for server_name, server_opts in pairs(servers) do
			local final_config = vim.tbl_deep_extend("force", server_opts, {
				on_attach = on_attach,
			})

			vim.lsp.config(server_name, final_config)
			vim.lsp.enable(server_name)
		end
	end,
	keys = {
		{ "<leader>lR", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "重命名符号" },
		{ "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "LSP 代码操作" },
		{
			"K",
			function()
				vim.lsp.buf.hover({
					border = "rounded",
				})
			end,
			{ desc = "LSP Hover" },
		},
		{ "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", desc = "签名帮助" },

		-- 诊断相关快捷键
		{ "<leader>D", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "诊断浮窗" },
		{ "<leader>ld", "<cmd>lua vim.diagnostic.open_float()<cr>", desc = "打开当前行的诊断信息浮窗" },
		{ "[d", "<cmd>lua vim.diagnostic.jump({ wrap = true, count = -1 })<cr>", desc = "上一个诊断" },
		{ "]d", "<cmd>lua vim.diagnostic.jump({ wrap = true, count = 1 })<cr>", desc = "下一个诊断" },

		-- 代码跳转等功能
		{ "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "定义跳转" },
		{ "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", desc = "声明跳转" },
		{ "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", desc = "实现跳转" },
		{ "gr", "<cmd>lua vim.lsp.buf.references()<cr>", desc = "引用查找" },
		{ "gt", "<cmd>lua vim.lsp.buf.type_definition()<cr>", desc = "跳转到类型定义" },
	},
}
