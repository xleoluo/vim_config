local api = require("utils.api")

local M = {}

function M.init(null_ls)
    M.null_ls = null_ls
end

-- cspell
local function get_cspell_disabled_filetypes()
    return { "NvimTree" }
end

local function get_cspell_conf()
    return {
        "--config",
        api.get_setting().get_cspell_conf_path(),
    }
end

local function safe_reset_virtual_text(text, position)
    local pos = vim.api.nvim_win_get_cursor(0)
    local col, end_col =
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.api.nvim_get_current_line():find(text)
    pcall(
        vim.api.nvim_buf_set_text,
        0, -- bufnr
        pos[1] - 1, -- start_row
        col - 1, -- start_col
        pos[1] - 1, -- end_row
        end_col, -- end_col
        ---@diagnostic disable-next-line: assign-type-mismatch
        { text }
    )
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
                    -- reset virtual text
                    safe_reset_virtual_text(word)
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
                    -- reset virtual text
                    safe_reset_virtual_text(word)
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
    return {
        M.null_ls.builtins.diagnostics.cspell.with({
            diagnostics_postprocess = function(diagnostic)
                diagnostic.severity = vim.diagnostic.severity["HINT"]
            end,
            extra_args = get_cspell_conf(),
            disabled_filetypes = get_cspell_disabled_filetypes(),
            runtime_condition = api.get_setting().is_code_spell,
        }),
    }
end

return M
