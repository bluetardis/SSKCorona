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


local onStartServer
local onStopServer

local onStartClient
local onStopClient
local onScan
local onConnectToServer

local serverStartButton
local serverStopButton

local clientStartButton
local clientStopButton
local clientScanButton
local connectToServerButtons = {}

local serverIndicators = {}
local connectedClients = {}
local clientIndicators = {}

-- Server event handlers
local onClientJoined
local onMsgFromClient
local onClientDropped
local onServerStopped

-- Client event handlers
local serversFound = 0
local onConnectedToServer
local onServerFound
local onDoneScanningForServers
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
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:enterScene( event )
	screenGroup = self.view
	-- Server EVENTS
	ssk.gem:add("CLIENT_JOINED", onClientJoined, "networkingTest" )
	ssk.gem:add("MSG_FROM_CLIENT", onMsgFromClient, "networkingTest" )
	ssk.gem:add("CLIENT_DROPPED", onClientDropped, "networkingTest" )
	ssk.gem:add("SERVER_STOPPED", onServerStopped, "networkingTest" )

	-- Client EVENTS
	ssk.gem:add("CONNECTED_TO_SERVER", onConnectedToServer, "networkingTest" )
	ssk.gem:add("SERVER_FOUND", onServerFound, "networkingTest" )
	ssk.gem:add("DONE_SCANNING_FOR_SERVERS", onDoneScanningForServers, "networkingTest" )
	ssk.gem:add("MSG_FROM_SERVER", onMsgFromServer, "networkingTest" )
	ssk.gem:add("SERVER_DROPPED", onServerDropped, "networkingTest" )
	ssk.gem:add("CLIENT_STOPPED", onClientStopped, "networkingTest" )

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:exitScene( event )
	screenGroup = self.view	

	ssk.networking:stop()
	ssk.gem:removeGroup( "networkingTest" )

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

	-- Page Title 
	ssk.labels:presetLabel( layers.interfaces, "default", "Join", centerX, 30, { fontSize = 32 } )


	ssk.display.line2( layers.interfaces, centerX, -80, 180, h+160, 10, 10, { color = _WHITE_ , width = 4, style = "dashed"} )

	ssk.labels:presetLabel( layers.interfaces, "default", "SERVER", 
	                                   centerX - w/4 , 20, 
									   { fontSize = 22 }  )

	ssk.labels:presetLabel( layers.interfaces, "default", "CLIENT", 
	                                   centerX + w/4 , 20, 
									   { fontSize = 22 }  )


	-- Server Elements (on left)
	serverStartButton = ssk.buttons:presetPush( layers.interfaces, "greenGradient", 
	                                     70, h - 80, 
										 80, 30, 
										 "Start", onStartServer )

	serverStopButton = ssk.buttons:presetPush( layers.interfaces, "redGradient", 
	                                     centerX - 70, h - 80, 
										 80, 30, 
										 "Stop", onStopServer )
	serverStopButton:disable()

	-- Running Indicator
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Running", 
	                                   w/4 - 15, 80, 
									   { fontSize = 20 }  )
	serverIndicators["running"] = ssk.display.circle( layers.interfaces, w/4 + 20, 80, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )

	-- Connected Clients Indicator
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Clients", 
	                                   w/4 - 15, 110, 
									   { fontSize = 20 }  )
	
	connectedClients[1] = ssk.display.circle( layers.interfaces, w/4 + 20, 110, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )
	connectedClients[2] = ssk.display.circle( layers.interfaces, w/4 + 45, 110, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )
	connectedClients[3] = ssk.display.circle( layers.interfaces, w/4 + 70, 110, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )
	connectedClients[4] = ssk.display.circle( layers.interfaces, w/4 + 95, 110, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )


	-- Client Elements (on right)
	clientStartButton = ssk.buttons:presetPush( layers.interfaces, "greenGradient", 
	                                     centerX + 70, h - 80, 
										 80, 30, 
										 "Start", onStartClient )

	clientStopButton = ssk.buttons:presetPush( layers.interfaces, "redGradient", 
	                                     w - 70, h - 80, 
										 80, 30, 
										 "Stop", onStopClient )
	clientStopButton:disable()


	clientScanButton = ssk.buttons:presetPush( layers.interfaces, "orangeGradient", 
	                                     centerX + w/4, h - 40, 
										 180, 30, 
										 "Scan", onScan )
	clientScanButton:disable()


	connectToServerButtons[1] = ssk.buttons:presetPush( layers.interfaces, "blueGradient", 
	                                     centerX + 60, 190, 
										 100, 30, 
										 "----", onConnectToServer, { fontSize = 12 } )
	connectToServerButtons[1]:disable()

	connectToServerButtons[2] = ssk.buttons:presetPush( layers.interfaces, "blueGradient", 
	                                     w- 60, 190, 
										 100, 30, 
										 "----", onConnectToServer, { fontSize = 12 } )
	connectToServerButtons[2]:disable()



	-- Running Indicator
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Running", 
	                                   centerX + w/4 - 15, 80, 
									   { fontSize = 20 }  )
	clientIndicators["running"] = ssk.display.circle( layers.interfaces, centerX + w/4 + 20, 80, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )

	-- Scanning Indicator
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Scanning", 
	                                   centerX + w/4 - 15, 110, 
									   { fontSize = 20 }  )
	
	clientIndicators["scanning"] = ssk.display.circle( layers.interfaces, centerX + w/4 + 20, 110, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )


	-- Scanning Indicator
	ssk.labels:presetLabel( layers.interfaces, "rightLabel", "Connected", 
	                                   centerX + w/4 - 15, 140, 
									   { fontSize = 20 }  )
	
	clientIndicators["connected"] = ssk.display.circle( layers.interfaces, centerX + w/4 + 20, 140, { radius = 8, fill = _RED_, stroke = _LIGHTGREY_, strokeWidth = 2} )



	-- BACK 
	curY = h - 25
	ssk.buttons:presetPush( layers.interfaces, "default", 60 , curY, 100, 40,  "Back", onBack )

