-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- This file is automatically loaded by lazyvim.config.init
local Util = require("lazyvim.util")

local map = vim.keymap.set

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
-- map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
-- map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })
-- map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
-- map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })

-- Add undo break-points
map("i", ",", ",<c-g>u")

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<C-n>", "<cmd>enew<cr>", { desc = "New File" })

-- formatting
-- map({ "n", "v" }, "S-f", function()
-- 	Util.format({ force = true })
-- end, { desc = "Format" })

-- floating terminal
local lazyterm = function()
	Util.terminal(nil, { cwd = Util.root() })
end
map("n", "<c-/>", lazyterm, { desc = "Terminal (root dir)" })

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- Disable mouse
vim.opt.mouse = ""

-- Disable arrow keys
map({
	"n",
	"v",
	"i",
}, "<Up>", "<nop>")
map({
	"n",
	"v",
	"i",
}, "<Down>", "<nop>")
map({
	"n",
	"v",
	"i",
}, "<Left>", "<nop>")
map({
	"n",
	"v",
	"i",
}, "<Right>", "<nop>")
