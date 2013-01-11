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

local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
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

local onBack
local onPlay

local connectedToServer = false

local connectLoop
local connectLoopTimerHandle = nil

local onStartClient
local onStopClient
local onScan

local clientIndicators = {}

-- Client event handlers
local onConnectedToServer
local onMsgFromServer
local onServerDropped
local onClientStopped


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

	clientIndicators["running"]:setFillColor(unpack(_RED_))
	clientIndicators["scanning"]:setFillColor(unpack(_RED_))
	clientIndicators["connected"]:setFillColor(unpack(_RED_))

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:enterScene( event )
	screenGroup = self.view
	-- Client EVENTS
	ssk.gem:add("CONNECTED_TO_SERVER", onConnectedToServer, "joiningEvents" )
	--ssk.gem:add("SERVER_FOUND", onServerFound, "joiningEvents" )
	--ssk.gem:add("DONE_SCANNING_FOR_SERVERS", onDoneScanningForServers, "joiningEvents" )
	ssk.gem:add("MSG_FROM_SERVER", onMsgFromServer, "joiningEvents" )
	ssk.gem:add("SERVER_DROPPED", onServerDropped, "joiningEvents" )
	ssk.gem:add("CLIENT_STOPPED", onClientStopped, "joiningEvents" )

	onStartClient()
	ssk.networking:autoconnectToHost()
	clientIndicators["scanning"]:setFillColor(unpack(_GREEN_))


	--EFM
	screenGroup.timer = connectLoop

	connectLoopTimerHandle = timer.performWithDelay( 2000, screenGroup)

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:exitScene( event )
	screenGroup = self.view	

	if(connectLoopTimerHandle) then
		timer.cancel(connectLoopTimerHandle)
		connectLoopTimerHandle = nil
	end

	--ssk.networking:stop() --EFM
	ssk.gem:removeGroup( "joiningEvents" )

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
	objs = nil

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

	objs = {} 

	-- Background Image
	objs.backImage   = ssk.display.backImage( layers.background, "protoBack2.png" ) 

	-- ==========================================
	-- Buttons and Labels
	-- ==========================================
	local curY = 30

	-- Page Title 
	ssk.labels:presetLabel( layers.interfaces, "default", "Joining", centerX, curY, { fontSize = 32 } )


	-- Running Indicator
	curY = centerY - 80
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Running", centerX + 15, curY, { fontSize = 20 }  )
	clientIndicators["running"] = ssk.display.circle( layers.interfaces, centerX + 50, curY, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )

	-- Scanning Indicator
	curY = curY + 30
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Scanning", centerX + 15, curY, { fontSize = 20 }  )
	clientIndicators["scanning"] = ssk.display.circle( layers.interfaces, centerX + 50, curY, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )

	-- Connected Indicator
	curY = curY + 30
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Connected", centerX + 15, curY, { fontSize = 20 }  )
	clientIndicators["connected"] = ssk.display.circle( layers.interfaces, centerX + 50, curY, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )

	-- BACK 
	curY = curY + 50
	ssk.buttons:presetPush( layers.interfaces, "default", centerX , curY, 100, 40,  "Cancel", onBack )

end	
----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------

connectLoop = function( self, event )
	if( connectedToServer ) then
		dprint(2, "I am connected.")
		connectLoopTimerHandle = nil
		return true
	else
		dprint(2, "\n**************************************")
		dprint(2, "Reset client and try to connect again.\n")
		ssk.networking:stopScanning()
		ssk.networking:stopClient()
		ssk.networking:startClient()
		ssk.networking:autoconnectToHost()

		connectLoopTimerHandle = timer.performWithDelay( 2000, screenGroup)
		
		return true
	end
end

onStartClient = function( event )
	print("onStartClient")

	clientIndicators["running"]:setFillColor(unpack(_GREEN_))

	ssk.networking:startClient()
end

onStopClient = function( event )
	print("onStopClient")

	connectedToServer = false

	clientIndicators["running"]:setFillColor(unpack(_RED_))
	clientIndicators["scanning"]:setFillColor(unpack(_RED_))
	clientIndicators["connected"]:setFillColor(unpack(_RED_))

	ssk.networking:clearMyName( currentPlayer.name )

	ssk.networking:stopScanning()
	ssk.networking:stopClient()
end

-- Networking Event Handlers
-- Client 
onConnectedToServer = function( event )
	clientIndicators["connected"]:setFillColor(unpack(_GREEN_))
	connectedToServer = true

	ssk.networking:setMyName( currentPlayer.name )
end

onMsgFromServer = function( event )	
	local msgTable = event.msgTable


	if( msgTable.msgType == "START_GAME" ) then
		onPlay()
	end
end

onServerDropped = function( event )
	clientIndicators["connected"]:setFillColor(unpack(_RED_))

	connectedToServer = false

	-- Go back to main menu if the server drops the client
	onBack()
end

onClientStopped = function( event )
	print("onClientStopped")
	clientIndicators["connected"]:setFillColor(unpack(_RED_))

end

onBack = function ( event ) 
	onStopClient()
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
