-- ========================================= --
-- ============== nvim-notify ============== --
-- ========================================= --

-- A fancy, configurable, notification manager for NeoVim
-- https://github.com/rcarriga/nvim-notify

-- Configuration
local function Config()
	return {
		level = 2,
		fps = 30,
		max_width = 250,
		max_height = 150,
		minimum_width = 50,
		background_colour = "#ffffff00",
		icons = {
			DEBUG = "",
			ERROR = "",
			INFO = "",
			TRACE = "✎",
			WARN = "",
		},
		time_formats = {
			notification = "%T",
			notification_history = "%FT%T",
		},
		render = "simple",
		stages = "static",
		timeout = 3000,
		opacity = 100,
		top_down = true,
		on_open = function() end,
		on_close = function() end,
	}
end

-- Setup
return {
	"rcarriga/nvim-notify",
	keys = {
		{
			"<leader>Q",
			function()
				require("notify").dismiss({ silent = true, pending = true })
			end,
			desc = "Dismiss All Notifications",
		},
	},
	config = Config(),
}
