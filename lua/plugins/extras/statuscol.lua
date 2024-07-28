return {
  "luukvbaal/statuscol.nvim",
  event = "VeryLazy",
  config = function()
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      bt_ignore = { "terminal", "nofile" },
      relculright = true,
      segments = {
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        { text = { "%s" }, click = "v:lua.ScSa" },
        { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
      },
    })
  end,
  -- NOTE: Enable foldcolumn if needed
  -- Below is an example of how to enable foldcolumn
  --
  -- init = function()
  --   -- Show foldcolumn on the left
  --   vim.o.foldcolumn = "1"
  -- end,
}
