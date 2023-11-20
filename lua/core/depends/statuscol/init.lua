-- https://github.com/luukvbaal/statuscol.nvim
local api = require("utils.api")

local M = {}

M.lazy = {
    "luukvbaal/statuscol.nvim",
    event = { "UIEnter" },
}

function M.init()
    M.statuscol = require("statuscol")
end

function M.load()
    local builtin = require("statuscol.builtin")

    M.statuscol.setup({
        ft_ignore = api.fn.get_ignore_filetypes(),
        bt_ignore = nil,
        segments = {
            {
                sign = {
                    name = { "Dap*", "Diag*" },
                    namespace = { "bulb*", "gitsign*" },
                    colwidth = 1,
                },
                click = "v:lua.ScSa",
            },
            {
                text = { " ", builtin.lnumfunc },
                condition = { true, builtin.not_empty },
                click = "v:lua.ScLa",
            },
            {
                text = { " ", builtin.foldfunc, "  " },
                condition = { true, builtin.not_empty },
                click = "v:lua.ScFa",
            },
        },
    })
end

function M.after() end

return M
