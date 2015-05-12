-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
--
-- =============================================================
local ballTrail = {}

-- This module requires SSK to function properly
require "ssk.loadSSK"

-- Locals
local speed 			= 150 -- in pixels-per-second
local turnEvery			= 3 -- Turn every time the (counter % this value)  == 0
local trailEvery		= 4 -- Add trail point every time the (counter % this value)  == 0
local turnByDegrees		= 35

local ballRadius 		= 15
local trailRadius 		= 5

-- Localized Functions
local mRand 	= math.random 
local getTimer 	= system.getTimer
local angle2Vec = ssk.math2d.angle2Vector
local normVec 	= ssk.math2d.normalize
local scaleVec  = ssk.math2d.scale
local addVec 	= ssk.math2d.add

-- Definitions

local function onEnterFrame( self, event )
	-- Is self valid?  If not, exit!			
	if( self.removeSelf == nil ) then 
		Runtime:removeEventListener( "enterFrame", self )
		return 
	end

	local curTime = getTimer()
	local dt      = curTime - self.lastTime
	self.lastTime = curTime

	self.myCount = self.myCount + 1
	-- Move the ball by a calculated amount in the current 'facing' direction
	local vec = angle2Vec( self.rotation, true ) 
	vec = normVec( vec )
	local dist = (dt * speed) / 1000
	vec = scaleVec( vec, dist )

	self.lx = self.x -- x before move (useful for non-basic trails)
	self.ly = self.x -- y before move (useful for non-basic trails)
	self.x = self.x + vec.x
	self.y = self.y + vec.y

	-- Turn?
	if( self.myCount % turnEvery == 0 ) then
		self.rotation = self.rotation + mRand( -turnByDegrees, turnByDegrees ) -- small turns only
	end

	-- Add trail point?
	if( self.myCount % trailEvery == 0 ) then
		if( self.trailStyle == 1) then
			ballTrail.drawTrail( self )
		
		elseif( self.trailStyle == 2) then
			ballTrail.drawTrail2( self )

		elseif( self.trailStyle == 3) then
			ballTrail.drawTrail3( self )

		else
			ballTrail.drawTrail2( self )
		end
		
	end
end



ballTrail.drawBall = function( group, trailStyle )
	-- Assign defaults if not passed in
	group 		= group or display.currentStage
	trailStyle 	= trailStyle or mRand( 1, 3 )

	local myColor = { mRand(20,100)/100, mRand(20,100)/100, mRand(20,100)/100 }
	
	local tmp = display.newCircle( group, centerX, centerY, ballRadius )	

	tmp:setFillColor( unpack( myColor) )
	tmp.myColor 	= myColor
	tmp.rotation 	= mRand(0,359)
	
	tmp.lastTime 	= getTimer()
	tmp.myCount  	= 0

	tmp.trailStyle 	= trailStyle

	tmp.enterFrame 	= onEnterFrame
	Runtime:addEventListener( "enterFrame", tmp )


	timer.performWithDelay( 10000, 		
		function()
			-- Is tmp valid?  If not, exit!			
			if( tmp.removeSelf == nil ) then return end
			transition.to( tmp, { alpha = 0, time = 2000, onComplete = display.remove })
		end )
	timer.performWithDelay( 11800, 
		function()			
			Runtime:removeEventListener( "enterFrame", tmp )
		end )
end


-- Basic Trail
ballTrail.drawTrail = function( obj )
	-- Is obj valid?  If not, exit!
	if( obj.removeSelf == nil ) then return end

	local tmp = display.newCircle( obj.parent, obj.x, obj.y , trailRadius)	
	tmp.fill = { type="image", filename="images/asked/chalk.png" }
	tmp:setFillColor( unpack( obj.myColor ) )

	transition.to( tmp, { delay = 5000, time = 1000, alpha = 0, onComplete = display.remove })
	obj:toFront()
end


-- Line Trail with Gaps
ballTrail.drawTrail2 = function( obj )
	if( not obj.last ) then
		obj.last = {x = obj.x, y = obj.y, rotation = obj.rotation}
		return
	end

	local tmp = display.newRect( obj.parent, obj.last.x, obj.last.y, 7, 12 )	
	tmp.rotation = obj.last.rotation
	tmp.fill = { type="image", filename="images/asked/chalk.png" }
	tmp:setFillColor( unpack( obj.myColor ) )
	obj.last = nil

	transition.to( tmp, { delay = 5000, time = 1000, alpha = 0, onComplete = display.remove })
	obj:toFront()
end

-- Footprint Trail with Gaps
ballTrail.drawTrail3 = function( obj )
	if( not obj.last ) then
		obj.last = {x = obj.x, y = obj.y, rotation = obj.rotation}
		return
	end
	local tmp = display.newRect( obj.parent, obj.x, obj.y, 15, 15 )	
	tmp.rotation = obj.rotation
	tmp.fill = { type="image", filename="images/asked/dog.png" }
	tmp:setFillColor( unpack( obj.myColor ) )

	transition.to( tmp, { delay = 5000, time = 1000, alpha = 0, onComplete = display.remove })
	obj:toFront()

	local tmp = display.newRect( obj.parent, obj.last.x, obj.last.y, 15, 15 )	
	tmp.rotation = obj.last.rotation
	tmp.fill = { type="image", filename="images/asked/dog.png" }
	tmp:setFillColor( unpack( obj.myColor ) )
	tmp.xScale = -1

	obj.last = nil

	transition.to( tmp, { delay = 5000, time = 1000, alpha = 0, onComplete = display.remove })
	obj:toFront()

end


return ballTrail