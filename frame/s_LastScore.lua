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

local myScore = 0

-- Callbacks/Functions
local createLayers
local addInterfaceElements_SP
local addInterfaceElements_MP
local addInterfaceElements_MP_Part2

local pollClientScores
local onBack
local onReplay

-- Client Callbacks
local onMsgFromServer
local onServerDropped
local onClientStopped

-- Server Callbacks
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

	createLayers()

	myScore = event.params.score

	if(not ssk.networking:isNetworking()) then
		addInterfaceElements_SP()
	else

		ssk.networking:setMyFinalScore( myScore )
		
		if( ssk.networking:isConnectedToServer() ) then -- I AM A CLIENT
			--print("I am a client")
			ssk.gem:add("MSG_FROM_SERVER", onMsgFromServer, "lastScoreNetworking" )
			ssk.gem:add("SERVER_DROPPED", onServerDropped, "lastScoreNetworking" )
			ssk.gem:add("CLIENT_STOPPED", onClientStopped, "lastScoreNetworking" )

			addInterfaceElements_MP()
		
		else                                            -- I AM THE SERVER
			--print("I am the server")
			ssk.gem:add("MSG_FROM_CLIENT", onMsgFromClient, "lastScoreNetworking" )
			ssk.gem:add("CLIENT_DROPPED", onClientDropped, "lastScoreNetworking" )
			ssk.gem:add("SERVER_STOPPED", onServerStopped, "lastScoreNetworking" )

			addInterfaceElements_MP()
			
			pollClientScores()
		
		end
	end
	
	--timer.performWithDelay( 3500, onReplay )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:exitScene( event )
	screenGroup = self.view	
	ssk.gem:removeGroup( "lastScoreNetworking" )
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExitScene( event )
	screenGroup = self.view

	layers:destroy()
	layers = nil
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
	layers = ssk.display.quickLayers( screenGroup, "background", "pollingLayer", "interfaces" )
end

-- addInterfaceElements_SP() - Create Single Player interfaces for this scene
addInterfaceElements_SP = function( )

	-- Background Image
	backImage   = ssk.display.backImage( layers.background, "protoBack2.png" ) 

	-- ==========================================
	-- Buttons and Labels
	-- ==========================================
	local curY
	local tmpButton
	local tmpLabel

	-- Page Title 
	ssk.labels:presetLabel( layers.interfaces, "default", "Score", centerX, 30, { fontSize = 32 } )

	-- My Score
	ssk.labels:presetLabel( layers.interfaces, "default", "You scored: " .. myScore .. " points!", centerX, centerY, { fontSize = 24 } )

	-- BACK 
	curY = centerY - 75
	ssk.buttons:presetPush( layers.interfaces, "default", 60 , h - 60, 100, 40,  "Done", onBack )
end	

-- addInterfaceElements_MP() - Create Single Player interfaces for this scene
addInterfaceElements_MP = function( )

	-- Background Image
	backImage   = ssk.display.backImage( layers.background, "protoBack2.png" ) 

	-- ==========================================
	-- Buttons and Labels
	-- ==========================================
	local curY = 30
	local tmpButton
	local tmpLabel

	-- Page Title 
	ssk.labels:presetLabel( layers.interfaces, "default", "Score", centerX, curY, { fontSize = 32 } )

	-- My Score
	ssk.labels:presetLabel( layers.pollingLayer, "default", "Collecting scores...", centerX, centerY, { fontSize = 32 } )

	-- BACK 
	curY = centerY - 75
	ssk.buttons:presetPush( layers.interfaces, "default", 60 , h - 60, 100, 40,  "Done", onBack )

end	

-- addInterfaceElements_MP_Part2( scores ) - Create Single Player interfaces for this scene
addInterfaceElements_MP_Part2 = function( scores )

	-- Hide the polling layer and any GUIs there
	layers.pollingLayer.isVisible = false

	-- Background Image
	backImage   = ssk.display.backImage( layers.background, "protoBack2.png" ) 

	-- ==========================================
	-- Buttons and Labels
	-- ==========================================
	local curY = 120
	local tmpButton
	local tmpLabel

	local highScore  = 0
	local winnerName = "none"

	for i = 1, #scores do
		if( tonumber(scores[i].finalScore) > highScore) then
			highScore  = scores[i].finalScore
			winnerName = scores[i].name
		end

		-- My Score
		ssk.labels:presetLabel( layers.interfaces, "rightLabel", scores[i].name, centerX - 10, curY, { fontSize = 22 } )
		ssk.labels:presetLabel( layers.interfaces, "leftLabel", tostring(scores[i].finalScore):lpad(9), centerX + 10, curY, { fontSize = 22 } )
		curY = curY + 25


	end

	-- My Score
	curY = curY + 20
	ssk.labels:presetLabel( layers.interfaces, "default", winnerName .. " won!" , centerX, curY, { fontSize = 24 } )


	-- BACK 
	curY = centerY - 75
	ssk.buttons:presetPush( layers.interfaces, "default", 60 , h - 60, 100, 40,  "Done", onBack )

end	


pollClientScores = function( )
	local scores = ssk.networking:getFinalScores()
	if( scores ) then
		print("\n\n\nGot all scores\n\n\n")
		--timer.performWithDelay( 500, onReplay )
		ssk.networking:msgClients( "FINAL_SCORES", { scores = scores } )
		addInterfaceElements_MP_Part2( scores )

	else
		print("\n\n\nDid NOT get all scores\n\n\n")
		timer.performWithDelay( 250, pollClientScores )
		
	end
end

onBack = function ( event ) 
	if(ssk.networking:isNetworking()) then
		ssk.networking:clearMyFinalScore( myScore )
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

onReplay = function ( event ) 
	ssk.networking:clearMyFinalScore( myScore )
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

--
-- Client Callbacks
--
onMsgFromServer = function( event )	
	local msgTable = event.msgTable
	table.dump(event) 

	if(msgTable.msgType == "FINAL_SCORES") then
		addInterfaceElements_MP_Part2( msgTable.scores )
	end

end

onServerDropped = function( event )
	table.dump(event) 
end

onClientStopped = function( event )
	table.dump(event) 
end

--
-- Server calbacks
--
onMsgFromClient = function( event )	
	local msgTable = event.msgTable
	table.dump(event) 
end

onClientDropped = function( event )
	table.dump(event) 
end

onServerStopped = function( event )
	table.dump(event) 
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
