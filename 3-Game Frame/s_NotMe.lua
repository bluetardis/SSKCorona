-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013 
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
local dp = ssk.debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local enableMultiplayer = true
local screenGroup
local layers -- Local reference to display layers 
local objs

-- Callbacks/Functions
local createLayers
local addInterfaceElements

local onRemove
local onRename
local onNewPlayer
local onPlayerSelect
local onOK

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
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnterScene( event )
	screenGroup = self.view

	createLayers()
	addInterfaceElements()
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

	layers:destroy()
	layers = nil
	objs = nil
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroyScene( event )
	screenGroup = self.view
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
	layers = ssk.display.quickLayers( screenGroup, "background", "playerList", "interfaces" )
end

-- addInterfaceElements() - Create interfaces for this scene
addInterfaceElements = function( )

	objs = {} 

	-- Background Image
	objs.backImage   = ssk.display.backImage( layers.background, "protoBack2.png" ) 

	-- ==========================================
	-- Buttons and Labels
	-- ==========================================
	local curY = 30
	local tmpButton
	local tmpLabel

	-- Page Title 
	ssk.labels:presetLabel( layers.interfaces, "default", "Select Player", centerX, curY, { fontSize = 32 } )

	-- Create Player List
	local maxPlayers = 4
	local playerCount = 0
	local x,y = 0,0
	for k,v in pairs(knownPlayers) do
		if( playerCount < maxPlayers ) then
			tmpButton = ssk.buttons:presetPush( layers.playerList, "default", x , y, 190, 35, v, onPlayerSelect )
			
			if( v == currentPlayer.name ) then
				tmpButton:setTextColor( _YELLOW_ )
			end
			
			y = y + tmpButton.height + 2
		end
		playerCount = playerCount + 1
	end

	-- If we are not at 'maxPlayers' add a button for adding new players
	if( playerCount < maxPlayers ) then
		tmpButton = ssk.buttons:presetPush( layers.playerList, "default", x , y, 190, 35, "(new player)", onPlayerSelect )
	end

	curY = curY + 35 + layers.playerList.height/2
	layers.playerList:setReferencePoint( display.CenterReferencePoint )
	layers.playerList.x = centerX
	layers.playerList.y = curY

	-- Rename/Remove
	curY = curY + layers.playerList.height/2 + 20
	ssk.buttons:presetPush( layers.interfaces, "default", centerX - 50 , curY, 90, 35,  "Rename", onRename )
	objs.removePlayerButton = ssk.buttons:presetPush( layers.interfaces, "default", centerX + 50 , curY, 90, 35,  "Remove", onRemove )
	
	if(playerCount == 1) then
		objs.removePlayerButton:disable()
	end

	-- OK
	curY = curY + 40
	ssk.buttons:presetPush( layers.interfaces, "default", centerX , curY, 190, 35,  "OK", onOK )

end	

onOK = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_MainMenu", options  )	

	return true
end

onNewPlayer = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			mode = "new"
		}
	}

	storyboard.gotoScene( "s_NotMeDialog", options  )	

	return true
end

onRemove = function ( event ) 

	knownPlayers[currentPlayer.name] = nil
	
	for k,v in pairs( knownPlayers ) do
		--currentPlayer.name = v
		loadCurrentPlayer( v )
		break
	end

	knownPlayers[currentPlayer.name] = currentPlayer.name
	saveCurrentPlayer()
	saveKnownPlayers()

	-- Clear all references to objects we created in 'createScene()' (or elsewhere).
	layers:destroy()
	layers = nil
	objs = nil


	createLayers()
	addInterfaceElements()
	
	return true
end

onRename = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			mode = "rename"
		}
	}

	storyboard.gotoScene( "s_NotMeDialog", options  )	

	return true
end


onPlayerSelect = function ( event ) 
	local target = event.target
	
	if(target:getText() == "(new player)") then
		onNewPlayer()
		return true

	else
		loadCurrentPlayer( target:getText() )

		for i=1, layers.playerList.numChildren do
			layers.playerList[i]:setTextColor( _WHITE_ )
		end

		target:setTextColor( _YELLOW_ )
	end
	
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
