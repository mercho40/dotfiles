-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>")
vim.keymap.set("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>")
vim.keymap.set("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>")
vim.keymap.set("n", "<c-f>", "<cmd>:silent  !tmux neww tmux-sessionizer<cr>")
-- vim.keymap.set("n", "<leader>x", "<cmd>:!chmod +x %<cr>")
-- vim.keymap.set("n", "<leader>co", "<cmd>:!g++ -DEVAL -std=gnu++11 -O2 -pipe -o %:r %:t<cr>", {
--   noremap = true, -- Recommended for most mappings
--   silent = false, -- Optional: Set to false if you want to see the command echoed
--   desc = "Compile current C++ file using 'comp' script",
-- })

-- Common compile command string
local compile_command_template = "g++ -DEVAL -std=gnu++11 -O2 -pipe -o %s %s"

-- Compile Only (<leader>co)
vim.keymap.set("n", "<leader>co", function()
  local source_file = vim.fn.expand("%:t")
  local output_file = vim.fn.expand("%:r")
  if source_file == "" or output_file == "" then
    vim.notify("Error: No file name to compile.", vim.log.levels.ERROR)
    return
  end

  -- Construct the full g++ command
  local cmd = string.format(compile_command_template, output_file, source_file)

  vim.notify("Compiling: " .. cmd, vim.log.levels.INFO)
  vim.cmd("silent !" .. cmd) -- Execute the g++ command

  if vim.v.shell_error ~= 0 then
    vim.notify("Compilation FAILED! Exit code: " .. vim.v.shell_error, vim.log.levels.ERROR)
  else
    vim.notify("Compilation successful! Output: ./" .. output_file, vim.log.levels.INFO)
  end
end, {
  noremap = true,
  silent = true,
  desc = "Compile current C++ file (g++ ... -o %:r %:t)",
})

-- Run Only (<leader>r using terminal)
vim.keymap.set("n", "<leader>rp", function()
  local executable = vim.fn.expand("%:r")
  if executable == "" then
    vim.notify("Error: No file name to run.", vim.log.levels.ERROR)
    return
  end
  local executable_path = "./" .. executable
  if vim.fn.filereadable(executable_path) == 0 then
    vim.notify("Error: Executable '" .. executable_path .. "' not found.", vim.log.levels.ERROR)
    return
  end
  if vim.fn.executable(executable_path) == 0 then
    vim.notify("Error: File '" .. executable_path .. "' is not executable. Use <leader>x?", vim.log.levels.ERROR)
    return
  end
  vim.notify("Running '" .. executable_path .. "' in terminal", vim.log.levels.INFO)
  vim.cmd(string.format("term %s", executable_path))
end, {
  noremap = true,
  silent = true,
  desc = "Run compiled executable in terminal (./%:r)",
})

-- Make Executable (<leader>x)
vim.keymap.set("n", "<leader>x", "<cmd>:!chmod +x %<cr>", {
  noremap = true,
  silent = true, -- Consider silent = false to see chmod output/errors
  desc = "Make current file executable",
})

-- Run Make and Execute (<leader>cm)
vim.keymap.set("n", "<leader>cm", function()
  -- 1. Run make
  vim.notify("Running make...", vim.log.levels.INFO)
  vim.cmd("silent !make")

  -- 2. Check make result
  if vim.v.shell_error ~= 0 then
    vim.notify("Make FAILED! Exit code: " .. vim.v.shell_error, vim.log.levels.ERROR)
    return -- Stop if make failed
  else
    vim.notify("Make completed successfully!", vim.log.levels.INFO)
  end

  -- 3. Determine executable name (same as current file without extension)
  local output_file = vim.fn.expand("%:r")
  if output_file == "" then
    vim.notify("Error: No file name to determine executable.", vim.log.levels.ERROR)
    return
  end

  local executable_path = "./" .. output_file

  -- 4. Check if the executable exists and is executable
  if vim.fn.filereadable(executable_path) == 0 then
    vim.notify("Error: Executable '" .. executable_path .. "' not found (after successful make).", vim.log.levels.ERROR)
    return
  end
  if vim.fn.executable(executable_path) == 0 then
    vim.notify("Error: File '" .. executable_path .. "' is not executable. Use <leader>x first?", vim.log.levels.ERROR)
    return
  end

  -- 5. Execute the program in a terminal window
  vim.notify("Running '" .. executable_path .. "' in terminal...", vim.log.levels.INFO)
  vim.cmd(string.format("term %s", executable_path))
end, {
  noremap = true,
  silent = true,
  desc = "Run make & execute ./%:r in terminal",
})

-- Compile and Run (<leader>cx)
vim.keymap.set("n", "<leader>cx", function()
  -- 1. Get filenames
  local source_file = vim.fn.expand("%:t")
  local output_file = vim.fn.expand("%:r")

  -- Validate filenames
  if source_file == "" or output_file == "" then
    vim.notify("Error: No file name to compile/run.", vim.log.levels.ERROR)
    return
  end

  -- 2. Construct and execute compile command
  local compile_cmd = string.format(compile_command_template, output_file, source_file)
  vim.notify("Compiling: " .. compile_cmd, vim.log.levels.INFO)
  vim.cmd("silent !" .. compile_cmd) -- Execute the g++ command silently

  -- 3. Check compilation result
  if vim.v.shell_error ~= 0 then
    vim.notify("Compilation FAILED! Exit code: " .. vim.v.shell_error, vim.log.levels.ERROR)
    return -- Stop if compilation failed
  else
    vim.notify("Compilation successful!", vim.log.levels.INFO)
  end

  -- --- If compilation succeeded, proceed to run ---

  local executable_path = "./" .. output_file

  -- 4. Check if the output file exists and is executable
  if vim.fn.filereadable(executable_path) == 0 then
    vim.notify(
      "Error: Compiled file '" .. executable_path .. "' not found (after successful compile?).",
      vim.log.levels.ERROR
    )
    return
  end
  if vim.fn.executable(executable_path) == 0 then
    vim.notify(
      "Error: Compiled file '" .. executable_path .. "' is not executable. Use <leader>x first?",
      vim.log.levels.ERROR
    )
    return
  end

  -- 5. Execute the compiled program in a terminal window
  vim.notify("Running '" .. executable_path .. "' in terminal...", vim.log.levels.INFO)
  vim.cmd(string.format("term %s", executable_path)) -- Use :term for interactive session
end, {
  noremap = true,
  silent = true, -- Keep the mapping trigger itself silent
  desc = "Compile & Run C++ file (g++ ... && term ./%:r)",
})
