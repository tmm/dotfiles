-- nvim-telescope/telescope.nvim (https://github.com/nvim-telescope/telescope.nvim)
local actions = require('telescope.actions')
require('telescope').setup({
  defaults = {
    mappings = {
      i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
    prompt_prefix = '❯ ',
    selection_caret = '→ ',
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
    }
  },
})
