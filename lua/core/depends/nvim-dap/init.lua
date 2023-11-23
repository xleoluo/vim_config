-- https://github.com/mfussenegger/nvim-dap

local api = require("utils.api")
local aux = require("core.depends.nvim-dap.aux")

local M = {}

M.lazy = {
    "mfussenegger/nvim-dap",
    dependencies = {
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
    },
    lazy = true,
}

function M.init()
    M.dap = require("dap")
    M.dapui = require("dapui")
    M.nvim_dap_virtual_text = require("nvim-dap-virtual-text")
    ---
    aux.init(M.dap, M.dapui, M.nvim_dap_virtual_text)
end

function M.load()
    for _, lang_pack in ipairs(api.get_lang().get_lang_pack()) do
        if "string" == type(lang_pack.dapconfig.config) then
            local dapconfig = require(lang_pack.dapconfig.config)
            M.dap.adapters =
                vim.tbl_deep_extend("force", M.dap.adapters, dapconfig.adapters)
            M.dap.configurations = vim.tbl_deep_extend(
                "force",
                M.dap.configurations,
                dapconfig.configurations
            )
        end
    end
end

function M.after() end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>db",
            rhs = function()
                require("dap").toggle_breakpoint()
            end,
            options = { silent = true },
            description = "Mark or delete breakpoints",
        },
        {
            mode = { "n" },
            lhs = "<leader>dc",
            rhs = function()
                require("dap").clear_breakpoints()
            end,
            options = { silent = true },
            description = "Clear breakpoints in the current buffer",
        },
        {
            mode = { "n" },
            lhs = "<F5>",
            rhs = function()
                require("dap").continue()
            end,
            options = { silent = true },
            description = "Enable debugging or jump to the next breakpoint",
        },
        {
            mode = { "n" },
            lhs = "<F6>",
            rhs = function()
                require("dap").step_into()
            end,
            options = { silent = true },
            description = "Step into",
        },
        {
            mode = { "n" },
            lhs = "<F7>",
            rhs = function()
                ---@diagnostic disable-next-line: missing-parameter
                require("dap").step_over()
            end,
            options = { silent = true },
            description = "Step over",
        },
        {
            mode = { "n" },
            lhs = "<F8>",
            rhs = function()
                require("dap").step_out()
            end,
            options = { silent = true },
            description = "Step out",
        },
        {
            mode = { "n" },
            lhs = "<F9>",
            rhs = function()
                require("dap").run_last()
            end,
            options = { silent = true },
            description = "Rerun debug",
        },
        {
            mode = { "n" },
            lhs = "<F10>",
            rhs = function()
                require("dap").terminate()
            end,
            options = { silent = true },
            description = "Close debug",
        },
        --- dapui
        {
            mode = { "n" },
            lhs = "<leader>du",
            rhs = function()
                ---@diagnostic disable-next-line: missing-parameter
                require("dapui").toggle()
            end,
            options = { silent = true },
            description = "Toggle debug ui",
        },
        {
            mode = { "n" },
            lhs = "<leader>de",
            rhs = function()
                for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                    if
                        vim.api.nvim_buf_get_option(bufnr, "filetype")
                        == "dapui_hover"
                    then
                        ---@diagnostic disable-next-line: missing-parameter
                        require("dapui").eval()
                        return
                    end
                end
                ---@diagnostic disable-next-line: missing-parameter
                require("dapui").eval(vim.fn.input("Enter debug expression: "))
            end,
            options = { silent = true },
            description = "Execute debug expressions",
        },
    })
end

return M
