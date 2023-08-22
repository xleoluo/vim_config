local conf = require("core.depends.nvim-cmp.aux_conf")
local maps = require("core.depends.nvim-cmp.aux_maps")

return {
    conf = conf,
    maps = maps,
    init = function(cmp, luasnip)
        maps.init(cmp)
        conf.init(cmp, luasnip)
    end,
}
