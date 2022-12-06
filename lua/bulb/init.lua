_G.__bulb_internal = {
	rtp_updated = false,
	macro_searcher_updated = false,
	version = "0.0.0",
	plugin_name = "bulb",
}

--- Safely load the cache
---@return boolean
local function load_cache()
	local cache_path = require("bulb.config").cfg["cache-path"]
	local ok, f = pcall(loadfile, cache_path)
	if ok and f ~= nil then
		local ok, err = pcall(f)
		if ok then
			return true
		end
		vim.notify("bulb: " .. err)
	end
	return false
end

-- We compile and preload all of bulb's fennel files here to bootstrap it
-- Then we get access to compilation tools to create the cache
local function bootstrap()
	local lutil = require("bulb.lutil")
	local fennel = require("bulb.fennel")

	local files = lutil["get-bulb-files"]()

	-- set fennel debugger
	local _debug_traceback = debug.traceback
	debug.traceback = fennel.traceback

	lutil["update-fnl-macro-rtp"]()

	for _, fnl_file in ipairs(files) do
		local f = assert(io.open(fnl_file, "r"))
		local input_fnl = f:read("*a")
		f:close()

		local result = fennel.compileString(input_fnl, { filename = fnl_file, compilerEnv = _G })

		local module_name = lutil["get-module-name"](fnl_file)

		-- preload files here
		package.preload[module_name] = package.preload[module_name]
			or function()
				local f = assert(loadstring(result, module_name), "bulb: Failed to load module " .. module_name)
				return f()
			end
	end

	-- unset debugger
	debug.traceback = _debug_traceback
end

--- we have to wrap this function b/c we don't know if bulb.setup will be
--- compiled yet
local function setup(user_config)
	local res = load_cache()
	if not res then
		vim.notify("bulb: Cache not found, bootstrapping...")
		bootstrap()
		require("bulb.setup").setup(user_config)
		vim.cmd("BulbPreload")
		load_cache()
	else
		require("bulb.setup").setup(user_config)
	end
end

return {
	setup = setup,
}
