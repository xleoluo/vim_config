local api = require("utils.api")

local M = {}

M.lazys = {}

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
        enable = true,
    },
}

M.code_runner = {
    filetype = { "c", "cpp" },
    command = function()
        local source_path = vim.fn.expand("%:p")
        local binary_path = vim.fn.expand("%:p:r")
        local command = ("gcc -fdiagnostics-color=always -g %s -o %s"):format(
            source_path,
            binary_path
        )
        vim.fn.jobstart(command)
        vim.cmd("sleep 200m")
        return binary_path
    end,
}

return M
