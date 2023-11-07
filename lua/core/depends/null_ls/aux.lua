local api = require("utils.api")

local M = {}

function M.init(null_ls, cspell, cspell_helpers)
    M.null_ls = null_ls
    M.cspell = cspell
    M.cspell_helpers = cspell_helpers
end

-- cspell
local function get_cspell_disabled_filetypes()
    return { "NvimTree" }
end

local function get_cspell_conf()
    return {
        ---@diagnostic disable-next-line: unused-local
        find_json = function(default_path)
            return api.get_setting().get_cspell_conf_path()
        end,
    }
end
--

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
        {
            mode = { "n" },
            lhs = "zg",
            rhs = function()
                local word = vim.fn.expand("<cword>")
                local file_name = api.get_setting().get_cspell_conf_path()
                local content = vim.json.decode(api.file.read(file_name))
                if not vim.tbl_contains(content.words, word) then
                    table.insert(content.words, word)
                    api.file.write(file_name, vim.json.encode(content))

                    local pos = vim.api.nvim_win_get_cursor(0)
                    M.cspell_helpers.set_word({
                        bufnr = 0,
                        col = pos[2],
                        end_col = pos[2] + #word,
                        end_lnum = pos[1] - 1,
                        lnum = pos[1] - 1,
                    }, word)
                else
                    vim.api.nvim_echo({
                        {
                            ("'%s' already exists in the word dictionary"):format(
                                word
                            ),
                            "WarningMsg",
                        },
                    }, false, {})
                end
            end,
            options = { silent = true },
            description = "Add word to cspell.json",
        },
        {
            mode = { "n" },
            lhs = "zw",
            rhs = function()
                local word = vim.fn.expand("<cword>")
                local file_name = api.get_setting().get_cspell_conf_path()
                local content = vim.json.decode(api.file.read(file_name))
                if vim.tbl_contains(content.words, word) then
                    table.remove(
                        content.words,
                        api.fn.tbl_find_index(content.words, word)
                    )
                    api.file.write(file_name, vim.json.encode(content))

                    local pos = vim.api.nvim_win_get_cursor(0)
                    M.cspell_helpers.set_word({
                        bufnr = 0,
                        col = pos[2],
                        end_col = pos[2] + #word,
                        end_lnum = pos[1] - 1,
                        lnum = pos[1] - 1,
                    }, word)
                else
                    vim.api.nvim_echo({
                        {
                            ("'%s' does not exist in the word dictionary"):format(
                                word
                            ),
                            "WarningMsg",
                        },
                    }, false, {})
                end
            end,
            options = { silent = true },
            description = "Del word to cspell.json",
        },
    })
end

function M.get_sources()
    local cspell_conf = get_cspell_conf()
    return {
        M.cspell.code_actions.with({
            config = cspell_conf,
            disabled_filetypes = get_cspell_disabled_filetypes(),
            runtime_condition = api.get_setting().is_code_spell,
        }),
        M.cspell.diagnostics.with({
            diagnostics_postprocess = function(diagnostic)
                diagnostic.severity = vim.diagnostic.severity["HINT"]
            end,
            config = cspell_conf,
            disabled_filetypes = get_cspell_disabled_filetypes(),
            runtime_condition = api.get_setting().is_code_spell,
        }),
    }
end

return M
