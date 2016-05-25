        =============================
        Compatibility Test v0.1.10.0
        =============================

        + Variable Gravity Directions (North, South, East, West, Up, Down)
        + Infinitely Tall Levels

        =============================
        Compatibility Test v0.1.1
        =============================

        + Multiplayer added
              - Max 32 Players per Server
              - Server can be started with command line arguments
              - Chat window Added (press T to Chat)
              - Players and Player Name is Visible in the game
              - Server saves Level on Exit
              - Server Accepts Command Line Arguments (-i input -s random_seed)

        + Different Blocks Available (Press 1-9)
        + Menu Reorganisation
        + Lua API extended:
              - Mods split into Client and Server mods
              - Render to texture available (dio.drawing.createRenderToTexture / setRenderToTexture)
              - Render passes can be added  (dio.drawing.addRenderPassBefore   / addRenderPassAfter)
              - New Events for dio.events.addListener:
	                    CLIENT_CHAT_MESSAGE_RECEIVED
	                    CLIENT_KEY_CLICKED
	                    CLIENT_WINDOW_FOCUS_LOST
	                    CLIENT_WINDOW_FOCUS_LOST

        + Paint Application added

        * BUGFIX: ESC correctly opens / closes pause menu
        * BUGFIX: Multiple Key Presses per tick were raised in reverse order


        =============================
        Compatibility Test v0.1.0
        =============================

        + Saves / Loads player position per level.
        + Level height is user selectable.
        + Block falling game temporarily added.
        + Compressed level saves. Filesize approx 5% of v0.0.2.

        * BUGFIX: Keypad ENTER acts like ENTER in menus.
        * BUGFIX: Players can't drop blocks over themselves.
        * BUGFIX: Players can't get stuck in unloaded chunk.
        * BUGFIX: Players can't get stuck when dropped into new levels.
        * BUGFIX: Crosshair now behind the pause menu.
        * BUGFIX: Better thread closure on exit.

        =============================
        Known Bugs
        =============================

        * Meshes update slower than collision. You can walk in blocks you just destroyed.
        * Delete World option doesn't always delete it fully! Delete it again!

        =============================
        Default Controls
        =============================

        WASD = Movement
        SPACE = Jump
        Hold SHIFT =  Move (very) Quickly
        LEFT MOUSE =  Destroy Cube
        RIGHT MOUSE = Place Cube
