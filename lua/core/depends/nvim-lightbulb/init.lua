-- https://github.com/kosayoda/nvim-lightbulb

local M = {}

M.lazy = {
    "kosayoda/nvim-lightbulb",
    event = { "LspAttach" },
}

function M.init()
    M.nvim_lightbulb = require("nvim-lightbulb")
end

function M.load()
    -- only enable display in symbol column
    M.nvim_lightbulb.setup({
        autocmd = { enabled = true },
        priority = 15,
        sign = {
            enabled = true,
            text = "💡",
            hl = "DiagnosticSignWarn",
        },
    })
end

function M.after() end

return M
