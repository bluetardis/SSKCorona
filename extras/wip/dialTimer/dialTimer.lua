-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- WIP
-- =============================================================
-- 								License
-- =============================================================
--[[
	> SSK is free to use.
	> SSK is free to edit.
	> SSK is free to use in a free or commercial game.
	> SSK is free to use in a free or commercial non-game app.
	> SSK is free to use without crediting the author (credits are still appreciated).
	> SSK is free to use without crediting the project (credits are still appreciated).
	> SSK is NOT free to sell for anything.
	> SSK is NOT free to credit yourself with.
]]
-- =============================================================
local getTimer  = system.getTimer

-- =============================================================
-- Locals
-- =============================================================
local useCache = false
local debugLevel = 0

local effect

local highp = system.getInfo( "gpuSupportsHighPrecisionFragmentShaders" )

if( highp ) then
	effect = require( "dialTimer.tickShader" )
	graphics.defineEffect( effect )
end

-- =============================================================
-- Forward Declarations
-- =============================================================

-- =============================================================
-- Localized Functions
-- =============================================================
local sSub  		= string.sub
local getTimer 		= system.getTimer
local isInBounds 	= ssk.misc.isInBounds

local mAbs 	= math.abs
local type 	= type

local mDeg  = math.deg
local mRad  = math.rad
local mCos  = math.cos
local mSin  = math.sin
local mAcos = math.acos
local mAsin = math.asin
local mSqrt = math.sqrt
local mCeil = math.ceil
local mFloor = math.floor
local mAtan2 = math.atan2
local mPi = math.pi

local function vAdd( x1, y1, x2, y2, alt )
	if( alt ) then 
		return { x = x2+x1, y = y2+y1 }
	end
	return x2+x1, y2+y1
end

local function vSub( x1, y1, x2, y2, alt )
	if( alt ) then 
		return { x = x2-x1, y = y2-y1 }
	end
	return x2-x1, y2-y1
end

local function vLen( x, y )
	return mSqrt( x * x + y * y )
end

local function vNorm( x, y, alt )	
	local vLen = len( x, y )

	if( alt ) then 
		return { x = x/vLen, y = y/vLen }
	end
	return x/vLen, y/vLen
end


local a2v
local a2vCache = {}
if( useCache ) then


	for i = 0,360 do
		local screenAngle = mRad(-(i+90))
		local x = mCos(screenAngle) 
		local y = mSin(screenAngle) 
		a2vCache[i] = { -x, y }
	end
	a2v = function( angle, alt )
		if( alt ) then
			return { x = a2vCache[angle][1], y = a2vCache[angle][2] }
		end
		return a2vCache[angle][1], a2vCache[angle][2] 
	end

else
	a2v = function( angle, alt )
		local screenAngle = mRad(-(angle+90))
		local x = mCos(screenAngle) 
		local y = mSin(screenAngle) 
		if( alt ) then
			return { x = -x, y = y }
		end
		return -x,y
	end
end

local function v2a( x, y )
	return mCeil(mAtan2( y, x ) * 180 / mPi) + 90	
end

local function vScale( x, y, mag, alt )
	if( alt ) then
		return { x = x*mag, y = y*mag }
	end
	return x*mag,y*mag
end

