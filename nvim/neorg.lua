-- this file should be copied to .config/nvim/lua/plugins/neorg.lua

require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        ["core.dirman"] = {
            config = {
                workspaces = {
                    notes = "~/notes",
                },
            },
        },
    },
})
