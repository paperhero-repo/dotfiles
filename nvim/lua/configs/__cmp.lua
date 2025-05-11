local M = {}

function M.setup()
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	-- LuaSnip 초기 설정
	luasnip.config.setup({})
	require("luasnip.loaders.from_vscode").lazy_load() -- VS Code 스니펫 지원

	-- 아이콘 설정 (Nerd Font 필요)
	local kind_icons = {
		Text = "󰉿",
		Method = "m",
		Function = "󰊕",
		Constructor = "",
		Field = "",
		Variable = "󰆧",
		Class = "󰌗",
		Interface = "",
		Module = "",
		Property = "",
		Unit = "",
		Value = "󰎠",
		Enum = "",
		Keyword = "󰌋",
		Snippet = "",
		Color = "󰏘",
		File = "󰈙",
		Reference = "",
		Folder = "󰉋",
		EnumMember = "",
		Constant = "󰇽",
		Struct = "",
		Event = "",
		Operator = "󰆕",
		TypeParameter = "󰊄",
	}

	-- cmp 기본 설정
	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body) -- LuaSnip과 연동
			end,
		},

		-- 자동 완성 옵션
		completion = {
			completeopt = "menu,menuone,noinsert", -- 기본 자동 선택 비활성화
		},

		-- 창 스타일 설정
		window = {
			completion = cmp.config.window.bordered({
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
			}),
			documentation = {
				max_width = 40,
				border = "rounded",
				winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder", -- 문서 창도 동일 스타일
			},
		},

		-- 키 매핑 설정
		mapping = cmp.mapping.preset.insert({
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter로 선택 확정
			["<C-c>"] = cmp.mapping.complete({}), -- 수동 완성 트리거
			["<Tab>"] = cmp.mapping(function(fallback) -- 다음 항목 선택/스니펫 점프
				if cmp.visible() then
					cmp.select_next_item()
				elseif luasnip.expand_or_locally_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback) -- 이전 항목 선택/스니펫 점프
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.locally_jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),

		-- 자동 완성 소스 설정
		sources = cmp.config.sources({
			{ name = "nvim_lsp" }, -- LSP
			{ name = "luasnip" }, -- 스니펫
			{ name = "buffer" }, -- 현재 버퍼
			{ name = "path" }, -- 파일 경로
			{ name = "cmdline" }, -- 명령어
		}),

		-- 서식 설정
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind) -- 아이콘 + 텍스트
				vim_item.menu = ({ -- 소스별 메뉴 표시
					nvim_lsp = "[LSP]",
					luasnip = "[스니펫]",
					buffer = "[버퍼]",
					path = "[경로]",
				})[entry.source.name]

				vim_item.menu_hl_group = "Special" -- 원하는 하이라이트 그룹
				return vim_item
			end,
		},
	})
end

return M
