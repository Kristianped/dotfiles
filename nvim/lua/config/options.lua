-- Options are automatically loaded before lazy.nvim startup.
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

-- LazyVim root dir detection
-- Always use Current Working Directory (CWD)
vim.g.root_spec = { "cwd" }

-- The ~/.local/state/nvim/lsp.log can get pretty noisy
vim.lsp.log.set_level("ERROR")

local opt = vim.opt

-- Concealed text is shown as normal. Text is never hidden.
opt.conceallevel = 0

-- Each buffer gets its own status line instead of sharing one.
opt.laststatus = 2

-- Allow left and right arrow keys to move to the previous and next line.
opt.whichwrap = "b,s,<,>"

-- Wrap lines so it's easier to see anything that's cut off.
opt.wrap = true
