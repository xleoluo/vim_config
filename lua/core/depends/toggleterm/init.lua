-- https://github.com/akinsho/toggleterm.nvim

local api = require("utils.api")
local aux = require("core.depends.toggleterm.aux")

local M = {}

M.lazy = {
    "akinsho/toggleterm.nvim",
    event = { "UIEnter" },
}

function M.init()
    M.toggleterm = require("toggleterm")
    M.terminal = require("toggleterm.terminal").Terminal
    --
    aux.init(M.terminal)
end

function M.load()
    M.toggleterm.setup({
        start_in_insert = false,
        shade_terminals = true,
        shading_factor = 1,
        on_open = aux.on_open,
        highlights = {
            Normal = {
                link = "Normal",
            },
            NormalFloat = {
                link = "NormalFloat",
            },
            FloatBorder = {
                link = "FloatBorder",
            },
        },
    })
end

function M.after()
    -- CodeRunner implementation
    local runner = api.get_lang().get_code_runner()
    vim.api.nvim_create_user_command("CodeRunner", function(ctx)
        local callback = runner[vim.opt.filetype:get()]
        if callback then
            local count = vim.api.nvim_eval("v:count1")
            -- Add go_back=0 to keep the cursor in term
            local command = ([[exe %d."TermExec cmd='%s' go_back=0"]]):format(
                count,
                callback()
            )
            aux.run_terminal_command(command)
        else
            vim.notify(
                "Not found code runner conf",
                "WARN",
                { annote = "[SimpleNvim]", key = "[SimpleNvim]" }
            )
        end
    end, { desc = "Code Run in toggleterm" })
end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>cr",
            rhs = "<cmd>CodeRunner<cr>",
            options = { silent = true },
            description = "Code running in terminal",
        },
        {
            mode = { "n" },
            lhs = "<leader>tf",
            rhs = aux.toggle_float_terminl,
            options = { silent = true },
            description = "Toggle float terminal",
        },
        {
            mode = { "n" },
            lhs = "<leader>tt",
            rhs = aux.toggle_bottom_terminal,
            options = { silent = true },
            description = "Toggle bottom terminal",
        },
        {
            mode = { "n" },
            lhs = "<leader>tg",
            rhs = aux.toggle_lazygit_terminl,
            options = { silent = true },
            description = "Toggle lazygit terminal",
        },
        {
            mode = { "n" },
            lhs = "<leader>ta",
            rhs = aux.toggle_all_terminal,
            options = { silent = true },
            description = "Toggle all terminal",
        },
    })
end

return M
