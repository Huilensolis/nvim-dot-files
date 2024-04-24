return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		lazy = false,
		opts = { flavour = "macchiato", transparent_background = true },
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "catppuccin",
			transparent = true,
			styles = {
				sidebars = "transparent",
				float = "transparent",
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = { eslint = {} },
			setup = {
				eslint = function()
					require("lazyvim.util").lsp.on_attach(function(client)
						if client.name == "eslint" then
							client.server_capabilities.documentFormattingProvider = true
						elseif client.name == "tsserver" then
							client.server_capabilities.documentFormattingProvider = false
						end
					end)
				end,
			},
		},
	},
}
