-- NOTE: Normal mode

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal. This won't work in all terminal emulators/tmux/etc.
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Disable arrow keys in normal mode
vim.keymap.set("n", "<left>", '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set("n", "<right>", '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set("n", "<up>", '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set("n", "<down>", '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier. Use CTRL+<hjkl> to switch between windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Keybinds useful for fast actions <leader>f
vim.keymap.set("n", "<leader>ft", "<Cmd>NvimTreeToggle<CR>", { desc = "Toggle nvim-[t]ree" })
vim.keymap.set("n", "<leader>fm", "<Cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle [M]arkdown-preview" })
vim.keymap.set("n", "<leader>fg", "<Cmd>Neogit<CR>", { desc = "Toggle Neo[g]it" })
vim.keymap.set("n", "<leader>fT1", "<Cmd>1ToggleTerm<CR>", { desc = "Toggle [1] [T]erminal" })
vim.keymap.set("n", "<leader>fT2", "<Cmd>2ToggleTerm<CR>", { desc = "Toggle [2] [T]erminal" })
vim.keymap.set("n", "<leader>fT3", "<Cmd>3ToggleTerm<CR>", { desc = "Toggle [3] [T]erminal" })
vim.keymap.set("n", "<leader>fT4", "<Cmd>4ToggleTerm<CR>", { desc = "Toggle [4] [T]erminal" })
vim.keymap.set("n", "<leader>fT5", "<Cmd>5ToggleTerm<CR>", { desc = "Toggle [5] [T]erminal" })
vim.keymap.set("n", "<leader>fT6", "<Cmd>6ToggleTerm<CR>", { desc = "Toggle [6] [T]erminal" })
vim.keymap.set("n", "<leader>fT7", "<Cmd>7ToggleTerm<CR>", { desc = "Toggle [7] [T]erminal" })
vim.keymap.set("n", "<leader>fT8", "<Cmd>8ToggleTerm<CR>", { desc = "Toggle [8] [T]erminal" })
vim.keymap.set("n", "<leader>fT9", "<Cmd>9ToggleTerm<CR>", { desc = "Toggle [9] [T]erminal" })
vim.keymap.set("n", "<leader>fb", "<Cmd>%bd!|e #|bd #|normal<CR>", { desc = "Close all [B]uffers" })

-- NOTE: Insert mode

vim.keymap.set("i", "jj", "<Esc>")

-- NOTE: Which Key Keymaps

local which_key = require("which-key")

which_key.register({
	-- Document existing key chains
	["<leader>c"] = { name = "[C]ode", _ = "which_key_ignore" },
	["<leader>d"] = { name = "[D]ocument", _ = "which_key_ignore" },
	["<leader>r"] = { name = "[R]ename", _ = "which_key_ignore" },
	["<leader>s"] = { name = "[S]earch", _ = "which_key_ignore" },
	["<leader>w"] = { name = "[W]orkspace", _ = "which_key_ignore" },
	["<leader>t"] = { name = "[T]oggle", _ = "which_key_ignore" },
	["<leader>h"] = { name = "Git [H]unk", _ = "which_key_ignore" },

	-- Added by me
	["<leader>f"] = { name = "[F]ast Actions", _ = "which_key_ignore" },
	["<leader>fT"] = { name = "Toggle [T]erminal (Toggleterm)", _ = "which_key_ignore" },
})

-- visual mode
which_key.register({
	["<leader>h"] = { "Git [H]unk" },
}, { mode = "v" })

-- NOTE: Toggleterm Plugin Keymaps

vim.keymap.set("t", "<esc>", [[<C-\><C-n>]])
vim.keymap.set("t", "jk", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]])

-- NOTE: barbar plugin keymap

-- Move to previous/next
vim.keymap.set("n", "<A-,>", "<Cmd>BufferPrevious<CR>")
vim.keymap.set("n", "<A-.>", "<Cmd>BufferNext<CR>")
-- Re-order to previous/next
vim.keymap.set("n", "<A-<>", "<Cmd>BufferMovePrevious<CR>")
vim.keymap.set("n", "<A->>", "<Cmd>BufferMoveNext<CR>")
-- Goto buffer in position...
vim.keymap.set("n", "<A-1>", "<Cmd>BufferGoto 1<CR>")
vim.keymap.set("n", "<A-2>", "<Cmd>BufferGoto 2<CR>")
vim.keymap.set("n", "<A-3>", "<Cmd>BufferGoto 3<CR>")
vim.keymap.set("n", "<A-4>", "<Cmd>BufferGoto 4<CR>")
vim.keymap.set("n", "<A-5>", "<Cmd>BufferGoto 5<CR>")
vim.keymap.set("n", "<A-6>", "<Cmd>BufferGoto 6<CR>")
vim.keymap.set("n", "<A-7>", "<Cmd>BufferGoto 7<CR>")
vim.keymap.set("n", "<A-8>", "<Cmd>BufferGoto 8<CR>")
vim.keymap.set("n", "<A-9>", "<Cmd>BufferGoto 9<CR>")
vim.keymap.set("n", "<A-0>", "<Cmd>BufferLast<CR>")
-- Pin/unpin buffer
vim.keymap.set("n", "<A-p>", "<Cmd>BufferPin<CR>")
-- Close buffer
vim.keymap.set("n", "<A-c>", "<Cmd>BufferClose<CR>")
-- Wipeout buffer
--                 :BufferWipeout
-- Close commands
--                 :BufferCloseAllButCurrent
--                 :BufferCloseAllButPinned
--                 :BufferCloseAllButCurrentOrPinned
--                 :BufferCloseBuffersLeft
--                 :BufferCloseBuffersRight
-- Magic buffer-picking mode
vim.keymap.set("n", "<C-p>", "<Cmd>BufferPick<CR>")
-- Sort automatically by...
vim.keymap.set("n", "<Space>bb", "<Cmd>BufferOrderByBufferNumber<CR>")
vim.keymap.set("n", "<Space>bn", "<Cmd>BufferOrderByName<CR>")
vim.keymap.set("n", "<Space>bd", "<Cmd>BufferOrderByDirectory<CR>")
vim.keymap.set("n", "<Space>bl", "<Cmd>BufferOrderByLanguage<CR>")
vim.keymap.set("n", "<Space>bw", "<Cmd>BufferOrderByWindowNumber<CR>")

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used
