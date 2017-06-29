--------------------------------------------------
local versionFilenames = 
{
    "versions/v8_1",
    "versions/v8_2"
}

local versions = {}

--------------------------------------------------
for _, filename in ipairs (versionFilenames) do
    local versionModule = require (filename)
    table.insert (versions, versionModule.create (version))
end

local room = dio.levelUpdater.updateRoom (versions, "../gamemodes/dio_tiny_galaxy/new_saves/default/galaxy_00_8_1/", #versions, "../gamemodes/dio_tiny_galaxy/new_saves/default/galaxy_00/")


