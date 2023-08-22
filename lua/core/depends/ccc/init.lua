-- https://github.com/uga-rosa/ccc.nvim

local M = {}

M.lazy = {
    "uga-rosa/ccc.nvim",
    event = { "UIEnter" },
}

function M.init()
    M.ccc = require("ccc")
end

function M.load()
    M.ccc.setup({
        highlighter = {
            auto_enable = true,
            lsp = true,
        },
    })
end

function M.after()
    vim.cmd([[CccHighlighterEnable]])
end

return M
