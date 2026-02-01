return
    {
        'lewis6991/gitsigns.nvim',
        -- event = "VeryLazy",
        cmd = "Gitsigns",
        config = function()
            require('gitsigns').setup()

            local gitsigns = require('gitsigns')
            vim.keymap.set('n', '<leader>gt', gitsigns.toggle_signs, {})
        end,
        opts = {},
        -- config = function()
        -- 	require('gitsigns').setup()
        -- end
    }
