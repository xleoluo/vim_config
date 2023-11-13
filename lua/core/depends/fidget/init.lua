-- https://github.com/j-hui/fidget.nvim

local M = {}

M.lazy = {
    "j-hui/fidget.nvim",
    tag = "legacy",
    dependencies = {
        { "neovim/nvim-lspconfig" },
    },
    event = { "LspAttach" },
}

function M.init()
    M.fidget = require("fidget")
end

function M.load()
    M.fidget.setup({
        window = {
            blend = 0,
        },
        text = {
            spinner = "meter",
        },
        fmt = {
            max_messages = 2,
            -- function to format each task line
            task = function(task_name, message, percentage)
                return string.format(
                    "%s%s [%s]",
                    message,
                    percentage and string.format(" (%s%%)", percentage) or "",
                    task_name
                )
            end,
        },
    })
end

function M.after() end

return M
