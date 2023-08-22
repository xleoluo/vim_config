-- https://github.com/RRethy/vim-illuminate

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
        -- TODO: filetype - 2023-08-21 -
        filetypes_denylist = {
            "NvimTree",
            "aerial",
            "spectre_panel",
            "help",
            "lazy",
            "mason",
            "notify",
            "lspinfo",
            "toggleterm",
            "TelescopePrompt",
        },
    })
end

function M.after() end

return M
