---@diagnostic disable: undefined-global

local M = {}

----------------------------------------- build-in fn extends ------------------------------------------
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

-- Get all window-buffer-filetype, return table
function M.get_all_window_buffer_filetype()
    return vim.tbl_map(function(winner)
        if vim.api.nvim_win_is_valid(winner) then
            local bufnr = vim.api.nvim_win_get_buf(winner)
            local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
            return {
                winner = winner,
                bufnr = bufnr,
                filetype = filetype,
            }
        end
    end, vim.api.nvim_list_wins())
end
----------------------------------------- depends plugin auxiliary fn ------------------------------------------
-- Get all plugin ignore filetypes
function M.get_ignore_filetypes(filetypes)
    return vim.tbl_extend("force", {
        "qf",
        "help",
        "lazy",
        "dbui",
        "mason",
        "aerial",
        "notify",
        "lspinfo",
        "NvimTree",
        "toggleterm",
        "spectre_panel",
        "TelescopePrompt",
    }, filetypes or {})
end
-----------------------------------------------------------------------------------
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

-----------------------------------------------------------------------------------

function M.ljust(str, length, fillchar)
    fillchar = fillchar or " "
    local diff = length - #str
    if diff > 0 then
        return str .. string.rep(fillchar, diff)
    else
        return str
    end
end

function M.rjust(str, length, fillchar)
    fillchar = fillchar or " "
    local diff = length - #str
    if diff > 0 then
        return string.rep(fillchar, diff) .. str
    else
        return str
    end
end

function M.center(str, length, fillchar)
    fillchar = fillchar or " "
    local diff = length - #str
    local left = math.floor(diff / 2)
    local right = diff - left

    if diff > 0 then
        return string.rep(fillchar, left) .. str .. string.rep(fillchar, right)
    else
        return str
    end
end
-----------------------------------------------------------------------------------

-- Generate a percent sign page turn indicator
function M.generate_win_percentage_footer(direction, winner, bufnr)
    local cline = vim.fn.line(".", winner)
    local aline = vim.api.nvim_buf_line_count(bufnr)
    local win_height = vim.api.nvim_win_get_height(winner)
    local win_last_line = vim.fn.line("w$", winner)

    local current_percentage

    if "up" == direction and 1 == cline then
        current_percentage = 0
    elseif "down" == direction and aline < win_height then
        current_percentage = 100
    else
        current_percentage = math.floor(win_last_line / aline * 100)
    end

    vim.api.nvim_win_set_config(winner, {
        footer = ("Percentage:%s%%"):format(
            M.rjust(tostring(current_percentage), 3)
        ),
        footer_pos = "right",
    })
end

return M
