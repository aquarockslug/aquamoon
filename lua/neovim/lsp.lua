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
				runtime = { version = "LuaJIT", path = { "?.lua", "?.lush", "lua/?.lua", "lua/?/init.lua" } },
				workspace = { library = { vim.env.VIMRUNTIME, vim.fn.stdpath("config") } },
				telemetry = { enable = false },
			})
		end,
	})

	local servers = {}
	if vim.fn.executable("lua-language-server") == 1 then
		servers[#servers + 1] = "lua_ls"
	end

	if vim.fn.executable("tombi") == 1 then
		vim.lsp.config("tombi", {
			cmd = { "tombi", "lsp" },
			filetypes = { "toml" },
			workspace_required = false,
			root_dir = function(buffer, on_dir)
				on_dir(vim.fs.root(buffer, { "tombi.toml", "pyproject.toml", ".git" }) or
					vim.fn.getcwd())
			end,
		})
		servers[#servers + 1] = "tombi"

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "toml",
			callback = function(event)
				vim.bo[event.buf].formatprg = "tombi format --quiet -"
			end,
		})
	end

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
		servers[#servers + 1] = "biome"
	end

	if #servers > 0 then
		vim.lsp.enable(servers)
	end
end

return M
