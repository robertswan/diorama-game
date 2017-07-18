--------------------------------------------------
local versionFilenames = 
{
    "versions/v3_0",
    "versions/v6_0",
    "versions/v8_1",
    "versions/v8_2",
    "versions/v8_3",
}

local versions = {}

--------------------------------------------------
for _, filename in ipairs (versionFilenames) do
    local versionModule = require (filename)
    table.insert (versions, versionModule.create (version))
end

-- dio.levelUpdater.updateRoom (
--         versions, 
--         "../gamemodes/dio_voxel_arena/new_saves/default/ORIGINAL_waiting_room/", 
--         #versions, 
--         "../gamemodes/dio_voxel_arena/new_saves/default/waiting_room/")

dio.levelUpdater.updateRoom (
        versions, 
        "../saves/_1350_original/default/", 
        #versions, 
        "../saves/_1350/default/")

-- dio.levelUpdater.updateRoom (
--         versions, 
--         "../gamemodes/dio_tiny_galaxy/new_saves/default/galaxy_00_8_1/", 
--         #versions, 
--         "../gamemodes/dio_tiny_galaxy/new_saves/default/galaxy_00/")

-- dio.levelUpdater.updateRoom (
--         versions, 
--         "../gamemodes/dio_tiny_galaxy/new_saves/default/map_00_8_2/", 
--         #versions, 
--         "../gamemodes/dio_tiny_galaxy/new_saves/default/map_00/")



