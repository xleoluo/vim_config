local M = {}

M.lazy = {}

M.mason = {
    "sql-formatter",
}

M.treesitter = {
    "sql",
}

M.lspconfig = {
    server = "sqlls",
    config = {},
}

M.dapconfig = {
    config = {},
}

M.null_ls = {
    formatting = {
        exe = "sql_formatter",
        extra_args = {
            "-l=postgresql",
        },
        enable = true,
    },
}

return M
