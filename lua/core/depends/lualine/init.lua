-- https://github.com/nvim-lualine/lualine.nvim

local M = {}

M.lazy = {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    event = { "UIEnter" },
}

function M.init()
    M.lualine = require("lualine")
    M.visual_studio_code = require("visual_studio_code")
end

function M.load()
    M.lualine.setup({
        options = {
            theme = "visual_studio_code",
            icons_enabled = true,
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
            disabled_filetypes = {},
            globalstatus = true,
            refresh = {
                statusline = 1000,
                tabline = 100,
                winbar = 100,
            },
        },
        sections = M.visual_studio_code.get_lualine_sections(),
    })
end

function M.after() end

return M
