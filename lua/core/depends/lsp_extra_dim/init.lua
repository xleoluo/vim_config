-- https://github.com/askfiy/lsp_extra_dim
local M = {}

M.lazy = {
    "askfiy/lsp_extra_dim",
    event = { "LspAttach" },
}

function M.init()
    M.lsp_extra_dim = require("lsp_extra_dim")
end

function M.load()
    M.lsp_extra_dim.setup()
end

function M.after() end

return M
