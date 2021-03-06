-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local app = {}

local physics 		= require "physics"

-- Localizations
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local easyIFC   	= ssk.easyIFC
local mRand 		= math.random
local isValid		= display.isValid
local getTimer		= system.getTimer
local twoTouch 		= ssk.easyInputs.twoTouch

-- Initialize the app
--
function app.init( group )
end

-- Stop, cleanup, and destroy the app.;
--
function app.cleanup( )
	app.isRunning = false
	local physics = require("physics")
	physics.setDrawMode( "normal" )
	physics.stop()
end

-- Run the Game
--
function app.run( group )
	app.isRunning = true		
	local physics = require("physics")
	physics.start()
	physics.setGravity(0,9.8)
	--physics.setDrawMode( "hybrid" )

	-- Locals
	--

	-- Initialize 'input'
	--
	twoTouch.create( group, { debugEn = true, keyboardEn = true } )


	-- Create a room and a 'ball' in the room
	--
	ssk.display.rect( group, left, centerY, { w = 20, h = fullh-40, fill = _W_, anchorX = 0  }, { bodyType = "static" } )
	ssk.display.rect( group, right, centerY, { w = 20, h = fullh-40, fill = _W_, anchorX = 1  }, { bodyType = "static" } )
	ssk.display.rect( group, centerX, top, { w = fullw, h = 20, fill = _R_, anchorY = 0  }, { bodyType = "static" } )
	ssk.display.rect( group, centerX, bottom, { w = fullw, h = 20, fill = _B_, anchorY = 1 }, { bodyType = "static" } )
	local ball = ssk.display.imageRect( group, centerX, centerY - 50, "images/smiley.png", { size = 40 }, { radius = 20 } )

	-- Start listenering for the two touch event
	ball.onTwoTouchLeft = function( self, event )
		if( not app.isRunning ) then
			ignore( "onTwoTouchLeft", self )
			return 
		end
		if( event.phase == "began" ) then
			ball:applyLinearImpulse( 15, -15, ball.x, ball.y )
		end
		return false
	end; listen( "onTwoTouchLeft", ball )

	ball.onTwoTouchRight = function( self, event )
		if( not app.isRunning ) then
			ignore( "onTwoTouchRight", self )
			return 
		end
		if( event.phase == "began" ) then
			ball:applyLinearImpulse( -15, -15, ball.x, ball.y )
		end
		return false
	end; listen( "onTwoTouchRight", ball )


end

return app