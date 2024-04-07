local options = {
  ensure_installed = { "lua", "vim", "vimdoc" },

  highlight = {
    enable = true,
    use_languagetree = true,
    disable = { "devicetree" }
  },

  indent = { enable = true },
}

return options
