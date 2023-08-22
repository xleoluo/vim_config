-- https://github.com/windwp/nvim-autopairs

local M = {}

M.lazy = {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
}

function M.init()
    M.nvim_autopairs = require("nvim-autopairs")
end

function M.load()
    M.nvim_autopairs.setup({
        map_c_h = true,
        map_c_w = true,
    })
end

function M.after() end

return M
