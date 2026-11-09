local M = {}

function M.setup()
	vim.lsp.config("lua_ls", {
		on_init = function(client)
			local root = client.workspace_folders and client.workspace_folders[1].name
			if root and root ~= vim.fn.stdpath("config")
			    and (vim.uv.fs_stat(root .. "/.luarc.json") or vim.uv.fs_stat(root .. "/.luarc.jsonc")) then
				return
			end
			client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
				runtime = { version = "LuaJIT", path = { "?.lua", "lua/?.lua", "lua/?/init.lua" } },
				workspace = { library = { vim.env.VIMRUNTIME, vim.fn.stdpath("config") } },
				telemetry = { enable = false },
			})
		end,
	})

	local has_biome = vim.fn.executable("biome") == 1
	if has_biome then
		vim.lsp.config("biome", {
			filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json", "jsonc" },
			workspace_required = false,
			root_dir = function(buffer, on_dir)
				on_dir(vim.fs.root(buffer, { ".git", "package.json", "biome.json", "biome.jsonc" }) or
					vim.fn.getcwd())
			end,
		})
	else
		vim.notify(
			"biome not found on PATH. Install it with:\ncurl -LsSf https://biomejs.dev/install.sh | sh",
			vim.log.levels.WARN
		)
	end
	vim.lsp.enable(has_biome and { "lua_ls", "biome" } or { "lua_ls" })

	local map = vim.keymap.set
	map("n", "gd", vim.lsp.buf.definition)
	map("n", "gr", vim.lsp.buf.references)
	map("n", "K", vim.lsp.buf.hover)
	map("n", "<leader>rn", vim.lsp.buf.rename)
	map("n", "<leader>ca", vim.lsp.buf.code_action)
	map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end)
	map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end)
	map("n", "<leader>d", vim.diagnostic.open_float)
	map("n", "<leader>j", function()
		pcall(vim.lsp.buf.format, { async = false })
		vim.cmd("write")
	end)
end

return M
