return {
  -- JsDoc generator
  {
    "heavenshell/vim-jsdoc",
    ft = "javascript,typescript,typescriptreact,svelte",
    vscode = true,
    cmd = { "JsDoc", "JsDocFormat" },
    keys = {
      { "<leader>jd", "<cmd>JsDoc<cr>", desc = "JsDoc" },
      { "<leader>jf", "<cmd>JsDocFormat<cr>", desc = "JsDocFormat" },
    },
    -- make sure that you will have lehre install locally on plugin folder, refer https://github.com/heavenshell/vim-jsdoc#manual-installation
    build = "make install",
  },
}
