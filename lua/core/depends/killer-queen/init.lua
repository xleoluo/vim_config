local api = require("utils.api")

local M = {}

M.lazy = {
    dir = "$HOME/project/neovim_project/killer-queen",
    priority = 80,
    cond = api.get_setting().is_enable_colorscheme("killer-queen")
}

function M.init()
    M.killer_queen = require("killer-queen")
end

function M.load()
    M.killer_queen.setup({
        is_border = api.get_setting().is_float_border(),
    })
    vim.cmd([[colorscheme killer-queen]])
end

function M.after() end

return M
