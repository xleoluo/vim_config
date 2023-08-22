-- https://github.com/askfiy/visual_studio_code

local api = require("utils.api")

local M = {}

M.lazy = {
    "askfiy/visual_studio_code",
    priority = 100,
    enabled = true,
}

function M.init()
    M.visual_studio_code = require("visual_studio_code")
end

function M.load()
    M.visual_studio_code.setup({
        mode = "dark",
        preset = true,
        transparent = api.get_setting().is_transparent_background(),
        expands = {
            hop = true,
            lazy = true,
            aerial = true,
            fidget = true,
            null_ls = true,
            nvim_cmp = true,
            gitsigns = true,
            which_key = true,
            nvim_tree = true,
            lspconfig = true,
            telescope = true,
            bufferline = true,
            nvim_navic = true,
            nvim_notify = true,
            vim_illuminate = true,
            nvim_treesitter = true,
            nvim_ts_rainbow = true,
            nvim_scrollview = true,
            indent_blankline = true,
            vim_visual_multi = true,
        },
        hooks = {
            ---@diagnostic disable-next-line: unused-local
            before = function(conf, colors, utils) end,
            ---@diagnostic disable-next-line: unused-local
            after = function(conf, colors, utils) end,
        },
    })
end

function M.after() end

return M
