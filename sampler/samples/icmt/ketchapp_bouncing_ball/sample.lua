-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local game = require "samples.icmt.ketchapp_bouncing_ball.game"

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
	local altName = "Bouncing Ball (Ketchapp)"
	local description = 
	'<font size="22" color="SteelBlue">Bouncing Ball by Ketchapp</font><br><br><br>' ..
    'Reproduces the basic game in 178 lines of LUA + 47 lines of comments.<br>'
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public