-- Super fast git decorations implemented purely in Lua.
-- https://github.com/lewis6991/gitsigns.nvim

return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = {text = '+'},
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },nge = {text = ''},
    }
  }
}
