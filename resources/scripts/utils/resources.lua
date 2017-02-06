
local m = {}

--------------------------------------------------
function m.loadEntityModels (models)
    for _, model in ipairs (models) do
        dio.resources.loadEntityModel (model.id, model.filename, model.options)
    end
end

--------------------------------------------------
function m.unloadEntityModels (models)
    for _, model in ipairs (models) do
        dio.resources.destroyEntityModel (model.id)
    end
end

return m