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
    })
end

function M.after() end

return M
