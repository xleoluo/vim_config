local api = require("utils.api")

local M = {}

function M.on_attach(bufnr)
    require("nvim-tree.api").config.mappings.default_on_attach(bufnr)

    api.map.unregister("n", "g?", { buffer = bufnr })
    api.map.unregister("n", "<c-x>", { buffer = bufnr })

    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "?",
            rhs = require("nvim-tree.api").tree.toggle_help,
            options = { silent = true, buffer = bufnr, nowait = true },
            description = "Toggle help document",
        },
        {
            mode = { "n" },
            lhs = "<c-s>",
            rhs = require("nvim-tree.api").node.open.horizontal,
            options = { silent = true, buffer = bufnr, nowait = true },
            description = "Open: Horizontal Spli",
        },
    })
end

return M
