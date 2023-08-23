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
    vim.lsp.inlay_hint(0, inlay_hint)
end

function M.toggle_sigature_help()
    for _, opts in ipairs(api.fn.get_all_window_buffer_filetype()) do
        if opts.buf_ft == lsp_hover_filetype.signature then
            vim.api.nvim_win_close(opts.win_id, false)
            return
        end
    end
    vim.lsp.buf.signature_help()
end

function M.scroll_docs_to_up(map)
    local cache_scrolloff = vim.opt.scrolloff:get()

    return function()
        for _, opts in ipairs(api.fn.get_all_window_buffer_filetype()) do
            if
                vim.tbl_contains(
                    vim.tbl_values(lsp_hover_filetype),
                    opts.buf_ft
                )
            then
                local window_height = vim.api.nvim_win_get_height(opts.win_id)
                local cursor_line = vim.api.nvim_win_get_cursor(opts.win_id)[1]
                local buffer_total_line =
                    vim.api.nvim_buf_line_count(opts.buf_id)
                ---@diagnostic disable-next-line: redundant-parameter
                local win_first_line = vim.fn.line("w0", opts.win_id)

                if
                    buffer_total_line + 1 <= window_height
                    or cursor_line == 1
                then
                    vim.api.nvim_echo(
                        { { "Can't scroll up", "WarningMsg" } },
                        false,
                        {}
                    )
                    return
                end

                vim.opt.scrolloff = 0

                if cursor_line > win_first_line then
                    if win_first_line - 5 > 1 then
                        vim.api.nvim_win_set_cursor(
                            opts.win_id,
                            { win_first_line - 5, 0 }
                        )
                    else
                        vim.api.nvim_win_set_cursor(opts.win_id, { 1, 0 })
                    end
                elseif cursor_line - 5 < 1 then
                    vim.api.nvim_win_set_cursor(opts.win_id, { 1, 0 })
                else
                    vim.api.nvim_win_set_cursor(
                        opts.win_id,
                        { cursor_line - 5, 0 }
                    )
                end

                vim.opt.scrolloff = cache_scrolloff

                return
            end
        end

        local key = vim.api.nvim_replace_termcodes(map, true, false, true)
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.api.nvim_feedkeys(key, "n", true)
    end
end

function M.scroll_docs_to_down(map)
    local cache_scrolloff = vim.opt.scrolloff:get()

    return function()
        for _, opts in ipairs(api.fn.get_all_window_buffer_filetype()) do
            if
                vim.tbl_contains(
                    vim.tbl_values(lsp_hover_filetype),
                    opts.buf_ft
                )
            then
                local window_height = vim.api.nvim_win_get_height(opts.win_id)
                local cursor_line = vim.api.nvim_win_get_cursor(opts.win_id)[1]
                local buffer_total_line =
                    vim.api.nvim_buf_line_count(opts.buf_id)
                ---@diagnostic disable-next-line: redundant-parameter
                local window_last_line = vim.fn.line("w$", opts.win_id)

                if
                    buffer_total_line + 1 <= window_height
                    or cursor_line == buffer_total_line
                then
                    vim.api.nvim_echo(
                        { { "Can't scroll down", "WarningMsg" } },
                        false,
                        {}
                    )
                    return
                end

                vim.opt.scrolloff = 0

                if cursor_line < window_last_line then
                    if window_last_line + 5 < buffer_total_line then
                        vim.api.nvim_win_set_cursor(
                            opts.win_id,
                            { window_last_line + 5, 0 }
                        )
                    else
                        vim.api.nvim_win_set_cursor(
                            opts.win_id,
                            { buffer_total_line, 0 }
                        )
                    end
                elseif cursor_line + 5 >= buffer_total_line then
                    vim.api.nvim_win_set_cursor(
                        opts.win_id,
                        { buffer_total_line, 0 }
                    )
                else
                    vim.api.nvim_win_set_cursor(
                        opts.win_id,
                        { cursor_line + 5, 0 }
                    )
                end

                vim.opt.scrolloff = cache_scrolloff

                return
            end
        end

        local key = vim.api.nvim_replace_termcodes(map, true, false, true)
        ---@diagnostic disable-next-line: param-type-mismatch
        vim.api.nvim_feedkeys(key, "n", true)
    end
end

return M
