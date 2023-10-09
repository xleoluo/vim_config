local M = {}

M.lazy = {}

M.mason = {
    "prettier",
}

M.treesitter = {
    "css",
}

M.lspconfig = {
    server = "cssls",
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
