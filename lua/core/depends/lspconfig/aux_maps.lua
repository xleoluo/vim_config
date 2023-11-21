local api = require("utils.api")

local M = {}

local inlay_hint = api.get_setting().is_lspconfig_inlay_hint()
local float_border_style = api.get_setting().get_float_border("rounded")

local lsp_hover_filetype = {
    hover = "lsp-hover",
    signature = "lsp-signature-help",
}

-------------------------------------------------------------------------------

function M.goto_prev_diagnostic()
    vim.diagnostic.goto_prev({
        float = { border = float_border_style },
    })
end

function M.goto_next_diagnostic()
    vim.diagnostic.goto_next({
        float = { border = float_border_style },
    })
end

function M.diagnostic_open_float()
    vim.diagnostic.open_float({
        border = float_border_style,
    })
end

function M.toggle_inlay_hint()
    inlay_hint = not inlay_hint
    vim.lsp.inlay_hint.enable(0, inlay_hint)
end

function M.toggle_sigature_help()
    for _, object in ipairs(api.fn.get_all_window_buffer_filetype()) do
        if object.filetype == lsp_hover_filetype.signature then
            vim.api.nvim_win_close(object.winner, false)
            return
        end
    end
    vim.lsp.buf.signature_help()
end

function M.scroll_docs_to_up(map, scroll)
    local cache_scrolloff = vim.opt.scrolloff:get()

    return function()
        for _, object in ipairs(api.fn.get_all_window_buffer_filetype()) do
            if
                vim.tbl_contains(
                    vim.tbl_values(lsp_hover_filetype),
                    object.filetype
                )
            then
                local cursor_line = vim.fn.line(".", object.winner)
                local buffer_total_line =
                    vim.api.nvim_buf_line_count(object.bufnr)
                local window_height = vim.api.nvim_win_get_height(object.winner)
                local win_first_line = vim.fn.line("w0", object.winner)

                if window_height >= buffer_total_line or cursor_line == 1 then
                    -- vim.api.nvim_echo(
                    --     { { "Can't scroll up", "WarningMsg" } },
                    --     false,
                    --     {}
                    -- )
                    return
                end

                vim.opt.scrolloff = 0

                if cursor_line > win_first_line then
                    if win_first_line - scroll > 1 then
                        vim.api.nvim_win_set_cursor(
                            object.winner,
                            { win_first_line - scroll, 0 }
                        )
                    else
                        vim.api.nvim_win_set_cursor(object.winner, { 1, 0 })
                    end
                elseif cursor_line - scroll < 1 then
                    vim.api.nvim_win_set_cursor(object.winner, { 1, 0 })
                else
                    vim.api.nvim_win_set_cursor(
                        object.winner,
                        { cursor_line - scroll, 0 }
                    )
                end
                vim.opt.scrolloff = cache_scrolloff

                api.fn.generate_win_percentage_footer(
                    "up",
                    object.winner,
                    object.bufnr
                )
                return
            end
        end

        local key = vim.api.nvim_replace_termcodes(map, true, false, true)
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.api.nvim_feedkeys(key, "n", true)
    end
end

function M.scroll_docs_to_down(map, scroll)
    local cache_scrolloff = vim.opt.scrolloff:get()

    return function()
        for _, object in ipairs(api.fn.get_all_window_buffer_filetype()) do
            if
                vim.tbl_contains(
                    vim.tbl_values(lsp_hover_filetype),
                    object.filetype
                )
            then
                local cursor_line = vim.fn.line(".", object.winner)
                local buffer_total_line =
                    vim.api.nvim_buf_line_count(object.bufnr)
                local window_height = vim.api.nvim_win_get_height(object.winner)
                local window_last_line = vim.fn.line("w$", object.winner)

                if
                    window_height >= buffer_total_line
                    or cursor_line == buffer_total_line
                then
                    -- vim.api.nvim_echo(
                    --     { { "Can't scroll down", "WarningMsg" } },
                    --     false,
                    --     {}
                    -- )
                    return
                end

                vim.opt.scrolloff = 0

                if cursor_line < window_last_line then
                    if window_last_line + scroll < buffer_total_line then
                        vim.api.nvim_win_set_cursor(
                            object.winner,
                            { window_last_line + scroll, 0 }
                        )
                    else
                        vim.api.nvim_win_set_cursor(
                            object.winner,
                            { buffer_total_line, 0 }
                        )
                    end
                elseif cursor_line + scroll >= buffer_total_line then
                    vim.api.nvim_win_set_cursor(
                        object.winner,
                        { buffer_total_line, 0 }
                    )
                else
                    vim.api.nvim_win_set_cursor(
                        object.winner,
                        { cursor_line + scroll, 0 }
                    )
                end

                vim.opt.scrolloff = cache_scrolloff

                api.fn.generate_win_percentage_footer(
                    "down",
                    object.winner,
                    object.bufnr
                )
                return
            end
        end

        local key = vim.api.nvim_replace_termcodes(map, true, false, true)
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.api.nvim_feedkeys(key, "n", true)
    end
end

return M
