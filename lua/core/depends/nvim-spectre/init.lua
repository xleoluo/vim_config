-- https://github.com/nvim-pack/nvim-spectre

local api = require("utils.api")

local M = {}

M.lazy = {
    "nvim-pack/nvim-spectre",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
}

function M.init()
    M.spectre = require("spectre")
end

function M.load()
    M.spectre.setup({
        highlight = {
            ui = "@string",
            search = "@string.regex",
            replace = "@text.emphasis",
        },
    })
end

function M.after() end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>rp",
            rhs = function()
                require("spectre").open()
            end,
            options = { silent = true },
            description = "Replace characters in all files in the current workspace",
        },
        {
            mode = { "n" },
            lhs = "<leader>rf",
            rhs = function()
                require("spectre").open_file_search()
            end,
            options = { silent = true },
            description = "Replace all characters in the current file",
        },
        {
            mode = { "n" },
            lhs = "<leader>rwf",
            rhs = function()
                require("spectre").open_visual({
                    select_word = true,
                    path = vim.fn.fnameescape(vim.fn.expand("%:p:.")),
                })
            end,
            options = { silent = true },
            description = "Replace the character under the cursor in the current file",
        },
        {
            mode = { "n" },
            lhs = "<leader>rwp",
            rhs = function()
                require("spectre").open_visual({ select_word = true })
            end,
            options = { silent = true },
            description = "Replace the character under the cursor in all files under the current workspace",
        },
    })
end

return M
