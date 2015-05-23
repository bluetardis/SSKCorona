-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local game = require "samples.demos.twoStick.app"

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
	local altName = "Easy Input - Two Stick"
	local description = 
	'<font size="22" color="SteelBlue">Easy Input - Two Stick</font><br><br><br>' ..
    'Short sample showing how to use the "Easy Input - Two Stick" module. <br><br>' ..
    'Instructions:<br>' ..
    ' - Touch the left-side of the screen and move finger to activate the left "virtual" joystick.<br>'..
    "This will move and rotate the smiley 'ball'<br>"..
    ' - Touch the right-side of the screen and move finger to activate the right "virtual" joystick.<br>'..
    "This will rotate the smiley 'ball'"
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public