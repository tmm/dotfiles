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
vim.opt.shortmess:append("IWs") -- Disable start up message and abbreviate items
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

function util.warn(msg, name)
	vim.notify(msg, vim.log.levels.WARN, { title = name or "init.lua" })
end

function util.error(msg, name)
	vim.notify(msg, vim.log.levels.ERROR, { title = name or "init.lua" })
end

function util.info(msg, name)
	vim.notify(msg, vim.log.levels.INFO, { title = name or "init.lua" })
end

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

function util.on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

local icons = {
	diagnostics = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	},
	git = {
		added = " ",
		modified = " ",
		removed = " ",
	},
	kinds = {
		Array = " ",
		Boolean = " ",
		Class = " ",
		Color = " ",
		Constant = " ",
		Constructor = " ",
		Copilot = " ",
		Enum = " ",
		EnumMember = " ",
		Event = " ",
		Field = " ",
		File = " ",
		Folder = " ",
		Function = " ",
		Interface = " ",
		Key = " ",
		Keyword = " ",
		Method = " ",
		Module = " ",
		Namespace = " ",
		Null = " ",
		Number = " ",
		Object = " ",
		Operator = " ",
		Package = " ",
		Property = " ",
		Reference = " ",
		Snippet = " ",
		String = " ",
		Struct = " ",
		Text = " ",
		TypeParameter = " ",
		Unit = " ",
		Value = " ",
		Variable = " ",
	},
}

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
						require("inc_rename").setup()
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
	defaults = {
		lazy = true,
	},

	{
		dir = "~/Developer/rsms",
		lazy = false,
		config = function()
			vim.cmd([[colorscheme rsms]])
		end,
	},

	-- dressing.nvim (https://github.com/stevearc/dressing.nvim)
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

	-- gitsigns.nvim (https://github.com/lewis6991/gitsigns.nvim)
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		keys = {
			{ "<leader>gd", "<cmd>Gitsigns diffthis<cr>", desc = "Diff" },
			{ "<leader>ghs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage" },
			{ "<leader>ghr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset" },
			{ "<leader>ugb", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Blame" },
			{ "<leader>ugd", "<cmd>Gitsigns toggle_deleted<cr>", desc = "Toggle Deleted" },
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
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			worktrees = {
				{
					gitdir = vim.env.HOME .. "/.files",
					toplevel = vim.env.HOME,
				},
			},
		},
	},

	-- flash.nvim (https://github.com/folke/flash.nvim)
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "o", "x" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote Flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter Search",
			},
		},
	},

	-- indent-blankline.nvim (https://github.com/lukas-reineke/indent-blankline.nvim)
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {
			indent = { char = "▏" },
			exclude = {
				filetypes = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
					"notify",
					"toggleterm",
					"lazyterm",
				},
			},
		},
	},

	-- LuaSnip (https://github.com/L3MON4D3/LuaSnip)
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
		keys = {
			{
				"<tab>",
				function()
					return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
			{
				"<tab>",
				function()
					require("luasnip").jump(1)
				end,
				mode = "s",
			},
			{
				"<s-tab>",
				function()
					require("luasnip").jump(-1)
				end,
				mode = { "i", "s" },
			},
		},
		config = function()
			require("luasnip.loaders.from_vscode").lazy_load()
		end,
	},

	-- lualine.nvim (https://github.com/nvim-lualine/lualine.nvim)
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
						"neotest-output-panel",
						"neotest-summary",
					},
					globalstatus = false,
					icons_enabled = true,
					section_separators = "",
				},
				sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						{
							"mode",
							color = "MsgArea",
						},
						{
							"filename",
							color = "MsgArea",
							cond = conditions.buffer_not_empty,
							symbols = { modified = "", readonly = "", unnamed = "" },
						},
						{
							"branch",
							color = "MsgArea",
							icon = "",
						},
						{
							"diagnostics",
							color = "MsgArea",
							sources = { "nvim_diagnostic" },
							symbols = {
								error = icons.diagnostics.Error,
								warn = icons.diagnostics.Warn,
								info = icons.diagnostics.Info,
							},
						},
					},
					lualine_x = {
						{
							"diff",
							color = "MsgArea",
							symbols = {
								added = icons.git.added,
								modified = icons.git.modified,
								removed = icons.git.removed,
							},
						},
						{
							"filetype",
							color = "MsgArea",
						},
						{
							"progress",
							color = "MsgArea",
						},
						{
							"location",
							color = "MsgArea",
						},
					},
					lualine_y = {},
					lualine_z = {},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						{
							"filename",
							color = "MsgArea",
						},
					},
					lualine_x = {
						{
							"location",
							color = "MsgArea",
						},
					},
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				extensions = {},
			})
		end,
	},

	-- mini.nvim (https://github.com/echasnovski/mini.nvim)
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		dependencies = {
			{
				-- TypeScript comment plugin (https://github.com/JoosepAlviste/nvim-ts-context-commentstring)
				"JoosepAlviste/nvim-ts-context-commentstring",
				config = function()
					require("ts_context_commentstring").setup({
						enable_autocmd = false,
					})
				end,
			},
		},
		config = function()
			require("mini.comment").setup({
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
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
				"<cmd>%bd<cr>",
				desc = "Delete All Buffers",
			},
			{
				"<leader>bc",
				"<cmd>%bd|edit#|bd#<cr>",
				desc = "Delete All Buffers (except current)",
			},
		},
	},

	-- neotest (https://github.com/nvim-neotest/neotest)
	{
		"nvim-neotest/neotest",
		dependencies = {
			"antoinemadec/FixCursorHold.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			-- adapters
			"jfpedroza/neotest-elixir",
			"marilari88/neotest-vitest",
		},
		config = function()
			require("neotest").setup({
				adapters = {
					require("neotest-elixir"),
					require("neotest-vitest"),
				},
				output = { open_on_run = true },
				status = {
					signs = false,
					virtual_text = true,
				},
			})
		end,
		keys = {
			{
				"<leader>tt",
				function()
					require("neotest").run.run(vim.fn.expand("%"))
				end,
				desc = "Run File",
			},
			{
				"<leader>tT",
				function()
					require("neotest").run.run(vim.loop.cwd())
				end,
				desc = "Run All Test Files",
			},
			{
				"<leader>tr",
				function()
					require("neotest").run.run()
				end,
				desc = "Run Nearest",
			},
			{
				"<leader>tl",
				function()
					require("neotest").run.run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>ts",
				function()
					require("neotest").summary.toggle()
				end,
				desc = "Toggle Summary",
			},
			{
				"<leader>to",
				function()
					require("neotest").output.open({ enter = true, auto_close = true })
				end,
				desc = "Show Output",
			},
			{
				"<leader>tO",
				function()
					require("neotest").output_panel.toggle()
				end,
				desc = "Toggle Output Panel",
			},
			{
				"<leader>tS",
				function()
					require("neotest").run.stop()
				end,
				desc = "Stop",
			},
		},
	},

	-- neo-tree.nvim (https://github.com/nvim-neo-tree/neo-tree.nvim)
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
			-- TODO: Hide file icons
			close_if_last_window = true,
			default_component_configs = {
				icon = {
					folder_closed = "▶︎",
					folder_open = "▼",
					folder_empty = "▽",
				},
				modified = {
					symbol = "●",
				},
				git_status = {
					symbols = {
						added = icons.git.added,
						deleted = icons.git.removed,
						modified = icons.git.modified,
						renamed = "",
						-- Status type
						untracked = "",
						ignored = "",
						unstaged = "",
						staged = "",
						conflict = "",
					},
				},
			},
			buffers = {
				follow_current_file = true,
				group_empty_dirs = true,
			},
			filesystem = {
				components = {
					icon = function(config, node, state)
						if node.type == "file" then
							return {}
						end
						return require("neo-tree.sources.common.components").icon(config, node, state)
					end,
				},
				filtered_items = {
					hide_dotfiles = false,
				},
				follow_current_file = true,
				hijack_netrw_behavior = "open_current",
			},
			window = {
				position = "left",
				width = 30,
			},
		},
	},

	-- noice.nvim (https://github.com/folke/noice.nvim)
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			cmdline = {
				format = {
					cmdline = { icon = "❯" },
					search_down = { icon = " " },
					search_up = { icon = " " },
				},
			},
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				progress = { enabled = false },
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = true,
				lsp_doc_border = false,
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
							{ find = "%d fewer lines" },
							{ find = "%d more lines" },
						},
					},
					opts = { skip = true },
				},
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			-- "rcarriga/nvim-notify",
		},
	},

	-- nvim-cmp (https://github.com/hrsh7th/nvim-cmp)
	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy",
		dependencies = {
			-- https://github.com/hrsh7th/cmp-nvim-lsp
			"hrsh7th/cmp-nvim-lsp",
			-- https://github.com/hrsh7th/cmp-buffer
			"hrsh7th/cmp-buffer",
			-- https://github.com/hrsh7th/cmp-path
			"hrsh7th/cmp-path",
			-- https://github.com/saadparwaiz1/cmp_luasnip
			"saadparwaiz1/cmp_luasnip",
			-- https://github.com/zbirenbaum/copilot-cmp
			{
				"zbirenbaum/copilot-cmp",
				dependencies = "copilot.lua",
				opts = {},
				config = function(_, opts)
					local copilot_cmp = require("copilot_cmp")
					copilot_cmp.setup(opts)
					-- attach cmp source whenever copilot attaches
					-- fixes lazy-loading issues with the copilot cmp source
					util.on_attach(function(client)
						if client.name == "copilot" then
							copilot_cmp._on_insert_enter({})
						end
					end)
				end,
			},
		},
		opts = function()
			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local defaults = require("cmp.config.default")()

			return {
				completion = {
					completeopt = "menu,menuone,noinsert",
				},
				experimental = {
					ghost_text = {
						hl_group = "CmpGhostText",
					},
				},
				formatting = {
					format = function(_, item)
						if icons.kinds[item.kind] then
							item.kind = icons.kinds[item.kind] .. item.kind
						end
						return item
					end,
				},
				mapping = {
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping(function()
						if cmp.visible() then
							cmp.close()
						else
							cmp.complete()
						end
					end, { "i", "c" }),
					["<C-e>"] = cmp.mapping.abort(),
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<S-CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				sorting = defaults.sorting,
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "copilot" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
				}),
			}
		end,
	},

	-- nvim-lastplace (https://github.com/ethanholz/nvim-lastplace)
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
		dependencies = {
			-- https://github.com/williamboman/mason.nvim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			-- https://github.com/nvimtools/none-ls.nvim
			"nvimtools/none-ls.nvim",
			-- https://github.com/smjonas/inc-rename.nvim
			"smjonas/inc-rename.nvim",
		},
		config = function()
			require("mason").setup()

			local tools = {
				"codelldb",
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
					"biome",
					"elixirls",
					"lua_ls",
					"rnix",
					"tsserver",
					"volar",
				},
				automatic_installation = true,
			})

			local vue_typescript_plugin = mr.get_package("vue-language-server"):get_install_path()
				.. "/node_modules/@vue/language-server"
				.. "/node_modules/@vue/typescript-plugin"

			local servers = {
				biome = {
					settings = {},
				},
				elixirls = {
					settings = {
						-- https://github.com/elixir-lsp/elixir-ls#elixirls-configuration-settings
						elixirLS = {
							fetchDeps = false,
						},
					},
				},
				lua_ls = {
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
				rnix = {
					settings = {},
				},
				rust_analyzer = {
					settings = {
						["rust-analyzer"] = {
							cargo = {
								allFeatures = true,
								loadOutDirsFromCheck = true,
								runBuildScripts = true,
							},
							-- Add clippy lints for Rust.
							checkOnSave = {
								allFeatures = true,
								command = "clippy",
								extraArgs = { "--no-deps" },
							},
						},
					},
				},
				tsserver = {
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
						"vue",
					},
					init_options = {
						plugins = {
							-- Use typescript language server along with vue typescript plugin
							{
								name = "@vue/typescript-plugin",
								location = vue_typescript_plugin,
								languages = { "javascript", "typescript", "vue" },
							},
						},
					},
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "literal",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				volar = {},
			}

			local signs = icons.diagnostics
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
				require("lspconfig")[server].setup(opts)
			end

			local nls = require("null-ls")
			nls.setup({
				debounce = 150,
				save_after_format = false,
				sources = {
					nls.builtins.diagnostics.fish,
					nls.builtins.formatting.biome,
					nls.builtins.formatting.fish_indent,
					nls.builtins.formatting.stylua,
				},
				on_attach = on_attach,
			})
		end,
	},

	-- nvim-treesitter (https://github.com/nvim-treesitter/nvim-treesitter)
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = {
			-- nvim-ts-autotag (https://github.com/windwp/nvim-ts-autotag)
			{
				"windwp/nvim-ts-autotag",
				opts = {},
			},
		},
		opts = {
			autopairs = { enable = true },
			autotag = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"css",
				"elixir",
				"eex",
				"fish",
				"gitignore",
				"heex",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"nix",
				"regex",
				"rust",
				"toml",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"vue",
			},
			highlight = { enable = true },
			indent = { enable = false },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},

	-- nvim-ufo (https://github.com/kevinhwang91/nvim-ufo)
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
		mappings = {
			["<c-t>"] = function(...)
				return require("trouble.providers.telescope").open_with_trouble(...)
			end,
			["<a-t>"] = function(...)
				return require("trouble.providers.telescope").open_selected_with_trouble(...)
			end,
			["<C-f>"] = function(...)
				return require("telescope.actions").preview_scrolling_down(...)
			end,
			["<C-b>"] = function(...)
				return require("telescope.actions").preview_scrolling_up(...)
			end,
		},
		opts = function()
			local function flash(prompt_bufnr)
				require("flash").jump({
					pattern = "^",
					label = { after = { 0, 0 } },
					search = {
						mode = "search",
						exclude = {
							function(win)
								return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
							end,
						},
					},
					action = function(match)
						local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
						picker:set_selection(match.pos[1] - 1)
					end,
				})
			end

			return {
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
							["<C-s>"] = flash,
						},
						n = { s = flash },
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
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--column",
						"-g",
						"!.git",
						"--hidden",
						"--line-number",
						"--no-heading",
						"--smart-case",
						"--with-filename",
					},
				},
				pickers = {
					find_files = {
						disable_devicons = true,
						find_command = { "rg", "--files", "--hidden", "-g", "!.git" },
						-- find_command = { "fd", "-t", "f", "-H" },
					},
					buffers = {
						ignore_current_buffer = true,
						sort_lastused = true,
					},
				},
			}
		end,
	},

	-- trouble.nvim (https://github.com/folke/trouble.nvim)
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		keys = {
			{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
		},
		opts = { use_diagnostic_signs = true },
	},

	-- twoslash-queries.nvim (https://github.com/marilari88/twoslash-queries.nvim)
	{
		"marilari88/twoslash-queries.nvim",
		opts = {
			multi_line = true,
			highlight = "Type",
		},
		config = function(_, opts)
			local twoslash_queries = require("twoslash-queries")
			twoslash_queries.setup(opts)
			-- attach whenever tsserver attaches
			util.on_attach(function(client, bufnr)
				if client.name == "tsserver" then
					require("twoslash-queries").attach(client, bufnr)
					vim.keymap.set(
						"n",
						"<leader>c//",
						"<cmd>TwoslashQueriesInspect<CR>",
						{ desc = "twoslash inspect variable under the cursor" }
					)
				end
			end)
		end,
	},

	-- vim-illuminate (https://github.com/RRethy/vim-illuminate)
	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			delay = 200,
			filetypes_denylist = {
				"TelescopePrompt",
			},
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

	-- vim-repeat (https://github.com/tpope/vim-repeat)
	{
		"tpope/vim-repeat",
		event = "VeryLazy",
	},

	-- vim-surround (https://github.com/tpope/vim-surround)
	{
		"tpope/vim-surround",
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
				show_keys = false,
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
						name = "+file/find",
						n = { "<cmd>enew<cr>", "New File" },
					},
					g = {
						name = "+git",
						h = { name = "+hunk" },
					},
					s = { name = "+search" },
					t = { name = "+test" },
					u = {
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

	-- rust-tools.nvim (https://github.com/simrat39/rust-tools.nvim)
	{
		"simrat39/rust-tools.nvim",
		lazy = true,
		opts = function()
			return {
				tools = {
					on_initialized = function()
						vim.cmd([[
	           augroup RustLSP
	           autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
	           autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
	           autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
	           augroup END
	           ]])
					end,
				},
			}
		end,
		config = function() end,
	},

	-- copilot.lua (https://github.com/zbirenbaum/copilot.lua)
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
		},
	},

	-- lush.nvim (https://github.com/rktjmp/lush.nvim)
	{
		"rktjmp/lush.nvim",
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
				vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
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

		-- Navigate between splits
		vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
		vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
		vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
		vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

		-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
		vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
		vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
		vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
		vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
		vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
		vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
	end,
})
