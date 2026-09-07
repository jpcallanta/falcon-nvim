-- Diagnostics, symbols, and LSP lists in a sidebar (Trouble)
return {
	"folke/trouble.nvim",
	cmd = "Trouble",
	opts = {
		win = {
			position = "bottom",
			size = 10, -- diagnostics panel height in lines
		},
		modes = {
			symbols = {
				win = {
					position = "right",
					size = 0.30, -- symbols panel width (fraction of editor)
				},
			},
		},
	}, -- panels opened via keymaps below
	keys = {
		-- `t` group: tabs + trouble (no bare <leader>t mapping exists)
		{ "<leader>td", "<cmd>Trouble diagnostics toggle focus=true<cr>", desc = "Diagnostics (Trouble)" },
		{ "<leader>tD", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics" },
		{ "<leader>ts", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
		{
			"<leader>tl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / References",
		},
		{ "<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
		{ "<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
	},
}
