local M = {}

M.lazy = {}

M.mason = {
    "shfmt",
}

M.treesitter = {
    "bash",
}

M.lspconfig = {
    server = "bashls",
    config = {},
}

M.dapconfig = {
    config = {},
}

M.null_ls = {
    formatting = {
        exe = "shfmt",
        extra_args = {},
        enable = true
    }
}

return M
