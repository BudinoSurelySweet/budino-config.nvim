-- ======================================= --
-- ============== Which Key ============== --
-- ======================================= --

-- WhichKey is a lua plugin for Neovim 0.5 that displays a popup with possible key bindings of the command you started typing.
-- https://github.com/folke/which-key.nvim

-- Configuration
local function Config()
	return {
		window = {
			border = "single", -- none, single, double, shadow
			position = "bottom", -- bottom, top
			margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
			padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
			winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
			zindex = 1000, -- positive value to position WhichKey above other floating windows.border = "single"
		},
		icons = {
			breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
			separator = "➜", -- symbol used between a key and it's label
			group = " ", -- symbol prepended to a group
		},
		layout = {
			height = { min = 4, max = 25 }, -- min and max height of the columns
			width = { min = 20, max = 50 }, -- min and max width of the columns
			spacing = 3, -- spacing between columns
			align = "center", -- align columns left, center or right
		},
	}
end

-- Setup
return {
	"folke/which-key.nvim",
	event = "VimEnter", -- Sets the loading event to 'VimEnter'
	config = Config(),
}
