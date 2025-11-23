-- Configuration for the LUA LSP server
return {
    on_init = function(client)
        -- Check if we are in an existing workspace, and if it has its own lua config
        if client.workspace_folders and #client.workspace_folders > 0 then
            local path = client.workspace_folders[1].name
      
            -- Don't override if project has its own Lua config
            if vim.uv.fs_stat(path .. '/.luarc.json') or 
                vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                return
            end
        end

        -- We are not in a workspace, or in a workspace with no lua config
        -- Apply neovm specific settings
        client.config.settings.Lua = vim.tbl_deep_extend(
            'force',
            client.config.settings.Lua or {},
            {
                runtime = { version = 'LuaJIT' },
                diagnostics = { globals = { 'vim' } },
                workspace = {
                    checkThirdParty = false,
                    library = { vim.env.VIMRUNTIME },
                },
            }
        )
    end,
    settings = {
        Lua = {
            telemetry = { enable = false },
        },
    },
}
