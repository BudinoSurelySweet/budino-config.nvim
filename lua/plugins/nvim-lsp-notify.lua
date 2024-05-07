-- NVIM plugin to notify about LSP processes
-- https://github.com/mrded/nvim-lsp-notify

return {
	"mrded/nvim-lsp-notify",
	requires = { "rcarriga/nvim-notify" },
	config = function()
		require("lsp-notify").setup({
			notify = require("notify"),
		})
	end,
}
