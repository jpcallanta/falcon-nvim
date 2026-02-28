local M = {}

function M.setup(capabilities)
	require("mason-tool-installer").setup({
		ensure_installed = require("plugins.lsp.servers").ensure_installed,
	})

	require("mason-lspconfig").setup({
		ensure_installed = {},
		automatic_installation = false,
		handlers = {
			function(server_name)
				local servers = require("plugins.lsp.servers").servers
				local server = servers[server_name] or {}

				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

				require("lspconfig")[server_name].setup(server)
			end,
		},
	})
end

return M
