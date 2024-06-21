return {
    auto_save = true,
    float_border = true,
    input_switch = true,
    colorscheme = "killer-queen",
    -- killer-queen
    -- visual_studio_code
    language_injections = false,
    transparent_background = false,
    spell = {
        switch = true,
        display_hint = true,
    },
    lspconfig = {
        inlay_hint = false,
        semantic_token = false,
    },
    icon = {
        diagnostic = {
            enable = false,
            groups = {
                Error = "",
                Warn = "",
                Info = "󰋽",
                Hint = "󰋽",
            },
        },
        comment = {
            enable = false,
            groups = {
                Note = "󱞁",
                Todo = "",
                Warn = "",
                Error = "ﰡ",
                Hack = "󱜯",
                Fix = "ﮉ",
            },
        },
        kind = {
            enable = true,
            groups = {
                Default = "",
                String = "",
                Number = "",
                Boolean = "◩",
                Array = "",
                Object = "",
                Key = "",
                Null = "ﳠ",
                Text = "",
                Method = "",
                Function = "",
                Constructor = "",
                Namespace = "",
                Field = "",
                Variable = "ﳋ",
                Class = "",
                Interface = "",
                Module = "ﰪ",
                Property = "",
                Unit = "塞",
                Value = "",
                Enum = "",
                Keyword = "",
                Snippet = "󰅴",
                Color = "",
                File = "",
                Reference = "",
                Folder = "",
                EnumMember = "",
                Constant = "",
                Struct = "﬌",
                Event = "",
                Operator = "",
                TypeParameter = "",
            },
        },
        source = {
            enable = true,
            groups = {
                ["cmp_tabnine"] = "",
                ["vim-dadbod-completion"] = "",
            },
        },
    },
    database = {
        {
            name = "mysql(example)",
            url = "mysql://username:password@localhost:3306/db?protocol=tcp",
        },
        {
            name = "postgresql(example)",
            url = "postgres://username:password@localhost:5432/db",
        },
    },
}
