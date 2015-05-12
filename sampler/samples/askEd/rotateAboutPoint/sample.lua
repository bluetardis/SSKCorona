-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

local rotateAbout = require "samples.AskEd.rotateAboutPoint.rotateAbout"

function public.init( group )
end

function public.cleanup( )
end

function public.run( group )
	-- Localizations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC
	local mRand 		= math.random

	-- Locals
	--
	local tmp = display.newCircle( group, 0, 0 , 5 )

	----[[
	-- Loop 3 times (with 1/2 second initial delay)
	tmp.myLoops = 3
	local function onComplete( self )
		tmp.myLoops = tmp.myLoops - 1
		if( tmp.myLoops > 0 ) then
			rotateAbout( self, centerX, centerY, { onComplete = onComplete } )
		end
	end
	rotateAbout( tmp, centerX, centerY, { delay = 500, debugEn = true, onComplete = onComplete } )
	--]]


	--[[
	-- Loop forever (with 1/2 second initial delay)
	local function onComplete( self )
		rotateAbout( self, centerX, centerY, { onComplete = onComplete } )
	end
	rotateAbout( tmp, centerX, centerY, { delay = 500, debugEn = true, onComplete = onComplete } )
	--]]

	-- More variations below

	--rotateAbout( tmp, centerX, centerY )

	--rotateAbout( tmp, centerX, centerY, { radius = 50, time = 2000, debugEn = true } )

	-- ==============================
	-- Only for attempt 3 code ==> 
	-- ==============================
	--rotateAbout( tmp )
	--rotateAbout( tmp, centerX, centerY, { debugEn = true } )

	--[[
	rotateAbout( tmp, centerX, centerY, 
		           { time = 10000, myEasing = easing.outElastic, 
		             debugEn = true } )
	--]]


	--[[
	rotateAbout( tmp, centerX, centerY,
		           { time = 6000, startA = 270, endA = 90, 
		             myEasing = easing.outBounce, 
		             debugEn = true } )
	--]]


end

function public.about()
	local altName = "Rotate About Point (2014 DEC)"
	local description = 
	'<font size="22" color="SteelBlue">Rotate About Point (2014 DEC)</font><br><br><br>'
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public