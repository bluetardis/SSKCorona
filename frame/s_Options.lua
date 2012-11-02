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

local effectVolumeSlider
local musicVolumeSlider

-- Callbacks/Functions
local createLayers
local addInterfaceElements

local onSoundEffectsEnable
local onMusicEnable
local onEffectsVolumeUpdate
local onMusicVolumeUpdate
local onMusicVolumeDraggingUpdate
local onBack

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
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:enterScene( event )
	screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:exitScene( event )
	screenGroup = self.view	
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExitScene( event )
	screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroyScene( event )
	screenGroup = self.view

	-- Clear all references to objects we created in 'createScene()' (or elsewhere).
	layers:destroy()
	layers = nil

	effectVolumeSlider =  nil
	musicVolumeSlider  =  nil

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
	layers = ssk.display.quickLayers( screenGroup, "background", "interfaces" )
end

-- addInterfaceElements() - Create interfaces for this scene
addInterfaceElements = function( )

	-- Background Image
	backImage   = ssk.display.backImage( layers.background, "protoBack2.png" ) 

	-- ==========================================
	-- Buttons and Labels
	-- ==========================================
	local curY = 30
	local tmpButton
	local tmpLabel

	-- Page Title 
	ssk.labels:presetLabel( layers.interfaces, "default", "Options", centerX, curY, { fontSize = 32 } )

	--if(system.orientation == "portrait") then		
	
		-- (Sound) Effects On/Off Toggle
		curY = curY + 50
		tmpButton = ssk.buttons:presetToggle( layers.interfaces, "default", 60, curY, 30, 30, "", ssk.sbc.tableToggler_CB )
		tmpButton.hasToggled = false -- Add a flag to allow us to ignore first toggle


		tmpLabel = ssk.labels:presetLabel( layers.interfaces, "default", "Effects Enabled", centerX, curY, { fontSize = 18 } )
		tmpLabel.x = tmpButton.x + tmpButton.width/2 + tmpLabel.width/2 + 25

		-- (Sound) Effects Volume Slider
		curY = curY + 40
		effectVolumeSlider = ssk.buttons:quickHorizSlider( centerX, curY, w  - 120, 16, 
											              "interface/trackHoriz",
														  ssk.sbc.horizSlider2Table_CB, onEffectsVolumeUpdate,
														  imagesDir .. "interface/thumbHoriz.png", 40, 16,
														  layers.interfaces )
		ssk.sbc.prep_horizSlider2Table( effectVolumeSlider, currentPlayer, "effectsVolume", nil )


		-- Note: I defered this prep because it may cause an update that affects the sound effects volume slider 
		ssk.sbc.prep_tableToggler( tmpButton, currentPlayer, "effectsEnabled", onSoundEffectsEnable )


		-- Music On/Off Toggle
		curY = curY + 50
		tmpButton = ssk.buttons:presetToggle( layers.interfaces, "default", 60, curY, 30, 30, "", ssk.sbc.tableToggler_CB )

		tmpLabel = ssk.labels:presetLabel( layers.interfaces, "default", "Music Enabled", centerX, curY, { fontSize = 18 } )
		tmpLabel.x = tmpButton.x + tmpButton.width/2 + tmpLabel.width/2 + 25


		-- Music Volume Slider
		curY = curY + 40
		musicVolumeSlider = ssk.buttons:quickHorizSlider( centerX, curY, w  - 120, 16, 
											              "interface/trackHoriz",
														  ssk.sbc.horizSlider2Table_CB, onMusicVolumeUpdate,
														  imagesDir .. "interface/thumbHoriz.png", 40, 16,
														  layers.interfaces )
		ssk.sbc.prep_horizSlider2Table( musicVolumeSlider, currentPlayer, "musicVolume", onMusicVolumeDraggingUpdate ) 

		--musicVolumeSlider:disable()


		-- Note: I defered this prep because it may cause an update that affects the music volume slider 
		ssk.sbc.prep_tableToggler( tmpButton, currentPlayer, "musicEnabled", onMusicEnable )


	--elseif(system.orientation == "landscapeRight") then
	--end



	-- BACK 
	curY = h - 60
	ssk.buttons:presetPush( layers.interfaces, "default", 60 , curY, 100, 40,  "Back", onBack )

end	


onSoundEffectsEnable = function (event)
	local target = event.target

	if(target:pressed() ) then
		target:setText("X")
		effectVolumeSlider:enable()

		if(not target.hasToggled) then
			target.hasToggled = true
		else
			ssk.sounds:play("boop")
		end
		
	else
		target:setText("")
		effectVolumeSlider:disable()

		if(not target.hasToggled) then
			target.hasToggled = true
		end

	end

	table.save(currentPlayer, "lastPlayer.txt", system.DocumentsDirectory )

	return false
end

onMusicEnable = function (event)
	local target = event.target

	if(target:pressed() ) then
		target:setText("X")
		musicVolumeSlider:enable()
		ssk.sounds:play("bouncing")
	else
		target:setText("")
		musicVolumeSlider:disable()
		ssk.sounds:stop("bouncing")
	end

	table.save(currentPlayer, "lastPlayer.txt", system.DocumentsDirectory )

	return false
end


onEffectsVolumeUpdate = function( event )
	local target = event.target
	table.save(currentPlayer, "lastPlayer.txt", system.DocumentsDirectory )
	ssk.sounds:setEffectsVolume(target:getValue())
	ssk.sounds:play("boop")
	return false
end

onMusicVolumeDraggingUpdate = function( event )
	local target = event.target
	ssk.sounds:setMusicVolume(target:getValue())
	return false
end

onMusicVolumeUpdate = function( event )
	local target = event.target
	ssk.sounds:setMusicVolume(target:getValue())
	table.save(currentPlayer, "lastPlayer.txt", system.DocumentsDirectory )
	return false
end



onBack = function ( event ) 
	local options =
	{
		effect = "zoomOutInFade",
		time = 200,
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
