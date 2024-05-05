-- Flog is a fast, beautiful, and powerful git branch viewer for Vim.
-- https://github.com/rbong/vim-flog?tab=readme-ov-file

return {
	"rbong/vim-flog",
	lazy = true,
	cmd = { "Flog", "Flogsplit", "Floggit" },
	dependencies = {
		"tpope/vim-fugitive",
	},
}
