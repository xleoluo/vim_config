local M = {}

M.lazys = {}

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
        enable = true,
    },
}

M.code_runner = {
    filetype = { "sh" },
    command = function()
        return ("sh %s"):format(vim.fn.expand("%:p"))
    end,
}

return M
