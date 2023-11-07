local api = require("utils.api")

local M = {}

function M.init(null_ls, cspell)
    M.null_ls = null_ls
    M.cspell = cspell
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
function M.get_sources()
    local cspell_conf = get_cspell_conf()

    return {
        M.cspell.code_actions.with({
            config = cspell_conf,
            disabled_filetypes = get_cspell_disabled_filetypes(),
            runtime_condition = api.get_setting().is_code_spell
        }),
        M.cspell.diagnostics.with({
            diagnostics_postprocess = function(diagnostic)
                diagnostic.severity = vim.diagnostic.severity["HINT"]
            end,
            config = cspell_conf,
            disabled_filetypes = get_cspell_disabled_filetypes(),
            runtime_condition = api.get_setting().is_code_spell
        }),
    }
end

return M
