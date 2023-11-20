-- https://github.com/Wansmer/symbol-usage.nvim

local M = {}

M.lazy = {
    "Wansmer/symbol-usage.nvim",
    dependencies = {
        { "neovim/nvim-lspconfig" },
    },
    event = "LspAttach",
}

function M.init()
    M.symbol_usage = require("symbol-usage")
end

function M.load()
    local symbol_kind = vim.lsp.protocol.SymbolKind
    M.symbol_usage.setup({
        hl = { link = "DiagnosticUnnecessary" },
        -- 'above'|'end_of_line'|'textwidth'
        vt_position = "end_of_line",
        disable = { filetypes = { "vue" } },
    })
end

function M.after() end

return M
