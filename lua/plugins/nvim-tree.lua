-- ======================================= --
-- ============== nvim-tree ============== --
-- ======================================= --

-- A File Explorer For Neovim Written In Lua
-- https://github.com/nvim-tree/nvim-tree.lua?tab=readme-ov-file

-- Configuration
local function Config()
	-- Keymaps
	local function my_on_attach(bufnr)
		local api = require("nvim-tree.api")

		local function opts(desc)
			return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = false, silent = true, nowait = true }
		end

		-- default mappings
		api.config.mappings.default_on_attach(bufnr)

		-- custom mappings
		vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
		vim.keymap.set("n", "v", api.node.open.vertical, opts("Open: Vertical Split"))
		vim.keymap.set("n", "h", api.node.open.horizontal, opts("Open: Horizontal Split"))
		vim.keymap.set("n", "<C-j>", api.tree.change_root_to_node, opts("CD"))

		-- remove mappings to prevent multiple shortcut to one option
		vim.keymap.set("n", "<C-v>", "", opts(""))
		vim.keymap.set("n", "<C-x>", "", opts(""))
	end

	-- Variables needed to center nvim-tree
	local gwidth = vim.api.nvim_list_uis()[1].width
	local gheight = vim.api.nvim_list_uis()[1].height
	local width = 50
	local height = 45

	return {

		on_attach = my_on_attach,

		view = {
			-- Uncomment these lines to make the nvim-tree's position at the center of the screen
			float = {
				enable = true,
				open_win_config = {
					relative = "editor",
					width = width,
					height = height,
					row = (gheight - height) * 0.4,
					col = (gwidth - width) * 0.5,
				},
			},
			side = "left",
			width = 35,
		},
	}
end

-- Setup
return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = Config(),
}
