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

-- Move Lines
-- map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
-- map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
	"n",
	"<leader>ur",
	"<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
	{ desc = "Redraw / clear hlsearch / diff update" }
)

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

-- toggle options
map("n", "<leader>uf", function()
	Util.format.toggle()
end, { desc = "Toggle auto format (global)" })
map("n", "<leader>uF", function()
	Util.format.toggle(true)
end, { desc = "Toggle auto format (buffer)" })
map("n", "<leader>us", function()
	Util.toggle("spell")
end, { desc = "Toggle Spelling" })
map("n", "A-z", function()
	Util.toggle("wrap")
end, { desc = "Toggle Word Wrap" })
map("n", "<leader>uL", function()
	Util.toggle("relativenumber")
end, { desc = "Toggle Relative Line Numbers" })
map("n", "<leader>ul", function()
	Util.toggle.number()
end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", function()
	Util.toggle.diagnostics()
end, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function()
	Util.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })
if vim.lsp.inlay_hint then
	map("n", "<leader>uh", function()
		vim.lsp.inlay_hint(0, nil)
	end, { desc = "Toggle Inlay Hints" })
end
map("n", "<leader>uT", function()
	if vim.b.ts_highlight then
		vim.treesitter.stop()
	else
		vim.treesitter.start()
	end
end, { desc = "Toggle Treesitter Highlight" })

-- lazygit
-- map("n", "<leader>gg", function()
-- 	Util.terminal({ "lazygit" }, { cwd = Util.root(), esc_esc = false, ctrl_hjkl = false })
-- end, { desc = "Lazygit (root dir)" })
-- map("n", "<leader>gG", function()
-- 	Util.terminal({ "lazygit" }, { esc_esc = false, ctrl_hjkl = false })
-- end, { desc = "Lazygit (cwd)" })

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