local function newTimerHUD( group, x, y, c1, c2 )
	local group = group or display.currentStage

	local c1 = c1 or {1,1,1,1}
	local c2 = c2 or {1,0,0,1}

	local hud = display.newGroup()
	group:insert(hud)
	

	-- Back Fill
	local backFill = display.newRect( hud, 0, 0, 360, 360 )
	backFill.anchorX = 0.5
	backFill.anchorY = 0.5

	if( c1.type == nil ) then
		backFill:setFillColor( unpack( c1 ) )
	else
		backFill.fill = c1
	end
	

	hud.x = x
	hud.y = y
	local lines = {}
	--local center = { x = 0, y = 0 }

    local numLines = 360 * 3
    local numLines = 600

    local dpl = 360/numLines

	for i = 1, numLines do

		--local vec = { x = 0, y = -1 }
		local vec = a2v( i * dpl, true )
		vec = vScale( vec.x, vec.y , 360/2, true )
		local line = display.newLine( hud, 0, 0, vec.x, vec.y )

		line.strokeWidth = 2
		line.strokeWidth = 3
		lines[#lines+1] = line

		if( c2.type == nil ) then
			line:setStrokeColor( unpack( c2 ) )
		else
			line.fill = c2
		end

	end

	local mask 

	--print( display.imageSuffix )
	if( display.imageSuffix == "@4x" ) then
		--print( "using 4X" )
		mask = graphics.newMask( "dialTimer/dialMask4.png" )
		hud:setMask( mask )
		hud.maskScaleX = 0.23
		hud.maskScaleY = 0.23
	elseif( display.imageSuffix == "@2x" ) then
		--print( "using 4X" )
		mask = graphics.newMask( "dialTimer/dialMask2.png" )
		hud:setMask( mask )
		hud.maskScaleX = 0.46
		hud.maskScaleY = 0.46
	else
		--print( "using 4X" )
		mask = graphics.newMask( "ssk/wip/dialTimer/dialMask.png" )
		hud:setMask( mask )
	end
	

	hud.x = x
	hud.y = y

	hud.setPercent = function ( self, percent )
		--print("setPercent", percent, round(#lines * percent/100), #lines)

		local numOn = round( #lines * percent/100 )

		for i = 1, #lines do
			lines[i].isVisible = ( numOn >= i ) 
		end
	end

	--hud:scale(0.5,0.5)

	return hud

end


local function newTimerHUD2( group, x, y, params )
	local group 		= group or display.currentStage
	local params 		= params or {}
	local foreFill 		= params.foreFill or {1,0,0,1}
	local backFill 		= params.backFill or {1,1,1,1}
	local dialRadius 	= params.radius or 100
	local dialTicks  	= params.ticks or 360
	local foreImg    	= params.foreImg or params.img
	local backImg    	= params.backImg or params.img
	local tickW 		= params.tickW or 10
	local tickH 		= params.tickH or 10
	local rotateTick    = params.rotateTick or false
	local useCircle 	= fnn( params.useCircle, true )
	local smooth 		= fnn( params.smooth, false )

	-- EFM fore and back shaders?

	local dpt 			= 360/dialTicks

	local hud = display.newGroup()
	group:insert(hud)

	local backTicks = {}
	local foreTicks = {}

	local angle = 0
	for i = 1, dialTicks do
		local vec = a2v( angle, true )
		vec = vScale( vec.x, vec.y, dialRadius, true )
		vec = vAdd( vec.x, vec.y, x, y, true )

		if( foreImg ) then
			aTick = display.newImageRect( hud, foreImg, tickW, tickH )
			if(smooth and highp) then
				aTick.fill.effect = "filter.tickShader"
				aTick.fill.effect.horizontal.blurSize = 2
				aTick.fill.effect.vertical.blurSize = 2	
			end
		else
			local aTick
			if( useCircle ) then
				aTick = display.newCircle( hud, vec.x, vec.y, tickW/2 )
			else
				aTick = display.newRect( hud, 0, 0, tickW, tickH )
			end
		end

		aTick.x = vec.x
		aTick.y = vec.y
		if( rotateTick ) then
			aTick.rotation = angle
		end
		aTick:toBack()
		foreTicks[i] = aTick
		aTick:setFillColor( unpack( foreFill ) )

		angle = angle + dpt
	end


	for i = 1, #foreTicks do
		local foreTick = foreTicks[i]
		if( backImg ) then
			aTick = display.newImageRect( hud, backImg, tickW, tickH )
			if(smooth and highp ) then
				aTick.fill.effect = "filter.tickShader"
				aTick.fill.effect.horizontal.blurSize = 8
				aTick.fill.effect.vertical.blurSize = 8	
			end
		else
			local aTick
			if( useCircle ) then
				aTick = display.newCircle( hud, foreTick.x, foreTick.y, tickW/2 )
			else
				aTick = display.newRect( hud, 0, 0, tickW, tickH )
			end
			aTick:setFillColor( unpack( backFill ) )
		end

		aTick.x = foreTick.x
		aTick.y = foreTick.y
		if( rotateTick ) then
			aTick.rotation = angle
		end
		aTick:toBack()
		backTicks[i] = aTick
		aTick:setFillColor( unpack( backFill ) )

		angle = angle + dpt
	end


	hud.setPercent = function ( self, percent )
		--print("setPercent", percent, round(#lines * percent/100), #lines)

		local numOn = round( #foreTicks * percent/100 )

		for i = 1, #foreTicks do
			foreTicks[i].isVisible = ( numOn >= i ) 
		end
	end


	
--[[
	-- Back Fill
	local backFill = display.newRect( hud, 0, 0, 360, 360 )
	backFill.anchorX = 0.5
	backFill.anchorY = 0.5

	if( backFill.type == nil ) then
		backFill:setFillColor( unpack( backFill ) )
	else
		backFill.fill = backFill
	end
	

	hud.x = x
	hud.y = y
	local lines = {}
	--local center = { x = 0, y = 0 }

    local numLines = 360 * 3
    local numLines = 600

    local dpl = 360/numLines

	for i = 1, numLines do

		--local vec = { x = 0, y = -1 }
		local vec = a2v( i * dpl, true )
		vec = vScale( vec.x, vec.y , 360/2, true )
		local line = display.newLine( hud, 0, 0, vec.x, vec.y )

		line.strokeWidth = 2
		line.strokeWidth = 3
		lines[#lines+1] = line

		if( foreFill.type == nil ) then
			line:setStrokeColor( unpack( foreFill ) )
		else
			line.fill = foreFill
		end

	end

	local mask 

	--print( display.imageSuffix )
	if( display.imageSuffix == "@4x" ) then
		--print( "using 4X" )
		mask = graphics.newMask( "images/dialMask4.png" )
		hud:setMask( mask )
		hud.maskScaleX = 0.23
		hud.maskScaleY = 0.23
	elseif( display.imageSuffix == "@2x" ) then
		--print( "using 4X" )
		mask = graphics.newMask( "images/dialMask2.png" )
		hud:setMask( mask )
		hud.maskScaleX = 0.46
		hud.maskScaleY = 0.46
	else
		--print( "using 4X" )
		mask = graphics.newMask( "images/dialMask.png" )
		hud:setMask( mask )
	end
	

	hud.x = x
	hud.y = y

	hud.setPercent = function ( self, percent )
		--print("setPercent", percent, round(#lines * percent/100), #lines)

		local numOn = round( #lines * percent/100 )

		for i = 1, #lines do
			lines[i].isVisible = ( numOn >= i ) 
		end
	end

	--hud:scale(0.5,0.5)

	--]]	

	return hud

end


ssk.dialTimer = {}
ssk.dialTimer.createHUD		= newTimerHUD
ssk.dialTimer.createHUD2	= newTimerHUD2

return ssk.dialTimer