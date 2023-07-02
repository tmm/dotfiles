local util = require("util")

return {
	-- https://github.com/echasnovski/mini.bufremove
	{
		"echasnovski/mini.bufremove",
		keys = {
			{
				"<leader>bd",
				function()
					require("mini.bufremove").delete(0, false)
				end,
				desc = "Delete Buffer",
			},
			{
				"<leader>bD",
				function()
					require("mini.bufremove").delete(0, true)
				end,
				desc = "Delete Buffer (Force)",
			},
			{
				"<leader>bk",
				"<cmd>%bd<cr>",
				desc = "Delete Buffers",
			},
		},
	},

	-- https://github.com/folke/trouble.nvim
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
		},
		opts = { use_diagnostic_signs = true },
	},

	-- https://github.com/folke/which-key.nvim
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			local wk = require("which-key")
			wk.setup({
				plugins = { spelling = true },
				key_labels = { ["<leader>"] = "SPC" },
				show_help = false,
				triggers = "auto",
			})
			wk.register({
				mode = { "n", "v" },
				["g"] = { name = "+goto" },
				["]"] = { name = "+next" },
				["["] = { name = "+prev" },
				["<leader>"] = {
					b = {
						name = "+buffer",
						b = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
					},
					c = { name = "+code" },
					f = {
						name = "+file",
						n = { "<cmd>enew<cr>", "New File" },
					},
					g = {
						name = "+git",
						h = { name = "+hunk" },
					},
					s = { name = "+search" },
					t = {
						name = "toggle",
						f = {
							require("plugins.lsp.format").toggle,
							"Format on Save",
						},
						g = { name = "git" },
						n = {
							function()
								util.toggle("relativenumber", true)
								util.toggle("number")
							end,
							"Line Numbers",
						},
						s = {
							function()
								util.toggle("spell")
							end,
							"Spelling",
						},
						w = {
							function()
								util.toggle("wrap")
							end,
							"Word Wrap",
						},
					},
					q = { "<cmd>q<cr>", "which_key_ignore", silent = true },
					Q = { "<cmd>q!<cr>", "which_key_ignore", silent = true },
					w = { "<cmd>w<cr>", "which_key_ignore", silent = true },
				},
				-- ["<leader>n"] = { name = "+noice" },
				-- ["<leader>o"] = { name = "+open" },
				-- ["<leader>q"] = { name = "+quit/session" },
				-- ["<leader>x"] = { name = "+diagnostics/quickfix" },
				-- ["<leader>w"] = { name = "+windows" },
				-- ["<leader><tab>"] = { name = "+tabs" },
			})
		end,
	},

	-- https://github.com/lewis6991/gitsigns.nvim
	{
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		keys = {
			{ "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff" },
			{ "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage" },
			{ "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset" },
			{ "<leader>tgb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Blame" },
			{ "<leader>tgd", "<cmd>Gitsigns toggle_deleted<cr>", desc = "Toggle Deleted" },
		},
		opts = {
			current_line_blame_opts = { delay = 500 },
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				-- Text object
				map({ "o", "x" }, "ih", ":<c-u>Gitsigns select_hunk<cr>")
			end,
			worktrees = {
				{
					gitdir = vim.env.HOME .. "/.files",
					toplevel = vim.env.HOME,
				},
			},
		},
	},

	-- https://github.com/nvim-neo-tree/neo-tree.nvim
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		dependencies = {
			-- https://github.com/nvim-lua/plenary.nvim
			"nvim-lua/plenary.nvim",
			-- https://github.com/nvim-tree/nvim-web-devicons
			{
				"nvim-tree/nvim-web-devicons",
				opts = {
					color_icons = false,
				},
			},
			-- https://github.com/MunifTanjim/nui.nvim
			"MunifTanjim/nui.nvim",
		},
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
		end,
		keys = {
			{ "<leader>fe", "<cmd>Neotree toggle<cr>", desc = "Toggle Explorer" },
			{ "<leader>fs", "<cmd>Neotree focus<cr>", desc = "Focus File in Explorer" },
		},
		opts = {
			default_component_configs = {
				indent = {
					with_markers = false,
				},
			},
			filesystem = {
				filtered_items = {
					hide_dotfiles = false,
				},
				follow_current_file = true,
				hijack_netrw_behavior = "open_current",
			},
			window = {
				width = 30,
			},
		},
	},

	-- https://github.com/nvim-telescope/telescope.nvim
	{
		"nvim-telescope/telescope.nvim",
		cmd = { "Telescope" },
		dependencies = {
			-- Lua functions (https://github.com/nvim-lua/plenary.nvim)
			"nvim-lua/plenary.nvim",
			-- Pop up API (https://github.com/nvim-lua/popup.nvim)
			"nvim-lua/popup.nvim",
		},
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find Buffers" },
			{ "<leader>fB", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Find Buffers (Show All)" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Find Recent Files" },

			{ "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
			{ "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Branches" },
			{ "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Status" },

			{ "<leader>s*", "<cmd>Telescope grep_string<cr>", desc = "Grep (Under Cursor)" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
			{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Highlight Groups" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{
				"<leader>ss",
				function()
					require("telescope.builtin").lsp_document_symbols({
						symbols = {
							"Class",
							"Function",
							"Method",
							"Constructor",
							"Interface",
							"Module",
							"Struct",
							"Trait",
							"Field",
							"Property",
						},
					})
				end,
				desc = "Goto Symbol",
			},
			{ "<leader>st", "<cmd>Telescope builtin<cr>", desc = "Telescope" },
		},
		opts = {
			defaults = {
				border = true,
				borderchars = {
					prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
					results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
					preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
				},
				mappings = {
					i = {
						["<C-i>"] = function()
							require("telescope.builtin").find_files({ no_ignore = true })
						end,
						["<C-j>"] = function(...)
							require("telescope.actions").move_selection_next(...)
						end,
						["<C-k>"] = function(...)
							require("telescope.actions").move_selection_previous(...)
						end,
					},
				},
				layout_strategy = "center",
				layout_config = {
					height = function(_, _, max_lines)
						return math.min(max_lines, 15)
					end,
					preview_cutoff = 1,
					width = function(_, max_columns, _)
						return math.min(max_columns, 80)
					end,
				},
				prompt_prefix = "❯ ",
				results_title = false,
				selection_caret = "→ ",
				sorting_strategy = "ascending",
			},
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
					-- find_command = { "fd", "-t", "f", "-H" },
				},
				buffers = {
					ignore_current_buffer = true,
					sort_lastused = true,
				},
			},
		},
	},

	-- https://github.com/RRethy/vim-illuminate
	{
		"RRethy/vim-illuminate",
		config = function(_, opts)
			require("illuminate").configure(opts)
		end,
		event = "BufReadPost",
		keys = {
			{
				"]]",
				function()
					require("illuminate").goto_next_reference(false)
				end,
				desc = "Next Reference",
			},
			{
				"[[",
				function()
					require("illuminate").goto_prev_reference(false)
				end,
				desc = "Prev Reference",
			},
		},
		opts = { delay = 200 },
	},
}
