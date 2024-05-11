-- Setup the options
require("core.options")

-- Setup the plugins
require("core.lazy")

-- Setup the keymaps
require("core.keymaps")

-- Setup the auto commands
require("core.autocmds")

-- Settings that must have to be after the plugins loading
vim.notify = require("notify")

vim.cmd.colorscheme("onedark")