end	


onStartServer = function( event )
	print("onStartServer")

	serverStartButton:disable()
	serverStopButton:enable()

	serverIndicators["running"]:setFillColor(unpack(_GREEN_))

	ssk.networking:setCustomBroadcast( "Networking Test" )
	ssk.networking:startServer()
end

onStopServer = function( event )
	print("onStartServer")

	serverStartButton:enable()
	serverStopButton:disable()
	serverIndicators["running"]:setFillColor(unpack(_RED_))
	connectedClients[1]:setFillColor(unpack(_RED_))
	connectedClients[2]:setFillColor(unpack(_RED_))
	connectedClients[3]:setFillColor(unpack(_RED_))
	connectedClients[4]:setFillColor(unpack(_RED_))

	ssk.networking:stopServer()
end

onStartClient = function( event )
	print("onStartClient")

	clientStartButton:disable()
	clientStopButton:enable()
	clientScanButton:enable()

	clientIndicators["running"]:setFillColor(unpack(_GREEN_))

	ssk.networking:startClient()
end

onStopClient = function( event )
	print("onStopClient")

	clientStartButton:enable()
	clientStopButton:disable()
	clientScanButton:disable()

	serversFound = 0

	connectToServerButtons[1]:disable()
	connectToServerButtons[2]:disable()
	connectToServerButtons[1]:setText("----")
	connectToServerButtons[2]:setText("----")

	clientIndicators["running"]:setFillColor(unpack(_RED_))
	clientIndicators["connected"]:setFillColor(unpack(_RED_))

	ssk.networking:stopScanning()
	ssk.networking:stopClient()
end

onScan = function( event )
	print("onScan")
	clientIndicators["scanning"]:setFillColor(unpack(_GREEN_))

	serversFound = 0

	connectToServerButtons[1]:disable()
	connectToServerButtons[2]:disable()
	connectToServerButtons[1]:setText("----")
	connectToServerButtons[2]:setText("----")

	ssk.networking:scanServers( 2000 )
end

onConnectToServer = function( event )
	ssk.networking:connectToSpecificHost( event.target.serverIP )
end

-- Networking Event Handlers
-- Server 
onClientJoined = function( event )
	table.dump(event) 
	connectedClients[1]:setFillColor(unpack(_RED_))
	connectedClients[2]:setFillColor(unpack(_RED_))
	connectedClients[3]:setFillColor(unpack(_RED_))
	connectedClients[4]:setFillColor(unpack(_RED_))

	local numClients = ssk.networking:getNumClients()

	if(numClients > 4) then 
		numClients = 4
	end

	while(numClients > 0) do
		connectedClients[numClients]:setFillColor(unpack(_GREEN_))
		numClients = numClients - 1
	end

end

onMsgFromClient = function( event )	table.dump(event) end

onClientDropped = function( event )
	table.dump(event) 
	connectedClients[1]:setFillColor(unpack(_RED_))
	connectedClients[2]:setFillColor(unpack(_RED_))
	connectedClients[3]:setFillColor(unpack(_RED_))
	connectedClients[4]:setFillColor(unpack(_RED_))

	local numClients = ssk.networking:getNumClients()

	print(numClients)

	if(numClients > 4) then 
		numClients = 4
	end

	while(numClients > 0) do
		connectedClients[numClients]:setFillColor(unpack(_GREEN_))
		numClients = numClients - 1
	end

end

onServerStopped = function( event )
	table.dump(event) 
	connectedClients[1]:setFillColor(unpack(_RED_))
	connectedClients[2]:setFillColor(unpack(_RED_))
	connectedClients[3]:setFillColor(unpack(_RED_))
	connectedClients[4]:setFillColor(unpack(_RED_))
end

-- Client 
onConnectedToServer = function( event )
	table.dump(event) 
	clientIndicators["connected"]:setFillColor(unpack(_GREEN_))
end

onServerFound = function( event )
	serversFound = serversFound  + 1
	
	table.dump(event) 

	if(serversFound > 2) then return false end
	
	connectToServerButtons[serversFound]:enable()
	connectToServerButtons[serversFound]:setText(event.serverIP)
	connectToServerButtons[serversFound].serverIP = event.serverIP
	connectToServerButtons[serversFound].port = event.port


end

onDoneScanningForServers = function( event )
	clientIndicators["scanning"]:setFillColor(unpack(_RED_))
	table.dump(event) 
end

onMsgFromServer = function( event )	table.dump(event) end

onServerDropped = function( event )
	table.dump(event) 
	clientIndicators["connected"]:setFillColor(unpack(_RED_))

	-- Just clear all server buttons for now (easiest solution)
	serversFound = 0
	connectToServerButtons[1]:disable()
	connectToServerButtons[2]:disable()
	connectToServerButtons[1]:setText("----")
	connectToServerButtons[2]:setText("----")

end

onClientStopped = function( event )
	print("onClientStopped")
	table.dump(event) 
	clientIndicators["connected"]:setFillColor(unpack(_RED_))

	-- Just clear all server buttons for now (easiest solution)
	serversFound = 0
	connectToServerButtons[1]:disable()
	connectToServerButtons[2]:disable()
	connectToServerButtons[1]:setText("----")
	connectToServerButtons[2]:setText("----")

end
onBack = function ( event ) 
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
