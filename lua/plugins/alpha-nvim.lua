-- alpha is a fast and fully programmable greeter for neovim.
-- https://github.com/goolord/alpha-nvim

return {
	"goolord/alpha-nvim",
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			"                     .:::!~!!!!!:.",
			"                  .xUHWH!! !!?M88WHX:.",
			"                .X*#M@$!!  !X!M$$$$$$WWx:.",
			"               :!!!!!!?H! :!$!$$$$$$$$$$8X:",
			"              !!~  ~:~!! :~!$!#$$$$$$$$$$8X:",
			"             :!~::!H!<   ~.U$X!?R$$$$$$$$MM!",
			"             ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!",
			'               !:~~~ .:!M"T#$$$$WX??#MRRMMM!',
			'               ~?WuxiW*`   `"#$$$$8!!!!??!!!',
			'             :X- M$$$$       `"T#$T~!8$WUXU~',
			"            :%`  ~#$$$m:        ~!~ ?$$$$$$",
			'          :!`.-   ~T$$$$8xx.  .xWW- ~""##*"',
			".....   -~~:<` !    ~?T#$$@@W@*?$$      /`",
			'W$@@M!!! .!~~ !!     .:XUW$W!~ `"~:    :',
			'#"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`',
			':::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~',
			'.~~   :X@!.-~   ?@WTWo("*$$$W$TH$! `',
			'Wi.~!X$?!-~   :: ?$$$B$Wu("**$RM!',
			"$R@i.~~ !    ::   ~$$$$$B$$en:``",
			'?MXT@Wx.~   ::     ~"##*$$$$M',
		}

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("n", "     New file", ":ene <BAR> startinsert <CR>"),
			dashboard.button("f", "     Find file", ":Telescope find_files<CR>"),
			dashboard.button("w", "󰷾     Find word", ":Telescope live_grep<CR>"),
			dashboard.button("r", "     Recent", ":Telescope oldfiles<CR>"),
			dashboard.button("e", "✎     Edit NVIM", ":e $MYVIMRC | :cd %:p:h | split . | wincmd k | pwd<CR>"),
			-- dashboard.button("t", "  > Change theme", ":Telescope colorscheme<CR>"),
			-- dashboard.button("h", "🛈  > Help", ":Telescope help_tags<CR>"),
			-- dashboard.button("p", "  > Projects", ""),
			-- dashboard.button("g", "⎇     Git Graph", ":Flog<CR>"),
			dashboard.button("l", "󰒲     Lazy", ":Lazy<CR>"),
			dashboard.button("m", "󱌣     Mason", ":Mason<CR>"),
			dashboard.button("q", "     Quit NVIM", ":qa<CR>"),
		}

		-- Set footer
		vim.api.nvim_create_autocmd("User", {
			pattern = "LazyVimStarted",
			callback = function()
				local v = vim.version()
				local dev = ""
				if v.prerelease == "dev" then
					dev = "-dev+" .. v.build
				else
					dev = ""
				end
				local version = v.major .. "." .. v.minor .. "." .. v.patch .. dev
				local stats = require("lazy").stats()
				local plugins_count = stats.loaded .. "/" .. stats.count
				local ms = math.floor(stats.startuptime + 0.5)
				local time = vim.fn.strftime("%H:%M:%S")
				local date = vim.fn.strftime("%d.%m.%Y")
				local line1 = " " .. plugins_count .. " plugins loaded in " .. ms .. "ms"
				local line2 = "󰃭 " .. date .. "  " .. time
				local line3 = " " .. version

				local empty_space = ""
				local line1_width = vim.fn.strdisplaywidth(line1)
				local line2Padded = string.rep(" ", (line1_width - vim.fn.strdisplaywidth(line2)) / 2) .. line2
				local line3Padded = string.rep(" ", (line1_width - vim.fn.strdisplaywidth(line3)) / 2) .. line3

				-- Get the current hour
				local current_hour = tonumber(os.date("%H"))

				-- Define the greeting variable
				local greeting

				if current_hour < 5 then
					greeting = " Good night!"
				elseif current_hour < 12 then
					greeting = "󰼰 Good morning!"
				elseif current_hour < 17 then
					greeting = " Good afternoon!"
				elseif current_hour < 20 then
					greeting = "󰖝 Good evening!"
				else
					greeting = "󰖔 Good night!"
				end

				local line4Padded = string.rep(" ", (line1_width - vim.fn.strdisplaywidth(greeting)) / 2) .. greeting

				dashboard.section.footer.val = {
					empty_space,
					line1,
					line2Padded,
					line3Padded,
					empty_space,
					line4Padded,
				}
				pcall(vim.cmd.AlphaRedraw)
			end,
		})

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
