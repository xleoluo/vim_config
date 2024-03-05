-- https://github.com/j-hui/fidget.nvim

local M = {}

M.lazy = {
    "j-hui/fidget.nvim",
    priority = 80,
}

local IGNORE_MESSAGE = {
    "textDocument/documentColor is not supported",
}

function M.init()
    M.fidget = require("fidget")
end

function M.load()
    M.fidget.setup({
        progress = {
            display = {
                render_limit = 2,
                done_style = "SpecialKey",
                progress_style = "SpecialKey",
                group_style = "Title",
                icon_style = "Title",
            },
        },
        notification = {
            override_vim_notify = true,
            -- How to configure notification groups when instantiated
            configs = {
                default = require("fidget.notification").default_config,
            },

            -- Conditionally redirect notifications to another backend
            redirect = function(msg, level, opts)
                for _, match in ipairs(IGNORE_MESSAGE) do
                    if msg:find(match) then
                        return true
                    end
                end
                if opts and opts.on_open then
                    return require("fidget.integration.nvim-notify").delegate(
                        msg,
                        level,
                        opts
                    )
                end
            end,
            window = {
                normal_hl = "SpecialKey",
                winblend = 0,
            },
            view = {
                stack_upwards = true,
                icon_separator = " ",
                group_separator = "---",
                group_separator_hl = "SpecialKey",
            },
        },
    })
end

function M.after()
    vim.api.nvim_create_user_command("FidgetHistory", function(ctx)
        require("fidget.notification").show_history()
    end, { desc = "Show fidget history" })
end

return M
