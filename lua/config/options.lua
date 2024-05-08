-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable wrap
vim.opt.wrap = false

-- Enable break indent
vim.opt.breakindent = true

-- Number of spaces a <Tab> in the file count for.
vim.opt.tabstop = 4

-- Set the indent size
vim.opt.shiftwidth = 4

-- Disable the swap file
vim.opt.swapfile = false

vim.g.have_nerd_font = true -- If terminal has a nerd font, if true use that nerd font in nvim
vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim.

-- Make line numbers default
vim.opt.number = true

vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
-- vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- vim.opt.listchars = { tab = "| ", trail = "·", nbsp = "␣" }
vim.opt.listchars = { tab = "▏ ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Virtcolumn settings
-- vim.g.virtcolumn_char = "▕" -- char to display the line
-- vim.g.virtcolumn_priority = 10 -- priority of extmark

-- Set the colorcolumn
-- vim.opt.colorcolumn = "80"

-- This is a necessary option for nvim-notify plugin
vim.opt.termguicolors = true
