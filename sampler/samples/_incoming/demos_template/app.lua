-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local game = {}

-- Initialize the game
--
function game.init( group )
end

-- Stop, cleanup, and destroy the game.;
--
function game.cleanup( )
	game.isRunning = false

	local physics = require("physics")
	physics.setDrawMode( "normal" )
	physics.stop()
end

-- Run the Game
--
function game.run( group )
	game.isRunning = true		
	local physics = require("physics")
	physics.start()
	physics.setGravity(0,9.8)
	--physics.setDrawMode( "hybrid" )

	-- Localizations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC
	local mRand 		= math.random

	-- Locals
	--
end

return game