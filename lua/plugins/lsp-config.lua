return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.bashls.setup({ capabilities = capabilities })
      lspconfig.clangd.setup({ capabilities = capabilities })

      local pid = vim.fn.getpid()
      local mason_registry = require("mason-registry")
      local omnisharp_pack = mason_registry.get_package("omnisharp")
      local omnisharp_bin = omnisharp_pack:get_install_path() .. "/omnisharp"

      lspconfig.omnisharp.setup({
        capabilities = capabilities,
        cmd = { omnisharp_bin, "--languageserver", "--hostPID", tostring(pid)},
      })
      lspconfig.cssls.setup({ capabilities = capabilities })
      lspconfig.dockerls.setup({ capabilities = capabilities })
      lspconfig.docker_compose_language_service.setup({ capabilities = capabilities })
      lspconfig.html.setup({ capabilities = capabilities })
      lspconfig.jsonls.setup({ capabilities = capabilities })
      lspconfig.quick_lint_js.setup({ capabilities = capabilities })
      lspconfig.marksman.setup({ capabilities = capabilities })
      lspconfig.pyre.setup({ capabilities = capabilities })
      lspconfig.sqls.setup({ capabilities = capabilities })
      lspconfig.yamlls.setup({ capabilities = capabilities })

      lspconfig.tsserver.setup({capabilities = capabilities})

      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

          local opts = { buffer = ev.buf }
          vim.keymap.set('n', '<space>gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', '<space>gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', '<space>K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', '<space>gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
          vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
          vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
          vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set('n', '<space>gr', vim.lsp.buf.references, opts)
          vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
          end, opts)
        end
      })
    end
  },
{
    "williamboman/mason.nvim",
    config = function ()
      require('mason').setup({
        ensure_installed = {
          "pylint",
          "black",
          "clang-format",
          "codelldb",
          "debugpy",
          "js-debug-adapter",
          "netcoredbg",
          "stylua",
        },
      })
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "clangd",
          "cssls",
          "docker_compose_language_service",
          "dockerls",
          "html",
          "jsonls",
          "lua_ls",
          "marksman",
          "omnisharp",
          "pylsp",
          "quick_lint_js",
          "sqls",
          "tsserver",
          "yamlls"
        },
        auto_install = true
      })
    end
  },
}