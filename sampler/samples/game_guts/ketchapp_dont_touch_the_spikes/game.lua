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
local oneTouch 		= ssk.easyInputs.oneTouch


-- Initialize the game
--
function game.init( group )

	-- Create a basic set of rendering layers
	--
	game.layers = ssk.display.quickLayers( group, "underlay", "world", { "spikes", "content", }, "overlay")
end

-- Stop, cleanup, and destroy the game.;
--
function game.cleanup( )
	-- Clear 'isRunning' flag
	--
	game.isRunning = false

	-- Clean up and stop physics
	--
	physics.setDrawMode( "normal" )
	physics.stop()

	-- Ignore the 'onSpikes' event
	--
	ignore( "onSpikes", game )

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
	physics.setGravity(0,15)
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
	listen( "onSpikes", game )

	-- 5. Create score counter
	--
	game.createScoreCounter()

end

function game.drawRoom()

	local back = newImageRect( game.layers.underlay, centerX, centerY, 
		                       "images/kenney/back/desert.png", 
		                       { w = 570, h = 380 } )
	back:toBack() -- Push under one-touch so if we turn on debug mode we can see it.

	-- left wall
	newRect( game.layers.content, left - 10, centerY, 
		     { w = 20, h = fullh, fill = _W_, alpha = 1 }, 
		     { bodyType = "static" } )

	-- right wall
	newRect( game.layers.content, right + 10, centerY, 
		     { w = 20, h = fullh, fill = _W_, alpha = 1 }, 
		     { bodyType = "static" } )

	-- top wall
	newImageRect( game.layers.content, centerX-fullw/4, top + 5, 
			 "images/kenney/bricks/Red/red6.png",
		     { w = fullw/2 + 2, h = 20, fill = _R_, alpha = 1, kills = true, yScale = -1 }, 
		     { bodyType = "static" } )
	newImageRect( game.layers.content, centerX+fullw/4, top + 5, 
			 "images/kenney/bricks/Red/red6.png",
		     { w = fullw/2 + 2, h = 20, fill = _R_, alpha = 1, kills = true, yScale = -1 }, 
		     { bodyType = "static" } )


	-- bottom wall
	newImageRect( game.layers.content, centerX-fullw/4, bottom - 5, 
			 "images/kenney/bricks/Red/red6.png",
		     { w = fullw/2 + 2, h = 20, fill = _R_, alpha = 1, kills = true}, 
		     { bodyType = "static" } )
	newImageRect( game.layers.content, centerX+fullw/4, bottom - 5, 
			 "images/kenney/bricks/Red/red6.png",
		     { w = fullw/2 + 2, h = 20, fill = _R_, alpha = 1, kills = true}, 
		     { bodyType = "static" } )

end

function game.createPlayer()
	local player = newImageRect( game.layers.content, centerX, centerY, 
		                         "images/kenney/physicsAssets/green_square.png",
		                         { size = 35, moving = false, speed = 200, kickMag = 9 }, 
		                         { gravityScale = 0, isFixedRotation = true } )

	game.player = player

	-- Attach Camera (for debug; will let you see how the spikes work)
	--ssk.camera.tracking( player, game.layers, { lockY = true }  )

	-- Collision listener
	--
	function player.collision( self, event )
		local other = event.other
		local phase = event.phase
		if( event.phase == "began" ) then
			if( other.kills ) then
				-- Set 'moving' flag to false immediately, but
				-- wait one cycle to move the player back to 'center'
				-- We most do this to avoid issues with ongoing collision calulations
				--
				self.moving = false
				nextFrame( function() self.gravityScale = 0 end )
				nextFrame( function() self:setLinearVelocity(0,0) end )
				nextFrame( function() self.x = centerX; self.y = centerY end )

				-- Clear the score
				--
				post( "onScore", { phase = "reset" } )

				-- Destroy all spikes and remove the list to reset spike 'logic'
				-- for new game.
				--
				if( game.lastSpikes ) then
					for k, v in pairs( game.lastSpikes ) do
						display.remove(v)
					end
				end
				game.lastSpikes = nil

			elseif( self.moving ) then 
				local vx,vy = self:getLinearVelocity()
				if( vx > 0 ) then
					self:setLinearVelocity( -self.speed, vy )
				else
					self:setLinearVelocity( self.speed, vy )
				end

				-- Add points to our score
				--
				post( "onScore"  )

				nextFrame( function() post( "onSpikes" ) end )
			end
		end
		return true
	end
	player:addEventListener( "collision" )

	-- One-touch input listener
	--
	function player.onOneTouch( self, event )

		-- Only do someting on 'began'
		--
		if( event.phase ~= "began" ) then return end		

		-- Player is moving, give it a 'kick'
		--
		if( self.moving ) then 
			local vx,vy = self:getLinearVelocity()
			self:setLinearVelocity( vx, 0 )
			self:applyLinearImpulse( 0, -self.kickMag )

		-- Player is not moving yet.  Start moving.
		--
		else
			self.moving = true
			self.gravityScale = 1
			self:setLinearVelocity( self.speed, 0 )

			post( "onSpikes", { phase == "start" } )
		end
	end
	listen( "onOneTouch", player )
