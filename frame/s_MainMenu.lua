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
-- Flags modifying main menu operation and layout


-- Variables
local screenGroup
local layers -- Local reference to display layers 
local backImage 

local playButton 
local hostButton
local joinButton
local spmpButton

local welcomeBackLabel
local playerNameLabel

-- Callbacks/Functions
local createLayers
local addInterfaceElements

local onPlay
local onHost
local onJoin
local onCredits
local onOptions
local onHighScores
local onRG
local onCorona

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
	storyboard.printMemUsage()

	-- Update player name in case it was changed while we were in another
	-- scene (such as the 'NOT ME' scene)
	if playerNameLabel and welcomeBackLabel then
		playerNameLabel:setText( currentPlayer.name )
		--playerNameLabel.x = welcomeBackLabel.x + welcomeBackLabel.width/2 + playerNameLabel.width / 2 + 5
	end
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

	layers:destroy()
	layers = nil
	playButton = nil
	hostButton = nil
	joinButton = nil
	spmpButton = nil
	welcomeBackLabel = nil
	playerNameLabel = nil

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
	local curY
	local tmpButton
	local tmpLabel

	-- Game Label / Name
	ssk.labels:presetLabel( layers.interfaces, "default", "Game Name Here", centerX, 30, { fontSize = 32 } )

	-- Version Label
	ssk.labels:presetLabel( layers.interfaces, "default", "Last Modified: " .. releaseDate, centerX, h-10, { fontSize = 12, textColor = _WHITE_ } )


	if(multiplayerMode == "OFF") then
		-- PLAY 
		curY = centerY - 75
		playButton = ssk.buttons:presetPush( layers.interfaces, "default", centerX, curY, 200, 40,  "Play", onPlay )

	elseif(multiplayerMode == "2P_EASY") then
		-- PLAY 
		curY = centerY - 75
		playButton = ssk.buttons:presetPush( layers.interfaces, "default", centerX-25, curY, 150, 40,  "Play", onPlay )

		-- SP/MP TOGGLE 
		curY = centerY - 75
		spmpButton = ssk.buttons:presetPush( layers.interfaces, "default", centerX+80, curY, 40, 40,  "SP", onSPMP )

	else
		-- PLAY 
		curY = centerY - 75
		playButton = ssk.buttons:presetPush( layers.interfaces, "default", centerX-25, curY, 150, 40,  "Play", onPlay )
		

		-- HOST/JOIN 
		curY = centerY - 75
		hostButton = ssk.buttons:presetPush( layers.interfaces, "default", centerX-65, curY, 70 , 40,  "Host", onHost )
		joinButton = ssk.buttons:presetPush( layers.interfaces, "default", centerX+15, curY, 70 , 40,  "Join", onJoin )
		hostButton.isVisible = false
		joinButton.isVisible = false

		-- SP/MP TOGGLE 
		curY = centerY - 75
		spmpButton = ssk.buttons:presetPush( layers.interfaces, "default", centerX+80, curY, 40, 40,  "SP", onSPMP )

	end

	-- OPTIONS
	curY = centerY - 25
	ssk.buttons:presetPush( layers.interfaces, "default", centerX, curY, 200, 40,  "Options", onOptions ) 

--[[ NOT READY YET
	-- HIGHSCORES
	curY = centerY + 25
	ssk.buttons:presetPush( layers.interfaces, "default", centerX, curY, 200, 40,  "High Scores", onHighScores ) 
--]]

	-- CREDITS
	curY = curY + 50 -- centerY + 75
	ssk.buttons:presetPush( layers.interfaces, "default", centerX, curY, 200, 40,  "Credits", onCredits ) 

	-- Welcome back label
	curY = curY + 50
	welcomeBackLabel = ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Welcome back ", centerX + 20, curY,  { fontSize = 18 } )
	curY = curY + 25
	playerNameLabel = ssk.labels:presetLabel( layers.interfaces, "rightLabel", currentPlayer.name, centerX + 20, curY,  { fontSize = 18 } )
	--playerNameLabel.x = welcomeBackLabel.x + welcomeBackLabel.width/2 + playerNameLabel.width / 2 + 5
	--playerNameLabel.x = welcomeBackLabel.x + welcomeBackLabel.width/2 + playerNameLabel.width / 2 + 5

	-- NOT ME
	curY = curY - 10
	ssk.buttons:presetPush( layers.interfaces, "default", centerX + 70, curY, 70, 40,  "Not Me", onNotMe ) 

	-- RG Button
	ssk.buttons:presetPush( layers.interfaces, "RGButton", 30, h-30, 40, 40, "", onRG  )

	-- Corona Badge/Button
	ssk.buttons:presetPush( layers.interfaces, "CoronaButton", w-30, h-30, 50, 48, "", onCorona  )
end	


onPlay = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 300,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_PlayGUI", options  )	

	return true
end

onHost = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_Host", options  )	
	--[[
	if(multiplayerMode == "2P_AUTO") then
		storyboard.gotoScene( "s_Host_2P_Auto", options  )	
	
	elseif(multiplayerMode == "2P_EASY") then
		storyboard.gotoScene( "s_Host_2P_Easy", options  )	
	
	elseif(multiplayerMode == "MP_MANUAL") then
		storyboard.gotoScene( "s_Host_MP_Manual", options  )	
	
	end
	--]]
	

	return true
end

onJoin = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_Join", options  )	
	--[[
	if(multiplayerMode == "2P_AUTO") then
		storyboard.gotoScene( "s_Join_2P_Auto", options  )	
	
	elseif(multiplayerMode == "2P_EASY") then
		storyboard.gotoScene( "s_Join_2P_Easy", options  )	
	
	elseif(multiplayerMode == "MP_MANUAL") then
		storyboard.gotoScene( "s_Join_MP_Manual", options  )	
	end
	--]]
	

	return true
end

onSPMP = function ( event ) 
	local target = event.target
	local text   = target:getText()

	if(text == "SP") then
		target:setText("MP")

		if( multiplayerMode == "2P_EASY") then
			playButton:setText("Play a Friend")
		else
			playButton.isVisible = (not playButton.isVisible)
			hostButton.isVisible = (not hostButton.isVisible)
			joinButton.isVisible = (not joinButton.isVisible)
		end

	else
		target:setText("SP")
		if( multiplayerMode == "2P_EASY") then
			playButton:setText("Play")
		else
			playButton.isVisible = (not playButton.isVisible)
			hostButton.isVisible = (not hostButton.isVisible)
			joinButton.isVisible = (not joinButton.isVisible)
		end

	end

	return true
	
end

onOptions = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_Options", options  )	

	return true
end

onHighScores = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_HighScores", options  )	

	return true
end
onCredits = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 400,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_Credits", options  )	

	return true
end

onNotMe = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 250,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_NotMe", options  )	

	return true
end


onRG = function(event)
	system.openURL( "http://roaminggamer.com/"  )
	return true
end

onCorona = function(event)
	system.openURL( "http://www.coronalabs.com/"  )
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
