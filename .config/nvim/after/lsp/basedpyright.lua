-- Config for the Based-Pyright LSP
return {
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "basic",
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
            },
            -- Disable organize imports (let Ruff handle it)
            disableOrganizeImports = true,
        },
    },
}
