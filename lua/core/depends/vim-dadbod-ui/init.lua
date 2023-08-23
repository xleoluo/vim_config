-- https://github.com/kristijanhusak/vim-dadbod-ui
-- https://github.com/tpope/vim-dadbod

local api = require("utils.api")

local M = {}

M.lazy = {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        { "tpope/vim-dadbod" },
    },
    cmd = { "DBUIToggle" },
}

function M.init()
    vim.g.dbs = api.get_setting().get_database()
end

function M.load()
    vim.g.db_ui_winwidth = 60
    vim.g.db_ui_win_position = "right"

    vim.g.db_ui_auto_execute_table_helpers = true
    vim.g.db_ui_execute_on_save = false
    vim.g.db_ui_show_database_icon = true
end

function M.after() end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>3",
            rhs = "<cmd>DBUIToggle<cr>",
            options = { silent = true },
            description = "Open Database Explorer",
        },
    })
end

return M
