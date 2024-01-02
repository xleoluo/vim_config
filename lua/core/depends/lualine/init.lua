-- https://github.com/nvim-lualine/lualine.nvim

local api = require("utils.api")

local M = {}

M.lazy = {
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    event = { "UIEnter" },
    cond = true,
}

function M.init()
    M.lualine = require("lualine")
end

function M.load()
    local sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    }

    if api.get_setting().is_enable_colorscheme("visual_studio_code") then
        sections = require("visual_studio_code").get_lualine_sections()

        table.insert(sections.lualine_x, 2, {
            "venn",
            fmt = function(content, context)
                return ("Venn: %s"):format(vim.b.venn_enabled and "Y" or "N")
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
    elseif api.get_setting().is_enable_colorscheme("killer-queen") then
        table.insert(sections.lualine_x, 2, {
            "venn",
            fmt = function(content, context)
                return ("Venn: %s"):format(vim.b.venn_enabled and "Y" or "N")
            end,
        })

        table.insert(sections.lualine_c, 2, {
            "spell",
            fmt = function(content, context)
                return ("Spell: %s"):format(
                    api.get_setting().is_code_spell_switch() and "Y" or "N"
                )
            end,
        })
        M.lualine.setup({
            options = {
                theme = "killer-queen",
                icons_enabled = true,
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
    else
        M.lualine.setup({
            options = {
                icons_enabled = true,
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
end

function M.after() end

return M
