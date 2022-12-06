return {
    cfg = {
        ["compiler-options"] = { compilerEnv = _G },
        ["cache-path"] = vim.fn.stdpath "cache" .. "/bulbcache.lua",
        -- threads = vim.loop.available_parallelism()
    },
}
