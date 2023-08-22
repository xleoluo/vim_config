-- https://github.com/creativenull/efmls-configs-nvim

local aux = require("core.depends.efmls-configs-nvim.aux")

local M = {}

M.lazy = {
    "creativenull/efmls-configs-nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
    },
}

function M.init()
    M.lspconfig = require("lspconfig")
end

function M.load()
    local languages = aux.get_efmls_conf()

    M.lspconfig.efm.setup({
        on_attach = function(client, bufnr)
            aux.progress_notify(client.id, "Analyse workspace")
        end,
        init_options = {
            documentFormatting = true,
            documentRangeFormatting = true,
        },
        filetypes = vim.tbl_keys(languages),
        settings = {
            languages = languages,
        },
    })
end

function M.after()
    local format_fn = vim.lsp.buf.format

    ---@diagnostic disable-next-line: duplicate-set-field
    vim.lsp.buf.format = function(...)
        format_fn({ ... })
        for _, client in ipairs(vim.lsp.get_clients()) do
            if client.name == "efm" then
                aux.progress_notify(client.id, aux.get_efmls_formatter_name())
            end
        end
    end
end

return M
