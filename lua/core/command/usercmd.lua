local api = require("utils.api")

local timer = nil

vim.api.nvim_create_user_command("BufferDelete", function(ctx)
    ---@diagnostic disable-next-line: missing-parameter
    local file_exists = vim.fn.filereadable(vim.fn.expand("%p"))
    local modified = vim.api.nvim_buf_get_option(0, "modified")

    if 0 == file_exists and modified then
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

vim.api.nvim_create_user_command("OpenUserConfigFile", function(ctx)
    local user_config_file_path =
        api.path.join(vim.fn.stdpath("config"), "lua", "conf", "config.lua")
    vim.cmd((":e %s"):format(user_config_file_path))
end, { desc = "Open user config file" })

vim.api.nvim_create_user_command("OpenUserSpellFile", function(ctx)
    vim.cmd((":e %s"):format(api.get_setting().get_cspell_conf_path()))
end, { desc = "Open user config file" })

vim.api.nvim_create_user_command("OpenUserSnippetFile", function(ctx)
    local snippet_file_name = vim.opt.filetype:get() .. ".json"
    local snippet_file_path =
        api.path.join(vim.fn.stdpath("config"), "snippets", snippet_file_name)
    vim.cmd((":e %s"):format(snippet_file_path))
end, { desc = "Open user snippet file from current filetype" })

vim.api.nvim_create_user_command("AutoReload", function(ctx)
    if not timer then
        local interval = 1000
        timer = api.fn.setInterval(
            interval,
            vim.schedule_wrap(function()
                vim.cmd([[checktime]])
                vim.cmd([[normal G]])
            end)
        )
    else
        api.fn.clearInterval(timer)
        timer = nil
    end
end, { desc = "Start Automatically flush the buffer" })

vim.api.nvim_create_user_command("CreateRunConf", function(ctx)
    local filepath = api.path.join(vim.fn.expand("%:p:h"), ".run.json")
    if not api.path.exists(filepath) then
        api.file.write(filepath, '{\n  "execute": ""\n}')
    end
    vim.cmd("e " .. filepath)
end, { desc = "Create Runner config file" })
