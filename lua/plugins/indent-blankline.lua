-- ============================================== --
-- ============== Indent Blankline ============== --
-- ============================================== --

-- This plugin adds indentation guides to Neovim.
-- https://github.com/lukas-reineke/indent-blankline.nvim

-- Configuration
local function Config()
	return {
		indent = {
			char = "▏",
		},
		scope = {
			-- "show_start" and "show_end" if set to false disable the underline
			show_start = false,
			show_end = false,
			enabled = true,
		},
	}
end

-- Setup
return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	config = Config(),
}
