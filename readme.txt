Compatability test v0.0.1
=========================

This is not to test features, it is to test the demo runs at all on a variaty of hardware.
If you have problems let me know on www.twitch.tv/robtheswan

It may have bugs, it may run slow, but I'm only really interested in if it crashes or has rendering bugs.

Controls
--------

WASD = movement
SPACE = jump
SHIFT + WASD = move (very) quickly)
LEFT MOUSE = destroy blocks
RIGHT MOUSE = place BRICK


Loading / Saving levels
-----------------------

There is only one save slot. To delete the world you must manually delete everything in the world/ folder.


Landscape Generation Parameters
-------------------------------

In resources/shaders/scripts/luates.lua are settings for the landscape.
There are several presets: 
	big_and_smooth
	regular_terrain
	big_twisting
	swiss_cheese
	dig_your_way_to_freedom

You can change the routine by reassigning the final line of the file like this:
(remember to delete the world region files as noted above)

	terrain_settings = big_twisting



Licenses
--------

glFont
	E-mail: bhf5@email.byu.edu
	Web: http://students.cs.byu.edu/~bfish/

TODO - add the licesnses for libraries I use
