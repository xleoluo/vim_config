local M = {}

function M.filter_publish_diagnostics(
    a,
    params,
    client_info,
    extra_message,
    config
)
    ---@diagnostic disable-next-line: unused-local
    local client = vim.lsp.get_client_by_id(client_info.client_id)

    local ignore_diagnostic_message = extra_message.ignore_diagnostic_message
        or {}
    local ignore_diagnostic_level = vim.tbl_map(function(level)
        return vim.diagnostic.severity[level:upper()]
    end, extra_message.ignore_diagnostic_level or {})

    if ignore_diagnostic_message then
        local new_index = 1

        for _, diagnostic in ipairs(params.diagnostics) do
            if
                not (
                    vim.tbl_contains(
                        ignore_diagnostic_level,
                        diagnostic.severity
                    ) -- disable level
                    or vim.tbl_contains(
                        ignore_diagnostic_message,
                        diagnostic.message
                    ) -- disable message
                )
            then
                params.diagnostics[new_index] = diagnostic
                new_index = new_index + 1
            end
        end

        for i = new_index, #params.diagnostics do
            params.diagnostics[i] = nil
        end
    end

    vim.lsp.diagnostic.on_publish_diagnostics(
        a,
        params,
        client_info,
        extra_message,
        ---@diagnostic disable-next-line: redundant-parameter
        config
    )
end

function M.get_diagnostic_namespace_by_name(name)
    local namespace = 0
    for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
        if diagnostic.source == name then
            ---@diagnostic disable-next-line: undefined-field
            namespace = diagnostic.namespace
            break
        end
    end
    return namespace
end

return M
