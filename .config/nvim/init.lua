--------------------------------------------------------------------------
-- Options
--------------------------------------------------------------------------

local indent = 2

vim.g.mapleader = " "

vim.opt.autoindent = true -- Good auto indent
vim.opt.clipboard = "unnamed,unnamedplus" -- Use clipboard for all operations
vim.opt.cursorline = true -- Highlight current line
vim.opt.expandtab = true -- Expand tabs into spaces
vim.opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldcolumn = "0"
vim.opt.hidden = true -- Handle multiple buffers better
vim.opt.mouse = "" -- Disable mouse
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Line numbers relative to cursor
vim.opt.scrolloff = 4 -- Always show at least four lines above/below cursor
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = indent -- Size of an indent
vim.opt.shortmess = "Iac" -- Disable start up message and abbreviate items
vim.opt.showbreak = "↪"
vim.opt.showmode = false -- Hide redundant mode
vim.opt.sidescrolloff = 4 -- Always show at least four columns left/right cursor
vim.opt.signcolumn = "yes" -- Always show the signcolumn
vim.opt.smartcase = true -- Switch to case-sensitive search for capital letters
vim.opt.smartindent = true
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.swapfile = false -- Disable swapfiles
vim.opt.tabstop = indent -- Number of spaces tabs count for
vim.opt.termguicolors = true -- Support for true color (https://github.com/termstandard/colors)
vim.opt.title = true -- Set terminal title
vim.opt.undodir = vim.env.XDG_CONFIG_HOME .. "/nvim/undo"
vim.opt.undofile = true
vim.opt.updatetime = 200 -- Faster update time
vim.opt.visualbell = true -- Disable beeping
vim.opt.wildmode = "longest:full,full" -- Completion settings

-- When using fish, set shell to bash
if vim.env.SHELL:match("fish$") then
	vim.opt.shell = "/bin/bash"
end

-- Use proper syntax highlighting in code blocks
local fences = {
	"console=sh",
	"javascript",
	"js=javascript",
	"json",
	"lua",
	"python",
	"sh",
	"shell=sh",
	"ts=typescript",
	"typescript",
}
vim.g.markdown_fenced_languages = fences
vim.g.markdown_recommended_style = 0

--------------------------------------------------------------------------
-- Util
--------------------------------------------------------------------------

local util = {}

function util.toggle(option, silent)
	local info = vim.api.nvim_get_option_info(option)
	local scopes = { buf = "bo", win = "wo", global = "o" }
	local scope = scopes[info.scope]
	local options = vim[scope]
	options[option] = not options[option]
	if silent ~= true then
		if options[option] then
			util.info("enabled vim." .. scope .. "." .. option, "Toggle")
		else
			util.warn("disabled vim." .. scope .. "." .. option, "Toggle")
		end
	end
end

--------------------------------------------------------------------------
-- LSP
--------------------------------------------------------------------------

local lsp = {}

lsp.autoformat = true
function lsp.toggle_format()
	lsp.autoformat = not lsp.autoformat
	vim.notify(lsp.autoformat and "Enabled format on save" or "Disabled format on save")
end

function lsp._format()
	if vim.lsp.buf.format then
		vim.lsp.buf.format()
	else
		vim.lsp.buf.formatting_sync()
	end
end

function lsp.setup_format(client, buf)
	local ft = vim.api.nvim_buf_get_option(buf, "filetype")
	local sources = require("null-ls.sources")
	local available = sources.get_available(ft, "NULL_LS_FORMATTING")
	local has_formatter = #available > 0

	local enable = false
	if has_formatter then
		enable = client.name == "null-ls"
	else
		enable = not (client.name == "null-ls")
	end

	if client.name == "tsserver" then
		enable = false
	end

	client.server_capabilities.documentFormattingProvider = enable
	if enable then
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = vim.api.nvim_create_augroup("LspFormat." .. buf, {}),
			buffer = buf,
			callback = function()
				if lsp.autoformat then
					lsp._format()
				end
			end,
		})
	end
end

