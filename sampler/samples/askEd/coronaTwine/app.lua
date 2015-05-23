-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local app = {}

local coronaTwine = require "samples.askEd.coronaTwine.coronaTwine"

-- GlitchGames/GGColour
-- https://github.com/GlitchGames/GGColour
local ggcolor = require "samples.askEd.coronaTwine.mltext.GGColour"



-- Initialize the app
--
function app.init( group )
end

-- Stop, cleanup, and destroy the app.;
--
function app.cleanup( )
	app.isRunning = false
end

-- Run the Game
--
function app.run( group )
	app.isRunning = true		

	local colorChart = ggcolor:new()
	colorChart:loadColours( "samples/askEd/coronaTwine/mltext/otherRGB.json" )

	local params =
	{
		font = "Consolas",
		fontSize = 16,
		fontColor = colorChart:fromName( "Tomato", true),
		spaceWidth = 2,
		lineHeight = 22,
		linkColor1 = colorChart:fromName( "Blue", true),
		linkColor2 = colorChart:fromName( "Purple", true),
	}


	coronaTwine.run( group, "samples/askEd/coronaTwine/twineSamples/sample1.txt", 40, 40, params )


end

return app