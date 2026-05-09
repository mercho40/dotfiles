return {
  'epwalsh/obsidian.nvim',
  version = '*',
  lazy = true,
  ft = 'markdown',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    workspaces = {
      {
        name = 'thevault',
        path = '/Users/simon/Library/Mobile Documents/iCloud~md~obsidian/Documents/thevault',
      },
    },
  },
}
