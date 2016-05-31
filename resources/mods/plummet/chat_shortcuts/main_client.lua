--------------------------------------------------
local function onKeyClicked (keyCode, keyCharacter, keyModifiers)

    local keyCodes = dio.inputs.keyCodes
    local self = instance

        if keyCode == keyCodes.J then
            dio.clientChat.send (".join")
            return true
        end
    
        if keyCode == keyCodes.R then
            dio.clientChat.send (".ready")
            return true
        end
    
        if keyCode == keyCodes.G then
            dio.clientChat.send (".join")
            dio.clientChat.send (".ready")
            return true
        end      

    return false
end

--------------------------------------------------
local function onLoadSuccessful ()

    local types = dio.events.types
    dio.events.addListener (types.CLIENT_KEY_CLICKED, onKeyClicked)

end

--------------------------------------------------
local modSettings = 
{
    name = "Plummet Chat Command Shortcuts",
    description = "Keyboard shortcuts for chat commands .ready and .join in the Plummet gamemode.",
    author = "RadstaR and oliz001",

    permissionsRequired = 
    {
        client = true,
        player = true,
        input = true,
    },
     
}

--------------------------------------------------
return modSettings, onLoadSuccessful
