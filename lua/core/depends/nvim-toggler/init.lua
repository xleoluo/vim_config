-- https://github.com/nguyenvukhang/nvim-toggler

local api = require("utils.api")
local aux = require("core.depends.nvim-toggler.aux")

local M = {}

M.lazy = {
    "nguyenvukhang/nvim-toggler",
    lazy = true,
}

function M.init()
    M.nvim_toggler = require("nvim-toggler")
end

function M.load()
    M.nvim_toggler.setup({
        -- your own inverses
        inverses = aux.get_inverse(),
        -- removes the default <leader>i keymap
        remove_default_keybinds = true,
        -- removes the default set of inverses
        remove_default_inverses = true,
    })
end

function M.after() end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "gs",
            rhs = function()
                require("nvim-toggler").toggle()
            end,
            options = { silent = true },
            description = "Switch current word",
        },
    })
end

return M
