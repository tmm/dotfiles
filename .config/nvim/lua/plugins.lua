local icons = require("config.icons")

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
return {
	{
		dir = "~/Developer/rsms",
		lazy = false,
		priority = 1000,
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
		opts = {
			current_line_blame_opts = { delay = 500 },
			on_attach = function(buffer)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview Hunk Inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame Line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame Buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
			end,
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				changedelete = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				untracked = { text = "▎" },
			},
			signs_staged = {
				add = { text = "▎" },
				change = { text = "▎" },
				changedelete = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
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
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
		config = function()
			-- Replace with builtin commenting
			-- https://gpanders.com/blog/whats-new-in-neovim-0.10/#builtin-commenting
			-- https://github.com/folke/ts-comments.nvim
			require("mini.comment").setup({
				options = {
					custom_commentstring = function()
						return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
					end,
				},
			})
			require("mini.indentscope").setup({
				draw = {
					animation = require("mini.indentscope").gen_animation.none(),
				},
				symbol = "",
			})
			require("mini.pairs").setup({})
		end,
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

	-- neo-tree.nvim (https://github.com/nvim-neo-tree/neo-tree.nvim)
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		keys = {
			{
				"<leader>fe",
				function()
					require("neo-tree.command").execute({ toggle = true })
				end,
				desc = "Explorer NeoTree (Root Dir)",
			},
			{
				"<leader>fE",
				function()
					require("neo-tree.command").execute({ reveal = true })
				end,
				desc = "Explorer NeoTree (Reveal File)",
			},
			{ "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
			{ "<leader>E", "<leader>fE", desc = "Explorer NeoTree (Reveal File)", remap = true },
		},
		deactivate = function()
			vim.cmd([[Neotree close]])
		end,
		init = function()
			-- FIX: use `autocmd` for lazy-loading neo-tree instead of directly requiring it,
			-- because `cwd` is not set up properly.
			vim.api.nvim_create_autocmd("BufEnter", {
				group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
				desc = "Start Neo-tree with directory",
				once = true,
				callback = function()
					if package.loaded["neo-tree"] then
						return
					else
						local stats = vim.uv.fs_stat(vim.fn.argv(0))
						if stats and stats.type == "directory" then
							require("neo-tree")
						end
					end
				end,
			})
		end,
		opts = {
			buffers = {
				follow_current_file = {
					enabled = true,
				},
				group_empty_dirs = true,
			},
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
			filesystem = {
				components = {
					icon = function(config, node, state)
						-- Disable file icons
						if node.type == "file" then
							return {}
						end
						return require("neo-tree.sources.common.components").icon(config, node, state)
					end,
				},
				filtered_items = {
					hide_dotfiles = false,
					hide_by_name = {
						".CFUserTextEncoding",
						".manpath",
					},
					never_show = {
						".DS_Store",
					},
				},
				follow_current_file = { enabled = true },
				use_libuv_file_watcher = true,
			},
			open_files_do_not_replace_types = { "terminal", "Trouble", "trouble", "qf", "Outline" },
			window = {
				mappings = {
					["O"] = {
						function(state)
							require("lazy.util").open(state.tree:get_node().path, { system = true })
						end,
						desc = "Open with System Application",
					},
					["P"] = { "toggle_preview", config = { use_float = false } },
					["Y"] = {
						function(state)
							local node = state.tree:get_node()
							local path = node:get_id()
							vim.fn.setreg("+", path, "c")
						end,
						desc = "Copy Path to Clipboard",
					},
				},
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
						else
							fallback()
						end
					end, {
						"i",
						"s",
					}),
				},
				sorting = defaults.sorting,
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "copilot" },
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
		cmd = { "Trouble" },
		opts = {
			modes = {
				lsp = {
					win = { position = "right" },
				},
			},
		},
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbols (Trouble)" },
			{ "<leader>cS", "<cmd>Trouble lsp toggle<cr>", desc = "LSP references/definitions/... (Trouble)" },
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
			{
				"[q",
				function()
					if require("trouble").is_open() then
						require("trouble").prev({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cprev)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Previous Trouble/Quickfix Item",
			},
			{
				"]q",
				function()
					if require("trouble").is_open() then
						require("trouble").next({ skip_groups = true, jump = true })
					else
						local ok, err = pcall(vim.cmd.cnext)
						if not ok then
							vim.notify(err, vim.log.levels.ERROR)
						end
					end
				end,
				desc = "Next Trouble/Quickfix Item",
			},
		},
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
}
