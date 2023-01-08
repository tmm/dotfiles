local util = require("util")

return {
	-- https://github.com/echasnovski/mini.bufremove
	{
		"echasnovski/mini.bufremove",
	},

	-- https://github.com/folke/trouble.nvim
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		config = { use_diagnostic_signs = true },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
		},
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
						d = {
							function()
								require("mini.bufremove").delete(0, false)
							end,
							"Delete Buffer",
						},
						D = {
							function()
								require("mini.bufremove").delete(0, true)
							end,
							"Force Delete Buffer",
						},
					},
					c = {
						name = "+code",
					},
					f = {
						name = "+file",
						e = { "<cmd>Neotree toggle<cr>", "Toggle File Explorer" },
						f = { "<cmd>Telescope find_files<cr>", "Find File" },
						n = { "<cmd>enew<cr>", "New File" },
						r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
						s = { "<cmd>Neotree focus<cr>", "Focus File in Explorer" },
					},
					g = {
						name = "+git",
						b = { "<cmd>Telescope git_branches<cr>", "Branches" },
						c = { "<cmd>Telescope git_commits<cr>", "Commits" },
						d = { "<cmd>Gitsigns diffthis<cr>", "Diff" },
						h = {
							name = "+hunk",
							s = { "<cmd>Gitsigns stage_hunk<cr>", "Stage" },
							r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset" },
						},
						s = { "<cmd>Telescope git_status<cr>", "Status" },
					},
					h = {
						name = "+help",
						t = { "<cmd>:Telescope builtin<cr>", "Telescope" },
					},
					p = {
						name = "+project",
						p = {
							function()
								require("telescope").extensions.project.project({})
							end,
							"Project Picker",
						},
					},
					s = {
						name = "+search",
						["*"] = { "<cmd>Telescope grep_string<cr>", "String Under Cursor" },
						b = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
						g = { "<cmd>Telescope live_grep<cr>", "Grep" },
						h = { "<cmd>Telescope command_history<cr>", "Command History" },
						s = {
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
							"Goto Symbol",
						},
					},
					t = {
						name = "toggle",
						f = {
							require("plugins.lsp.format").toggle,
							"Format on Save",
						},
						g = {
							name = "git",
							b = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Blame" },
							d = { "<cmd>Gitsigns toggle_deleted<cr>", "Deleted" },
						},
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
		config = function()
			require("gitsigns").setup({
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
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},

	-- https://github.com/nvim-neo-tree/neo-tree.nvim
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		dependencies = {
			-- https://github.com/nvim-lua/plenary.nvim
			"nvim-lua/plenary.nvim",
			-- https://github.com/nvim-tree/nvim-web-devicons
			"nvim-tree/nvim-web-devicons",
			-- https://github.com/MunifTanjim/nui.nvim
			"MunifTanjim/nui.nvim",
		},
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
		end,
		config = function()
			require("neo-tree").setup({
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
			})
			require("nvim-web-devicons").setup({ default = true })
		end,
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
			-- https://github.com/nvim-telescope/telescope-project.nvim
			"nvim-telescope/telescope-project.nvim",
		},
		config = function()
			local actions = require("telescope.actions")

			local telescope = require("telescope")
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
					},
					prompt_prefix = "❯ ",
					selection_caret = "→ ",
				},
				extensions = {
					project = {
						theme = "dropdown",
					},
				},
				pickers = {
					buffers = {
						ignore_current_buffer = true,
						sort_lastused = true,
						theme = "dropdown",
					},
					find_files = {
						theme = "dropdown",
					},
					grep_string = {
						theme = "dropdown",
					},
					live_grep = {
						theme = "dropdown",
					},
				},
			})

			telescope.load_extension("project")
		end,
	},
}
