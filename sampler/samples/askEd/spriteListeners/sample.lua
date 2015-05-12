-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}


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


	local diceData    = require("images.asked.dice")
	local diceSheet = graphics.newImageSheet( "images/asked/dice.png", diceData:getSheet() )
	local sequenceData =
	{
	    name="rolling",
	    start=1,
	    count=6,
	    time=6000,
	    loopCount = 0, 
	    loopDirection = "bounce"    -- Optional ; values include "forward" or "bounce"
	}

	local dieAnim = display.newSprite( group, diceSheet, sequenceData )
	dieAnim.x = centerX
	dieAnim.y = centerY
	dieAnim.myLabel = easyIFC:quickLabel( group, "TBD", dieAnim.x, dieAnim.y + 100, gameFont, 32, _W_ )	

	local function spriteListener( self,  event )
	    self.myLabel.text = "Frame: " .. self.frame
	end

	dieAnim.sprite = spriteListener
	dieAnim:addEventListener("sprite")
	dieAnim:play()


end

function public.about()
	local altName = "Sprite Listeners (2015 FEB)"
	local description = 
	'<font size="22" color="SteelBlue">Sprite Listeners (2015 FEB)</font><br><br><br>' 
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public