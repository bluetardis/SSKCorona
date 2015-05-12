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

	local msg = easyIFC:quickLabel( group, "Tap Around", centerX, bottom - 30, gameFont, 10, _W_ )	

	-- 1. Write a single listener like this
	local function onTouch( self, event )
	   if(event.phase == "ended" ) then
	      print("You touched: ", self.myName )
	      msg.text = "You touched: " .. self.myName
	   end
	   return true
	end

	--2. Create as many objects as you want and have them all use the same listener
	--
	local maskGroup = display.newGroup()
	group:insert(maskGroup)
	maskGroup.x = 240
	maskGroup.y = 160
	local tmp = display.newRect( maskGroup, 0, -80, 240, 80 )
	tmp.touch = onTouch
	tmp.myName = "Red"
	tmp.isHitMasked = true
	tmp:setFillColor( 1, 0,  0)
	tmp:addEventListener( "touch" )

	local tmp = display.newRect( maskGroup, 0, 0, 240, 80 )
	tmp.touch = onTouch -- uses same code as "Bob"
	tmp.myName = "White"
	tmp:setFillColor( 1, 1, 1 )
	tmp.isHitMasked = true
	tmp:addEventListener( "touch" )

	local tmp = display.newRect( maskGroup, 0, 80, 240, 80 )
	tmp.touch = onTouch -- uses same code as "Bob" and "Bill"
	tmp.myName = "Blue"
	tmp:setFillColor( 0, 0, 1)
	tmp.isHitMasked = true
	tmp:addEventListener( "touch" )

	local mask = graphics.newMask( "images/asked/mask.png" )
	maskGroup:setMask( mask )
	maskGroup.maskScaleX = 1.5
	maskGroup.maskScaleY = 1.5

	-- ...


end

function public.about()
	local altName = "Is Hit Masked? (2015 FEB)"
	local description = 
	'<font size="22" color="SteelBlue">Is Hit Masked? (2015 FEB)</font><br><br><br>' ..
    'From this post:<a href = "https://forums.coronalabs.com/topic/54784-touch-event-on-masked-group-doesnt-work/">CLICK HERE</a><br><br>'


	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public