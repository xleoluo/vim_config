local M = {}

M.lazys = {
    {
        "askfiy/neovim-easy-less",
        ft = { "less" },
        config = function()
            require("easy-less").setup()
        end,
    },
}

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
        enable = true,
    },
}

return M