function lsp.setup_keymaps(client, buffer)
	local wk = require("which-key")
	local cap = client.server_capabilities

	local keymap = {
		buffer = buffer,
		["<leader>"] = {
			c = {
				name = "+code",
				{
					cond = client.name == "tsserver",
					o = { "<cmd>:TypescriptOrganizeImports<cr>", "Organize Imports" },
					R = { "<cmd>:TypescriptRenameFile<cr>", "Rename File" },
				},
				r = {
					function()
						require("inc_rename").setup({
							input_buffer_type = "dressing",
						})
						return ":IncRename " .. vim.fn.expand("<cword>")
					end,
					"Rename",
					cond = cap.renameProvider,
					expr = true,
				},
				a = {
					{ vim.lsp.buf.code_action, "Code Action" },
					{ "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action", mode = "v" },
				},
				f = {
					{
						lsp._format,
						"Format Document",
						cond = cap.documentFormatting,
					},
					{
						lsp._format,
						"Format Range",
						cond = cap.documentRangeFormatting,
						mode = "v",
					},
				},
				d = { vim.diagnostic.open_float, "Line Diagnostics" },
				l = {
					name = "+lsp",
					i = { "<cmd>LspInfo<cr>", "Lsp Info" },
					a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>", "Add Folder" },
					r = { "<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>", "Remove Folder" },
					l = { "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>", "List Folders" },
				},
			},
		},
		g = {
			name = "+goto",
			d = { "<cmd>Telescope lsp_definitions<cr>", "Goto Definition" },
			r = { "<cmd>Telescope lsp_references<cr>", "References" },
			R = { "<cmd>Trouble lsp_references<cr>", "Trouble References" },
			D = { "<cmd>Telescope lsp_declarations<cr>", "Goto Declaration" },
			I = { "<cmd>Telescope lsp_implementations<cr>", "Goto Implementation" },
			t = { "<cmd>Telescope lsp_type_definitions<cr>", "Goto Type Definition" },
		},
		["\\"] = { "<cmd>lua vim.lsp.buf.hover()<cr>", "Hover" },
		["<C-,>"] = { "<cmd>lua vim.lsp.buf.signature_help()<cr>", "Signature Help", mode = { "n", "i" } },
		["[d"] = { "<cmd>lua vim.diagnostic.goto_prev()<cr>", "Next Diagnostic" },
		["]d"] = { "<cmd>lua vim.diagnostic.goto_next()<cr>", "Prev Diagnostic" },
		["[e"] = { "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<cr>", "Next Error" },
		["]e"] = { "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<cr>", "Prev Error" },
		["[w"] = {
			"<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.WARNING})<cr>",
			"Next Warning",
		},
		["]w"] = {
			"<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.WARNING})<cr>",
			"Prev Warning",
		},
	}

	wk.register(keymap)
end

