---@diagnostic disable: undefined-global

local M = {}

function M.get_all_window_buffer_filetype()
    return vim.tbl_map(function(win_id)
        if vim.api.nvim_win_is_valid(win_id) then
            local buf_id = vim.api.nvim_win_get_buf(win_id)
            local buf_ft = vim.api.nvim_buf_get_option(buf_id, "filetype")
            return {
                win_id = win_id,
                buf_id = buf_id,
                buf_ft = buf_ft,
            }
        end
    end, vim.api.nvim_list_wins())
end

-- Get all can require module from directory
function M.get_package_from_directory(dir_path, ignore_package_array)
    ignore_package_array = ignore_package_array or {}

    -- allow ignore init.lua
    table.insert(ignore_package_array, "init")

    local package_dirs = vim.fn.globpath(dir_path, "*", false, true)
    local package_mapping = {}

    local root_path =
        table.concat(vim.tbl_flatten({ vim.fn.stdpath("config"), "lua" }), "/")

    for _, pack_path in ipairs(package_dirs) do
        local pack_name = vim.fn.fnamemodify(pack_path, ":t:r")
        if not vim.tbl_contains(ignore_package_array, pack_name) then
            local require_path = table
                .concat(vim.tbl_flatten(
                    { dir_path:sub(#root_path + 2), "/", pack_name },
                    ---@diagnostic disable-next-line: redundant-parameter
                    "/"
                ))
                :gsub("//", "/")
            local pack = require(require_path)

            assert(
                type(pack) == "table",
                ("Invalid pack <%s>, expected <table> but got <%s>"):format(
                    pack_name,
                    type(pack)
                )
            )
            ---@diagnostic disable-next-line: need-check-nil
            package_mapping[pack_name] = pack
        end
    end

    return package_mapping
end

-- Find element index from table
function M.tbl_find_index(tbl, element)
    local index = 0
    for i, v in ipairs(tbl) do
        if v == element then
            index = i
            break
        end
    end
    return index
end

-- Creating a simple setTimeout wrapper
function M.setTimeout(timeout, callback)
    local timer = vim.loop.new_timer()
    timer:start(timeout, 0, function()
        timer:stop()
        timer:close()
        callback()
    end)
    return timer
end

-- Creating a simple setInterval wrapper
function M.setInterval(interval, callback)
    local timer = vim.loop.new_timer()
    timer:start(interval, interval, function()
        callback()
    end)
    return timer
end

-- And clearInterval
function M.clearInterval(timer)
    timer:stop()
    timer:close()
end

return M
