return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		-- { "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
		"ray-x/lsp_signature.nvim",
		"mfussenegger/nvim-lint",
	},
	config = function()
		-- LSP 연결 시 설정할 이벤트 핸들러
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
			callback = function(event)
				-- 커서 하이라이트 설정
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					-- LSP 분리 시 하이라이트 제거
					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
						end,
					})
				end
			end,
		})

		-- LSP 클라이언트 기능 설정
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- 언어 서버별 설정
		local servers = {
			ts_ls = {},
			ruff = {},
			pylsp = {
				settings = {
					pylsp = {
						plugins = {
							pyflakes = { enabled = false },
							pycodestyle = { enabled = false },
							autopep8 = { enabled = false },
							yapf = { enabled = false },
							mccabe = { enabled = false },
							pylsp_mypy = { enabled = false },
							pylsp_black = { enabled = false },
							pylsp_isort = { enabled = false },
						},
					},
				},
			},
			html = { filetypes = { "html", "twig", "hbs" } },
			cssls = {},
			tailwindcss = {},
			dockerls = {},
			sqlls = {},
			terraformls = {},
			jsonls = {},
			yamlls = {},
			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" },
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = vim.api.nvim_get_runtime_file("", true),
						},
						diagnostics = { disable = { "missing-fields" } },
						format = { enable = false },
					},
				},
			},
			gopls = {
				settings = {
					gopls = {
						-- Enable gofumpt formatting
						gofumpt = true,
						-- Use placeholder text for function parameters
						usePlaceholders = true,
						-- Enable analyses for unused parameters
						analyses = {
							unusedparams = true,
						},
						-- Enable code hints
						hints = {
							assignVariableTypes = true,
							compositeLiteralFields = true,
							constantValues = true,
						},
					},
				},
			},
		}

		-- Mason 설정
		require("mason").setup()
		local ensure_installed = vim.tbl_keys(servers)
		vim.list_extend(ensure_installed, { "stylua" })
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- 언어 서버 설정 적용
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})

					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