end


function game.drawSpikes( self )
	local side = "right"

	-- If we're just re-starting, we won't have a table to track our spikes	
	--
	if( game.lastSpikes == nil ) then
		game.lastSpikes = {}

	-- The game is already started, check to see which side we need to 
	-- put spikes on now.
	--
	else
		-- Get the first spike in our list
		--
		local first = game.lastSpikes[1]

		-- Check to see what side it is on and choose the other side
		-- for this turn
		--
		if( first.x < centerX ) then 
			side = "right"
		else
			side = "left"
		end
	end


	-- Hide the old spikes (if any) and create newSpikes
	--
	-- Note: Very basic creation algorithm for now, never gets harder.
	--

	if( side == "right" ) then
		for k, v in pairs( self.lastSpikes ) do
			transition.to( v, { x = left - 40, time = 500, onComplete = display.remove } )
		end

		self.lastSpikes = {}

		self.lastSpikes[#self.lastSpikes+1] = newImageRect( game.layers.spikes, right + 20, centerY - 20 - mRand(0, 100), 
			"images/kenney/bricks/Red/red1.png",
			{ size = 32, fill = _R_, kills = true, rotation = -90 }, { bodyType = "static", isSensor = true } )

		self.lastSpikes[#self.lastSpikes+1] = newImageRect( game.layers.spikes, right + 20, centerY + 20 + mRand(0, 100), 
			"images/kenney/bricks/Red/red1.png",
			{ size = 32, fill = _R_, kills = true, rotation = -90 }, { bodyType = "static", isSensor = true } )

		for k, v in pairs( self.lastSpikes ) do
			transition.to( v, { x = right - 5, time = 250} )
		end

	else
		for k,v in pairs( self.lastSpikes ) do
			transition.to( v, { x = right + 40, time = 500, onComplete = display.remove } )
		end

		self.lastSpikes = {}

		self.lastSpikes[#self.lastSpikes+1] = newImageRect( game.layers.spikes, left - 20, centerY - 20 - mRand(0, 100), 
			"images/kenney/bricks/Red/red1.png",
			{ size = 32, fill = _R_, kills = true, rotation = 90 }, { bodyType = "static", isSensor = true } )

		self.lastSpikes[#self.lastSpikes+1] = newImageRect( game.layers.spikes, left - 20, centerY + 20 + mRand(0, 100), 
			"images/kenney/bricks/Red/red1.png",
			{ size = 32, fill = _R_, kills = true, rotation = 90 }, { bodyType = "static", isSensor = true } )

		for k, v in pairs( self.lastSpikes ) do
			transition.to( v, { x = left + 5, time = 250} )
		end
	end

end

function game.onSpikes( self, event )

	-- When starting, do some cleanup and initialization
	--
	if( event.phase == "start" ) then
		-- Purge any old spikes
		layers.purge("spikes")

		-- Stop tracking them.
		--
		game.lastSpikes = nil
	end

	game:drawSpikes()

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