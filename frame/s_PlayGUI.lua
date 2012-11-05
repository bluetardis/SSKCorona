-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- SSKCorona Sampler Main Menu
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
--
-- =============================================================

local storyboard = require( "storyboard" )
local scene      = storyboard.newScene()

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local enableMultiplayer = true
local screenGroup
local layers -- Local reference to display layers 
local backImage 

local countDownHUD
local scoreHUD
local curGemColorHUD

local gemColors = { _PINK_, _GREEN_, _YELLOW_, _BRIGHTORANGE_ }
local lastGemColor = math.random(1,#gemColors)

local xDrops = {}
local i = 50
while( i < (w-50) ) do
	xDrops[#xDrops+1] = i
	i = i + 75
end

local last_xDrop


local dropTimerHandle

-- Callbacks/Functions
local createLayers
local addInterfaceElements
local dropGem

local onDone
local onQuit

----------------------------------------------------------------------
--	Scene Methods:
-- scene:createScene( event )  - Called when the scene's view does not exist
-- scene:willEnterScene( event ) -- Called BEFORE scene has moved onscreen
-- scene:enterScene( event )   - Called immediately after scene has moved onscreen
-- scene:exitScene( event )    - Called when scene is about to move offscreen
-- scene:didExitScene( event ) - Called AFTER scene has finished moving offscreen
-- scene:destroyScene( event ) - Called prior to the removal of scene's "view" (display group)
-- scene:overlayBegan( event ) - Called if/when overlay scene is displayed via storyboard.showOverlay()
-- scene:overlayEnded( event ) - Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
----------------------------------------------------------------------
function scene:createScene( event )
	screenGroup = self.view

	createLayers()
	addInterfaceElements()
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnterScene( event )
	screenGroup = self.view

	scoreHUD:set(0)
	--scoreHUD:set(math.random(100,1000)) --EFM

	countDownHUD:set( 30 )
	--countDownHUD:set( math.random(1,3) ) --EFm

	countDownHUD:autoCountDown( 0 , onDone ) 
	--countDownHUD:autoCountDown( 0 , nil ) --EFM

	curGemColorHUD.myColor = gemColors[math.random(1,#gemColors)]
	curGemColorHUD:setFillColor( unpack(curGemColorHUD.myColor) )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:enterScene( event )
	screenGroup = self.view
	
	dropTimerHandle = timer.performWithDelay( 500, dropGem, 0 )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:exitScene( event )
	screenGroup = self.view	
	countDownHUD:stop()
	timer.cancel(dropTimerHandle)
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExitScene( event )
	screenGroup = self.view

	while( layers.content.numChildren > 0 ) do
		layers.content[1]:removeSelf()
		--tmp:removeSelf()
	end

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroyScene( event )
	screenGroup = self.view

	layers:destroy()
	layers = nil
	
	countDownHUD = nil
	scoreHUD = nil
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:overlayBegan( event )
	screenGroup = self.view
	local overlay_name = event.sceneName  -- name of the overlay scene
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:overlayEnded( event )
	screenGroup = self.view
	local overlay_name = event.sceneName  -- name of the overlay scene
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
-- createLayers() - Create layers for this scene
createLayers = function( )
	layers = ssk.display.quickLayers( screenGroup, "background", "content", "interfaces" )
end

-- addInterfaceElements() - Create interfaces for this scene
addInterfaceElements = function( )

	-- Background Image
	backImage   = ssk.display.backImage( layers.background, "protoBack2.png" ) 

	-- ==========================================
	-- Buttons, Labels, Counters, etc.
	-- ==========================================

	-- Header bar
	local img = display.newRect( layers.interfaces, 0 , 0,  w, 60)
	img.x = centerX
	img.y = 30
	img:setFillColor( unpack( _DARKGREY_ ) )
	img:setStrokeColor( unpack( _LIGHTGREY_ ))
	img.strokeWidth = 2

	-- Countdown timer (30 seconds)
	local img = display.newImageRect( layers.interfaces, imagesDir .. "misc/stopwatch_70_80.png", 35, 40)
	img.x,img.y = 25, 30

	countDownHUD = ssk.huds:createTimeHUD( 0, 0, "default", layers.interfaces, {fontSize = 22, color = _WHITE_})
	countDownHUD:set( 30 )
	countDownHUD.x = img.x + img.width/2 + countDownHUD.width/2 + 10
	countDownHUD.y = img.y + 2

	-- Score HUD
	scoreHUD = ssk.huds:createNumericScoreHUD( 0, 0, 0, "default", layers.interfaces, {fontSize = 22, color = _WHITE_})
	scoreHUD:set(0)
	scoreHUD.x = w - scoreHUD.width/2 - 70
	scoreHUD.y = countDownHUD.y

	-- Current GEM Color HUD + Label
	local lbl = ssk.labels:presetLabel( layers.interfaces, "default", "Tap These:", 0, 30,  { fontSize = 16 } )
	curGemColorHUD = display.newImageRect( layers.interfaces, imagesDir .. "Lost Garden/lostGardenGem.png", 30, 30 )
	
	lbl.x = centerX - lbl.width/2 - 5 - 35

	curGemColorHUD.x = centerX + curGemColorHUD.width/2 + 5 - 35
	curGemColorHUD.y = 30

	-- DONE --EFM Convert this to a pause button, leading to a pause overlay? 
	ssk.buttons:presetPush( layers.interfaces, "default", w - 30, 30, 40, 25, "Quit", onQuit, { fontSize = 12 } )

end	

dropGem = function()

	local gem = display.newImageRect( layers.content, imagesDir .. "Lost Garden/lostGardenGem.png", 60, 60 )

	local xDrop = xDrops[math.random(1,#xDrops)]
	while(xDrop == last_xDrop) do
		xDrop = xDrops[math.random(1,#xDrops)]
	end
	last_xDrop = xDrop

	gem.x = xDrop
	gem.y = 50

	lastGemColor = lastGemColor + 1
	if(lastGemColor > #gemColors) then
		lastGemColor = 1
	end

	gem.myColor = gemColors[lastGemColor]
	gem:setFillColor( unpack(gem.myColor) )

	-- Callback to increment score if we touch right gem
	gem.touch = function( self, event )
		local phase = event.phase

		if(phase == "began") then			
			if( self.myColor == curGemColorHUD.myColor ) then -- Good!			
				if(currentPlayer.effectsEnabled) then
					ssk.sounds:play("good")
				end			
				scoreHUD:increment(20)			
				self:removeSelf()
			
			else
				if(currentPlayer.effectsEnabled) then
					ssk.sounds:play("bad")
				end
				scoreHUD:increment(-10)
				self:removeSelf()
			end
		end

		return true -- only top gem catches touch in overlapping touches
	end

	gem:addEventListener( "touch", gem )


	-- Drop off screen over 4 seconds
	transition.to( gem, {y = h + 100, time = 4000 } )

	-- Self Delete in 4.1 seconds
	gem.timer = function( self, event ) 
		if(isDisplayObject(self)) then
			self:removeSelf()
		end
	end
	timer.performWithDelay( 4100, gem )
end

onDone = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 300,
		params =
		{
			score = scoreHUD:get()
		}
	}

	storyboard.gotoScene( "s_LastScore", options  )	

	return true
end

onQuit = function ( event ) 
	if(ssk.networking:isNetworking()) then
		ssk.networking:stop()
	end

	local options =
	{
		effect = "fade",
		time = 300,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_MainMenu", options  )	

	return true
end

---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "didExitScene", scene )
scene:addEventListener( "destroyScene", scene )
scene:addEventListener( "overlayBegan", scene )
scene:addEventListener( "overlayEnded", scene )
---------------------------------------------------------------------------------

return scene
