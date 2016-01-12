Compatibility test v0.1.0
=========================

This is not to test features, it is to test the demo runs at all on a variety
of hardware. If you have problems let me know on www.twitch.tv/robtheswan

It may have bugs, it may run slow, but I'm only really interested in if it
crashes or has rendering bugs!


Changelog
=========

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


Contributors
============

compatibility demo v0.1.1
-------------------------

Bug fixers

* Toeger

QA

* waterlimon
* whiteland92
* AcarX
* Swappik
* QeraiX
* Moopaloo
* LazyKernal
* FGArray
* Snellekenny


compatibility demo v0.1.0
-------------------------

Bug fixers

* RayMarch


compatibility demo v0.0.2
-------------------------

Bug fixers

* Amazedstream
* GhassanPL
* QeralX
* Roblon
* TheRustyBrick
* waterlimon

QA

* dgendreau
* Funisdangerous
* LazyKernel
* LuaKT
* McBrainiac
* Moopaloo
* Nidaegwyn
* NeutralNoise
* TheRustyBrick
* RedSquirrelsNut (@theredsquirrely)
* SSStormy
* xCosminPlays


compatibility demo v0.0.1
-------------------------

Bug fixers

* dgendreau
* Pjuke
* sp0nji
* ticedev
* waterlimon


Third Party Software and Licenses
=================================

GLFW 3.1
--------

http://www.glfw.org/


libpng 1.5.2
------------

http://www.libpng.org/


lua 5.2.3
---------

http://www.lua.org/

Copyright © 1994–2015 Lua.org, PUC-Rio.
Permission is hereby granted, free of charge, to any person obtaining a copy 
of this software and associated documentation files (the "Software"), to deal 
in the Software without restriction, including without limitation the rights 
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
copies of the Software, and to permit persons to whom the Software is 
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


Raknet 4.081
------------

https://github.com/OculusVR/RakNet

BSD License 
For RakNet software

Copyright (c) 2014, Oculus VR, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, 
are permitted provided that the following conditions are met:

*	Redistributions of source code must retain the above copyright notice, 
	this list of conditions and the following disclaimer.
	
*	Redistributions in binary form must reproduce the above copyright notice,     
    this list of conditions and the following disclaimer in the documentation 
    and/or other materials provided with the distribution.
	
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, 
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED 
TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN 
ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


TinyThread++ 1.1
----------------

http://tinythreadpp.bitsnbites.eu/


zlib 1.2.5
----------

http://www.zlib.net/

glFont
------

E-mail: bhf5@email.byu.edu
Web: http://students.cs.byu.edu/~bfish/
