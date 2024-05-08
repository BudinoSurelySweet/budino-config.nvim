-- This plugin will color the border of active window
-- https://github.com/nvim-zh/colorful-winsep.nvim

return {
	"nvim-zh/colorful-winsep.nvim",
	config = true,
	event = { "WinNew" },
}
