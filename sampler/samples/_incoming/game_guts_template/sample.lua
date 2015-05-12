-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local game = require "samples.game_guts.template.game"

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
	local altName = "GameGutsTemplate"
	local description = 
	'<font size="22" color="SteelBlue">Developer - ' .. "GameTitle</font><br><br><br>" ..
    'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum. <br><br><br>' ..
    'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum. <br>' ..
    'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum. <br>'
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public