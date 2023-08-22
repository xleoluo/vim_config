-- https://github.com/L3MON4D3/LuaSnip
-- https://github.com/rafamadriz/friendly-snippets

local api = require("utils.api")

local M = {}

M.lazy = {
    "L3MON4D3/LuaSnip",
    dependencies = {
        { "rafamadriz/friendly-snippets" },
    },
    lazy = true,
}

function M.init()
    M.luasnip = require("luasnip")
    M.luasnip_loaders_from_vscode = require("luasnip.loaders.from_vscode")
end

function M.load()
    M.luasnip.setup({
        history = true,
        region_check_events = "InsertEnter",
        delete_check_events = "TextChanged,InsertLeave",
        update_events = "TextChanged,TextChangedI,InsertLeave",
        enable_autosnippets = true,
        store_selection_keys = "<Tab>",
    })

    M.luasnip_loaders_from_vscode.lazy_load({
        paths = {
            api.path.join(vim.fn.stdpath("config"), "snippets"),
            api.path.join(
                api.get_setting().get_depends_install_path(),
                "friendly-snippets"
            ),
        },
    })
end

function M.after()
    if api.get_lang().has_language("javascript") then
        M.luasnip.filetype_extend("javascript", { "typescript" })
    end
    if api.get_lang().has_language("typescript") then
        M.luasnip.filetype_extend("typescript", { "javascript" })
    end
    if api.get_lang().has_language("vue") then
        M.luasnip.filetype_extend("vue", { "javascript", "typescript" })
    end
end

function M.register_maps()
    api.map.bulk_register({
        {
            mode = { "i", "s" },
            lhs = "<tab>",
            rhs = function()
                return vim.api.nvim_eval(
                    "luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<tab>'"
                )
            end,
            options = { silent = true, expr = true },
            description = "Jump to the next fragment placeholder",
        },
        {
            mode = { "i", "s" },
            lhs = "<s-tab>",
            rhs = function()
                return vim.api.nvim_eval(
                    "luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<s-tab>'"
                )
            end,
            options = { silent = true, expr = true },
            description = "Jump to the prev fragment placeholder",
        },
    })
end

return M
