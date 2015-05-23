-- =============================================================
-- main.lua
-- =============================================================
require "ssk.loadSSK"

--
-- You can mostly ignore from here ...
--
io.output():setvbuf("no") 
display.setStatusBar(display.HiddenStatusBar)  
local physics = require "physics"
physics.start()

ssk.display.rect( nil, left, centerY, { w = 20, h = fullh-40, fill = _W_, anchorX = 0  }, { bodyType = "static" } )
ssk.display.rect( nil, right, centerY, { w = 20, h = fullh-40, fill = _W_, anchorX = 1  }, { bodyType = "static" } )
ssk.display.rect( nil, centerX, top, { w = fullw, h = 20, fill = _R_, anchorY = 0  }, { bodyType = "static" } )
ssk.display.rect( nil, centerX, bottom, { w = fullw, h = 20, fill = _B_, anchorY = 1 }, { bodyType = "static" } )
local ball = ssk.display.imageRect( nil, centerX, centerY - 50, "images/smiley.png", { size = 40 }, { radius = 20 } )

--
-- .. to here
--

local debugEn 		= false
local keyboardEn 	= true
local example 		= "oneTouch"

if( example == "oneTouch" ) then
	local input = require "ssk.modules.input.oneTouch"
	input.create( nil, { debugEn = debugEn, keyboardEn = keyboardEn } )

	physics.start()

	ball.onOneTouch = function( self, event )
		if( event.phase == "began" ) then
			ball:applyLinearImpulse( 0, -15, ball.x, ball.y )
		end
		return false
	end; listen( "onOneTouch", ball )

	physics.start()

elseif( example == "twoTouch" ) then
	local input = require "ssk.modules.input.twoTouch"
	input.create( nil, { debugEn = debugEn, keyboardEn = keyboardEn } )

	ball.onTwoTouchLeft = function( self, event )
		if( event.phase == "began" ) then
			ball:applyLinearImpulse( -15, -15, ball.x, ball.y )
		end
		return false
	end; listen( "onTwoTouchLeft", ball )

	ball.onTwoTouchRight = function( self, event )
		if( event.phase == "began" ) then
			ball:applyLinearImpulse( 15, -15, ball.x, ball.y )
		end
		return false
	end; listen( "onTwoTouchRight", ball )

elseif( example == "oneStick" ) then
	local input = require "ssk.modules.input.oneStick"
	input.create( nil, { debugEn = debugEn, joyParams = { doNorm = true } } )

	physics.setGravity(0,0)
	ball.isFixedRotation = true
	ball.linearDamping = 0.5
	ball.forceX = 0
	ball.forceY = 0
	ball.x = centerX
	ball.y = centerY

	ball.enterFrame = function( self )
		self:applyForce( self.forceX, self.forceY, self.x, self.y )
	end; listen( "enterFrame", ball )

	ball.onJoystick = function( self, event )
		if( event.state == "on" ) then
			self.forceX = 15 * event.nx
			self.forceY = 15 * event.ny
			self.rotation = event.angle
		elseif( event.state == "off" ) then
			self.forceX = 0
			self.forceY = 0

		end
		return false
	end; listen( "onJoystick", ball )

elseif( example == "twoStick" ) then
	local input = require "ssk.modules.input.twoStick"
	input.create( nil, { debugEn = debugEn, joyParams = { doNorm = true } } )

	physics.setGravity(0,0)
	ball.isFixedRotation = true
	ball.linearDamping = 0.5
	ball.forceX = 0
	ball.forceY = 0
	ball.x = centerX
	ball.y = centerY

	ball.enterFrame = function( self )
		self:applyForce( self.forceX, self.forceY, self.x, self.y )
	end; listen( "enterFrame", ball )

	ball.onLeftJoystick = function( self, event )
		if( event.state == "on" ) then
			self.forceX = 15 * event.nx
			self.forceY = 15 * event.ny
		elseif( event.state == "off" ) then
			self.forceX = 0
			self.forceY = 0

		end
		return false
	end; listen( "onLeftJoystick", ball )


	ball.onRightJoystick = function( self, event )
		self.rotation = event.angle
		return false
	end; listen( "onRightJoystick", ball )


elseif( example == "oneStickOneTouch" ) then
	local input = require "ssk.modules.input.oneStickOneTouch"
	input.create( nil, { debugEn = debugEn, keyboardEn = keyboardEn, 
						 stickOnRight = true,
		                 joyParams = { doNorm = true } } )

	physics.setGravity(0,0)
	ball.isFixedRotation = true
	ball.linearDamping = 0.5
	ball.forceX = 0
	ball.forceY = 0
	ball.thrusting = false
	ball.x = centerX
	ball.y = centerY

	ball.enterFrame = function( self )
		if( self.thrusting == true ) then
			self:applyForce( self.forceX, self.forceY, self.x, self.y )
		end
	end; listen( "enterFrame", ball )

	ball.onJoystick = function( self, event )
		if( event.state == "on" ) then
			self.forceX = 15 * event.nx
			self.forceY = 15 * event.ny
			self.rotation = event.angle
		elseif( event.state == "off" ) then
			self.forceX = 0
			self.forceY = 0

		end
		return false
	end; listen( "onJoystick", ball )

	ball.onOneTouch = function( self, event )
		if( event.phase == "began" ) then
			self.thrusting = true
		elseif( event.phase == "ended" ) then
			self.thrusting = false
		end
		return false
	end; listen( "onOneTouch", ball )

elseif( example == "cornerButtons" ) then
	local input = require "ssk.modules.input.cornerButtons"
	input.create( nil, { debugEn = debugEn, keyboardEn = keyboardEn } )

	physics.start()

	ball.onButton1 = function( self, event )
		if( event.phase == "began" ) then
			ball:applyLinearImpulse( -15, -15, ball.x, ball.y )
		end
		return false
	end; listen( "onButton1", ball )

	ball.onButton2 = function( self, event )
		if( event.phase == "began" ) then
			ball:applyLinearImpulse( 15, -15, ball.x, ball.y )
		end
		return false
	end; listen( "onButton2", ball )

	physics.start()

end
