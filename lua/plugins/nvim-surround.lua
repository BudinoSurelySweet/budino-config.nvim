-- =========================================== --
-- ============== Plugin's name ============== --
-- =========================================== --

-- Short description of the plugin
-- link to the plugin

-- Setup
local plugin = {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
}

-- Configuration
function plugin.config()
	local input = require("nvim-surround.input")
	local functional = require("nvim-surround.functional")

	--[====================================================================================================================[
                                             Configuration Helper Functions
	--]====================================================================================================================]

	-- Gets input from the user.
	---@param prompt string The input prompt.
	---@return string|nil @The user input.
	---@nodiscard
	plugin.get_input = function(prompt)
		return input.get_input(prompt)
	end

	-- Gets a selection from the buffer based on some heuristic.
	---@param args { char: string|nil, motion: string|nil, pattern: string|nil, node: string|nil, query: { capture: string, type: string }|nil }
	---@return selection|nil @The retrieved selection.
	---@nodiscard
	plugin.get_selection = function(args)
		if args.char then
			return plugin.get_find(args.char)(args.char)
		elseif args.motion then
			return require("nvim-surround.motions").get_selection(args.motion)
		elseif args.node then
			return require("nvim-surround.treesitter").get_selection(args.node)
		elseif args.pattern then
			return require("nvim-surround.patterns").get_selection(args.pattern)
		elseif args.query then
			return require("nvim-surround.queries").get_selection(args.query.capture, args.query.type)
		else
			vim.notify("Invalid key provided for `:h nvim-surround.config.get_selection()`.", vim.log.levels.ERROR)
		end
	end

	-- Gets a pair of selections from the buffer based on some heuristic.
	---@param args { char: string, pattern: string|nil, exclude: function|nil }
	---@nodiscard
	plugin.get_selections = function(args)
		local selection = plugin.get_selection({ char = args.char })
		if not selection then
			return nil
		end
		if args.pattern then
			return require("nvim-surround.patterns").get_selections(selection, args.pattern)
		elseif args.exclude then
			local outer_selection = plugin.get_opts().surrounds[args.char].find()
			if not outer_selection then
				return nil
			end
			vim.fn.cursor(outer_selection.first_pos)
			local inner_selection = args.exclude()
			if not inner_selection then
				return nil
			end
			-- Properly exclude the inner selection from the outer selection
			local selections = {
				left = {
					first_pos = outer_selection.first_pos,
					last_pos = { inner_selection.first_pos[1], inner_selection.first_pos[2] - 1 },
				},
				right = {
					first_pos = { inner_selection.last_pos[1], inner_selection.last_pos[2] + 1 },
					last_pos = outer_selection.last_pos,
				},
			}
			return selections
		else
			vim.notify("Invalid key provided for `:h nvim-surround.config.get_selections()`.", vim.log.levels.ERROR)
		end
	end

	--[====================================================================================================================[
                                                End of Helper Functions
--]====================================================================================================================]

	-- Stores the global user-set options for the plugin.
	plugin.user_opts = nil

	-- Returns the buffer-local options for the plugin, or global options if buffer-local does not exist.
	---@return options @The buffer-local options.
	---@nodiscard
	plugin.get_opts = function()
		return vim.b[0].nvim_surround_buffer_opts or plugin.user_opts or {}
	end

	-- Returns the value that the input is aliased to, or the character if no alias exists.
	---@param char string|nil The input character.
	---@return string|nil @The aliased character if it exists, or the original if none exists.
	---@nodiscard
	plugin.get_alias = function(char)
		local aliases = plugin.get_opts().aliases
		if type(aliases[char]) == "string" then
			return aliases[char]
		end
		return char
	end

	-- Gets a delimiter pair for a user-inputted character.
	---@param char string|nil The user-given character.
	---@param line_mode boolean Whether or not the delimiters should be put on new lines.
	---@return delimiter_pair|nil @A pair of delimiters for the given input, or nil if not applicable.
	---@nodiscard
	plugin.get_delimiters = function(char, line_mode)
		char = plugin.get_alias(char)
		-- Get the delimiters, using invalid_key_behavior if the add function is undefined for the character
		local delimiters = plugin.get_add(char)(char)
		-- Add new lines if the addition is done line-wise
		if delimiters and line_mode then
			local lhs = delimiters[1]
			local rhs = delimiters[2]

			-- Trim whitespace after the leading delimiter and before the trailing delimiter
			lhs[#lhs] = lhs[#lhs]:gsub("%s+$", "")
			rhs[1] = rhs[1]:gsub("^%s+", "")

			table.insert(rhs, 1, "")
			table.insert(lhs, "")
		end

		return delimiters
	end

	-- Returns the add key for the surround associated with a given character, if one exists.
	---@param char string|nil The input character.
	---@return add_func @The function to get the delimiters to be added.
	---@nodiscard
	plugin.get_add = function(char)
		char = plugin.get_alias(char)
		if plugin.get_opts().surrounds[char] and plugin.get_opts().surrounds[char].add then
			return plugin.get_opts().surrounds[char].add
		end
		return plugin.get_opts().surrounds.invalid_key_behavior.add
	end

	-- Returns the find key for the surround associated with a given character, if one exists.
	---@param char string|nil The input character.
	---@return find_func @The function to get the selection.
	---@nodiscard
	plugin.get_find = function(char)
		char = plugin.get_alias(char)
		if plugin.get_opts().surrounds[char] and plugin.get_opts().surrounds[char].find then
			return plugin.get_opts().surrounds[char].find
		end
		return plugin.get_opts().surrounds.invalid_key_behavior.find
	end

	-- Returns the delete key for the surround associated with a given character, if one exists.
	---@param char string|nil The input character.
	---@return delete_func @The function to get the selections to be deleted.
	---@nodiscard
	plugin.get_delete = function(char)
		char = plugin.get_alias(char)
		if plugin.get_opts().surrounds[char] and plugin.get_opts().surrounds[char].delete then
			return plugin.get_opts().surrounds[char].delete
		end
		return plugin.get_opts().surrounds.invalid_key_behavior.delete
	end

	-- Returns the change key for the surround associated with a given character, if one exists.
	---@param char string|nil The input character.
	---@return change_table @A table holding the target/replacement functions.
	---@nodiscard
	plugin.get_change = function(char)
		char = plugin.get_alias(char)
		if plugin.get_opts().surrounds[char] then
			if plugin.get_opts().surrounds[char].change then
				return plugin.get_opts().surrounds[char].change
			else
				return {
					target = plugin.get_delete(char),
				}
			end
		end
		return plugin.get_change("invalid_key_behavior")
	end

	-- Translates the user-provided surround.add into the internal form.
	---@param user_add user_add The user-provided add key.
	---@return false|add_func|nil @The translated add key.
	plugin.translate_add = function(user_add)
		if type(user_add) ~= "table" then
			return user_add
		end
		-- If the input is given as a pair of strings, or pair of string lists, wrap it in a function
		return function()
			return {
				functional.to_list(user_add[1]),
				functional.to_list(user_add[2]),
			}
		end
	end

	-- Translates the user-provided surround.find into the internal form.
	---@param user_find user_find The user-provided find key.
	---@return false|find_func|nil @The translated find key.
	plugin.translate_find = function(user_find)
		if type(user_find) ~= "string" then
			return user_find
		end
		-- Treat the string as a Lua pattern, and find the selection
		return function()
			return plugin.get_selection({ pattern = user_find })
		end
	end

	-- Translates the user-provided surround.delete into the internal form.
	---@param char string The character used to activate the surround.
	---@param user_delete user_delete The user-provided delete key.
	---@return false|delete_func|nil @The translated delete key.
	plugin.translate_delete = function(char, user_delete)
		if type(user_delete) ~= "string" then
			return user_delete
		end
		-- Treat the string as a Lua pattern, and find the selection
		return function()
			return plugin.get_selections({ char = char, pattern = user_delete })
		end
	end

	-- Translates the user-provided surround.change into the internal form.
	---@param char string The character used to activate the surround.
	---@param user_change user_change|nil The user-provided change key.
	---@return false|change_table|nil @The translated change key.
	plugin.translate_change = function(char, user_change)
		if type(user_change) ~= "table" then
			return user_change
		end
		return {
			target = plugin.translate_delete(char, user_change.target),
			replacement = plugin.translate_add(user_change.replacement),
		}
	end

	-- Translates the user-provided surround into the internal form.
	---@param char string The character used to activate the surround.
	---@param user_surround false|user_surround The user-provided surround.
	---@return false|surround @The translated surround.
	plugin.translate_surround = function(char, user_surround)
		if not user_surround then
			return false
		end
		return {
			add = plugin.translate_add(user_surround.add),
			find = plugin.translate_find(user_surround.find),
			delete = plugin.translate_delete(char, user_surround.delete),
			change = plugin.translate_change(char, user_surround.change),
		}
	end

	-- Translates `invalid_key_behavior` into the internal form.
	---@param invalid_surround false|user_surround The user-provided `invalid_key_behavior`.
	---@return surround @The translated `invalid_key_behavior`.
	plugin.translate_invalid_key_behavior = function(invalid_surround)
		local noop_surround = {
			add = function() end,
			find = function() end,
			delete = function() end,
			change = {
				target = function() end,
			},
		}
		local invalid = plugin.translate_surround("invalid_key_behavior", invalid_surround)
		if invalid == false then
			return noop_surround
		end
		if invalid.add == false then
			invalid.add = noop_surround.add
		end
		if invalid.find == false then
			invalid.find = noop_surround.find
		end
		if invalid.delete == false then
			invalid.delete = noop_surround.delete
		end
		if invalid.change == false then
			invalid.change = noop_surround.change
		elseif invalid.change ~= nil then
			if invalid.change.target == false then
				invalid.change.target = noop_surround.change.target
			end
		end
		return invalid
	end

	-- Translates the user-provided configuration into the internal form.
	---@param user_opts user_options The user-provided options.
	---@return options @The translated options.
	plugin.translate_opts = function(user_opts)
		local opts = {}
		for key, value in pairs(user_opts) do
			if key == "surrounds" then
			elseif key == "indent_lines" then
				opts[key] = value or function() end
			else
				opts[key] = value
			end
		end
		if not user_opts.surrounds then
			return opts
		end

		opts.surrounds = {}
		for char, user_surround in pairs(user_opts.surrounds) do
			-- Support Vim's notation for special characters
			char = vim.api.nvim_replace_termcodes(char, true, true, true)
			-- Special case translation for `invalid_key_behavior`
			if type(user_surround) ~= "nil" then
				if char == "invalid_key_behavior" then
					opts.surrounds[char] = plugin.translate_invalid_key_behavior(user_surround)
				else
					opts.surrounds[char] = plugin.translate_surround(char, user_surround)
				end
			end
		end
		return opts
	end

	-- Updates the buffer-local options for the plugin based on the input.
	---@param base_opts options The base options that will be used for configuration.
	---@param new_opts user_options|nil The new options to potentially override the base options.
	---@return options The merged options.
	plugin.merge_opts = function(base_opts, new_opts)
		new_opts = new_opts or {}
		local opts = vim.tbl_deep_extend("force", base_opts, plugin.translate_opts(new_opts))
		return opts
	end

	-- Check if a keymap should be added before setting it.
	---@param args table The arguments to set the keymap.
	plugin.set_keymap = function(args)
		-- If the keymap is disabled
		if not args.lhs then
			-- If the mapping is disabled globally, do nothing
			if not plugin.user_opts.keymaps[args.name] then
				return
			end
			-- Otherwise disable the global keymap
			args.lhs = plugin.user_opts.keymaps[args.name]
			args.rhs = "<NOP>"
		end
		vim.keymap.set(args.mode, args.lhs, args.rhs, args.opts)
	end

	-- Set up user-configured keymaps, globally or for the buffer.
	---@param args { buffer: boolean } Whether the keymaps should be set for the buffer or not.
	plugin.set_keymaps = function(args)
		-- Set up <Plug> keymaps
		plugin.set_keymap({
			mode = "i",
			lhs = "<Plug>(nvim-surround-insert)",
			rhs = function()
				require("nvim-surround").insert_surround({ line_mode = false })
			end,
			opts = {
				buffer = args.buffer,
				desc = "Add a surrounding pair around the cursor (insert mode)",
				silent = true,
			},
		})
		plugin.set_keymap({
			mode = "i",
			lhs = "<Plug>(nvim-surround-insert-line)",
			rhs = function()
				require("nvim-surround").insert_surround({ line_mode = true })
			end,
			opts = {
				buffer = args.buffer,
				desc = "Add a surrounding pair around the cursor, on new lines (insert mode)",
				silent = true,
			},
		})
		plugin.set_keymap({
			mode = "n",
			lhs = "<Plug>(nvim-surround-normal)",
			rhs = function()
				return require("nvim-surround").normal_surround({ line_mode = false })
			end,
			opts = {
				buffer = args.buffer,
				desc = "Add a surrounding pair around a motion (normal mode)",
				expr = true,
				silent = true,
			},
		})
		plugin.set_keymap({
			mode = "n",
			lhs = "<Plug>(nvim-surround-normal-cur)",
			rhs = function()
				return "<Plug>(nvim-surround-normal)Vg_"
			end,
			opts = {
				buffer = args.buffer,
				desc = "Add a surrounding pair around the current line (normal mode)",
				expr = true,
				silent = true,
			},
		})
		plugin.set_keymap({
			mode = "n",
			lhs = "<Plug>(nvim-surround-normal-line)",
			rhs = function()
				return require("nvim-surround").normal_surround({ line_mode = true })
			end,
			opts = {
				buffer = args.buffer,
				desc = "Add a surrounding pair around a motion, on new lines (normal mode)",
				expr = true,
				silent = true,
			},
		})
		plugin.set_keymap({
			mode = "n",
			lhs = "<Plug>(nvim-surround-normal-cur-line)",
			rhs = function()
				return "^" .. tostring(vim.v.count1) .. "<Plug>(nvim-surround-normal-line)g_"
			end,
			opts = {
				buffer = args.buffer,
				desc = "Add a surrounding pair around the current line, on new lines (normal mode)",
				expr = true,
				silent = true,
			},
		})
		plugin.set_keymap({
			mode = "x",
			lhs = "<Plug>(nvim-surround-visual)",
			rhs = function()
				local curpos = require("nvim-surround.buffer").get_curpos()
				return string.format(
					":lua require'nvim-surround'.visual_surround({ line_mode = false, curpos = { %d, %d } })<CR>",
					curpos[1],
					curpos[2]
				)
			end,
			opts = {
				buffer = args.buffer,
				desc = "Add a surrounding pair around a visual selection",
				silent = true,
				expr = true,
			},
		})
		plugin.set_keymap({
			mode = "x",
			lhs = "<Plug>(nvim-surround-visual-line)",
			rhs = function()
				local curpos = require("nvim-surround.buffer").get_curpos()
				return string.format(
					":lua require'nvim-surround'.visual_surround({ line_mode = true, curpos = { %d, %d } })<CR>",
					curpos[1],
					curpos[2]
				)
			end,
			opts = {
				buffer = args.buffer,
				desc = "Add a surrounding pair around a visual selection, on new lines",
				silent = true,
				expr = true,
			},
		})
		plugin.set_keymap({
			mode = "n",
			lhs = "<Plug>(nvim-surround-delete)",
			rhs = require("nvim-surround").delete_surround,
			opts = {
				buffer = args.buffer,
				desc = "Delete a surrounding pair",
				expr = true,
				silent = true,
			},
		})
		plugin.set_keymap({
			mode = "n",
			lhs = "<Plug>(nvim-surround-change)",
			rhs = function()
				return require("nvim-surround").change_surround({ line_mode = false })
			end,
			opts = {
				buffer = args.buffer,
				desc = "Change a surrounding pair",
				expr = true,
				silent = true,
			},
		})
		plugin.set_keymap({
			mode = "n",
			lhs = "<Plug>(nvim-surround-change-line)",
			rhs = function()
				return require("nvim-surround").change_surround({ line_mode = true })
			end,
			opts = {
				buffer = args.buffer,
				desc = "Change a surrounding pair, putting replacements on new lines",
				expr = true,
				silent = true,
			},
		})

		-- Set up user-defined keymaps
		plugin.set_keymap({
			name = "insert",
			mode = "i",
			lhs = plugin.get_opts().keymaps.insert,
			rhs = "<Plug>(nvim-surround-insert)",
			opts = {
				desc = "Add a surrounding pair around the cursor (insert mode)",
			},
		})
		plugin.set_keymap({
			name = "insert_line",
			mode = "i",
			lhs = plugin.get_opts().keymaps.insert_line,
			rhs = "<Plug>(nvim-surround-insert-line)",
			opts = {
				desc = "Add a surrounding pair around the cursor, on new lines (insert mode)",
			},
		})
		plugin.set_keymap({
			name = "normal",
			mode = "n",
			lhs = plugin.get_opts().keymaps.normal,
			rhs = "<Plug>(nvim-surround-normal)",
			opts = {
				desc = "Add a surrounding pair around a motion (normal mode)",
			},
		})
		plugin.set_keymap({
			name = "normal_cur",
			mode = "n",
			lhs = plugin.get_opts().keymaps.normal_cur,
			rhs = "<Plug>(nvim-surround-normal-cur)",
			opts = {
				desc = "Add a surrounding pair around the current line (normal mode)",
			},
		})
		plugin.set_keymap({
			name = "normal_line",
			mode = "n",
			lhs = plugin.get_opts().keymaps.normal_line,
			rhs = "<Plug>(nvim-surround-normal-line)",
			opts = {
				desc = "Add a surrounding pair around a motion, on new lines (normal mode)",
			},
		})
		plugin.set_keymap({
			name = "normal_cur_line",
			mode = "n",
			lhs = plugin.get_opts().keymaps.normal_cur_line,
			rhs = "<Plug>(nvim-surround-normal-cur-line)",
			opts = {
				desc = "Add a surrounding pair around the current line, on new lines (normal mode)",
			},
		})
		plugin.set_keymap({
			name = "visual",
			mode = "x",
			lhs = plugin.get_opts().keymaps.visual,
			rhs = "<Plug>(nvim-surround-visual)",
			opts = {
				desc = "Add a surrounding pair around a visual selection",
			},
		})
		plugin.set_keymap({
			name = "visual_line",
			mode = "x",
			lhs = plugin.get_opts().keymaps.visual_line,
			rhs = "<Plug>(nvim-surround-visual-line)",
			opts = {
				desc = "Add a surrounding pair around a visual selection, on new lines",
			},
		})
		plugin.set_keymap({
			name = "delete",
			mode = "n",
			lhs = plugin.get_opts().keymaps.delete,
			rhs = "<Plug>(nvim-surround-delete)",
			opts = {
				desc = "Delete a surrounding pair",
			},
		})
		plugin.set_keymap({
			name = "change",
			mode = "n",
			lhs = plugin.get_opts().keymaps.change,
			rhs = "<Plug>(nvim-surround-change)",
			opts = {
				desc = "Change a surrounding pair",
			},
		})
		plugin.set_keymap({
			name = "change_line",
			mode = "n",
			lhs = plugin.get_opts().keymaps.change_line,
			rhs = "<Plug>(nvim-surround-change-line)",
			opts = {
				desc = "Change a surrounding pair, putting replacements on new lines",
			},
		})
	end

	-- Setup the global user options for all files.
	---@param user_opts user_options|nil The user-defined options to be merged with default_opts.
	plugin.setup = function(user_opts)
		-- Overwrite default options with user-defined options, if they exist
		plugin.user_opts = plugin.merge_opts(plugin.translate_opts(plugin.default_opts), user_opts)
		plugin.set_keymaps({ buffer = false })
		-- Configure highlight group, if necessary
		if plugin.user_opts.highlight.duration then
			vim.cmd.highlight("default link NvimSurroundHighlight Visual")
		end
		-- Intercept dot repeat action, remembering cursor position
		local buffer = require("nvim-surround.buffer")
		local nvim_surround = require("nvim-surround")
		vim.on_key(function(key)
			if key == "." and not nvim_surround.pending_surround then
				nvim_surround.normal_curpos = buffer.get_curpos()
			end
		end)
	end

	-- Setup the user options for the current buffer.
	---@param buffer_opts user_options|nil The buffer-local options to be merged with the global user_opts.
	plugin.buffer_setup = function(buffer_opts)
		-- pluginerge the given table into the existing buffer-local options, or global options otherwise
		vim.b[0].nvim_surround_buffer_opts = plugin.merge_opts(plugin.get_opts(), buffer_opts)
		plugin.set_keymaps({ buffer = true })
	end

	return {
		require("nvim-surround").setup({
			keymaps = {
				insert = "<C-g>s",
				insert_line = "<C-g>S",
				normal = "ys",
				normal_cur = "yss",
				normal_line = "yS",
				normal_cur_line = "ySS",
				visual = "S",
				visual_line = "gS",
				delete = "ds",
				change = "cs",
				change_line = "cS",
			},
			surrounds = {
				["("] = {
					add = { "( ", " )" },
					find = function()
						return plugin.get_selection({ motion = "a(" })
					end,
					delete = "^(. ?)().-( ?.)()$",
				},
				[")"] = {
					add = { "(", ")" },
					find = function()
						return plugin.get_selection({ motion = "a)" })
					end,
					delete = "^(.)().-(.)()$",
				},
				["{"] = {
					add = { "{ ", " }" },
					find = function()
						return plugin.get_selection({ motion = "a{" })
					end,
					delete = "^(. ?)().-( ?.)()$",
				},
				["}"] = {
					add = { "{", "}" },
					find = function()
						return plugin.get_selection({ motion = "a}" })
					end,
					delete = "^(.)().-(.)()$",
				},
				["<"] = {
					add = { "< ", " >" },
					find = function()
						return plugin.get_selection({ motion = "a<" })
					end,
					delete = "^(. ?)().-( ?.)()$",
				},
				[">"] = {
					add = { "<", ">" },
					find = function()
						return plugin.get_selection({ motion = "a>" })
					end,
					delete = "^(.)().-(.)()$",
				},
				["["] = {
					add = { "[ ", " ]" },
					find = function()
						return plugin.get_selection({ motion = "a[" })
					end,
					delete = "^(. ?)().-( ?.)()$",
				},
				["]"] = {
					add = { "[", "]" },
					find = function()
						return plugin.get_selection({ motion = "a]" })
					end,
					delete = "^(.)().-(.)()$",
				},
				["'"] = {
					add = { "'", "'" },
					find = function()
						return plugin.get_selection({ motion = "a'" })
					end,
					delete = "^(.)().-(.)()$",
				},
				['"'] = {
					add = { '"', '"' },
					find = function()
						return plugin.get_selection({ motion = 'a"' })
					end,
					delete = "^(.)().-(.)()$",
				},
				["`"] = {
					add = { "`", "`" },
					find = function()
						return plugin.get_selection({ motion = "a`" })
					end,
					delete = "^(.)().-(.)()$",
				},
				["i"] = { -- TODO: Add find/delete/change functions
					add = function()
						local left_delimiter = plugin.get_input("Enter the left delimiter: ")
						local right_delimiter = left_delimiter and plugin.get_input("Enter the right delimiter: ")
						if right_delimiter then
							return { { left_delimiter }, { right_delimiter } }
						end
					end,
					find = function() end,
					delete = function() end,
				},
				["t"] = {
					add = function()
						local user_input = plugin.get_input("Enter the HTML tag: ")
						if user_input then
							local element = user_input:match("^<?([^%s>]*)")
							local attributes = user_input:match("^<?[^%s>]*%s+(.-)>?$")

							local open = attributes and element .. " " .. attributes or element
							local close = element

							return { { "<" .. open .. ">" }, { "</" .. close .. ">" } }
						end
					end,
					find = function()
						return plugin.get_selection({ motion = "at" })
					end,
					delete = "^(%b<>)().-(%b<>)()$",
					change = {
						target = "^<([^%s<>]*)().-([^/]*)()>$",
						replacement = function()
							local user_input = plugin.get_input("Enter the HTML tag: ")
							if user_input then
								local element = user_input:match("^<?([^%s>]*)")
								local attributes = user_input:match("^<?[^%s>]*%s+(.-)>?$")

								local open = attributes and element .. " " .. attributes or element
								local close = element

								return { { open }, { close } }
							end
						end,
					},
				},
				["T"] = {
					add = function()
						local user_input = plugin.get_input("Enter the HTML tag: ")
						if user_input then
							local element = user_input:match("^<?([^%s>]*)")
							local attributes = user_input:match("^<?[^%s>]*%s+(.-)>?$")

							local open = attributes and element .. " " .. attributes or element
							local close = element

							return { { "<" .. open .. ">" }, { "</" .. close .. ">" } }
						end
					end,
					find = function()
						return plugin.get_selection({ motion = "at" })
					end,
					delete = "^(%b<>)().-(%b<>)()$",
					change = {
						target = "^<([^>]*)().-([^/]*)()>$",
						replacement = function()
							local user_input = plugin.get_input("Enter the HTML tag: ")
							if user_input then
								local element = user_input:match("^<?([^%s>]*)")
								local attributes = user_input:match("^<?[^%s>]*%s+(.-)>?$")

								local open = attributes and element .. " " .. attributes or element
								local close = element

								return { { open }, { close } }
							end
						end,
					},
				},
				["f"] = {
					add = function()
						local result = plugin.get_input("Enter the function name: ")
						if result then
							return { { result .. "(" }, { ")" } }
						end
					end,
					find = function()
						if vim.g.loaded_nvim_treesitter then
							local selection = plugin.get_selection({
								query = {
									capture = "@call.outer",
									type = "textobjects",
								},
							})
							if selection then
								return selection
							end
						end
						return plugin.get_selection({ pattern = "[^=%s%(%){}]+%b()" })
					end,
					delete = "^(.-%()().-(%))()$",
					change = {
						target = "^.-([%w_]+)()%(.-%)()()$",
						replacement = function()
							local result = plugin.get_input("Enter the function name: ")
							if result then
								return { { result }, { "" } }
							end
						end,
					},
				},
				invalid_key_behavior = {
					add = function(char)
						if not char or char:find("%c") then
							return nil
						end
						return { { char }, { char } }
					end,
					find = function(char)
						if not char or char:find("%c") then
							return nil
						end
						return plugin.get_selection({
							pattern = vim.pesc(char) .. ".-" .. vim.pesc(char),
						})
					end,
					delete = function(char)
						if not char or char:find("%c") then
							return nil
						end
						return plugin.get_selections({
							char = char,
							pattern = "^(.)().-(.)()$",
						})
					end,
				},
			},
			aliases = {
				["a"] = ">",
				["b"] = ")",
				["B"] = "}",
				["r"] = "]",
				["q"] = { '"', "'", "`" },
				["s"] = { "}", "]", ")", ">", '"', "'", "`" },
			},
			highlight = {
				duration = 0,
			},
			move_cursor = "begin",
			indent_lines = function(start, stop)
				local b = vim.bo
				-- Only re-indent the selection if a formatter is set up already
				if
					start < stop and (b.equalprg ~= "" or b.indentexpr ~= "" or b.cindent or b.smartindent or b.lisp)
				then
					vim.cmd(string.format("silent normal! %dG=%dG", start, stop))
					require("nvim-surround.cache").set_callback("")
				end
			end,
		}),
	}
end

return plugin
