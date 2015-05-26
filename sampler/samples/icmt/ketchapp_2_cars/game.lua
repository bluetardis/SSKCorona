-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local game = {}

local physics 		= require "physics"

-- Localizations
local newAngleLine 	= ssk.display.newAngleLine
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local easyIFC   	= ssk.easyIFC
local mRand 		= math.random
local twoTouch 		= ssk.easyInputs.twoTouch


-- Locals
local carBlue 			= hexcolor("#00aac1")
local carRed  			= hexcolor("#ee3a61")
local laneTime 			= 500
local steerTime1 		= 350
local steerTime2 		= laneTime - steerTime1
local minObstacleTime 	= 1000
local maxObstacleTime 	= 2000
local obstacleSpeed 	= 100


-- Initialize the game
--
function game.init( group )

	-- Create a basic set of rendering layers
	--
	game.layers = ssk.display.quickLayers( group, "underlay", "lanes", "obstacles", "players", "overlay")

	game.resetCount = 0

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

	-- Destroy Two-touch inputs
	--
	twoTouch.destroy()

	-- Ignore Two-touch inputs
	--
	ignore( "onTwoTouchRight", game.rightPlayer )
	ignore( "onTwoTouchLeft", game.leftPlayer )

	-- Ignore onScore event
	--
	ignore( "onScore", game.scoreCounter )

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

	-- 1. Create Two-touch input
	--
	twoTouch.create( game.layers.underlay, { debugEn = false, keyboardEn = true } )

	-- 2. Draw the walls
	--
	game.drawLanes()

	-- 3. Create the Player
	--
	game.createPlayers()	

	-- 4. Create Obstacles
	--
	nextFrame( function() game.createObstacle( "left" ) end, mRand( minObstacleTime, maxObstacleTime ) + 1000 )
	nextFrame( function() game.createObstacle( "right" ) end, mRand( minObstacleTime, maxObstacleTime ) + 1000 )

	-- 5. Create score counter
	--
	game.createScoreCounter()
end

function game.drawLanes()

	-- Road
	newRect( game.layers.lanes, centerX, centerY, { w = 240, h = fullh, fill = hexcolor("#25337a") })

	-- Left Lane Marker
	newAngleLine( game.layers.lanes, centerX - 60, top, 180, fullh, 
		          { w = 2, color = _LIGHTGREY_, style = "dashed" , gapLen = 5, dashLen = 5 } )

	-- Right Lane Marker
	newAngleLine( game.layers.lanes, centerX + 60, top, 180, fullh, 
		          { w = 2, color = _LIGHTGREY_, style = "dashed" , gapLen = 5, dashLen = 5 } )


	-- Center Lane Marker
	newAngleLine( game.layers.lanes, centerX - 2, top, 180, fullh, 
		          { w = 2, color = _Y_ } )
	newAngleLine( game.layers.lanes, centerX + 2, top, 180, fullh, 
		          { w = 2, color = _Y_ } )

end

