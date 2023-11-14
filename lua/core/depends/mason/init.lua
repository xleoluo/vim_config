-- https://github.com/williamboman/mason.nvim

local api = require("utils.api")

local M = {}

M.lazy = {
    "williamboman/mason.nvim",
    dependencies = {
        { "williamboman/mason-lspconfig.nvim" },
        { "j-hui/fidget.nvim" },
    },
    event = { "VimEnter" },
}

function M.init()
    M.mason = require("mason")
    M.mason_registry = require("mason-registry")
    M.mason_lspconfig = require("mason-lspconfig")
end

function M.load()
    M.mason.setup({
        ui = {
            icons = {
                package_installed = "",
                package_pending = "",
                package_uninstalled = "",
            },
            border = api.get_setting().get_float_border("double"),
        },
        max_concurrent_installers = 20,
        install_root_dir = api.get_setting().get_mason_install_path(),
    })
    M.mason_lspconfig.setup({
        automatic_installation = true,
    })
end

function M.after()
    local ref_lock_file = api.path.join(
        api.get_setting().get_mason_install_path(),
        "refresh.lock"
    )

    if not api.path.exists(ref_lock_file) then
        M.mason_registry.refresh()
        api.file.create(ref_lock_file)
    else
        M.mason_registry.update()
    end

    for _, mason_pack_name in
        ipairs(api.get_lang().get_mason_install({ "cspell" }))
    do
        if not M.mason_registry.is_installed(mason_pack_name) then
            if
                not vim.tbl_contains(
                    M.mason_registry.get_all_package_names(),
                    mason_pack_name
                )
            then
                vim.notify(
                    ("Invalid package name <%s>"):format(mason_pack_name),
                    ---@diagnostic disable-next-line: param-type-mismatch
                    "ERROR",
                    { annote = "[mason.nvim]", key = "[mason.nvim]" }
                )
            else
                M.mason_registry.get_package(mason_pack_name):install()
                vim.notify(
                    ("Installing <%s>"):format(mason_pack_name),
                    ---@diagnostic disable-next-line: param-type-mismatch
                    "INFO",
                    { annote = "[mason.nvim]", key = "[mason.nvim]" }
                )
            end
        end
    end
end

return M
