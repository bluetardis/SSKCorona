-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local app = require "samples.askEd.coronaTwine.app"

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
	local altName = "Corona Twine (JUN 2013)"
	local description = 
	'<font size="22" color="SteelBlue">Corona Twine (JUN 2013)</font><br><br><br>' ..
    'A basic "Twine" interpretor and display library for Corona.'
	
	local video = "http://bit.ly/corona_twine"

	return altName, description, video
end

return public