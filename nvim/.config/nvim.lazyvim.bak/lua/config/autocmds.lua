-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Auto-import notebook outputs when opening .ipynb files
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.ipynb",
  callback = function()
    vim.schedule(function()
      if vim.fn.exists(":MoltenImportOutput") > 0 then
        vim.cmd("MoltenImportOutput")
      end
    end)
  end,
})

-- Auto-export notebook outputs when writing .ipynb files
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = "*.ipynb",
  callback = function()
    if vim.fn.exists(":MoltenExportOutput") > 0 then
      vim.cmd("MoltenExportOutput!")
    end
  end,
})

-- Set up proper syntax highlighting for jupyter notebooks
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.ipynb",
  callback = function()
    vim.bo.filetype = "python"
  end,
})

-- Highlight jupyter cell delimiters
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "markdown" },
  callback = function()
    vim.cmd([[
      syntax match JupyterCellDelimiter /^# %%.*$/
      highlight JupyterCellDelimiter ctermfg=blue guifg=#61afef cterm=bold gui=bold
    ]])
  end,
})
