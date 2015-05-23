-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local app = require "samples.askEd.mlText.app"

function public.init( group )
	app.init( group )
end

function public.cleanup( )
	app.cleanup( )
end

function public.run( group )
	app.run( group )
end

function public.about()
	local altName = "ML Text (JUN 2013)"
	local description = 
	'<font size="22" color="SteelBlue">ML Text (JUN 2013)</font><br><br><br>' ..
    'A basic (and old) Markup Language translator and display library for Corona.'
	
	local video = "http://bit.ly/corona_mltext"

	return altName, description, video
end

return public