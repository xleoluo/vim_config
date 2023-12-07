-- https://github.com/nvim-lualine/lualine.nvim
local api = require("utils.api")

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
    local sections = M.visual_studio_code.get_lualine_sections()

    table.insert(sections.lualine_x, 2, {
        "venn",
        fmt = function(content, context)
            return ("Venn: %s"):format(
                vim.b.venn_enabled and "Y" or "N"
            )
        end,
    })

    table.insert(sections.lualine_x, 2, {
        "spell",
        fmt = function(content, context)
            return ("Spell: %s"):format(
                api.get_setting().is_code_spell_switch() and "Y" or "N"
            )
        end,
    })

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
        sections = sections,
    })
end

function M.after() end

return M
