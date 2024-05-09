require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.plugins")

-- Settings that must have to be after the plugins
vim.notify = require("notify")

vim.cmd.colorscheme("eldritch")
