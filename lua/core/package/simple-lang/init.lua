local M = {
    lang_pack_array = {},
}

local ignore_pack_array = {
    "init",
}

function M.get_lang_pack()
    local api = require("utils.api")

    if vim.tbl_isempty(M.lang_pack_array) then

        local lang_pack_paths =
            api.path.listdir(api.path.generate_absolute_path("../simple-lang"))

        ---@diagnostic disable-next-line: param-type-mismatch
        for _, lang_pack_path in ipairs(lang_pack_paths) do
            local lang_pack_name = vim.fn.fnamemodify(lang_pack_path, ":t:r")
            if not vim.tbl_contains(ignore_pack_array, lang_pack_name) then
                local lang_pack = require(
                    api.path.generate_relative_path("./" .. lang_pack_name)
                )

                ---@diagnostic disable-next-line: need-check-nil
                M.lang_pack_array[lang_pack_name] = lang_pack
            end
        end
    end

    return vim.tbl_values(M.lang_pack_array)
end

function M.has_language(langauge)
    return vim.tbl_contains(vim.tbl_keys(M.lang_pack_array), langauge)
end

function M.get_lang_install(install_name)
    local all_install = {}

    for _, lang_pack in ipairs(M.get_lang_pack()) do
        if not vim.tbl_isempty(lang_pack[install_name]) then
            all_install = vim.list_extend(all_install, lang_pack[install_name])
        end
    end

    local unique_install = {}

    for _, install in ipairs(all_install) do
        if not vim.tbl_contains(unique_install, install) then
            table.insert(unique_install, install)
        end
    end

    return unique_install
end

function M.get_lazy_install()
    return M.get_lang_install("lazy")
end

function M.get_mason_install()
    return M.get_lang_install("mason")
end

function M.get_treesitter_install()
    return M.get_lang_install("treesitter")
end

return M