function game.createPlayers()
	local rightPlayer = newRect( game.layers.players, centerX + 90,  bottom - 40, 
		                     { width = 20, height = 30, fill = carBlue,
		                       cornerRadius = 4, strokeWidth = 2,  
		                       inLane = "right", changingLanes = false }, 
		                     { gravityScale = 0} )

	game.rightPlayer = rightPlayer
	rightPlayer.xR = rightPlayer.x
	rightPlayer.xL = rightPlayer.x - 60

	local leftPlayer = newRect( game.layers.players, centerX - 90, bottom - 40, 
		                     { width = 20, height = 30, fill = carRed, 
		                       cornerRadius = 4, strokeWidth = 2,  
		                       inLane = "left", changingLanes = false }, 
		                     { gravityScale = 0} )

	game.leftPlayer = leftPlayer
	leftPlayer.xL = leftPlayer.x
	leftPlayer.xR = leftPlayer.x + 60


	-- Collision listener
	--
	local function collision( self, event )
		local other = event.other
		local phase = event.phase
		table.dump( other, nil, "collided")
		if( event.phase == "began" ) then
			if( other.isDanger ) then
				
				nextFrame( 
					function()

					-- Clear the score
					--
					post( "onScore", { phase = "reset" } )
					
					game.layers:purge("obstacles")
					
					game.resetCount = 2				
					
					transition.cancel( game.rightPlayer )
					transition.cancel( game.leftPlayer )
					
					game.rightPlayer.x = game.rightPlayer.xR
					game.leftPlayer.x = game.leftPlayer.xL

					game.rightPlayer.inLane = "right"
					game.leftPlayer.inLane = "left"
					
					game.rightPlayer.rotation = 0
					game.leftPlayer.rotation = 0
				end )
			else
				-- Add points to our score
				--
				post( "onScore"  )
				display.remove( other )
			end
		end
		return true
	end
	rightPlayer.collision 	= collision
	leftPlayer.collision 	= collision
	rightPlayer:addEventListener( "collision" )
	leftPlayer:addEventListener( "collision" )

	-- Two-touch input listener
	--
	local function onTwoTouch( self, event )

		-- Only do someting on 'began'
		--
		if( event.phase ~= "began" ) then return end	

		-- In the middle of a lane change. Do nothing
		if( self.changingLanes )	then return end

		-- Tip: Try with and without this setting to change difficult
		--self.changingLanes = true

		local function onComplete( self )
			self.changingLanes = false
		end
		if( self.inLane == "left" ) then
			self.inLane = "right"
			transition.to( self, { rotation = 45, time = steerTime1, transition = easing.outCirc } )
			transition.to( self, { rotation = 0, delay = steerTime1, time = steerTime2, transition = easing.inCirc } )
			transition.to( self, { x = self.xR, time = laneTime, onComplete = onComplete } )
		else
			self.inLane = "left"
			transition.to( self, { rotation = -45, time = steerTime1, transition = easing.outCirc } )
			transition.to( self, { rotation = 0, delay = steerTime1, time = steerTime2, transition = easing.inCirc } )
			transition.to( self, { x = self.xL, time = laneTime, onComplete = onComplete } )
		end
	end
	rightPlayer.onTwoTouchRight = onTwoTouch
	leftPlayer.onTwoTouchLeft 	= onTwoTouch
	listen( "onTwoTouchRight", rightPlayer )
	listen( "onTwoTouchLeft", leftPlayer )
end


function game.createObstacle( lane )
	-- Don't do anything if the game is not running
	if( game.isRunning == false ) then return end

	-- We just died.  Wait a bit longer, the start it up again.
	if( game.resetCount > 0 ) then
		game.resetCount = game.resetCount - 1
		nextFrame( function() game.createObstacle( lane ) end, mRand( minObstacleTime, maxObstacleTime ) + 1000 )
		return
	end

	-- Create either a danger or a pickup
	--
	local obstacle 
	if( mRand(0,100) > 50 ) then
		obstacle = newCircle( game.layers.obstacles, centerX, top - mRand(50,100),
		                      { fill = _W_, size = 25, isDanger = true, strokeWidth = 2}, 
		                      { isSensor = true, isBullet = true } )
	else
		obstacle = newRect( game.layers.obstacles, centerX, top - mRand(50,100),
		                      { fill = _W_, size = 25, cornerRadius = 6, strokeWidth = 2, isDanger = false }, 
		                      { isSensor = true, isBullet = true } )
	end

	-- Choose a random color to confuse player
	--
	if( mRand(0,100) > 50 ) then
		obstacle:setFillColor( unpack( carRed ) )
	else
		obstacle:setFillColor( unpack( carBlue ) )
	end


	-- Choose an x-position
	--
	if( lane == "left" ) then
		obstacle.x = ( mRand(0,100) > 50 ) and centerX - 90 or centerX - 30
	else
		obstacle.x = ( mRand(0,100) > 50 ) and centerX + 90 or centerX + 30
	end

	-- Start it moving
	--
	obstacle:setLinearVelocity( 0, obstacleSpeed )

	-- Create another obstacle after a delay
	--
	nextFrame( function() game.createObstacle( lane ) end, mRand( minObstacleTime, maxObstacleTime ) )
end

function game.createScoreCounter( )

	
	game.scoreCounter = easyIFC:quickLabel( game.layers.overlay, "Score: 0", centerX - 190, top + 30, gameFont, 22 )
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