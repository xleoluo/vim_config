-- https://github.com/nvimtools/none-ls.nvim

local api = require("utils.api")
local aux = require("core.depends.null_ls.aux")

local M = {}

M.lazy = {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "neovim/nvim-lspconfig" },
        { "davidmh/cspell.nvim" },
    },
}

function M.init()
    M.null_ls = require("null-ls")
    M.cspell = require("cspell")
    ---
    aux.init(M.null_ls, M.cspell)
end

function M.load()
    local sources = aux.get_sources()

    -- load all sources
    for _, lang_pack in ipairs(api.get_lang().get_lang_pack()) do
        if not vim.tbl_isempty(lang_pack.null_ls) then
            for source_type, source_conf in pairs({
                hover = lang_pack.null_ls.hover,
                formatting = lang_pack.null_ls.formatting,
                completion = lang_pack.null_ls.completion,
                diagnostics = lang_pack.null_ls.diagnostics,
                code_actions = lang_pack.null_ls.code_actions,
            }) do
                if source_conf and source_conf.enable then
                    local null_ls_pack =
                        M.null_ls.builtins[source_type][source_conf.exe]
                    if not vim.tbl_isempty(source_conf.extra_args) then
                        null_ls_pack =
                            M.null_ls.builtins[source_type][source_conf.exe].with({
                                extra_args = source_conf.extra_args,
                            })
                    end
                    if not vim.tbl_contains(sources, null_ls_pack) then
                        table.insert(sources, null_ls_pack)
                    end
                end
            end
        end
    end

    M.null_ls.setup({
        border = api.get_setting().get_float_border("double"),
        sources = sources,
    })
end

function M.after() end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>cs",
            rhs = function()
                local null_query = { name = "cspell" }
                local code_spell = not api.get_setting().is_code_spell()
                if code_spell then
                    M.null_ls.enable(null_query)
                else
                    M.null_ls.disable(null_query)
                end
                api.get_config()["code_spell"] = code_spell
            end,
            options = { silent = true },
            description = "Enable or disable spell checking",
        },
        {

            mode = { "n" },
            lhs = "[s",
            rhs = function()
                vim.diagnostic.goto_prev({
                    namespace = api.lsp.get_diagnostic_namespace_by_name(
                        "cspell"
                    ),
                    float = false,
                })
            end,
            options = { silent = true },
            description = "Go to prev cspell word",
        },
        {

            mode = { "n" },
            lhs = "]s",
            rhs = function()
                vim.diagnostic.goto_next({
                    namespace = api.lsp.get_diagnostic_namespace_by_name(
                        "cspell"
                    ),
                    float = false,
                })
            end,

            options = { silent = true },
            description = "Go to next cspell word",
        },
    })
end

return M
