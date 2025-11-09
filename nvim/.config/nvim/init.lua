-- For simple options, just use .vimrc:
vim.cmd([[
  source ~/.vimrc
]])

require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

vim.o.shell = 'zsh'

-- Work activity logging
if vim.env.WORK_LOG_ENABLE and vim.env.WORK_LOG_ENABLE ~= "" then
  local work_log_dir = vim.fn.expand("~/.work_logs")
  local work_log_nvim = work_log_dir .. "/nvim_write.log"

  -- Create log directory if it doesn't exist
  if vim.fn.isdirectory(work_log_dir) == 0 then
    vim.fn.mkdir(work_log_dir, "p")
  end

  -- Log file writes
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*",
    callback = function()
      local timestamp = os.date("%Y-%m-%d %H:%M:%S")
      local exec_dir = vim.fn.getcwd()
      local file_path = vim.fn.expand("%:p")
      local log_entry = string.format("%s | %s | [NVIM :w] %s\n", timestamp, exec_dir, file_path)

      local file = io.open(work_log_nvim, "a")
      if file then
        file:write(log_entry)
        file:close()
      end
    end,
  })
end

