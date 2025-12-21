local icons = require("config").icons

return {
  -- amp.nvim (https://github.com/sourcegraph/amp.nvim)
  {
    "sourcegraph/amp.nvim",
    branch = "main",
    lazy = false,
    opts = { auto_start = true, log_level = "info" },
  },

  -- blink.cmp (https://github.com/saghen/blink.cmp)
  {
    "saghen/blink.cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    version = not vim.g.lazyvim_blink_main and "*",
    build = vim.g.lazyvim_blink_main and "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },
      cmdline = {
        enabled = false,
        keymap = {
          preset = "cmdline",
          ["<Right>"] = false,
          ["<Left>"] = false,
        },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function(_ctx)
              return vim.fn.getcmdtype() == ":"
            end,
          },
          ghost_text = { enabled = true },
        },
      },
      completion = {
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp,
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
      },
      keymap = {
        ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
      },
      snippets = {
        expand = function(snippet, _)
          return require("util.cmp").expand(snippet)
        end,
      },
      -- experimental signature help support
      signature = { enabled = true },
      sources = {
        -- adding any nvim-cmp sources here will enable them
        -- with blink.compat
        compat = {},
        default = { "lsp", "path", "snippets", "buffer" },
      },
    },
    config = function(_, opts)
      -- setup compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- Unset custom prop to pass blink.cmp validation
      opts.sources.compat = nil

      -- check if we need to override symbol kinds
      for _, provider in pairs(opts.sources.providers or {}) do
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          local transform_items = provider.transform_items
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
              item.kind_icon = icons.kinds[item.kind_name] or item.kind_icon or nil
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      opts.appearance.kind_icons = vim.tbl_extend("force", opts.appearance.kind_icons or {}, icons.kinds)

      require("blink.cmp").setup(opts)
    end,
  },

  -- conform.nvim (https://github.com/stevearc/conform.nvim)
  {
    "stevearc/conform.nvim",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    init = function()
      -- Install the conform formatter on VeryLazy
      require("util.init").on_very_lazy(function()
        require("util.format").register({
          name = "conform.nvim",
          priority = 100,
          primary = true,
          format = function(buf)
            require("conform").format({ bufnr = buf })
          end,
          sources = function(buf)
            local ret = require("conform").list_formatters(buf)
            return vim.tbl_map(function(v)
              return v.name
            end, ret)
          end,
        })
      end)
    end,
    opts = function()
      local opts = {
        default_format_opts = {
          timeout_ms = 3000,
          async = false, -- not recommended to change
          quiet = false, -- not recommended to change
          lsp_format = "fallback", -- not recommended to change
        },
        formatters_by_ft = {
          css = { "biome-check" },
          eex = { "mix" },
          elixir = { "mix" },
          fish = { "fish_indent" },
          heex = { "mix" },
          json = { "biome-check" },
          jsonc = { "biome-check" },
          lua = { "stylua" },
          nix = { "nixfmt" },
          sh = { "shfmt" },
          svelte = { "biome-check" },
          typescript = { "biome-check" },
          typescriptreact = { "biome-check" },
          vue = { "biome-check" },
        },
        -- The options you set here will be merged with the builtin formatters.
        -- You can also define any custom formatters here.
        formatters = {
          biome = { require_cwd = true },
          injected = { options = { ignore_errors = true } },
          -- # Example of using dprint only when a dprint.json file is present
          -- dprint = {
          --   condition = function(ctx)
          --     return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          --   end,
          -- },
          --
          -- # Example of using shfmt with extra args
          -- shfmt = {
          --   prepend_args = { "-i", "2", "-ci" },
          -- },
        },
      }
      return opts
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
    },
  },

  -- flash.nvim (https://github.com/folke/flash.nvim)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
		keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  -- grug-far.nvim (https://github.com/MagicDuck/grug-far.nvim)
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    keys = {
      {
        "<leader>sr",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Search and Replace",
      },
    },
    config = function(_, opts)
      require("grug-far").setup(opts)

      -- add highlight group for grug-far
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("grug_far_hl", { clear = true }),
        pattern = { "grug-far" },
        callback = function()
          vim.wo.winhighlight = "Normal:GrugFarNormal"
        end,
      })
    end,
  },

  -- lualine.nvim (https://github.com/nvim-lualine/lualine.nvim)
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        -- set an empty statusline till lualine loads
        vim.o.statusline = " "
      else
        -- hide the statusline on the starter page
        vim.o.laststatus = 0
      end
    end,
    config = function()
      local conditions = {
        buffer_not_empty = function()
          return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
        end,
      }

      require("lualine").setup({
        extensions = { "lazy", "fzf" },
        options = {
          always_divide_middle = true,
          component_separators = "",
          disabled_filetypes = {
            "gitsigns-blame",
          },
          globalstatus = false,
          icons_enabled = true,
          section_separators = "",
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            { "mode", color = "MsgArea" },
            {
              "filename",
              color = "MsgArea",
              cond = conditions.buffer_not_empty,
              symbols = { modified = "", readonly = "", unnamed = "" },
            },
            { "branch", color = "MsgArea", icon = icons.git.Branch },
            {
              "diff",
              color = "MsgArea",
              symbols = {
                added = icons.git.Added,
                modified = icons.git.Modified,
                removed = icons.git.Removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_x = {
            {
              "diagnostics",
              color = "MsgArea",
              sources = { "nvim_diagnostic" },
              symbols = {
                error = icons.diagnostics.Error,
                hint = icons.diagnostics.Hint,
                info = icons.diagnostics.Info,
                warn = icons.diagnostics.Warn,
              },
            },
            {
              require("noice").api.status.search.get,
              cond = require("noice").api.status.search.has,
              color = "MsgArea",
            },
            -- stylua: ignore
            { require("lazy.status").updates, cond = require("lazy.status").has_updates, color = "MsgArea" },
            { "progress", color = "MsgArea" },
            { "location", color = "MsgArea" },
          },
          lualine_y = {},
          lualine_z = {},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            { "filename", color = "StatusLine" },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
      })
    end,
  },

  -- mason.nvim (https://github.com/mason-org/mason.nvim)
  {
    "mason-org/mason.nvim",
    version = "^1.0.0",
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "biome",
        "shfmt",
        "stylua",
        "svelte-language-server",
        "tailwindcss-language-server",
        "vue-language-server",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")

      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  -- mini.nvim (https://github.com/nvim-mini/mini.nvim)
  {
    "nvim-mini/mini.icons",
    event = "VeryLazy",
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
  {
    "nvim-mini/mini.pairs",
    event = "VeryLazy",
    opts = {
      -- TODO: https://github.com/LazyVim/LazyVim/blob/3dbace941ee935c89c73fd774267043d12f57fe2/lua/lazyvim/util/mini.lua#L123
      modes = { insert = true, command = true, terminal = false },
    },
  },
  {
    "nvim-mini/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa", -- Add surrounding in Normal and Visual modes
        delete = "gsd", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "gsr", -- Replace surrounding
      },
    },
  },

  -- noice.nvim (https://github.com/folke/noice.nvim)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    -- stylua: ignore
    keys = {
      { "<leader>sn", "", desc = "+noice"},
      { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
      { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
      { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
      { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
      { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (FzfLua)" },
      { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
      { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
    },
    opts = {
      cmdline = {
        format = {
          cmdline = { icon = icons.misc.PromptPrefix },
          search_down = { icon = " " },
          search_up = { icon = " " },
        },
      },
      lsp = {
        -- override markdown rendering so plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
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
          view = "mini",
          opts = { skip = true },
        },
      },
    },
    config = function(_, opts)
      -- HACK: noice shows messages from before it was enabled,
      -- but this is not ideal when Lazy is installing plugins,
      -- so clear the messages in this case.
      if vim.o.filetype == "lazy" then
        vim.cmd([[messages clear]])
      end
      require("noice").setup(opts)
    end,
  },

  -- nvim-lspconfig (https://github.com/neovim/nvim-lspconfig)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    dependencies = {
      -- https://github.com/mason-org/mason.nvim
      { "mason-org/mason.nvim", version = "^1.0.0" },
      { "mason-org/mason-lspconfig.nvim", version = "^1.0.0", config = function() end },
    },
    opts = function()
      local ret = {
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
              [vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
              [vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
              [vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
            },
          },
        },
        -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the inlay hints.
        inlay_hints = {
          enabled = false,
          exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        -- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
        -- Be aware that you also will need to properly configure your LSP server to
        -- provide the code lenses.
        codelens = {
          enabled = false,
        },
        -- add any global capabilities here
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        -- options for vim.lsp.buf.format
        -- `bufnr` and `filter` is handled by the LazyVim formatter,
        -- but can be also overridden when specified
        format = {
          formatting_options = nil,
          timeout_ms = nil,
        },
        -- LSP Server Settings
        servers = {
          biome = {
            settings = {},
          },
          elixirls = {
            keys = {
              {
                "<leader>cp",
                function()
                  local params = vim.lsp.util.make_position_params()
                  require("util.lsp").execute({
                    command = "manipulatePipes:serverid",
                    arguments = { "toPipe", params.textDocument.uri, params.position.line, params.position.character },
                  })
                end,
                desc = "To Pipe",
              },
              {
                "<leader>cP",
                function()
                  local params = vim.lsp.util.make_position_params()
                  require("util.lsp").execute({
                    command = "manipulatePipes:serverid",
                    arguments = { "fromPipe", params.textDocument.uri, params.position.line, params.position.character },
                  })
                end,
                desc = "From Pipe",
              },
            },
            settings = {
              elixirLS = {
                fetchDeps = false,
              },
            },
          },
          lua_ls = {
            -- mason = false, -- set to false if you don't want this server to be installed with mason
            -- Use this to add any additional keymaps
            -- for specific lsp servers
            -- keys = {},
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
                workspace = {
                  checkThirdParty = false,
                },
                codeLens = {
                  enable = true,
                },
                completion = {
                  callSnippet = "Replace",
                },
                doc = {
                  privateName = { "^_" },
                },
                hint = {
                  enable = true,
                  setType = false,
                  paramType = true,
                  paramName = "Disable",
                  semicolon = "Disable",
                  arrayIndex = "Disable",
                },
              },
            },
          },
          nil_ls = {},
          rust_analyzer = { enabled = false },
          volar = { enabled = false },
          tailwindcss = {
            filetypes_exclude = { "markdown" },
            filetypes_include = {},
          },
          vue_ls = {
            init_options = {
              vue = {
                hybridMode = true,
              },
            },
          },
          vtsls = {
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "svelte",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
              "vue",
            },
            init_options = {},
            settings = {
              complete_function_calls = true,
              vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                  completion = {
                    enableServerSideFuzzyMatch = true,
                  },
                },
                tsserver = {
                  globalPlugins = {
                    {
                      name = "@vue/typescript-plugin",
                      location = require("util.init").get_pkg_path(
                        "vue-language-server",
                        "/node_modules/@vue/language-server"
                      ),
                      languages = { "vue" },
                      configNamespace = "typescript",
                      enableForWorkspaceTypeScriptVersions = true,
                    },
                    {
                      name = "typescript-svelte-plugin",
                      location = require("util.init").get_pkg_path(
                        "svelte-language-server",
                        "/node_modules/typescript-svelte-plugin"
                      ),
                      languages = { "svelte" },
                      enableForWorkspaceTypeScriptVersions = true,
                    },
                  },
                },
              },
              typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
                inlayHints = {
                  enumMemberValues = { enabled = true },
                  functionLikeReturnTypes = { enabled = true },
                  parameterNames = { enabled = "literals" },
                  parameterTypes = { enabled = true },
                  propertyDeclarationTypes = { enabled = true },
                  variableTypes = { enabled = false },
                },
              },
            },
            keys = {
              {
                "gD",
                function()
                  local params = vim.lsp.util.make_position_params()
                  require("util.lsp").execute({
                    command = "typescript.goToSourceDefinition",
                    arguments = { params.textDocument.uri, params.position },
                    open = true,
                  })
                end,
                desc = "Goto Source Definition",
              },
              {
                "gR",
                function()
                  require("util.lsp").execute({
                    command = "typescript.findAllFileReferences",
                    arguments = { vim.uri_from_bufnr(0) },
                    open = true,
                  })
                end,
                desc = "File References",
              },
              -- stylua: ignore
              { "<leader>co", require("util.lsp").action["source.organizeImports"], desc = "Organize Imports" },
              { "<leader>cM", require("util.lsp").action["source.addMissingImports.ts"], desc = "Add missing imports" },
              { "<leader>cu", require("util.lsp").action["source.removeUnused.ts"], desc = "Remove unused imports" },
              { "<leader>cD", require("util.lsp").action["source.fixAll.ts"], desc = "Fix all diagnostics" },
              {
                "<leader>cV",
                function()
                  require("util.lsp").execute({ command = "typescript.selectTypeScriptVersion" })
                end,
                desc = "Select TS workspace version",
              },
              { "<C-\\>", "<cmd>TwoslashQueriesInspect<CR>", desc = "Twoslash Inspect" },
            },
          },
        },
        -- you can do any additional lsp server setup here
        -- return true if you don't want this server to be setup with lspconfig
        setup = {
          -- example to setup with typescript.nvim
          -- ts_ls = function(_, opts)
          --   require("typescript").setup({ server = opts })
          --   return true
          -- end,
          -- Specify * to use this function as a fallback for any server
          -- ["*"] = function(server, opts) end,
          tailwindcss = function(_, opts)
            opts.filetypes = opts.filetypes or {}

            -- Add default filetypes
            local default_config = vim.lsp.config["tailwindcss"]
            if default_config and default_config.filetypes then
              vim.list_extend(opts.filetypes, default_config.filetypes)
            end

            -- Remove excluded filetypes
            --- @param ft string
            opts.filetypes = vim.tbl_filter(function(ft)
              return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
            end, opts.filetypes)

            -- Additional settings for Phoenix projects
            opts.settings = {
              tailwindCSS = {
                includeLanguages = {
                  elixir = "html-eex",
                  eelixir = "html-eex",
                  heex = "html-eex",
                },
              },
            }

            -- Add additional filetypes
            vim.list_extend(opts.filetypes, opts.filetypes_include or {})
          end,
          vtsls = function(_, opts)
            require("util.lsp").on_attach(function(client, _buf)
              client.commands["_typescript.moveToFileRefactoring"] = function(command, _ctx)
                ---@diagnostic disable-next-line: deprecated
                local action, uri, range = unpack(command.arguments)

                local function move(newf)
                  client:request("workspace/executeCommand", {
                    command = command.command,
                    arguments = { action, uri, range, newf },
                  })
                end

                local fname = vim.uri_to_fname(uri)
                client:request("workspace/executeCommand", {
                  command = "typescript.tsserverRequest",
                  arguments = {
                    "getMoveToRefactoringFileSuggestions",
                    {
                      file = fname,
                      startLine = range.start.line + 1,
                      startOffset = range.start.character + 1,
                      endLine = range["end"].line + 1,
                      endOffset = range["end"].character + 1,
                    },
                  },
                }, function(_, result)
                  ---@type string[]
                  local files = result.body.files
                  table.insert(files, 1, "Enter new path...")
                  vim.ui.select(files, {
                    prompt = "Select move destination:",
                    format_item = function(f)
                      return vim.fn.fnamemodify(f, ":~:.")
                    end,
                  }, function(f)
                    if f and f:find("^Enter new path") then
                      vim.ui.input({
                        prompt = "Enter move destination:",
                        default = vim.fn.fnamemodify(fname, ":h") .. "/",
                        completion = "file",
                      }, function(newf)
                        return newf and move(newf)
                      end)
                    elseif f then
                      move(f)
                    end
                  end)
                end)
              end
            end, "vtsls")
            -- copy typescript settings to javascript
            opts.settings.javascript =
              vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
          end,
        },
      }
      return ret
    end,
    config = function(_, opts)
      local lsp = require("util.lsp")
      -- setup autoformat
      require("util.format").register(lsp.formatter())

      -- setup keymaps
      lsp.on_attach(function(client, buffer)
        require("util.keymaps").on_attach(client, buffer)
      end)

      lsp.setup()
      lsp.on_dynamic_capability(require("util.keymaps").on_attach)

      -- diagnostics signs
      if vim.fn.has("nvim-0.10.0") == 0 then
        if type(opts.diagnostics.signs) ~= "boolean" then
          for severity, icon in pairs(opts.diagnostics.signs.text) do
            local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
            name = "DiagnosticSign" .. name
            vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
          end
        end
      end

      -- inlay hints
      if opts.inlay_hints.enabled then
        lsp.on_supports_method("textDocument/inlayHint", function(_, buffer)
          if
            vim.api.nvim_buf_is_valid(buffer)
            and vim.bo[buffer].buftype == ""
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
          end
        end)
      end

      -- code lens
      if opts.codelens.enabled and vim.lsp.codelens then
        lsp.on_supports_method("textDocument/codeLens", function(_, buffer)
          vim.lsp.codelens.refresh()
          vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
            buffer = buffer,
            callback = vim.lsp.codelens.refresh,
          })
        end)
      end

      if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
        opts.diagnostics.virtual_text.prefix = function(diagnostic)
          for d, icon in pairs(icons.diagnostics) do
            if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
              return icon
            end
          end
        end
      end

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      local servers = opts.servers
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end

      -- get all the servers that are available through mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
            if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
              setup(server)
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          end
        end
      end

      if have_mason then
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            require("util.init").opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        })
      end
    end,
  },

  -- nvim-treesitter (https://github.com/nvim-treesitter/nvim-treesitter)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "VeryLazy" },
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline
    dependencies = {
      -- https://github.com/windwp/nvim-ts-autotag
      { "windwp/nvim-ts-autotag", opts = {} },
    },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treesitter** module to be loaded in time.
      -- Luckily, the only things that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    keys = {
      { "<c-space>", desc = "Increment Selection" },
      { "<bs>", desc = "Decrement Selection", mode = "x" },
    },
    opts = {
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
        "ron",
        "svelte",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "vue",
        "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        -- stylua: ignore
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
  },

  -- nvim-treesitter-context (https://github.com/nvim-treesitter/nvim-treesitter-context)
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = function()
      local tsc = require("treesitter-context")
      require("snacks")
        .toggle({
          name = "Treesitter Context",
          get = tsc.enabled,
          set = function(state)
            if state then
              tsc.enable()
            else
              tsc.disable()
            end
          end,
        })
        :map("<leader>ut")
      return {
        max_lines = 3,
        mode = "cursor",
        multiwindow = true,
      }
    end,
    keys = {
      {
        "[c",
        function()
          require("treesitter-context").go_to_context(vim.v.count1)
        end,
        desc = "Jump to context",
      },
    },
  },

  -- oil.nvim (https://github.com/stevearc/oil.nvim)
  {
    "stevearc/oil.nvim",
    lazy = false,
    dependencies = { { "nvim-mini/mini.icons", opts = {} } },
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "Explorer Oil", remap = true },
    },
    opts = {
      keymaps = {
        ["<C-h>"] = false,
        ["<C-l>"] = false,
        ["<C-r>"] = "actions.refresh",
        ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
      },
    },
    config = function(_, opts)
      -- helper function to parse output
      local function parse_output(proc)
        local result = proc:wait()
        local ret = {}
        if result.code == 0 then
          for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
            -- Remove trailing slash
            line = line:gsub("/$", "")
            ret[line] = true
          end
        end
        return ret
      end

      -- build git status cache
      local function new_git_status()
        return setmetatable({}, {
          __index = function(self, key)
            local ignore_proc = vim.system(
              { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
              {
                cwd = key,
                text = true,
              }
            )
            local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
              cwd = key,
              text = true,
            })
            local ret = {
              ignored = parse_output(ignore_proc),
              tracked = parse_output(tracked_proc),
            }
            rawset(self, key, ret)
            return ret
          end,
        })
      end
      local git_status = new_git_status()

      -- Clear git status cache on refresh
      local refresh = require("oil.actions").refresh
      local orig_refresh = refresh.callback
      refresh.callback = function(...)
        git_status = new_git_status()
        orig_refresh(...)
      end

      opts.view_options = {
        is_hidden_file = function(name, bufnr)
          local dir = require("oil").get_current_dir(bufnr)
          local is_dotfile = vim.startswith(name, ".") and name ~= ".."
          -- if no local directory (e.g. for ssh connections), just hide dotfiles
          if not dir then
            return is_dotfile
          end
          -- dotfiles are considered hidden unless tracked
          if is_dotfile then
            return not git_status[dir].tracked[name]
          else
            -- Check if file is gitignored
            return git_status[dir].ignored[name]
          end
        end,
      }

      require("oil").setup(opts)
    end,
  },

  -- rustaceanvim (https://github.com/mrcjkb/rustaceanvim)
  {
    "mrcjkb/rustaceanvim",
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = {
                enable = true,
              },
            },
            checkOnSave = true,
            diagnostics = {
              enable = true,
            },
            procMacro = {
              enable = true,
            },
            files = {
              exclude = {
                ".direnv",
                ".git",
                ".jj",
                ".github",
                ".gitlab",
                "bin",
                "node_modules",
                "target",
                "venv",
                ".venv",
              },
              -- Avoid Roots Scanned hanging, see https://github.com/rust-lang/rust-analyzer/issues/12613#issuecomment-2096386344
              watcher = "client",
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- if LazyVim.has("mason.nvim") then
      --   local codelldb = vim.fn.exepath("codelldb")
      --   local codelldb_lib_ext = io.popen("uname"):read("*l") == "Linux" and ".so" or ".dylib"
      --   local library_path = vim.fn.expand("$MASON/opt/lldb/lib/liblldb" .. codelldb_lib_ext)
      --   opts.dap = {
      --     adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb, library_path),
      --   }
      -- end
      vim.g.rustaceanvim = vim.tbl_deep_extend("keep", vim.g.rustaceanvim or {}, opts or {})
      if vim.fn.executable("rust-analyzer") == 0 then
        require("util.init").error(
          "**rust-analyzer** not found in PATH, please install it.\nhttps://rust-analyzer.github.io/",
          { title = "rustaceanvim" }
        )
      end
    end,
  },

  -- snacks.nvim (https://github.com/folke/snacks.nvim)
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1001,
    opts = {
      bigfile = { enabled = true },
      dim = {
        animate = { enabled = false },
      },
      indent = {
        enabled = true,
        animate = { enabled = false },
      },
      input = { enabled = true },
      notifier = {
        enabled = true,
        icons = {
          error = icons.diagnostics.Error,
          warn = icons.diagnostics.Warn,
          info = icons.diagnostics.Info,
          debug = icons.misc.Bug,
          trace = " ",
        },
      },
      picker = {
        actions = {
          flash = function(picker)
            require("flash").jump({
              pattern = "^",
              label = { after = { 0, 0 } },
              search = {
                mode = "search",
                exclude = {
                  function(win)
                    return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                  end,
                },
              },
              action = function(match)
                local idx = picker.list:row2idx(match.pos[1])
                picker.list:_move(idx, true, true)
              end,
            })
          end,
          toggle_cwd = function(p)
            local root = require("util.root").get({ buf = p.input.filter.current_buf, normalize = true })
            local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or ".")
            local current = p:cwd()
            p:set_cwd(current == root and cwd or root)
            p:find()
          end,
          trouble_open = function(...)
            return require("trouble.sources.snacks").actions.trouble_open.action(...)
          end,
        },
        formatters = {
          file = {
            truncate = 80,
          },
        },
        win = {
          input = {
            keys = {
              ["s"] = { "flash" },
              ["<a-c>"] = { "toggle_cwd", mode = { "n", "i" } },
              ["<a-s>"] = { "flash", mode = { "n", "i" } },
              ["<a-t>"] = { "trouble_open", mode = { "n", "i" } },
            },
          },
        },
      },
      quickfile = { enabled = true },
      scope = { enabled = true },
      toggle = {
        enabled = true,
        map = require("util.init").safe_keymap_set,
        notify = true,
        which_key = true,
      },
      words = { enabled = true },
    },
    keys = function()
      local snacks = require("snacks")
      local pick = require("util.pick")

      -- stylua: ignore
      return {
        { "<leader>un", function() snacks.notifier.hide() end, desc = "Dismiss All Notifications" },

        { "<leader>,", function() snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>/", pick.open("grep"), desc = "Grep (Root Dir)" },
        { "<leader>:", function() snacks.picker.command_history() end, desc = "Command History" },
        { "<leader><space>", pick.open("files"), desc = "Find Files (Root Dir)" },
        { "<leader>n", function() snacks.picker.notifications() end, desc = "Notification History" },
        -- find
        { "<leader>fb", function() snacks.picker.buffers() end, desc = "Buffers" },
        { "<leader>fB", function() snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
        { "<leader>fc", pick.config_files(), desc = "Find Config File" },
        { "<leader>ff", pick.open("files"), desc = "Find Files (Root Dir)" },
        { "<leader>fF", pick.open("files", { root = false }), desc = "Find Files (cwd)" },
        { "<leader>fg", function() snacks.picker.git_files() end, desc = "Find Files (git-files)" },
        { "<leader>fr", pick.open("recent"), desc = "Recent" },
        { "<leader>fR", function() snacks.picker.recent({ filter = { cwd = true }}) end, desc = "Recent (cwd)" },
        { "<leader>fp", function() snacks.picker.projects() end, desc = "Projects" },
        -- git
        { "<leader>gd", function() snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
        { "<leader>gs", function() snacks.picker.git_status() end, desc = "Git Status" },
        { "<leader>gS", function() snacks.picker.git_stash() end, desc = "Git Stash" },
        -- Grep
        { "<leader>sb", function() snacks.picker.lines() end, desc = "Buffer Lines" },
        { "<leader>sB", function() snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
        { "<leader>sg", pick.open("grep"), desc = "Grep (Root Dir)" },
        { "<leader>sG", pick.open("grep", { root = false }), desc = "Grep (cwd)" },
        { "<leader>sp", function() snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
        { "<leader>sw", pick.open("grep_word"), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
        { "<leader>sW", pick.open("grep_word", { root = false }), desc = "Visual selection or word (cwd)", mode = { "n", "x" } },
        -- search
        { '<leader>s"', function() snacks.picker.registers() end, desc = "Registers" },
        { '<leader>s/', function() snacks.picker.search_history() end, desc = "Search History" },
        { "<leader>sa", function() snacks.picker.autocmds() end, desc = "Autocmds" },
        { "<leader>sc", function() snacks.picker.command_history() end, desc = "Command History" },
        { "<leader>sC", function() snacks.picker.commands() end, desc = "Commands" },
        { "<leader>sd", function() snacks.picker.diagnostics() end, desc = "Diagnostics" },
        { "<leader>sD", function() snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
        { "<leader>sh", function() snacks.picker.help() end, desc = "Help Pages" },
        { "<leader>sH", function() snacks.picker.highlights() end, desc = "Highlights" },
        { "<leader>si", function() snacks.picker.icons() end, desc = "Icons" },
        { "<leader>sj", function() snacks.picker.jumps() end, desc = "Jumps" },
        { "<leader>sk", function() snacks.picker.keymaps() end, desc = "Keymaps" },
        { "<leader>sl", function() snacks.picker.loclist() end, desc = "Location List" },
        { "<leader>sM", function() snacks.picker.man() end, desc = "Man Pages" },
        { "<leader>sm", function() snacks.picker.marks() end, desc = "Marks" },
        { "<leader>sR", function() snacks.picker.resume() end, desc = "Resume" },
        { "<leader>sq", function() snacks.picker.qflist() end, desc = "Quickfix List" },
        { "<leader>su", function() snacks.picker.undo() end, desc = "Undotree" },
        -- ui
        { "<leader>uC", function() snacks.picker.colorschemes() end, desc = "Colorschemes" },
      }
    end,
    config = function(_, opts)
      local notify = vim.notify
      require("snacks").setup(opts)
      -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
      -- this is needed to have early notifications show up in noice history
      if require("util.init").has("noice.nvim") then
        vim.notify = notify
      end
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

  -- ts-comments.nvim (https://github.com/folke/ts-comments.nvim)
  {
    "folke/ts-comments.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- twoslash-queries.nvim (https://github.com/marilari88/twoslash-queries.nvim)
  {
    "marilari88/twoslash-queries.nvim",
    opts = {
      highlight = "Type",
      multi_line = true,
    },
    config = function(_, opts)
      local twoslash_queries = require("twoslash-queries")
      twoslash_queries.setup(opts)
      require("util.lsp").on_attach(function(client, bufnr)
        require("twoslash-queries").attach(client, bufnr)
      end, "vtsls")
    end,
  },

  -- vim-repeat (https://github.com/tpope/vim-repeat)
  {
    "tpope/vim-repeat",
    event = "VeryLazy",
  },

  -- which-key.nvim (https://github.com/folke/which-key.nvim)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      defaults = {},
      icons = {
        -- mappings = false,
        colors = true,
        rules = false,
      },
      preset = "helix",
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui" },
          { "<leader>x", group = "diagnostics/quickfix" },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps (which-key)",
      },
      {
        "<c-w><space>",
        function()
          require("which-key").show({ keys = "<c-w>", loop = true })
        end,
        desc = "Window Hydra Mode (which-key)",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
    end,
  },

  -- rsms (https://github.com/tmm/rsms)
  {
    "tmm/rsms",
    dev = true,
    dependencies = { "rktjmp/lush.nvim" },
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme rsms]])
    end,
  },
}
