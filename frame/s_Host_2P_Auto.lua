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

-- Callbacks/Functions
local createLayers
local addInterfaceElements

local onBack
local onPlay

local onStartServer
local onStopServer

local serverIndicators = {}
local connectedClient

-- Server event handlers
local onClientJoined
local onMsgFromClient
local onClientDropped
local onServerStopped

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

	serverIndicators["running"]:setFillColor(unpack(_RED_))
	connectedClient:setFillColor(unpack(_RED_))

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:enterScene( event )
	screenGroup = self.view
	-- Server EVENTS
	ssk.gem:add("CLIENT_JOINED", onClientJoined, "hostingEvents" )
	ssk.gem:add("MSG_FROM_CLIENT", onMsgFromClient, "hostingEvents" )
	ssk.gem:add("CLIENT_DROPPED", onClientDropped, "hostingEvents" )
	ssk.gem:add("SERVER_STOPPED", onServerStopped, "hostingEvents" )

	onStartServer()

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:exitScene( event )
	screenGroup = self.view	

	--ssk.networking:stop()
	ssk.gem:removeGroup( "hostingEvents" )

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

	-- Page Title 
	ssk.labels:presetLabel( layers.interfaces, "default", "Hosting", centerX, curY, { fontSize = 32 } )
	
	-- Running Indicator
	curY = centerY - 40
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Running", centerX + 25, curY, { fontSize = 20 }  )
	serverIndicators["running"] = ssk.display.circle( layers.interfaces, centerX + 60, curY, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )

	-- Connected Clients Indicator
	curY = curY + 30
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Connected", centerX + 25, curY, { fontSize = 20 }  )
	connectedClient = ssk.display.circle( layers.interfaces, centerX + 60, curY, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )


	-- BACK 
	curY = curY + 50
	ssk.buttons:presetPush( layers.interfaces, "default", centerX , curY, 100, 40,  "Cancel", onBack )

end	

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------

onStartServer = function( event )
	print("onStartServer")

	serverIndicators["running"]:setFillColor(unpack(_GREEN_))

	--ssk.networking:setCustomBroadcast( "Networking Test" )
	ssk.networking:startServer()
	ssk.networking:setMyName( currentPlayer.name )
end

onStopServer = function( event )
	print("onStartServer")

	serverIndicators["running"]:setFillColor(unpack(_RED_))
	connectedClient:setFillColor(unpack(_RED_))

	ssk.networking:stopServer()
	ssk.networking:clearMyName( currentPlayer.name )
end


-- Networking Event Handlers
-- Server 
onClientJoined = function( event )
	table.dump(event) 
	connectedClient:setFillColor(unpack(_RED_))

	ssk.networking:msgClient( event.clientID, "START_GAME" )
	onPlay()
end

onMsgFromClient = function( event )	
	local msgTable = event.msgTable
	table.dump(event) 
end

onClientDropped = function( event )
	table.dump(event) 
	connectedClient:setFillColor(unpack(_RED_))

	connectedClient:setFillColor(unpack(_GREEN_))

end

onServerStopped = function( event )
	table.dump(event) 
	connectedClient:setFillColor(unpack(_RED_))
end


onBack = function ( event ) 
	onStopServer()
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

onPlay = function ( event ) 
	local options =
	{
		effect = "fade",
		time = 200,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_PlayGUI", options  )	

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
