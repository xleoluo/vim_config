local cspell = require("core.depends.null_ls.cspell")

local M = {}

function M.init(null_ls)
    M.null_ls = null_ls
    cspell.init(M.null_ls)
end

--

function M.get_sources()
    return {
        cspell.get_source(),
    }
end

function M.register_maps()
    cspell.register_maps()
end

return M
