-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local game = require "samples.game_guts.ketchapp_dont_touch_the_spikes.game"

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
	local altName = "Don't Touch The Spikes (Ketchapp)"
	local description = 
	'<font size="22" color="SteelBlue">' .. "Don't Touch The Spikes by Ketchapp</font><br><br><br>" ..
    'Reproduces the basic game in 175 lines of LUA + 85 lines of comments.<br>'
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public