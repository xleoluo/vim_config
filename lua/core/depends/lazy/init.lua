-- https://github.com/folke/lazy.nvim

local api = require("utils.api")

local M = {
    lazy = nil,
}

local ignore_pack_array = {
    "init",
    "lazy",
}

local function get_lazy_options()
    return {
        root = api.get_setting().get_depends_install_path(),
        install = {
            colorscheme = { "default" },
        },
        ui = {
            border = api.get_setting().get_float_border("double"),
        },
        performance = {
            disabled_plugins = {
                -- "netrw",
                -- "netrwPlugin",
                "netrwSettings",
                "netrwFileHandlers",
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "tar",
                "tarPlugin",
                "rrhelper",
                "spellfile_plugin",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
            },
        },
    }
end

function M.before()
    local install_path =
        api.path.join(api.get_setting().get_depends_install_path(), "lazy.nvim")

    if not vim.uv.fs_stat(install_path) then
        vim.fn.mkdir(install_path, "p")

        vim.notify(
            "[SimpleNvim] clone lazy.nvim ...",
            "INFO",
            { title = "SimpleNvim" }
        )

        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            install_path,
        })
    end

    vim.opt.runtimepath:prepend(install_path)
end

function M.load()
    M.lazy = require("lazy")
    local lazy_load_pack = api.get_lang().get_lazy_install()

    for pack_name, pack in
        pairs(
            api.fn.get_package_from_directory(
                api.path.generate_absolute_path("../"),
                { "lazy" }
            )
        )
    do
        assert(
            not not pack.lazy,
            ("package <%s> require 'lazy' attribute"):format(pack_name)
        )

        pack.lazy.init = pack.lazy.init
            or function()
                if pack.register_maps then
                    pack.register_maps()
                end
            end

        pack.lazy.config = pack.lazy.config
            or function()
                if pack.init then
                    pack.init()
                end
                if pack.load then
                    pack.load()
                end
                if pack.after then
                    pack.after()
                end
            end
        table.insert(lazy_load_pack, pack.lazy)
    end

    M.lazy.setup(lazy_load_pack, get_lazy_options())
end

function M.after()
    M.register_maps()
end

function M.entry()
    M.before()
    M.load()
    M.after()
end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "n" },
            lhs = "<leader>lh",
            rhs = ":Lazy<cr>",
            options = { silent = true },
            description = "Run Lazy command",
        },
        {
            mode = { "n" },
            lhs = "<leader>li",
            rhs = ":Lazy install<cr>",
            options = { silent = true },
            description = "Run Lazy install command",
        },
        {
            mode = { "n" },
            lhs = "<leader>lu",
            rhs = ":Lazy update<cr>",
            options = { silent = true },
            description = "Run Lazy update command",
        },
        {
            mode = { "n" },
            lhs = "<leader>ls",
            rhs = ":Lazy sync<cr>",
            options = { silent = true },
            description = "Run Lazy sync command",
        },
        {
            mode = { "n" },
            lhs = "<leader>lx",
            rhs = ":Lazy clean<cr>",
            options = { silent = true },
            description = "Run Lazy clean command",
        },
        {
            mode = { "n" },
            lhs = "<leader>lc",
            rhs = ":Lazy check<cr>",
            options = { silent = true },
            description = "Run Lazy check command",
        },
        {
            mode = { "n" },
            lhs = "<leader>ll",
            rhs = ":Lazy log<cr>",
            options = { silent = true },
            description = "Run Lazy log command",
        },
        {
            mode = { "n" },
            lhs = "<leader>lr",
            rhs = ":Lazy restore<cr>",
            options = { silent = true },
            description = "Run Lazy restore command",
        },
        {
            mode = { "n" },
            lhs = "<leader>lp",
            rhs = ":Lazy profile<cr>",
            options = { silent = true },
            description = "Run Lazy profile command",
        },
        {
            mode = { "n" },
            lhs = "<leader>ld",
            rhs = ":Lazy debug<cr>",
            options = { silent = true },
            description = "Run Lazy debug command",
        },
        {
            mode = { "n" },
            lhs = "<leader>l?",
            rhs = ":Lazy help<cr>",
            options = { silent = true },
            description = "Run Lazy help command",
        },
    })
end

return M
