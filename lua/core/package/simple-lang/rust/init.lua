local api = require("utils.api")

local M = {}

M.lazys = {}

M.mason = {}

M.treesitter = {
    "rust",
}

M.lspconfig = {
    server = "rust_analyzer",
    config = api.path.generate_relative_path("./rust_analyzer"),
}

M.dapconfig = {
    config = api.path.generate_relative_path("./dapconfig"),
}

M.null_ls = {
    formatting = {
        exe = "rustfmt",
        extra_args = {},
        enable = true,
    },
}

return M
