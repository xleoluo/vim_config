-- https://github.com/kevinhwang91/nvim-ufo

local api = require("utils.api")
local aux = require("core.depends.nvim-ufo.aux")

local M = {}

M.lazy = {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    event = { "VeryLazy" },
}

function M.init()
    M.ufo = require("ufo")
end

function M.load()
    M.ufo.setup({
        open_fold_hl_timeout = 0,
        close_fold_kinds = {},
        ---@diagnostic disable-next-line: unused-local
        provider_selector = function(bufnr, filetype, buftype)
            return { "lsp", "indent" }
        end,
        fold_virt_text_handler = aux.fold_virtual_text_handler,
    })
end

function M.after() end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "zR",
            rhs = function()
                require("ufo").openAllFolds()
            end,
            options = { silent = true },
            descriptions = "Open all folds",
        },
        {
            mode = { "n" },
            lhs = "zM",
            rhs = function()
                require("ufo").closeAllFolds()
            end,
            options = { silent = true },
            descriptions = "Close all folds",
        },
        {
            mode = { "n" },
            lhs = "zr",
            rhs = function()
                require("ufo").openFoldsExceptKinds()
            end,
            options = { silent = true },
            descriptions = "Fold less",
        },
        {
            mode = { "n" },
            lhs = "zm",
            rhs = function()
                require("ufo").closeFoldsWith()
            end,
            options = { silent = true },
            descriptions = "Fold more",
        },
    })
end

return M
