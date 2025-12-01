require("mini.indentscope").setup({ symbol = vim.flag, draw = { delay = 300 } })
-- require("mini.snippets").setup({ mappings = { jump_next = "<Tab>", jump_prev = "<S-Tab>" } }) -- TODO not jumping?

require("mini.hipatterns").setup({
	highlighters = {
		WARN = { pattern = "%f[%w]()WARN()%f[%W]", group = "MiniHipatternsWarn" },
		HACK = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
		TODO = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
	},
})

local starter = require('mini.starter')
require("mini.starter").setup({
	header = "",
	footer = "",
	evaluate_single = true,
	items = {
		starter.sections.recent_files(20, false),
	},
	content_hooks = {
		starter.gen_hook.aligning('center', 'top'),
		starter.gen_hook.padding(0, 5),
		starter.gen_hook.adding_bullet(vim.flag .. " "),
	},
})

-- mini plugins that use default settings
for _, plug in ipairs({
	"ai",
	"basics",
	"bracketed",
	"comment",
	"completion", -- TODO toggle completions
	"diff",
	"icons",
	"jump",
	"pairs",
	"snippets",
	"surround",
	"trailspace",
	"visits",
}) do
	require("mini." .. plug).setup()
end
