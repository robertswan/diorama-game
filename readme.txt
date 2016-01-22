Compatibility test v0.1.1
=========================

This is not to test features, it is to test the demo runs at all on a variety
of hardware. If you have problems let me know on www.twitch.tv/robtheswan

It may have bugs, it may run slow, but I'm only really interested in if it
crashes or has rendering bugs!


Changelog
=========

compatibility demo v0.1.0
-------------------------

TODO


compatibility demo v0.1.0
-------------------------

* Saves / Loads player position per level.
* Level height is user selectable.
* Block falling game temporarily added.
* Compressed level saves. Filesize approx 5% of v0.0.2.
* BUGFIX: Keypad ENTER acts like ENTER in menus.
* BUGFIX: players can't drop blocks over themselves.
* BUGFIX: players can't get stuck in unloaded chunk.
* BUGFIX: players can't get stuck when dropped into new levels.
* BUGFIX: Crosshair now behind the pause menu.
* BUGFIX: Better thread closure on exit.


Known Bugs
==========

* Meshes update slower than collision. You can walk in blocks you just destroyed.
* Delete World option doesn't always delete it fully! Delete it again!


Controls
========

WASD = movement
SPACE = jump
SHIFT + WASD = move (very) quickly)
LEFT MOUSE = destroy blocks
RIGHT MOUSE = place BRICK
