-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local game = {}

local physics 		= require "physics"

-- Localizations
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local easyIFC   	= ssk.easyIFC
local mRand 		= math.random
local isValid 		= display.isValid
local oneTouch 		= ssk.easyInputs.oneTouch


local mAbs 			= math.abs

-- Initialize the game
--
function game.init( group )

	-- Create a basic set of rendering layers
	--
	game.layers = ssk.display.quickLayers( group, "underlay", "spikes", "content", "overlay")
end

-- Reset (restart) then game
--
function game.reset()
	game.isResetting = true
	game.player:reset()

	if( game.spikes ) then
		for k,v in pairs( game.spikes ) do
			ignore( "enterFrame", v )
			display.remove( v )
		end
		game.spikes = nil
	end

	post( "onScore", { phase = "reset" } )

	timer.performWithDelay( 500,
		function() 
			if( isValid(group) ) then
				game.drawSpikes()
			end
		end  )
	game.isResetting = false
end


-- Stop, cleanup, and destroy the game.;
--
function game.cleanup( )
	-- Clear 'isRunning' flag
	--
	game.isRunning = false

	if( game.spikes ) then
		for k,v in pairs( game.spikes ) do
			ignore( "enterFrame", v )
			display.remove( v )
		end
		game.spikes = nil
	end



	-- Clean up and stop physics
	--
	physics.setDrawMode( "normal" )
	physics.stop()

	-- Ignore onScore event
	--
	ignore( "onScore", game.scoreCounter )

	-- Destroy One-touch inputs
	--
	oneTouch.destroy()

	-- Ignore One-touch inputs
	--
	ignore( "onOneTouch", game.player )

	-- Destroy all layers
	--
	display.remove( game.layers )
	game.layers = nil 
end

-- Run the Game
--
function game.run( group )
	-- Set 'isRunning' flag
	--
	game.isRunning = true		
	
	physics.start()
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )


	-- 1. Create One-touch input
	--
	oneTouch.create( game.layers.underlay, { debugEn = false, keyboardEn = true } )

	-- 2. Draw the game 'room'
	--
	game.drawRoom()

	-- 3. Create the Player
	--
	game.createPlayer()	

	-- 4. Create spikes
	--	
	timer.performWithDelay( 500,
		function() 
			if( isValid(group) ) then
				game.drawSpikes()
			end
		end  )


	-- 5. Create score counter
	--
	game.createScoreCounter()

end

function game.drawRoom()

	-- Background image
	--
	local back = newImageRect( game.layers.underlay, centerX, centerY, 
		                       "images/kenney/back/castle.png", 
		                       { w = 570, h = 380 } )
	back:toBack() -- Push under one-touch so if we turn on debug mode we can see it.

	-- Floor/Ground
	--
	newImageRect( game.layers.content, centerX-fullw/4, bottom, 
			 "images/kenney/bricks/Blue/blue6.png",
		     { w = fullw/2 + 2, h = 20, fill = _W_, alpha = 1, kills = true, yScale = -1} )
	newImageRect( game.layers.content, centerX+fullw/4, bottom, 
			 "images/kenney/bricks/Blue/blue6.png",
		     { w = fullw/2 + 2, h = 20, fill = _W_, alpha = 1, kills = true, yScale = -1} )

end

function game.createPlayer()

	local radius 	= 30
	local startX 	= left + 50
	local downY 	= bottom - 10 - radius/2
	local upY 	 	= bottom - 110
	local baseSpeed = 150
	local speed 	= baseSpeed
	
	local function onCollision( self, event )
		if(event.phase == "began") then
			game.reset()
		end
		return true
	end

	local player = newImageRect( game.layers.content, startX, upY, 
		                         "images/kenney/physicsAssets/yellow_round.png",
		                         { size = radius, movingDown = false,
		                           collision = onCollision }, 
		                         { radius = radius/2, friction = 0, isFixedRotation = true, isSensor = true } )

	game.player = player

	player.reset = function( self )
		transition.cancel(self)
		timer.performWithDelay( 500,
			function() 
				if( isValid(self) ) then
					self.x = startX
					self.y = upY
					self:moveDown()
				end
			end  )
	end

	player.moveDown = function ( self )
		movingDown = true
		transition.cancel(self)
		local dy = self.y - downY
		local time = mAbs(1000 * dy/speed)
		--print(dy,time)
		transition.to( self, { y = downY, time = time, transition = easing.inQuad, onComplete = self.moveUp } )
	end

	player.moveUp = function ( self )
		speed = baseSpeed
		movingDown = false
		transition.cancel(self)
		local dy = upY - self.y
		local time = mAbs(1000 * dy/speed)
		transition.to( self, { y = upY, time = time, transition = easing.outQuad, onComplete = self.moveDown } )
	end

	-- One-touch input listener
	--
	function player.onOneTouch( self, event )
		if( event.phase ~= "began" ) then return end		
		speed = 4 * baseSpeed
		self:moveDown()
	end
	listen( "onOneTouch", player )

	-- Start 'bouncing'
	player:moveDown()

end


function game.drawSpikes( self )

	local size = 24
	local minT = 1500
	local maxT = 3000
	local speed = 125
	local offset = 50

	local totalSpikes = mRand(1,3)

	game.spikes = game.spikes or {}

	for i = 1, totalSpikes do
		local tmp = newImageRect( game.layers.spikes, right + offset + i * size, bottom - 15,
			"images/kenney/bricks/Red/red1.png",
				{ size = size, fill = _R_, num = i  }, { bodyType = "dynamic" } )
		tmp:setLinearVelocity( -speed, 0 )
		game.spikes[tmp] = tmp

		tmp.enterFrame = function( self )
			if( not isValid(self) ) then 
				ignore( "enterFrame", self)
				return 
			end
			if( self.x > game.player.x ) then return end
			game.spikes[self] = nil

			nextFrame( function() display.remove(self) end, 3000 )
			ignore( "enterFrame", self )
			if( not game.isResetting and self.num == totalSpikes ) then post( "onScore" ) end
		end
		listen( "enterFrame", tmp )
	end

	game.lastSpikeTimer = timer.performWithDelay( mRand( minT, maxT ),
		function() 
			if( game and isValid(game.layers) ) then
				game.drawSpikes()
			end
		end  )

end

function game.createScoreCounter( )
	
	game.scoreCounter = easyIFC:quickLabel( game.layers.overlay, "Score: 0", left + 40, top + 40, gameFont, 22, _G_, 0 )
	game.scoreCounter.score = 0

	game.scoreCounter.onScore = function( self, event )
		if( event.phase == "reset" ) then
			self.score = 0
			self.text = "Score: 0"
		else
			self.score = self.score + 1
			self.text = "Score: " .. self.score
		end
	end
	listen("onScore", game.scoreCounter)

end

return game