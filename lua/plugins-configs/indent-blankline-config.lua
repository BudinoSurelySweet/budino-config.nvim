-- Indent-blankline Configuration

require("ibl").setup({
	indent = {
		char = "▏",
	},
	scope = {
		-- "show_start" and "show_end" if set to false disable the underline
		show_start = false,
		show_end = false,
		enabled = true,
	},
})
