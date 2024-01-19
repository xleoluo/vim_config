-- https://github.com/RRethy/vim-illuminate

local api = require("utils.api")

local M = {}

M.lazy = {
    "RRethy/vim-illuminate",
    event = { "UIEnter" },
}

function M.init()
    M.illuminate = require("illuminate")
end

function M.load()
    M.illuminate.configure({
        delay = 100,
        under_cursor = true,
        modes_denylist = { "i" },
        providers = {
            --[[ "lsp", ]]
            "regex",
            "treesitter",
        },
        filetypes_denylist = api.fn.get_ignore_filetypes(),
    })
end

function M.after() end

return M
