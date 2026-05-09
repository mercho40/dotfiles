return {
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    dependencies = { "3rd/image.nvim" },
    build = ":UpdateRemotePlugins",
    init = function()
      vim.g.molten_image_provider = "image.nvim"
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    keys = {
      { "<leader>mi", ":MoltenInit<CR>", desc = "Initialize Molten" },
      { "<leader>me", ":MoltenEvaluateOperator<CR>", desc = "Evaluate Operator", mode = "n" },
      { "<leader>ml", ":MoltenEvaluateLine<CR>", desc = "Evaluate Line" },
      { "<leader>mr", ":MoltenReevaluateCell<CR>", desc = "Re-evaluate Cell" },
      { "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", desc = "Evaluate Visual", mode = "v" },
      { "<leader>md", ":MoltenDelete<CR>", desc = "Delete Molten Cell" },
      { "<leader>mo", ":MoltenShowOutput<CR>", desc = "Show Output" },
      { "<leader>mh", ":MoltenHideOutput<CR>", desc = "Hide Output" },
      { "<leader>ms", ":MoltenSave<CR>", desc = "Save Molten" },
      { "<leader>ml", ":MoltenLoad<CR>", desc = "Load Molten" },
      { "<leader>mq", ":MoltenDeinit<CR>", desc = "Deinitialize Molten" },
    },
    ft = { "python", "jupyter" },
  },
  {
    "GCBallesteros/jupytext.nvim",
    config = function()
      require("jupytext").setup({
        style = "percent",
        output_extension = "py",
        force_ft = "python",
        custom_language_formatting = {
          python = {
            extension = "py",
            style = "percent",
            force_ft = "python",
          },
        },
      })
    end,
    ft = { "ipynb" },
  },
  {
    "quarto-dev/quarto-nvim",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("quarto").setup({
        lspFeatures = {
          enabled = true,
          languages = { "python", "bash", "html" },
          chunks = "curly",
          diagnostics = {
            enabled = true,
            triggers = { "BufWritePost" },
          },
          completion = {
            enabled = true,
          },
        },
        codeRunner = {
          enabled = true,
          default_method = "molten",
        },
      })
    end,
    ft = { "quarto", "markdown" },
  },
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty",
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "markdown", "vimwiki" },
        },
        neorg = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
          filetypes = { "norg" },
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
      window_overlap_clear_enabled = false,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
      editor_only_render_when_focused = false,
      tmux_show_only_in_active_window = false,
      hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
    },
    ft = { "markdown", "vimwiki", "python", "jupyter" },
  },
}