-- https://github.com/folke/todo-comments.nvim

local api = require("utils.api")

local M = {}

M.lazy = {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
}

function M.init()
    M.todo_comments = require("todo-comments")
end

function M.load()
    local icons = api.get_setting().get_icon_groups("comment", false)
    local signs_enable = api.get_setting().is_enable_icon_groups("comment")

    M.todo_comments.setup({
        signs = signs_enable,
        keywords = {
            NOTE = { icon = icons.Note, color = "#D9D9D9" },
            TODO = { icon = icons.Todo, color = "#D9D9D9" },
            WARN = { icon = icons.Warn, color = "#CCA700" },
            ERROR = { icon = icons.Error, color = "#F14C4C" },
            HACK = { icon = icons.Hack, color = "#DDB6F2", alt = { "DEP" } },
            FIX = { icon = icons.Fix, color = "#DDB6F2", alt = { "BUG" } },
        },
        highlight = { multiline = false },
        gui_style = { fg = "NONE", bg = "NONE", gui = "NONE" },
    })
end

function M.after() end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "]t",
            rhs = function()
                require("todo-comments").jump_next()
            end,
            options = { silent = true },
            description = "Next todo comment",
        },
        {
            mode = { "n" },
            lhs = "[t",
            rhs = function()
                require("todo-comments").jump_prev()
            end,
            options = { silent = true },
            description = "Prev todo comment",
        },
        {
            mode = { "n" },
            lhs = "<leader>ft",
            rhs = function()
                require("telescope").extensions["todo-comments"].todo()
            end,
            options = { silent = true },
            description = "Find todo tag in the current workspace",
        },
    })
end

return M
