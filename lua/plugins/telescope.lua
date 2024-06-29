return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	enabled = function()
		return LazyVim.pick.want() == "telescope"
	end,
	version = false, -- telescope did only one release, so use HEAD for now
	dependencies = {
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = have_make and "make"
				or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
			enabled = have_make or have_cmake,
			config = function(plugin)
				LazyVim.on_load("telescope.nvim", function()
					local ok, err = pcall(require("telescope").load_extension, "fzf")
					if not ok then
						local lib = plugin.dir
							.. "/build/libfzf."
							.. (LazyVim.is_win() and "dll" or "so")
						if not vim.uv.fs_stat(lib) then
							LazyVim.warn(
								"`telescope-fzf-native.nvim` not built. Rebuilding..."
							)
							require("lazy")
								.build({ plugins = { plugin }, show = false })
								:wait(function()
									LazyVim.info(
										"Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim."
									)
								end)
						else
							LazyVim.error(
								"Failed to load `telescope-fzf-native.nvim`:\n" .. err
							)
						end
					end
				end)
			end,
		},
	},
	keys = {
		{
			"<leader>,",
			"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
			desc = "Switch Buffer",
		},
		{ "<leader>/", LazyVim.pick("live_grep"), desc = "Grep (Root Dir)" },
		{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
		{ "<leader><space>", LazyVim.pick("auto"), desc = "Find Files (Root Dir)" },
		-- find
		{ "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
		{ "<leader>ff", LazyVim.pick("auto"), desc = "Find Files (Root Dir)" },
	},
	opts = function()
		local actions = require("telescope.actions")

		local open_with_trouble = function(...)
			return require("trouble.sources.telescope").open(...)
		end
		local find_files_no_ignore = function()
			local action_state = require("telescope.actions.state")
			local line = action_state.get_current_line()
			LazyVim.pick("find_files", { no_ignore = true, default_text = line })()
		end
		local find_files_with_hidden = function()
			local action_state = require("telescope.actions.state")
			local line = action_state.get_current_line()
			LazyVim.pick("find_files", { hidden = true, default_text = line })()
		end

		return {
			defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				-- open files in the first window that is an actual file.
				-- use the current window if no other window is available.
				get_selection_window = function()
					local wins = vim.api.nvim_list_wins()
					table.insert(wins, 1, vim.api.nvim_get_current_win())
					for _, win in ipairs(wins) do
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].buftype == "" then
							return win
						end
					end
					return 0
				end,
				mappings = {
					i = {
						["<c-t>"] = open_with_trouble,
						["<a-t>"] = open_with_trouble,
						["<a-i>"] = find_files_no_ignore,
						["<a-h>"] = find_files_with_hidden,
						["<C-Down>"] = actions.cycle_history_next,
						["<C-Up>"] = actions.cycle_history_prev,
						["<C-f>"] = actions.preview_scrolling_down,
						["<C-b>"] = actions.preview_scrolling_up,
					},
					n = {
						["q"] = actions.close,
					},
				},
			},
		}
	end,
}
