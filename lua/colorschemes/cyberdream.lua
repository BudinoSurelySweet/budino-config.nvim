-- ======================================== --
-- ============== Cyberdream ============== --
-- ======================================== --

-- A high-contrast, futuristic & vibrant theme for neovim
-- https://github.com/scottmckendry/cyberdream.nvim

-- Configuration
local function Config()
	return {
		transparent = true,
		italic_comments = true,
		hide_fillchars = true,
		borderless_telescope = false,
		terminal_colors = true,
	}
end

-- Setup
return {
	"scottmckendry/cyberdream.nvim",
	lazy = false,
	priority = 1000,
	config = Config(),
}
