require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.plugins")

-- Settings that must have to be after the plugins
vim.notify = require("notify")
