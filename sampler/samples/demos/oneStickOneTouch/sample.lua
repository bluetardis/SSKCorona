-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local game = require "samples.demos.oneStickOneTouch.app"

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
	local altName = "Easy Input - One Stick + One Touch"
	local description = 
	'<font size="22" color="SteelBlue">Easy Input - One Stick + One Touch</font><br><br><br>' ..
    'Short sample showing how to use the "Easy Input - One Stick + One Touch" module. <br><br>' ..
    'Instructions:<br>' ..
    ' - Touch the left side of screen and move finger to activate the "virtual" joystick.<br>'..
    "This will rotate the smiley 'ball'<br>" ..
    " - Hold right side of screen to move the smiley 'bal'."
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public