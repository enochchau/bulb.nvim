-- Lua utils
-- we need these in lua b/c they're part of the boostrap operation

--- Update `fennel.macro-path` with runtimepaths
--- We call this function during bootstrap and setup
local function update_fnl_macro_rtp()
    -- stop rtp from being updated multiple times
    if _G.__bulb_internal.rtp_updated then
        return
    end

    local fennel = require "bulb.fennel"
    local rtps = vim.api.nvim_list_runtime_paths()
    local templates = {
        -- lua base dir
        ";%s/lua/?.fnl",
        ";%s/lua/?/init.fnl",
        -- fnl base dir
        ";%s/fnl/?.fnl",
        ";%s/fnl/?/init.fnl",
    }
    for _, rtp in ipairs(rtps) do
        for _, template in ipairs(templates) do
            fennel["macro-path"] = fennel["macro-path"]
                .. string.format(template, rtp)
        end
    end

    _G.__bulb_internal.rtp_updated = true
end

--- Get the `.` separated module name from the fnl file name
---@param fnl_file string
---@return string|nil
local function get_module_name(fnl_file)
    -- check both the fnl/ and lua/ directories

    local module_partial = nil
    local matchers = { "fnl/(.+)%.fnl$", "lua/(.+)%.fnl$" }
    for _, matcher in ipairs(matchers) do
        module_partial = string.match(fnl_file, matcher)
        if module_partial ~= nil then
            break
        end
    end

    if module_partial == nil then
        -- assert(module_partial, "Coudn't get module name for: " .. fnl_file)
        return nil
    end

    local module_name = string.gsub(module_partial, "/", ".")
    return module_name
end

return {
    ["get-module-name"] = get_module_name,
    ["update-fnl-macro-rtp"] = update_fnl_macro_rtp,
}
