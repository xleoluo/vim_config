-- https://github.com/j-hui/fidget.nvim

local M = {}

M.lazy = {
    "j-hui/fidget.nvim",
    priority = 80,
}

function M.init()
    M.fidget = require("fidget")
end

function M.load()
    M.fidget.setup({
        progress = {
            display = {
                render_limit = 2,
                done_style = "SpecialKey",
                progress_style = "SpecialKey",
                group_style = "Title",
                icon_style = "Title",
            },
        },
        notification = {
            override_vim_notify = true,
            window = {
                normal_hl = "SpecialKey",
                winblend = 0,
            },
            view = {
                stack_upwards = true,
                icon_separator = " ",
                group_separator = "---",
                group_separator_hl = "SpecialKey",
            },
        },
    })
end

function M.after() end

return M
