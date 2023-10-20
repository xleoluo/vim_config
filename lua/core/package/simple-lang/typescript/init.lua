local api = require("utils.api")

local M = {}

M.lazys = {
    {
        "mxsdev/nvim-dap-vscode-js",
        ft = { "javascript", "typescript" },
        config = function()
            require("dap-vscode-js").setup({
                node = "node",
                debugpath = api.path.join(
                    api.get_setting().get_mason_install_path(),
                    "packages",
                    "js-debug-adapter"
                ),
                adapters = {
                    "pwa-node",
                    "pwa-chrome",
                    "pwa-msedge",
                    "node-terminal",
                    "pwa-extensionHost",
                },
            })
        end,
    },
}

M.mason = {
    "prettier",
    "js-debug-adapter",
}

M.treesitter = {
    "javascript",
    "typescript",
}

M.lspconfig = {
    server = "tsserver",
    config = api.path.generate_relative_path("./tsserver"),
}

M.dapconfig = {
    config = api.path.generate_relative_path("./dapconfig"),
}

M.null_ls = {
    formatting = {
        exe = "prettier",
        extra_args = {},
        enable = true,
    },
}

return M
