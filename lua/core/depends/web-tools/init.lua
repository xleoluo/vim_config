-- https://github.com/ray-x/web-tools.nvim

-- npm install -g browser-sync

local M = {}

M.lazy = {
    "ray-x/web-tools.nvim",
    cmd = {
        "BrowserSync",
        "BrowserOpen",
        "BrowserPreview",
        "BrowserRestart",
    },
}

function M.init()
    M.web_tools = require("web-tools")
end

function M.load()
    M.web_tools.setup()
end

function M.after() end

return M
