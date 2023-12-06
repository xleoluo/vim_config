local M = {
    lang_pack_array = {},
}

function M.get_lang_pack()
    local api = require("utils.api")

    if vim.tbl_isempty(M.lang_pack_array) then
        ---@diagnostic disable-next-line: param-type-mismatch
        local lang_pack_mapping = api.fn.get_package_from_directory(
            api.path.generate_absolute_path("../simple-lang/")
        )

        for lang_pack_name, lang_pack in pairs(lang_pack_mapping) do
            ---@diagnostic disable-next-line: need-check-nil
            M.lang_pack_array[lang_pack_name] = lang_pack
        end
    end

    return vim.tbl_values(M.lang_pack_array)
end

function M.has_language(langauge)
    return vim.tbl_contains(vim.tbl_keys(M.lang_pack_array), langauge)
end

function M.get_code_runner()
    local mapping = {}
    local runner = "code_runner"

    for _, lang_pack in ipairs(M.get_lang_pack()) do
        if lang_pack[runner] then
            for _, filetype in ipairs(lang_pack[runner]["filetype"]) do
                mapping[filetype] = lang_pack[runner]["command"]
            end
        end
    end

    return mapping
end

function M.get_lang_install(install_name)
    local all_install = {}

    for _, lang_pack in ipairs(M.get_lang_pack()) do
        if
            lang_pack[install_name]
            and not vim.tbl_isempty(lang_pack[install_name])
        then
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
    return M.get_lang_install("lazys")
end

function M.get_mason_install(extra_install)
    return vim.tbl_extend(
        "force",
        M.get_lang_install("mason"),
        extra_install or {}
    )
end

function M.get_treesitter_install(extra_install)
    return vim.tbl_extend(
        "force",
        M.get_lang_install("treesitter"),
        extra_install or {}
    )
end

return M
