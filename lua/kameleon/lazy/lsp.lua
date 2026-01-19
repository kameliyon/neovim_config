return
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "j-hui/fidget.nvim",
			'hrsh7th/cmp-nvim-lsp-signature-help',
        },

        config = function()
            local cmp = require("cmp")
            require("luasnip.loaders.from_vscode").lazy_load();
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())

            require("fidget").setup({})
            require("mason").setup({
                registries = {
                    'github:mason-org/mason-registry',
                    'github:crashdummyy/mason-registry',
                },
            })
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    -- "rust_analyzer",
                    -- "omnisharp",
                    "pyright",
                    "html",
                    "gopls",
                    "sqls",
                    "solidity-ls"
                },
                handlers = {
                    function(server_name)
                        require("lspconfig")[server_name].setup{
                            capabilities = capabilities
                        }
                    end,
                    -- ["omnisharp"] = function()
                    --     require("lspconfig").omnisharp.setup{
                    --         capabilities = capabilities,
                    --         enable_roslyn_analysers = true,
                    --         enable_import_completion = true,
                    --         organize_imports_on_format = true,
                    --         complete_using_omnisharp_snippets = true,
                    --         filetypes = { 'cs', 'vb', 'csproj', 'sln', 'slnx', 'props' },
                    --     }
                    -- end,
                    ["sqls"] = function()
                        require("lspconfig").sqls.setup{
                            on_attach = function(client, bufnr)
                                require('sqls').on_attach(client, bufnr)
                            end 
                        }
                    end
                }
            })

            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                -- mapping = cmp.mapping.preset.insert({
                --     ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                --     ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                --     ['<CR>'] = cmp.mapping.confirm({ select = true }),
                --     ["<C-Space>"] = cmp.mapping.complete(),
                -- }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }, -- For luasnip users.
                    { name = 'nvim_lsp_signature_help' }
                }, {
                        { name = 'buffer' },
                    })
            })

            local on_attach = function(client, bufnr)
                local nmap = function(keys, func, desc)
                    desc = "LSP: " .. desc
                    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc, noremap = true })
                end

                nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
                nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
                nmap("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
                nmap("K", vim.lsp.buf.hover, "Hover Documentation")
                nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

                nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
                nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
            end
        end
    }
