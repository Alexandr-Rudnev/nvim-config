return {
  "nvimtools/none-ls.nvim",
  dependencies = { "mason.nvim" },
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.yamlfmt,
        null_ls.builtins.formatting.prettier.with({
          filetypes = { "yaml", "yml" },
          extra_args = { "--prose-wrap=always" },
        }),
        null_ls.builtins.formatting.prettier.with({
          filetypes = { "ini", "cfg" },
        }),
        null_ls.builtins.formatting.terraform_fmt,
        null_ls.builtins.formatting.hclfmt,
      },
    })
    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format file with LSP" })
  end,
}
