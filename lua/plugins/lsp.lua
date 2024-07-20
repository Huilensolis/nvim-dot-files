return {
	"neovim/nvim-lspconfig",
	opts = {
		servers = {
			tailwindcss = {
				-- exclude a filetype from the default_config
				filetypes_exclude = { "markdown" },
				-- add additional filetypes to the default_config
				filetypes_include = {},
				-- to fully override the default_config, change the below
				-- filetypes = {}
			},
			tsserver = {
				on_attach = function(client)
					-- this is important, otherwise tsserver will format ts/js
					-- files which we *really* don't want.
					client.server_capabilities.documentFormattingProvider = false
				end,
				settings = {
					complete_function_calls = true,
					vtsls = {
						enableMoveToFileCodeAction = true,
						autoUseWorkspaceTsdk = true,
						experimental = {
							completion = {
								enableServerSideFuzzyMatch = true,
							},
						},
					},
					typescript = {
						updateImportsOnFileMove = { enabled = "always" },
						suggest = {
							completeFunctionCalls = true,
						},
						inlayHints = {
							enumMemberValues = { enabled = true },
							functionLikeReturnTypes = { enabled = true },
							parameterNames = { enabled = "literals" },
							parameterTypes = { enabled = true },
							propertyDeclarationTypes = { enabled = true },
							variableTypes = { enabled = false },
						},
					},
				},
				keys = {
					{
						"<leader>oi",
						function()
							vim.lsp.buf.code_action({
								apply = true,
								context = {
									only = { "source.organizeImports.ts" },
									diagnostics = {},
								},
							})
						end,
						desc = "Organize Imports",
					},
					{
						"<leader>ru",
						function()
							vim.lsp.buf.code_action({
								apply = true,
								context = {
									only = { "source.removeUnused.ts" },
									diagnostics = {},
								},
							})
						end,
						desc = "Remove Unused Imports",
					},
				},
			},
			biome = {},
			eslint = {
				settings = {
					-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
					workingDirectories = { mode = "auto" },
					filetype = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
						"vue",
						"svelte",
						"astro",
					},
				},
			},
			taplo = {
				keys = {
					{
						"K",
						function()
							if
								vim.fn.expand("%:t") == "Cargo.toml"
								and require("crates").popup_available()
							then
								require("crates").show_popup()
							else
								vim.lsp.buf.hover()
							end
						end,
						desc = "Show Crate Documentation",
					},
				},
			},
		},
		setup = {
			tailwindcss = function(_, opts)
				local tw = require("lspconfig.server_configurations.tailwindcss")
				opts.filetypes = opts.filetypes or {}

				-- Add default filetypes
				vim.list_extend(opts.filetypes, tw.default_config.filetypes)

				-- Remove excluded filetypes
				--- @param ft string
				opts.filetypes = vim.tbl_filter(function(ft)
					return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
				end, opts.filetypes)

				-- Add additional filetypes
				vim.list_extend(opts.filetypes, opts.filetypes_include or {})
			end,
			tsserver = function()
				return {
					filetype = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
				}
			end,
			eslint = function()
				local function get_client(buf)
					return LazyVim.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
				end

				local formatter = LazyVim.lsp.formatter({
					name = "eslint: lsp",
					primary = false,
					priority = 200,
					filter = "eslint",
				})

				-- Use EslintFixAll on Neovim < 0.10.0
				if not pcall(require, "vim.lsp._dynamic") then
					formatter.name = "eslint: EslintFixAll"
					formatter.sources = function(buf)
						local client = get_client(buf)
						return client and { "eslint" } or {}
					end
					formatter.format = function(buf)
						local client = get_client(buf)
						if client then
							local diag = vim.diagnostic.get(buf, {
								namespace = vim.lsp.diagnostic.get_namespace(client.id),
							})
							if #diag > 0 then
								vim.cmd("EslintFixAll")
							end
						end
					end
				end

				-- register the formatter with LazyVim
				LazyVim.format.register(formatter)
			end,
		},
	},
}
