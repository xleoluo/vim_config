local M = {}

M.lazys = {}

M.mason = {
    "prettier",
}

M.treesitter = {
    "html",
}

M.lspconfig = {
    server = "html",
    config = {},
}

M.dapconfig = {
    config = {},
}

M.null_ls = {
    formatting = {
        exe = "prettier",
        extra_args = {},
        enable = true
    }
}

return M
