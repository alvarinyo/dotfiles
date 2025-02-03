local trouble = require("trouble.sources.telescope")
local lga_actions = require("telescope-live-grep-args.actions")

local options = {
  pickers = {
    find_files = {
      -- hidden = true,
      find_command = {
        "ag",
        "--hidden",
        "-g",
        ".",
        "--ignore",
        ".git",
        "--ignore",
        "external",
        "--ignore",
        "env",
      },
    },
  },
  defaults = {
    vimgrep_arguments = {
      "ag",
      "--follow",
      "--nocolor",
      "--noheading",
      "--filename",
      "--numbers",
      "--column",
      "--smart-case",
      "--hidden",
      "--silent",
      "--vimgrep",
      -- "-l",
      "--ignore=.git",
      "--ignore",
      "external",
      "--ignore",
      "env",
      "--ignore",
      "*.svg"
    },
    -- vimgrep_arguments = {
      -- "rg",
      -- "--follow",
      -- "--color=never",
      -- "--no-heading",
      -- "--with-filename",
      -- "--line-number",
      -- "--column",
      -- "--smart-case",
      -- "--hidden",
      -- "-g",
      -- "!.git"
    -- },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      vertical = {
        mirror = false,
      },
      width = 0.87,
      height = 0.80,
      preview_cutoff = 120,
    },
    file_sorter = require("telescope.sorters").get_fuzzy_file,
    file_ignore_patterns = { "node_modules" },
    generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
    path_display = { "truncate" },
    winblend = 0,
    border = {},
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    color_devicons = true,
    set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
    -- file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    -- grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    -- qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    -- -- Developer configurations: Not meant for general override
    -- buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
    mappings = {
      n = { ["q"] = require("telescope.actions").close,
            ["<c-t>"] = trouble.open
      },
      i = { ["<c-t>"] = trouble.open},
    },
  },

  extensions_list = { "themes", "terms", "fzf", "live_grep_args" },
  extensions = {
    live_grep_args =
    {
      -- auto_quoting = true, -- enable/disable auto-quoting
      -- define mappings, e.g.
      mappings = { -- extend mappings
        i = {
          ["<C-k>"] = lga_actions.quote_prompt(),
          ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
        },
      },
      -- ... also accepts theme settings, for example:
      -- theme = "dropdown", -- use dropdown theme
      -- theme = { }, -- use own theme spec
      -- layout_config = { mirror=true }, -- mirror preview pane
    }
  }
}

return options
