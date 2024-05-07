-- A fancy, configurable, notification manager for NeoVim
-- https://github.com/rcarriga/nvim-notify

return {
	"rcarriga/nvim-notify",
	keys = {
		{
			"<leader>un",
			function()
				require("notify").dismiss({ silent = true, pending = true })
			end,
			desc = "Dismiss All Notifications",
		},
	},
	opts = {
		stages = "fade",
		timeout = 3000,
		max_height = function()
			return math.floor(vim.o.lines * 0.75)
		end,
		max_width = function()
			return math.floor(vim.o.columns * 0.75)
		end,
		on_open = function(win)
			vim.api.nvim_win_set_config(win, { zindex = 100 })
		end,
	},
	config = function()
		-- local async = require("plenary.async")
		-- local notify = require("notify").async
		--
		-- async.run(function()
		-- 	notify("Let's wait for this to close").events.close()
		-- 	notify("It closed!")
		-- end)
	end,
}
