local api = require("utils.api")

local M = {}

local float_extra_line = not api.get_setting().is_float_border()
local float_border_style = api.get_setting().get_float_border("rounded")

local lsp_hover_filetype = {
    hover = "lsp-hover",
    signature = "lsp-signature-help",
}

local lsp_replace_message_char = {
    ["\\\\n"] = "\n",
    ["\\_"] = "_",
    ["\\%["] = "[",
    ["\\%]"] = "]",
}

-------------------------------------------------------------------------------

function M.get_client_headlers(configuration)
    -------------------------------------------
    local function lsp_message_handle(config)
        local contents = config.contents
        -- local extra_line = config.extra_line

        local after_handle_contents = ""

        if type(contents) == "string" then
            -- signatures
            after_handle_contents = string.gsub(contents or "", "&nbsp;", " ")
        else
            -- hover
            after_handle_contents =
                string.gsub((contents or {}).value or "", "&nbsp;", " ")
        end

        for before_char, after_char in pairs(lsp_replace_message_char) do
            after_handle_contents =
                after_handle_contents:gsub(before_char, after_char)
        end

        -- if not extra_line then
        --     return after_handle_contents
        -- end

        return ("---\n%s\n---"):format(after_handle_contents)
    end

    local function lsp_hover_handle(_, result, ctx, config)
        if result then
            result.contents = lsp_message_handle({
                contents = result.contents,
                extra_line = float_extra_line,
            })
        end

        local bufnr, winner = vim.lsp.handlers.hover(_, result, ctx, config)

        if bufnr and winner then
            vim.api.nvim_buf_set_option(bufnr, "filetype", config.filetype)
            return bufnr, winner
        end
    end

    local function lsp_signature_help_handle(_, result, ctx, config)
        if result then
            local documentation = result.signatures[1].documentation
            local signatures_label = result.signatures[1].label

            if documentation then
                if documentation.value then
                    documentation.value = lsp_message_handle({
                        contents = documentation.value,
                        extra_line = float_extra_line,
                    })
                else
                    documentation = lsp_message_handle({
                        contents = documentation,
                        extra_line = float_extra_line,
                    })
                end
            else
                signatures_label = lsp_message_handle({
                    contents = signatures_label,
                    extra_line = false,
                })
            end
        end

        local bufnr, winner =
            vim.lsp.handlers.signature_help(_, result, ctx, config)

        local current_cursor_line = vim.api.nvim_win_get_cursor(0)[1]
        local ok, window_height = pcall(vim.api.nvim_win_get_height, winner)

        if not ok then
            return
        end

        if current_cursor_line > window_height + 2 then
            ---@diagnostic disable-next-line: param-type-mismatch
            vim.api.nvim_win_set_config(winner, {
                anchor = "SW",
                relative = "cursor",
                row = 0,
                col = -1,
            })
        end

        if bufnr and winner then
            vim.api.nvim_buf_set_option(bufnr, "filetype", config.filetype)
            return bufnr, winner
        end
    end
    -------------------------------------------
    local lsp_client_headlers = {
        ["textDocument/hover"] = vim.lsp.with(lsp_hover_handle, {
            border = float_border_style,
            filetype = lsp_hover_filetype.hover,
        }),
        ["textDocument/signatureHelp"] = vim.lsp.with(
            lsp_signature_help_handle,
            {
                border = float_border_style,
                filetype = lsp_hover_filetype.signature,
            }
        ),
    }

    return vim.tbl_deep_extend(
        "force",
        lsp_client_headlers,
        configuration.handlers or {}
    )
end

-------------------------------------------------------------------------------

function M.get_client_capabilities(configuration)
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }

    ---@diagnostic disable-next-line: missing-fields
    capabilities.textDocument.completion.completionItem = {
        documentationFormat = { "markdown", "plaintext" },
        snippetSupport = true,
        preselectSupport = true,
        insertReplaceSupport = true,
        labelDetailsSupport = true,
        deprecatedSupport = true,
        commitCharactersSupport = true,
        tagSupport = { valueSet = { 1 } },
        resolveSupport = {
            properties = {
                "documentation",
                "detail",
                "additionalTextEdits",
            },
        },
    }

    return vim.tbl_deep_extend(
        "force",
        capabilities,
        configuration.capabilities or {}
    )
end

-------------------------------------------------------------------------------

function M.init_configuration(configuration)
    local default_callback = function(client, bufnr) end

    local private_on_init = configuration.on_init or default_callback
    local private_on_attach = configuration.on_attach or default_callback

    configuration.on_init = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        if not api.get_setting().is_lspconfig_semantic_token() then
            client.server_capabilities.semanticTokensProvider = nil
        end
        private_on_init(client, bufnr)
    end

    configuration.on_attach = function(client, bufnr)
        vim.lsp.inlay_hint(bufnr, api.get_setting().is_lspconfig_inlay_hint())
        private_on_attach(client, bufnr)
    end

    configuration.handlers = M.get_client_headlers(configuration)
    configuration.capabilities = M.get_client_capabilities(configuration)

    return configuration
end

return M
