local M = {}

function M.init(cmp)
    M.cmp = cmp
end

function M.confirm()
    return M.cmp.mapping(M.cmp.mapping.confirm(), { "i", "s", "c" })
end

function M.confirm_select()
    return M.cmp.mapping(
        M.cmp.mapping.confirm({ select = true }),
        { "i", "s", "c" }
    )
end

function M.select_prev_item()
    return M.cmp.mapping(M.cmp.mapping.select_prev_item(), { "i", "s", "c" })
end

function M.select_next_item()
    return M.cmp.mapping(M.cmp.mapping.select_next_item(), { "i", "s", "c" })
end

function M.scroll_docs(n)
    return M.cmp.mapping(M.cmp.mapping.scroll_docs(n), { "i", "s", "c" })
end

function M.select_prev_n_item(n)
    return M.cmp.mapping(function(fallback)
        if M.cmp.visible() then
            ---@diagnostic disable-next-line: unused-local
            for i = 1, n, 1 do
                M.cmp.select_prev_item({
                    behavior = M.cmp.SelectBehavior.Select,
                })
            end
        else
            fallback()
        end
    end, { "i", "s", "c" })
end

function M.select_next_n_item(n)
    return M.cmp.mapping(function(fallback)
        if M.cmp.visible() then
            ---@diagnostic disable-next-line: unused-local
            for i = 1, n, 1 do
                M.cmp.select_next_item({
                    behavior = M.cmp.SelectBehavior.Select,
                })
            end
        else
            fallback()
        end
    end, { "i", "s", "c" })
end

function M.toggle_complete_menu()
    return M.cmp.mapping(function()
        if M.cmp.visible() then
            M.cmp.abort()
        else
            M.cmp.complete()
        end
    end, { "i", "s", "c" })
end

return M
