local M = {}

function M.init(dap, dapui, nvim_dap_virtual_text)
    --
    nvim_dap_virtual_text.setup()
    --
    dapui.setup({
        layouts = {
            {
                elements = {
                    -- elements can be strings or table with id and size keys.
                    "scopes",
                    "breakpoints",
                    "stacks",
                    "watches",
                },
                size = 30,
                position = "right",
            },
            {
                elements = {
                    "repl",
                    "console",
                },
                size = 10,
                position = "bottom",
            },
        },
    })

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
        ---@diagnostic disable-next-line: missing-parameter
        dapui.close()
        dap.repl.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
        dap.repl.close()
    end
end

return M
