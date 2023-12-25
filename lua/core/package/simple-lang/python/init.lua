local api = require("utils.api")

local M = {}

M.lazys = {
    {
        "Vimjas/vim-python-pep8-indent",
        ft = { "python" },
    },
}

M.mason = {
    "autopep8",
    "pylint",
    "debugpy",
}

M.treesitter = {
    "python",
    "requirements",
    "htmldjango",
}

M.lspconfig = {
    -- server = "pyright",
    -- config = api.path.generate_relative_path("./pyright"),
    -----
    server = "pylance",
    config = api.path.generate_relative_path("./pylance"),
}

M.dapconfig = {
    config = api.path.generate_relative_path("./dapconfig"),
}

M.null_ls = {
    formatting = {
        exe = "autopep8",
        extra_args = {
            "-a",
            "--max-line-length=120",
        },
        enable = true,
    },
    diagnostics = {
        exe = "pylint",
        extra_args = {
            "--rcfile=" .. api.path.generate_absolute_path("./linter/pylintrc"),
        },
        enable = false,
    },
}

M.code_runner = {
    filetype = { "python" },
    command = function()
        local root_dir = vim.lsp.buf.list_workspace_folders()[1]
        local config_file = api.path.join(root_dir, ".run.json")

        if config_file then
            if api.path.exists(config_file) then
                local conf_content = vim.json.decode(api.file.read(config_file))
                local execute_script = conf_content["execute"]
                if execute_script then
                    return ("%s %s"):format("python3", execute_script)
                end
            end
        end

        return ("python3 %s"):format(vim.fn.expand("%:p"))
    end,
}

return M
