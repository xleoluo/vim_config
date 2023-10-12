local api = require("utils.api")

local M = {}

M.lazys = {}

M.mason = {
    "prettier",
}

M.treesitter = {
    "vue",
}

M.lspconfig = {
    server = "vuels",
    config = api.path.generate_relative_path("./vuels"),
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
