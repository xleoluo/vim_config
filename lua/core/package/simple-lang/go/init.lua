local api = require("utils.api")

local M = {}

M.lazys = {}

M.mason = {
    "delve",
}

M.treesitter = {
    "go",
    "gomod",
    "gosum",
    "gowork",
}

M.lspconfig = {
    server = "gopls",
    config = {},
}

M.dapconfig = {
    config = api.path.generate_relative_path("./dapconfig"),
}

M.null_ls = {
    formatting = {
        exe = "gofmt",
        extra_args = {},
        enable = true,
    },
}

M.code_runner = {
    filetype = { "go" },
    command = function()
        return "go run ."
    end,
}

return M
