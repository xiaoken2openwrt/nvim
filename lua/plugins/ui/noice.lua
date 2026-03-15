return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		notify = {
			enabled = true,
		},
		lsp = {
			progress = {
				enabled = false,
			},
			hover = {
				enabled = false,
			},
			signature = {
				enabled = false,
			},
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},

	config = function(_, opts)
    require("noice").setup(opts)

    -- ========== 解决“消息消失”问题的快捷键 ==========
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- 1. 重新显示最后一条消失的消息 (核心！)
    map("n", "<leader>nl", "<cmd>Noice last<CR>", { desc = "Noice: 重显最后一条消息" })

    -- 2. 打开完整消息历史记录 (慢慢翻阅)
    map("n", "<leader>nh", "<cmd>Noice history<CR>", { desc = "Noice: 查看消息历史" })

    -- 3. 立即关闭/暂停所有消息 (主动清屏)
    map("n", "<leader>nd", "<cmd>Noice dismiss<CR>", { desc = "Noice: 关闭所有消息" })

    -- 4. (可选) 如果你想看所有消息，包括被过滤掉的 echo
    map("n", "<leader>na", "<cmd>Noice all<CR>", { desc = "Noice: 查看所有消息(含echo)" })

    -- 5. (可选) 如果想用 Telescope 来浏览历史 (如果你装了 telescope)
    -- map("n", "<leader>nT", "<cmd>Noice telescope<CR>", { desc = "Telescope 浏览历史" })
	end,
}
