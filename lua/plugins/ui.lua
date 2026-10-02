-- ============================================================================
--  plugins/ui.lua — statusline and diagnostic aggregators
-- ============================================================================

-- catppuccin ships per-flavour lualine themes at `lualine/themes/catppuccin-<flavour>.lua`
-- (there is no `catppuccin.lua`, so naming the theme plainly "catppuccin" produces
-- a "theme not found" warning). Match the flavour we set in plugins/colorscheme.lua.
-- Falls back to "auto" if catppuccin isn't present for any reason.
local lualine_theme = pcall(require, "catppuccin") and "catppuccin-mocha" or "auto"

require("lualine").setup({
  options = {
    theme                 = lualine_theme,
    globalstatus          = true,  -- one statusline for all windows
    component_separators  = { left = "", right = "" },
    section_separators    = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    -- Branch + diff come from gitsigns' cached buffer vars (b:gitsigns_head /
    -- b:gitsigns_status_dict) so no git subprocess can ever run inside the
    -- statusline redraw path.
    lualine_b = {
      { "b:gitsigns_head", icon = "" },
      {
        "diff",
        source = function()
          local g = vim.b.gitsigns_status_dict
          if g then return { added = g.added, modified = g.changed, removed = g.removed } end
        end,
      },
    },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = {
      { "diagnostics", sources = { "nvim_diagnostic" } },
      "encoding", "fileformat", "filetype",
    },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

require("todo-comments").setup()

require("trouble").setup()
local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true }) end
map("<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",              "Diagnostics (Trouble)")
map("<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", "Buffer diagnostics")
map("<leader>xq", "<cmd>Trouble qflist toggle<CR>",                   "Quickfix list")
map("<leader>xl", "<cmd>Trouble loclist toggle<CR>",                  "Location list")
map("<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>",      "Symbols outline")
map("<leader>xt", "<cmd>TodoTrouble<CR>",                             "TODO comments (Trouble)")

