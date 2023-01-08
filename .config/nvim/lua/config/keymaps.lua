vim.o.timeoutlen = 300

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
