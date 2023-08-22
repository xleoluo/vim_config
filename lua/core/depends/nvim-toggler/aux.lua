local M = {}

local inverse = {
    ["+"] = "-",
    [">"] = "<",
    ["!="] = "==",
    ["on"] = "off",
    ["in"] = "out",
    ["no"] = "yes",
    ["to"] = "from",
    ["up"] = "down",
    ["top"] = "bottom",
    ["true"] = "false",
    ["open"] = "close",
    ["next"] = "prev",
    ["left"] = "right",
    ["show"] = "hidden",
    ["before"] = "after",
    ["enable"] = "disable",
    ["enabled"] = "disabled",
    ["resolve"] = "reject",
    ["relative"] = "absolute",
}

local function title(s)
    return (
        s:gsub("(%a)([%w_']*)", function(f, r)
            return f:upper() .. r:lower()
        end)
    )
end

function M.get_inverse()
    local words = vim.deepcopy(inverse)

    for word1, word2 in pairs(inverse) do
        words[title(word1)] = title(word2)
        words[word1:upper()] = word2:upper()
    end

    return words
end

return M
