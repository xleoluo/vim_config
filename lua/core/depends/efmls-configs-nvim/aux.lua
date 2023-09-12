-- https://github.com/creativenull/efmls-configs-nvim

local api = require("utils.api")

local M = {}

local defaut_formatter = {
    formatCommand = "defaut formatter",
    formatStdin = true,
}

local default_linter = {
    prefix = "efmls",
    lintSource = "default source",
    lintCommand = "default linter",
    lintFormats = {},
    rootMarkers = {},
    lintStdin = false,
}

function M.progress_notify(client_id, message)
    local fn = vim.lsp.handlers["$/progress"]
    local token = os.time()

    math.randomseed(token)
    local random = math.random(0, 5)

    -- Send the initial progress notification
    fn(nil, {
        token = token,
        value = {
            kind = "begin",
            title = message,
            percentage = 0,
        },
    }, {
        client_id = client_id,
    })

    local function update_progress(w)
        if w < 100 then
            fn(nil, {
                token = token,
                value = {
                    kind = "report",
                    title = message,
                    percentage = w,
                },
            }, {
                client_id = client_id,
            })
            -- Schedule the next update
            vim.defer_fn(function()
                update_progress(w + 1)
            end, random)
        else
            fn(nil, {
                token = token,
                value = {
                    kind = "end",
                    title = message,
                    percentage = 100,
                },
            }, {
                client_id = client_id,
            })
        end
    end

    -- Start the progress updates
    vim.defer_fn(function()
        update_progress(1)
    end, random)
end

function M.get_efmls_conf()
    local fs = require("efmls-configs.fs")

    local efmls_conf = {}

    for _, lang_pack in ipairs(api.get_lang().get_lang_pack()) do
        if not vim.tbl_isempty(lang_pack.efm_ls) then
            local fmt = lang_pack.efm_ls.formatter
            local linter = lang_pack.efm_ls.linter
            for _, filetype in ipairs(lang_pack.efm_ls.filetype) do
                efmls_conf[filetype] = {}

                if fmt.enable then
                    local ok, build_formatter =
                        pcall(require, "efmls-configs.formatters." .. fmt.exe)

                    local fmt_package =
                        vim.deepcopy(ok and build_formatter or defaut_formatter)

                    if not vim.tbl_isempty(fmt.args) then
                        local args = table.concat(fmt.args, " ")
                        ---@diagnostic disable-next-line: missing-parameter
                        local exe = fs.executable(fmt.exe)
                        fmt_package.formatCommand = ("%s %s"):format(exe, args)
                    end

                    table.insert(efmls_conf[filetype], fmt_package)
                end

                if linter.enable then
                    local ok, build_linter =
                        pcall(require, "efmls-configs.linters." .. linter.exe)

                    local linter_package = ok and build_linter or default_linter

                    if not vim.tbl_isempty(linter.args) then
                        local args = table.concat(linter.args, " ")
                        ---@diagnostic disable-next-line: missing-parameter
                        local exe = fs.executable(linter.exe)
                        linter_package.lintCommand = ("%s %s"):format(exe, args)
                        linter_package.lintSource = linter.prefix
                            or linter_package.prefix
                    end

                    table.insert(efmls_conf[filetype], linter_package)
                end
            end
        end
    end

    return efmls_conf
end

function M.get_efmls_formatter_name()
    local formatter_name = "formatting"

    for _, lang_pack in ipairs(api.get_lang().get_lang_pack()) do
        if
            not vim.tbl_isempty(lang_pack.efm_ls)
            and vim.tbl_contains(
                lang_pack.efm_ls.filetype,
                vim.api.nvim_buf_get_option(0, "filetype")
            )
        then
            formatter_name = lang_pack.efm_ls.formatter.exe
            break
        end
    end

    return formatter_name
end

return M
