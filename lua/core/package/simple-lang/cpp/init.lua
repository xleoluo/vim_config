local api = require("utils.api")

local M = {}

M.lazy = {}

M.mason = {
    "clang-format",
    "cpptools",
}

M.treesitter = {
    "c",
    "cpp",
    "cmake",
}

M.lspconfig = {
    server = "clangd",
    config = api.path.generate_relative_path("./clangd"),
}

M.dapconfig = {
    config = api.path.generate_relative_path("./dapconfig"),
}

M.null_ls = {
    formatting = {
        exe = "clang_format",
        extra_args = {
            "--style",
            "{IndentWidth: 4}",
        },
        enable = true
    }
}

return M
