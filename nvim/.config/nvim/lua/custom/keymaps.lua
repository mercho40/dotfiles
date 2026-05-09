-- C++ compile / run / make keymaps

local compile_command_template = 'g++ -DEVAL -std=gnu++11 -O2 -pipe -o %s %s'

-- <leader>co — compile only
vim.keymap.set('n', '<leader>co', function()
  local source_file = vim.fn.expand '%:t'
  local output_file = vim.fn.expand '%:r'
  if source_file == '' or output_file == '' then
    vim.notify('Error: No file name to compile.', vim.log.levels.ERROR)
    return
  end
  local cmd = string.format(compile_command_template, output_file, source_file)
  vim.notify('Compiling: ' .. cmd, vim.log.levels.INFO)
  vim.cmd('silent !' .. cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify('Compilation FAILED! Exit code: ' .. vim.v.shell_error, vim.log.levels.ERROR)
  else
    vim.notify('Compilation successful! Output: ./' .. output_file, vim.log.levels.INFO)
  end
end, { noremap = true, silent = true, desc = 'Compile current C++ file' })

-- <leader>rp — run compiled executable
vim.keymap.set('n', '<leader>rp', function()
  local executable = vim.fn.expand '%:r'
  if executable == '' then
    vim.notify('Error: No file name to run.', vim.log.levels.ERROR)
    return
  end
  local executable_path = './' .. executable
  if vim.fn.filereadable(executable_path) == 0 then
    vim.notify("Error: Executable '" .. executable_path .. "' not found.", vim.log.levels.ERROR)
    return
  end
  if vim.fn.executable(executable_path) == 0 then
    vim.notify("Error: File '" .. executable_path .. "' is not executable. Use <leader>x?", vim.log.levels.ERROR)
    return
  end
  vim.notify("Running '" .. executable_path .. "' in terminal", vim.log.levels.INFO)
  vim.cmd(string.format('term %s', executable_path))
end, { noremap = true, silent = true, desc = 'Run compiled executable in terminal' })

-- <leader>x — chmod +x current file
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<cr>', { noremap = true, silent = true, desc = 'Make current file executable' })

-- <leader>cm — make + run
vim.keymap.set('n', '<leader>cm', function()
  vim.notify('Running make...', vim.log.levels.INFO)
  vim.cmd 'silent !make'
  if vim.v.shell_error ~= 0 then
    vim.notify('Make FAILED! Exit code: ' .. vim.v.shell_error, vim.log.levels.ERROR)
    return
  end
  vim.notify('Make completed successfully!', vim.log.levels.INFO)
  local output_file = vim.fn.expand '%:r'
  if output_file == '' then
    vim.notify('Error: No file name to determine executable.', vim.log.levels.ERROR)
    return
  end
  local executable_path = './' .. output_file
  if vim.fn.filereadable(executable_path) == 0 then
    vim.notify("Error: Executable '" .. executable_path .. "' not found after make.", vim.log.levels.ERROR)
    return
  end
  if vim.fn.executable(executable_path) == 0 then
    vim.notify("Error: File '" .. executable_path .. "' is not executable.", vim.log.levels.ERROR)
    return
  end
  vim.cmd(string.format('term %s', executable_path))
end, { noremap = true, silent = true, desc = 'Run make & execute' })

-- <leader>cx — compile + run
vim.keymap.set('n', '<leader>cx', function()
  local source_file = vim.fn.expand '%:t'
  local output_file = vim.fn.expand '%:r'
  if source_file == '' or output_file == '' then
    vim.notify('Error: No file name to compile/run.', vim.log.levels.ERROR)
    return
  end
  local compile_cmd = string.format(compile_command_template, output_file, source_file)
  vim.notify('Compiling: ' .. compile_cmd, vim.log.levels.INFO)
  vim.cmd('silent !' .. compile_cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify('Compilation FAILED! Exit code: ' .. vim.v.shell_error, vim.log.levels.ERROR)
    return
  end
  vim.notify('Compilation successful!', vim.log.levels.INFO)
  local executable_path = './' .. output_file
  if vim.fn.filereadable(executable_path) == 0 then
    vim.notify("Error: Compiled file '" .. executable_path .. "' not found.", vim.log.levels.ERROR)
    return
  end
  if vim.fn.executable(executable_path) == 0 then
    vim.notify("Error: Compiled file '" .. executable_path .. "' is not executable.", vim.log.levels.ERROR)
    return
  end
  vim.cmd(string.format('term %s', executable_path))
end, { noremap = true, silent = true, desc = 'Compile & Run C++ file' })
