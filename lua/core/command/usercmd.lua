local api = require("utils.api")

vim.api.nvim_create_user_command("BufferDelete", function(ctx)
    ---@diagnostic disable-next-line: missing-parameter
    local file_exists = vim.fn.filereadable(vim.fn.expand("%p"))
    local modified = vim.api.nvim_buf_get_option(0, "modified")

    if file_exists == 0 and modified then
        local user_choice = vim.fn.input(
            "The file is not saved, whether to force delete? Press enter or input [y/n]:"
        )
        if user_choice == "y" or user_choice:len() == 0 then
            vim.cmd("bd!")
        end
        return
    end

    local force = not vim.bo.buflisted or vim.bo.buftype == "nofile"

    vim.cmd(
        force and "bd!"
            or ("bp | bd! %s"):format(vim.api.nvim_get_current_buf())
    )
end, { desc = "Delete the current Buffer while maintaining the window layout" })

vim.api.nvim_create_user_command("OpenUserSnippetFile", function(ctx)
    local snippet_file_name = vim.bo.filetype .. ".json"
    local snippet_file_path =
        api.path.join(vim.fn.stdpath("config"), "snippets", snippet_file_name)
    vim.cmd((":e %s"):format(snippet_file_path))
end, { desc = "Open user snippet file from current filetype" })
