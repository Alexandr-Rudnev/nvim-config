return {
  -- Mason (установка LSP серверов)
  {
    "williamboman/mason.nvim",
    config = true,
  },

  -- Mason LSP Config (интеграция Mason с lspconfig)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "html", "cssls", "yamlls", "jsonls" },
      })
    end,
  },

  -- Настройка LSP серверов
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp", -- для интеграции с autocompletion
    },
    config = function()
      local lspconfig = require("lspconfig")

      -- Общие настройки LSP
      local on_attach = function(client, bufnr)
        -- Горячие клавиши для LSP
        local nmap = function(keys, func, desc)
          if desc then desc = "LSP: " .. desc end
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
        end

        nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
        nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
        nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
        nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
        nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
        nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
        nmap("K", vim.lsp.buf.hover, "Hover Documentation")
        nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
      end

      -- Подключение LSP серверов
      local servers = { "html", "cssls", "yamlls", "jsonls" }
      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          on_attach = on_attach,
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })
      end

      -- Специфические настройки для YAML
      lspconfig.yamlls.setup({
        settings = {
          yaml = {
            schemas = {
              ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
              ["https://json.schemastore.org/github-action.json"] = "/.github/action.{yml,yaml}",
            },
          },
        },
      })

      -- Форматирование при сохранении
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = { "*.html", "*.js", "*.css", "*.yaml", "*.yml", "*.json" },
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },
}
