-- https://github.com/jbyuki/venn.nvim

local api = require("utils.api")
local aux = require("core.depends.venn.aux")

local M = {}

M.lazy = {
    "jbyuki/venn.nvim",
    lazy = true,
}

function M.init()
    M.venn = require("venn")
    aux.init(M.venn)
end

function M.load()
    M.venn.toggle = function()
        local venn_enable = vim.b.venn_enabled
        if not venn_enable then
            vim.b.venn_enabled = true
            vim.wo.virtualedit = "all"
            aux.register_buf_maps(0)
            vim.api.nvim_echo({ { "Venn mode enable", "WarningMsg" } }, false, {})
        else
            vim.b.venn_enabled = false
            vim.wo.virtualedit = ""
            vim.cmd([[mapclear <buffer>]])
            vim.api.nvim_echo({ { "Venn mode disable", "WarningMsg" } }, false, {})
        end
    end
end

function M.after() end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>4",
            rhs = function()
                require("venn").toggle()
            end,
            options = { silent = true },
            description = "Open Venn Mode",
        },
    })
end

return M
