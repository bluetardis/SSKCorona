-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local game = require "samples.demos.twoTouch.app"

function public.init( group )
	game.init( group )
end

function public.cleanup( )
	game.cleanup( )
end

function public.run( group )
	game.run( group )
end

function public.about()
	local altName = "Easy Input - Two Touch"
	local description = 
	'<font size="22" color="SteelBlue">Easy Input - Two Touch</font><br><br><br>' ..
    'Short sample showing how to use the "Easy Input - Two Touch" module. <br><br>' ..
    'Instructions:<br>' ..
    ' - Tap the left and right sides of the screen to make the smiley "ball" bounce.<br>' ..
    ' - On simulator*, tap "A" & "D" or "Left Arrow" & "Right Arrow" for same response. (debug feature)<br><br><br>' ..
    " * If you're running the simulator under Windows, select an android device to enable<br>" ..
    "keyboard input."
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public