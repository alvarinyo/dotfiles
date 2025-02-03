
local opts = {
  log_level = 'warning',
  auto_session_enable_last_session = nil,
  root_dir = vim.fn.stdpath('data').."/sessions/",
  auto_restore = true,
  auto_save = true,
  enabled = true,
  suppressed_dirs = { "~/", "~/s", "~/Downloads", "/"},
  auto_session_use_git_branch = nil,
  lazy_support = true,
  -- the configs below are lua only
  bypass_session_save_file_types = nil,
  session_lens = {
    load_on_setup = false,
    previewer = false,
  }
}

return opts
