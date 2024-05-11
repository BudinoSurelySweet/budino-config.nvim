-- ================================== --
-- ============== Tint ============== --
-- ================================== --

-- Tint inactive windows in Neovim using window-local highlight namespaces.
-- https://github.com/levouh/tint.nvim

-- Configuration
local function Config()
	return {
		tint = -15, -- darken colors, use a positive value to brighten
		saturation = 0.6, -- saturation to preserve
		-- transforms = require("tint").transforms.saturate_tint, -- showing default behavior, but value here can be predefined set of transforms
		tint_background_colors = true, -- tint background portions of highlight groups
		highlight_ignore_patterns = { "winseparator", "status.*" }, -- highlight group patterns to ignore, see `string.find`
		window_ignore_function = function(winid)
			local bufid = vim.api.nvim_win_get_buf(winid)
			local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
			local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

			-- do not tint `terminal` or floating windows, tint everything else
			return buftype == "terminal" or floating
		end,
	}
end

-- Setup
return {
	"levouh/tint.nvim",
	enabled = false,
	config = Config(),
}
