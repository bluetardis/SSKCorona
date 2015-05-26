-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local game = require "samples.icmt.ketchapp_2_cars.game"

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
	local altName = "2 Cars (Ketchapp)"
	local description = 
	'<font size="22" color="SteelBlue">2 Cars by Ketchapp</font><br><br><br>' ..
    'Reproduces the basic game in 170 lines of LUA + 67 lines of comments.<br>'
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public