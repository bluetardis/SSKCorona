-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local game = require "samples.game_guts.duck_shoot.game"

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
	local altName = "Duck Shoot"
	local description = 
	'<font size="22" color="SteelBlue">Duck Shoot</font><br><br><br>' ..
    'A very simple duck shooting game in fewer that 150 lines of code.'
	
	local video = "http://youtu.be/B4R2-7gJciY" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public