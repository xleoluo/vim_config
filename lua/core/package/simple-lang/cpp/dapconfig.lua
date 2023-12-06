-- https://github.com/Microsoft/vscode-cpptools

local configurations = {
    {
        name = "Launch file",
        type = "cppdbg",
        request = "launch",
        program = function()
            local source_path = vim.fn.expand("%:p")
            local binary_path = vim.fn.expand("%:p:r")
            local command = ("gcc -fdiagnostics-color=always -g %s -o %s"):format(
                source_path,
                binary_path
            )
            vim.fn.jobstart(command)
            return binary_path
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
    },
}

return {
    adapters = {
        cppdbg = {
            id = "cppdbg",
            type = "executable",
            -- Linux
            command = "OpenDebugAD7",
        },
    },
    configurations = {
        c = vim.deepcopy(configurations),
        cpp = vim.deepcopy(configurations),
    },
}
