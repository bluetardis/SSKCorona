-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

-- =============================================================
-- init( group )
-- Code that needs to run before the sample can be executed goes here.
-- This is usually stuff like loading sprites, sound files, or prepping
-- data.
--
-- group - A display group for you to place any visual content into.
--         This group is managed for you and should not be destroyed by
--         your code.
-- =============================================================
function public.init( group )
	print("Did init @ ", system.getTimer() )
end

-- =============================================================
-- cleanup()
-- Any special cleanup code goes here.  
--
-- The module itself will be destroyed as well as all content rendered into
-- the group, so you don't need to do that.
-- =============================================================
function public.cleanup( )
	print("Did cleanup @ ", system.getTimer() )
end

-- =============================================================
-- run( group )
--
-- group - A display group for you to place any visual content into.
--         This group is managed for you and should not be destroyed by
--         your code. 
-- =============================================================
function public.run( group )

	-- Localizations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC

	-- Locals
	--
	local trayWidth = 160
	local trayButtonWidth = 20
	local openCloseTime = 200

	-- Create a group to contain our drawer contents
	--
	local theDrawer = display.newGroup()
	group:insert( theDrawer )
	theDrawer.isOpen = true

	-- Add open and close functions
	--
	function theDrawer.doOpen( self, time )		
		if( self.isOpen ) then return end
		time = time or openCloseTime
		self.isOpen = true
		if( time == 0 ) then
			self.x = 0
		else
			transition.to( self, { x = 0, time = time, transition = easing.inOutQuad } )
		end
	end

	function theDrawer.doClose( self, time )
		if( not self.isOpen ) then return end
		time = time or openCloseTime
		self.isOpen = false
		if(time == 0) then
			self.x = -(trayWidth-trayButtonWidth)
		else
			transition.to( self, { x = -(trayWidth-trayButtonWidth), time = time, transition = easing.inOutQuad } )
		end
	end

	-- Touch handler for our tray open-close button
	--
	local function onDrawerButton( event )	
		if(theDrawer.isOpen) then
			theDrawer:doClose()
		else
			theDrawer:doOpen()
		end
		return true
	end	

	-- Add background to our tray
	--
	local trayImage  = newImageRect( theDrawer, left, centerY, "images/felt.png", 
		                             { w = trayWidth, h = fullh, alpha = 0.3, anchorX = 0 } ) 

	-- Create an open-close button
	local openClose = easyIFC:presetPush( theDrawer, "default", 
		                                  left + trayWidth - trayButtonWidth/2, centerY, 
		                                  20, fullh, "", onDrawerButton )
	openClose.alpha = 0.25

	-- Add some dummy content (buttons)
	--
	local function onPressed( event )
		print("Pressed button: " .. event.target:getText() )
		return true
	end
	easyIFC:presetPush( theDrawer, "default", left + 70, centerY - 70, 60, 60, "A", onPressed )
	easyIFC:presetPush( theDrawer, "default", left + 70, centerY, 60, 60, "B", onPressed )
	easyIFC:presetPush( theDrawer, "default", left + 70, centerY + 70, 60, 60, "C", onPressed )

	-- Start the drawer off closed
	theDrawer:doClose( 0 )
end

-- =============================================================
-- More... add any additional functions you need below
-- =============================================================


-- =============================================================
-- Functions below this marker are optional.
-- They are used by the sampler to provide more details about the
-- sample and to do special sampler-only setup or cleanup.
-- =============================================================
function public.about()
	local altName = "Sliding Drawer (AUG 2012)"
	local description = 
	'<font size="22" color="SteelBlue">Sliding Drawer (AUG 2012)</font><br><br><br>' ..
    'This example demonstrates how to make a simple sliding drawer interface <br>' ..
    'that hides off the edge of the screen.<br><br><br>' ..
    'Note: The video for this example is also very old.'
	

	local video = "https://www.youtube.com/watch?v=DQ_lKayyClk" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end
function public.samplerSetup( group )
	print("Did sampler setup @ ", system.getTimer() )
end
function public.samplerCleanup( group )
	print("Did sampler cleanup @ ", system.getTimer() )
end

return public