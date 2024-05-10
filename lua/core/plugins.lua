-- Setup of Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Lazy Configuration
require("lazy").setup({
	-- Import all colorscheme inside the folder lua\colorscheme\
	{ import = "colorschemes" },

	-- Import all plugins inside the folder lua\plugins\
	{ import = "plugins" },
})

-- Import all configurations for the directories inside "configs_dir"
local configs_dir = {
	"plugins-configs",
	-- "colorschemes-configs",
}

for index in ipairs(configs_dir) do
	local dir = configs_dir[index]

	for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/" .. dir, [[v:val =~ '\.lua$']])) do
		require(dir .. "." .. file:gsub("%.lua$", ""))
	end
end
