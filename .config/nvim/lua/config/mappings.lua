local wk = require("which-key")
local util = require("util")

vim.o.timeoutlen = 300

wk.setup({
	key_labels = { ["<leader>"] = "SPC" },
	plugins = { spelling = true },
	show_help = false,
	triggers = "auto",
})

local opts = { noremap = true, silent = true }
vim.g.mapleader = " "

----------------------------------------------------
-- General
----------------------------------------------------

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

----------------------------------------------------
-- Leader
----------------------------------------------------

local leader = {
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
		f = { "<cmd>Telescope find_files<cr>", "Find File" },
		n = { "<cmd>enew<cr>", "New File" },
		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
		t = { "<cmd>Neotree toggle<cr>", "Open Explorer" },
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
		p = {
			name = "+packer",
			p = { "<cmd>PackerSync<cr>", "Sync" },
			s = { "<cmd>PackerStatus<cr>", "Status" },
			i = { "<cmd>PackerInstall<cr>", "Install" },
			c = { "<cmd>PackerCompile<cr>", "Compile" },
		},
	},
	o = {
		name = "+open",
		g = { "<cmd>Glow<cr>", "Markdown Glow" },
	},
	p = {
		name = "+project",
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
			require("plugins.lsp.formatting").toggle,
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
}
wk.register(leader, { prefix = "<leader>" })

----------------------------------------------------
-- Plugins
----------------------------------------------------

-- christoomey/vim-tmux-runner (https://github.com/christoomey/vim-tmux-runner)
-- vim.keymap.set('n', '<Leader>va', ':VtrAttachToPane<Space>', opts)
-- vim.keymap.set('n', '<Leader>vc', ':VtrSendCtrlC<CR>', opts)
-- vim.keymap.set('n', '<Leader>vf', ':VtrFocusRunner!<CR>', opts)
-- vim.keymap.set('n', '<Leader>vk', ':VtrKillRunner<CR>', opts)
-- vim.keymap.set('n', '<Leader>vo', ':VtrOpenRunner<CR>', opts)
-- vim.keymap.set('n', '<Leader>vv', ':VtrSendCommandToRunner<Space>', opts)

-- -- junegunn/vim-easy-align (https://github.com/junegunn/vim-easy-align)
-- vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)', opts)
-- vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', opts)

-- kyazdani42/nvim-tree.lua (https://github.com/kyazdani42/nvim-tree.lua)
-- vim.keymap.set('n', '<Leader>e', ':NvimTreeToggle<CR>', opts)
-- vim.keymap.set('n', '<Leader>f', ':NvimTreeFindFile<CR>', opts)
