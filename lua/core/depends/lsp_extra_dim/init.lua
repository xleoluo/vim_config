-- https://github.com/askfiy/lsp_extra_dim

local api = require("utils.api")

local M = {}

M.lazy = {
    "askfiy/lsp_extra_dim",
    event = { "LspAttach" },
}

function M.init()
    M.lsp_extra_dim = require("lsp_extra_dim")
end

function M.load()
    M.lsp_extra_dim.setup({
        disable_diagnostic_style = {
            "parameter",
        },
        hooks = {
            lsp_filter = function(diagnostics, create_mark)
                return vim.tbl_filter(function(diagnostic)
                    ---
                    if
                        api.get_lang().has_language("lua")
                        and diagnostic.code == "unused-function"
                    then
                        return false
                    end
                    ---
                    if
                        api.get_lang().has_language("python")
                        and diagnostic.message:find(".*is not accessed.*")
                            ~= nil
                    then
                        create_mark(diagnostic)
                        return false
                    end

                    return true
                end, diagnostics)
            end,
        },
    })
end

function M.after() end

return M
