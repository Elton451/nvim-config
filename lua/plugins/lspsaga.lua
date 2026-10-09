-- ============================================================================
--  plugins/lspsaga.lua — prettier LSP UIs (rename, peek, code action)
--
--  Sits on top of the native vim.lsp setup in plugins/lsp.lua; it doesn't
--  start servers itself, it just replaces a few of the built-in UIs.
--  Keymaps are bound per-buffer on LspAttach, like the ones in lsp.lua.
-- ============================================================================

require("lspsaga").setup({
	ui = { border = "rounded" },
	-- dropbar.nvim already owns the winbar; saga's breadcrumbs would fight it.
	symbol_in_winbar = { enable = false },
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("dream_lspsaga_attach", { clear = true }),
	callback = function(args)
		local map = function(lhs, rhs, desc, mode)
			vim.keymap.set(mode or "n", lhs, rhs, { buffer = args.buf, desc = "LSP: " .. desc, silent = true })
		end

		-- Overrides Neovim 0.12's native `grn` with saga's rename UI.
		map("grn", "<cmd>Lspsaga rename<CR>", "[R]e[n]ame")

    -- Find references for the word under your cursor.
		map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

		map("pk", "<cmd>Lspsaga peek_type_definition<CR>", "[P]eek type definition")
		map("pd", "<cmd>Lspsaga peek_definition<CR>", "[P]eek [D]efinition")

		-- `:` (not <cmd>) in visual mode so the selection range is passed along.
		map("ca", ":Lspsaga code_action<CR>", "[C]ode [A]ction", { "n", "x" })
	end,
})