--------------------------------------------------------------------------
-- Lazy
--------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup({
	defaults = { lazy = true },

	-- better vim.ui (https://github.com/stevearc/dressing.nvim)
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},

	-- git signs (https://github.com/lewis6991/gitsigns.nvim)
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
				end, { expr = true, desc = "Next hunk" })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Previous hunk" })

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

	-- indent guides (https://github.com/lukas-reineke/indent-blankline.nvim)
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = {
			show_current_context = true,
			show_current_context_start = true,
		},
	},

	-- status line (https://github.com/nvim-lualine/lualine.nvim)
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		config = function()
			local conditions = {
				buffer_not_empty = function()
					return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
				end,
			}

			require("lualine").setup({
				options = {
					always_divide_middle = true,
					component_separators = "",
					disabled_filetypes = {
						"neo-tree",
					},
					globalstatus = false,
					icons_enabled = true,
					section_separators = "",
					theme = "tokyonight",
				},
				sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						"mode",
						{
							"filename",
							cond = conditions.buffer_not_empty,
						},
						{
							"branch",
							icon = "",
						},
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
						},
					},
					lualine_x = {
						{
							"diagnostics",
							sources = { "nvim_diagnostic" },
							symbols = { error = " ", warn = " ", info = " " },
						},
						"filetype",
						"progress",
						"location",
					},
					lualine_y = {},
					lualine_z = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = {},
			})
		end,
	},

	-- mini (https://github.com/echasnovski/mini.nvim)
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		dependencies = {
			{
				-- TypeScript comment plugin (https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
				"JoosepAlviste/nvim-ts-context-commentstring",
			},
		},
		config = function()
			require("mini.comment").setup({
				hooks = {
					pre = function()
						require("ts_context_commentstring.internal").update_commentstring({})
					end,
				},
			})
			require("mini.pairs").setup({})
		end,
	},

	-- mini.bufremove (https://github.com/echasnovski/mini.bufremove)
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

	-- tree explorer (https://github.com/nvim-neo-tree/neo-tree.nvim)
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
					override = {
						default_icon = {
							color = "",
						},
					},
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

	-- nvim-cmp (https://github.com/hrsh7th/nvim-cmp)
	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy",
		dependencies = {
			-- https://github.com/hrsh7th/cmp-buffer
			"hrsh7th/cmp-buffer",
			-- https://github.com/hrsh7th/cmp-nvim-lsp
			"hrsh7th/cmp-nvim-lsp",
			-- https://github.com/hrsh7th/cmp-path
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			})
		end,
	},

	-- save last edit location (https://github.com/ethanholz/nvim-lastplace)
	{
		"ethanholz/nvim-lastplace",
		opts = {
			lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
			lastplace_ignore_filetype = { "gitcommit", "gitrebase" },
			lastplace_open_folds = true,
		},
	},

	-- nvim-lspconfig (https://github.com/neovim/nvim-lspconfig)
	{
		"neovim/nvim-lspconfig",
		name = "lsp",
		event = "BufReadPre",
		dependencies = {
			-- https://github.com/williamboman/mason.nvim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			-- https://github.com/jose-elias-alvarez/null-ls.nvim
			"jose-elias-alvarez/null-ls.nvim",
			-- https://github.com/jose-elias-alvarez/typescript.nvim
			"jose-elias-alvarez/typescript.nvim",
			-- https://github.com/folke/lua-dev.nvim
			"folke/lua-dev.nvim",
			-- https://github.com/marilari88/twoslash-queries.nvim
			"marilari88/twoslash-queries.nvim",
			-- https://github.com/smjonas/inc-rename.nvim
			"smjonas/inc-rename.nvim",
		},
		config = function()
			require("mason").setup()

			local tools = {
				"prettierd",
				"stylua",
			}
			local mr = require("mason-registry")
			for _, tool in ipairs(tools) do
				local p = mr.get_package(tool)
				if not p:is_installed() then
					p:install()
				end
			end

			require("mason-lspconfig").setup({
				ensure_installed = {
					"eslint",
					"sumneko_lua",
					"tsserver",
				},
				automatic_installation = true,
			})

			local servers = {
				eslint = {},
				marksman = {},
				sumneko_lua = {
					settings = {
						Lua = {
							diagnostics = {
								globals = {
									"after_each",
									"assert",
									"before_each",
									"describe",
									"it",
									"require",
									"use",
									"vim",
								},
							},
							format = {
								enable = true,
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
									continuation_indent_size = "2",
								},
							},
						},
					},
				},
				tsserver = {},
			}

			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end
			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
			})

			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local function on_attach(client, bufnr)
				lsp.setup_format(client, bufnr)
				lsp.setup_keymaps(client, bufnr)

				if client.name == "tsserver" then
					require("twoslash-queries").attach(client, bufnr)
				end
			end

			local options = {
				on_attach = on_attach,
				capabilities = capabilities,
				flags = {
					debounce_text_changes = 150,
				},
			}

			for server, opts in pairs(servers) do
				opts = vim.tbl_deep_extend("force", {}, options, opts or {})
				if server == "tsserver" then
					require("typescript").setup({ server = opts })
				else
					require("lspconfig")[server].setup(opts)
				end
			end

			local nls = require("null-ls")
			nls.setup({
				debounce = 150,
				save_after_format = false,
				sources = {
					nls.builtins.formatting.stylua,
					nls.builtins.formatting.fish_indent,
				},
				on_attach = on_attach,
			})
		end,
	},

	-- nvim-treesitter (https://github.com/nvim-treesitter/nvim-treesitter)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = "BufReadPost",
		opts = {
			autopairs = {
				enable = true,
			},
			context_commentstring = {
				enable = true,
				enable_autocmd = false,
			},
			ensure_installed = {
				"bash",
				"fish",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"tsx",
				"typescript",
			},
			highlight = {
				enable = true,
			},
			indent = {
				enable = false,
			},
		},
	},

	-- telescope (https://github.com/nvim-telescope/telescope.nvim)
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

	-- colorscheme (https://github.com/folke/tokyonight)
	{
		"folke/tokyonight.nvim",
		lazy = false,
		opts = {
			style = "night",
			light_style = "day",
			styles = {
				sidebars = "dark",
				floats = "dark",
			},
			on_highlights = function(hl, c)
				hl.MsgArea = { bg = c.bg_dark }
				hl.NeoTreeDirectoryIcon = { fg = c.comment }
				hl.TelescopeBorder = { fg = c.comment, bg = c.bg_float }
			end,
		},
		config = function(_, opts)
			local tokyonight = require("tokyonight")
			tokyonight.setup(opts)
			tokyonight.load()
		end,
	},

	-- diagnostics (https://github.com/folke/trouble.nvim)
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
		},
		opts = { use_diagnostic_signs = true },
	},

	-- folds (https://github.com/kevinhwang91/nvim-ufo)
	{
		"kevinhwang91/nvim-ufo",
		dependencies = "kevinhwang91/promise-async",
		event = "BufReadPost",
		opts = {},
		init = function()
			-- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
			vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
			vim.keymap.set("n", "zp", require("ufo").peekFoldedLinesUnderCursor, { desc = "Peek fold" })
		end,
	},

	-- highlight word under cusor (https://github.com/RRethy/vim-illuminate)
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			delay = 200,
			large_file_cutoff = 2000,
			large_file_overrides = {
				providers = { "lsp" },
			},
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},

	-- repeat commands (https://github.com/tpope/vim-repeat)
	{
		"tpope/vim-repeat",
		event = "VeryLazy",
	},

	-- vim-surround (https://github.com/tpope/vim-surround)
	{
		"tpope/vim-surround",
		event = "VeryLazy",
	},

	-- vim-tmux-navigator (https://github.com/christoomey/vim-tmux-navigator)
	{
		"christoomey/vim-tmux-navigator",
		event = "VeryLazy",
		config = function()
			vim.g.tmux_navigator_disable_when_zoomed = 1
			vim.g.tmux_navigator_save_on_switch = 2
			vim.g.VtrOrientation = "v"
			vim.g.VtrPercentage = 20
		end,
	},

	-- vim-unimpaired (https://github.com/tpope/vim-unimpaired)
	{
		"tpope/vim-unimpaired",
		event = "VeryLazy",
	},

	-- which-key (https://github.com/folke/which-key.nvim)
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
							lsp.toggle_format,
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
					x = { name = "+diagnostics" },
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
})
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<cr>")

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		--------------------------------------------------------------------------
		-- Commands
		--------------------------------------------------------------------------

		-- Switch between relative and absolute line numbers based on mode
		local number_toggle = vim.api.nvim_create_augroup("number_toggle", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
			callback = function()
				if vim.opt.number:get() == true then
					vim.opt.relativenumber = true
				end
			end,
			group = number_toggle,
		})
		vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
			callback = function()
				if vim.opt.number:get() == true then
					vim.opt.relativenumber = false
				end
			end,
			group = number_toggle,
		})

		-- Highlight on yank
		vim.api.nvim_create_autocmd("TextYankPost", {
			callback = function()
				vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
			end,
		})

		--------------------------------------------------------------------------
		-- Keymaps
		--------------------------------------------------------------------------

		vim.o.timeoutlen = 300

		local opts = { noremap = true, silent = true }
		vim.g.mapleader = " "

		-- Move to first character on line
		vim.keymap.set("n", "H", "^", opts)
		-- Move to last character on line
		vim.keymap.set("n", "L", "g_", opts)

		-- Move up/down five lines
		vim.keymap.set("n", "J", "5j", opts)
		vim.keymap.set("n", "K", "5k", opts)
		vim.keymap.set("v", "J", "5j", opts)
		vim.keymap.set("v", "K", "5k", opts)

		-- Move up and down by visible lines if current line is wrapped
		vim.keymap.set("n", "j", "gj", opts)
		vim.keymap.set("n", "k", "gk", opts)

		-- Yank to end of current line
		vim.keymap.set("n", "Y", "y$", opts)

		-- Visually select text that was last edited/pasted (Vimcast#26)
		vim.keymap.set("n", "gV", "`[v`]", opts)

		-- Replay macro
		vim.keymap.set("n", "Q", "@q", opts)

		-- Remove highlights
		vim.keymap.set("n", "<CR>", ":noh<CR><CR>", opts)

		-- Don't yank on delete character
		vim.keymap.set("n", "x", '"_x', opts)
		vim.keymap.set("n", "X", '"_X', opts)
		vim.keymap.set("v", "x", '"_x', opts)
		vim.keymap.set("v", "X", '"_X', opts)

		-- Disable arrow keys
		vim.keymap.set("", "<down>", "<nop>", opts)
		vim.keymap.set("", "<left>", "<nop>", opts)
		vim.keymap.set("", "<right>", "<nop>", opts)
		vim.keymap.set("", "<up>", "<nop>", opts)
	end,
})
