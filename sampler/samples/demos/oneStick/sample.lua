-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local game = require "samples.demos.oneStick.app"

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
	local altName = "Easy Input - One Stick"
	local description = 
	'<font size="22" color="SteelBlue">Easy Input - One Stick</font><br><br><br>' ..
    'Short sample showing how to use the "Easy Input - One Stick" module. <br><br>' ..
    'Instructions:<br>' ..
    ' - Touch the screen and move finger to activate the "virtual" joystick.<br>'..
    "This will move and rotate the smiley 'ball'"
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public