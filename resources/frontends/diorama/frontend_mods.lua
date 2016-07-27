require ("resources/mods/diorama/frontend_menus/main")


-- --------------------------------------------------
-- local modsToLoad =
-- {
--     {
--         folder = "diorama",
--         modName = "frontend_menus",
--         versionRequired = {major = 1, minor = 0},
--     },
-- }

-- local mods = {}

-- --------------------------------------------------
-- local function main ()

--     local permissions =
--     {
--         blocks = true,
--         drawing = true,
--         file = true,
--         world = true,
--     }

--     for _, modData in ipairs (modsToLoad) do
--         local mod, error = dio.mods.load (modData, permissions)
--         if mod then
--             mods [modData.modName] = mod
--         else
--             print (error)
--         end
--     end
-- end

-- --------------------------------------------------
-- main ()