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

--local room = dio.levelUpdater.updateRoom (versions, "input/8_1/", #versions, "output/8_2/")
--local room = dio.levelUpdater.updateRoom (versions, "output/8_2/", #versions, "output/8_2_yay/")
local room = dio.levelUpdater.updateRoom (versions, "output/8_2_yay/", #versions, "output/8_2_yay2/")


