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

return M
