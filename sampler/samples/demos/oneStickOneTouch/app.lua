-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local app = {}

local physics 		= require "physics"

-- Localizations
local newCircle 		= ssk.display.newCircle
local newRect 			= ssk.display.newRect
local newImageRect 		= ssk.display.newImageRect
local easyIFC   		= ssk.easyIFC
local mRand 			= math.random
local isValid			= display.isValid
local getTimer			= system.getTimer
local oneStickOneTouch 	= ssk.easyInputs.oneStickOneTouch
local angle2Vec 		= ssk.math2d.angle2Vector
local normVec 			= ssk.math2d.normalize
local scaleVec  		= ssk.math2d.scale
local addVec 			= ssk.math2d.add

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
	oneStickOneTouch.create( group, { debugEn = true, joyParams = { doNorm = true } } )


	-- Create a room and a 'ball' in the room
	--
	ssk.display.rect( group, left, centerY, { w = 20, h = fullh-40, fill = _W_, anchorX = 0  }, { bodyType = "static" } )
	ssk.display.rect( group, right, centerY, { w = 20, h = fullh-40, fill = _W_, anchorX = 1  }, { bodyType = "static" } )
	ssk.display.rect( group, centerX, top, { w = fullw, h = 20, fill = _R_, anchorY = 0  }, { bodyType = "static" } )
	ssk.display.rect( group, centerX, bottom, { w = fullw, h = 20, fill = _B_, anchorY = 1 }, { bodyType = "static" } )
	local ball = ssk.display.imageRect( group, centerX, centerY - 50, "images/smiley.png", { size = 40 }, { radius = 20 } )

	-- Start listenering for the two touch event
	--
	physics.setGravity(0,0)
	ball.isFixedRotation = true
	ball.linearDamping = 0.5
	ball.forceX = 0
	ball.forceY = 0
	ball.x = centerX
	ball.y = centerY

	ball.enterFrame = function( self )
		if( not app.isRunning ) then
			ignore( "enterFrame", self )
			return 
		end
		self:applyForce( self.forceX, self.forceY, self.x, self.y )
	end; listen( "enterFrame", ball )

	ball.onJoystick = function( self, event )
		if( not app.isRunning ) then
			ignore( "onJoystick", self )
			return 
		end
		if( event.state == "on" ) then
			self.rotation = event.angle
		elseif( event.state == "off" ) then
		end
		return false
	end; listen( "onJoystick", ball )

	ball.onOneTouch = function( self, event )
		if( not app.isRunning ) then
			ignore( "onOneTouch", self )
			return 
		end
		local vec = angle2Vec( self.rotation, true )
		vec = normVec( vec )


		if( event.phase == "began" ) then
			self.forceX = 15 * vec.x
			self.forceY = 15 * vec.y
		
		elseif( event.phase == "ended" ) then
			self.forceX = 0
			self.forceY = 0

		end
		return false
	end; listen( "onOneTouch", ball )

end

return app