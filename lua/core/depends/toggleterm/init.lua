-- https://github.com/akinsho/toggleterm.nvim

local api = require("utils.api")
local aux = require("core.depends.toggleterm.aux")

local M = {}

M.lazy = {
    "akinsho/toggleterm.nvim",
}

function M.init()
    M.toggleterm = require("toggleterm")
    M.terminal = require("toggleterm.terminal").Terminal
    --
    aux.init(M.terminal)
end

function M.load()
    M.toggleterm.setup({
        start_in_insert = false,
        shade_terminals = true,
        shading_factor = 1,
        on_open = aux.on_open,
        highlights = {
            Normal = {
                link = "Normal",
            },
            NormalFloat = {
                link = "NormalFloat",
            },
            FloatBorder = {
                link = "FloatBorder",
            },
        },
    })
end

function M.after() end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>tf",
            rhs = aux.toggle_float_terminl,
            options = { silent = true },
            description = "Toggle float terminal",
        },
        {
            mode = { "n" },
            lhs = "<leader>tt",
            rhs = aux.toggle_bottom_terminal,
            options = { silent = true },
            description = "Toggle bottom terminal",
        },
        {
            mode = { "n" },
            lhs = "<leader>tg",
            rhs = aux.toggle_lazygit_terminl,
            options = { silent = true },
            description = "Toggle lazygit terminal",
        },
        {
            mode = { "n" },
            lhs = "<leader>ta",
            rhs = aux.toggle_all_terminal,
            options = { silent = true },
            description = "Toggle all terminal",
        },
    })
end

return M
