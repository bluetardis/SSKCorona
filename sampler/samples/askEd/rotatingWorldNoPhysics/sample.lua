-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local game = require "samples.askEd.rotatingWorldNoPhysics.app"

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
	local altName = "Rotating World (JUN 2014)"
	local description = 
	'<font size="22" color="SteelBlue">Rotating World No Physics (JUN 2014)</font><br><br><br>' ..
    'From this post:<a href = "https://forums.coronalabs.com/topic/49114-how-to-rotate-a-huge-group-object/">CLICK HERE</a><br><br>'
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public