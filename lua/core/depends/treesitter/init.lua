-- https://github.com/nvim-treesitter/nvim-treesitter

local api = require("utils.api")

local M = {}

M.lazy = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "windwp/nvim-ts-autotag" },
        { "JoosepAlviste/nvim-ts-context-commentstring" },
    },
    event = { "UIEnter" },
}

function M.init()
    M.nvim_treesitter_configs = require("nvim-treesitter.configs")
    M.nvim_treesitter_install = require("nvim-treesitter.install")

    --------------
    M.ensure_installed = vim.list_extend({
        "xml",
        "dockerfile",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
    }, api.get_lang().get_treesitter_install())
end

function M.load()
    local enable_highlight = not api.get_setting().is_lspconfig_semantic_token()

    M.nvim_treesitter_install.prefer_git = true
    M.nvim_treesitter_configs.setup({
        ensure_installed = M.ensure_installed,
        ignore_install = {},
        highlight = {
            enable = enable_highlight,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = false,
        },
        -- incremental selection
        incremental_selection = {
            enable = false,
            keymaps = {
                init_selection = "<cr>",
                node_incremental = "<cr>",
                node_decremental = "<bs>",
                scope_incremental = "<tab>",
            },
        },
        -- nvim-ts-autotag
        autotag = {
            enable = true,
        },
        -- nvim-ts-context-commentstring
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
    })
end

function M.after() end

return M
