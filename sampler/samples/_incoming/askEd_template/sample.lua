-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local game = require "samples.askEd.template.app"

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
	local altName = "askEdTemplate"
	local description = 
	'<font size="22" color="SteelBlue">askEdTemplate</font><br><br><br>' ..
    'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum. <br><br><br>' ..
    'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum. <br>' ..
    'Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum Lorem ipsum. <br>'
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public