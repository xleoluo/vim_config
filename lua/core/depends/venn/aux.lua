local api = require("utils.api")

local M = {}

function M.init(venn)
    M.venn = venn

end

function M.register_buf_maps(bufnr)
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<c-j>",
            rhs = "<c-v>j:VBox<cr>",
            options = { silent = true, buffer = bufnr },
            description = "Draw line to down",
        },
        {
            mode = { "n" },
            lhs = "<c-k>",
            rhs = "<c-v>k:VBox<cr>",
            options = { silent = true, buffer = bufnr },
            description = "Draw line to up",
        },
        {
            mode = { "n" },
            lhs = "<c-l>",
            rhs = "<c-v>l:VBox<cr>",
            options = { silent = true, buffer = bufnr },
            description = "Draw line to left",
        },
        {
            mode = { "n" },
            lhs = "<c-h>",
            rhs = "<c-v>h:VBox<cr>",
            options = { silent = true, buffer = bufnr },
            description = "Draw line to right",
        },
        {
            mode = { "v" },
            lhs = "b",
            rhs = ":VBox<cr>",
            options = { silent = true, buffer = bufnr },
            description = "Draw hollow box",
        },
        {
            mode = { "v" },
            lhs = "f",
            rhs = ":VFill<cr>",
            options = { silent = true, buffer = bufnr },
            description = "Draw solid box",
        },
    })
end

return M
