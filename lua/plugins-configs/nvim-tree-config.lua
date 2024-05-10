-- Nvim-tree Configuration

-- Variables needed to center nvim-tree
local gwidth = vim.api.nvim_list_uis()[1].width
local gheight = vim.api.nvim_list_uis()[1].height
local width = 50
local height = 45

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

require("nvim-tree").setup({
	---
	on_attach = my_on_attach,
	---

	-- Uncomment to make nvim-tree's position at the center of the screen
	-- view = {
	-- 	float = {
	-- 		enable = true,
	-- 		open_win_config = {
	-- 			relative = "editor",
	-- 			width = width,
	-- 			height = height,
	-- 			row = (gheight - height) * 0.4,
	-- 			col = (gwidth - width) * 0.5,
	-- 		},
	-- 	},
	-- },
})
