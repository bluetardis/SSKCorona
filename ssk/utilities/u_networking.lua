-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Networking Utilities - NOT READY FOR USE (EFM)
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
--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print


--EFM remove game specific code from this
---------------------------------------------------------------------------------
--
-- u_networking:lua
--
---------------------------------------------------------------------------------
--module(..., package.seeall)

local networking = {}

----------------------------------------------------------------------
--						REQUIRES									--
----------------------------------------------------------------------
local storyboard  = require( "storyboard" )
local json        = require "json"
local gem         =  ssk.gem
local clientClass = require( "ssk.external.mydevelopergames.Client" ) -- Client (External: http://www.mydevelopersgames.com/AutoLAN/)
local serverClass = require( "ssk.external.mydevelopergames.Server" ) -- Server (External: http://www.mydevelopersgames.com/AutoLAN/)

----------------------------------------------------------------------
--						LOCALS										--
----------------------------------------------------------------------
-- Variables
networking.connectedToServer = false
networking.clients = {} 
networking.numClients = 0

networking.serverRunning = false
networking.clientRunning = false

-- Special Variables
networking.myName  = "invalid"
networking.myFinalScore = "invalid"
networking.myDataTable  = invalid

-- Callbacks/Functions
-- COMMON
local dataReceived 

-- SERVER
local host_handleDataReceived
local server_PlayerJoined
local server_PlayerDropped

-- CLIENT
local client_handleDataReceived
local client_DoneScanning
local client_ServerFound
local client_ConnectedToServer
local client_Disconnected
local client_ConnectionFailed


----------------------------------------------------------------------
--						GLOBAL FUNCTIONS							--
----------------------------------------------------------------------

function networking:isNetworking()
	return (self.serverRunning or self.clientRunning )
end

function networking:msgServer( msg, data ) 
	local msg  = msg
	local data = data or {}
	data.msgType = msg	

	clientClass:send( json.encode(data) )
end

function networking:msgClient( aClient, msg, data  )
	local msg  = msg
	local data = data or {}
	data.msgType = msg			

	aClient:send( json.encode(data) )
end

function networking:msgClients( msg, data )
	local msg  = msg
	local data = data or {}
	data.msgType = msg			

	for key,aClient in pairs(self.clients) do
		aClient:send( json.encode(data) )
	end
end

function networking:getNumClients(  )
	return self.numClients
end

function networking:getClientsTable(  )
	return self.clients
end

function networking:startServer( )
	if( self.serverRunning ) then
		return
	end

	serverClass:start() 
	self.serverRunning = true
end

function networking:startClient( )
	if( self.clientRunning ) then
		return
	end

	clientClass:start() 	
	self.clientRunning = true
end


function networking:scanServers( durationMS )
	if( not self.clientRunning ) then
		clientClass:start() 
		self.clientRunning = true
	end
	clientClass:scanServers( durationMS )
end

function networking:stopScanning( )
	if( not self.clientRunning ) then
		return
	end
	clientClass:stopScanning( )
end


function networking:setClientApplicationName( newName ) -- EFM WORKING?
	clientClass:setOptions({applicationName = newName})
end

function networking:setServerApplicationName( newName ) -- EFM WORKING?
	serverClass:setOptions({applicationName = newName})
	serverClass:setCustomBroadcast()
end

function networking:setCustomBroadcast( newBroadcast ) -- EFM WORKING?
	serverClass:setOptions({customBroadcast = newBroadcast})
	serverClass:setCustomBroadcast()
end

function networking:autoconnectToHost( )
	dprint(1,"autoconnectToHost()")
	if( not self.clientRunning ) then
		clientClass:start() 		
		self.clientRunning = true
	end
	clientClass:autoConnect( )
end

function networking:connectToSpecificHost( hostIP )
	dprint(1,"connectToSpecificHost( " .. hostIP .. " )")
	if( not self.clientRunning ) then
		clientClass:start() 
		self.clientRunning = true
	end
	clientClass:connect(hostIP)
end

function networking:stop()
	dprint(1,"stopNetworking()")
	if( self.numClients > 0) then
		serverClass:disconnect()
		for k,v in pairs(self.clients) do 
			local client = self.clients[k]
			clients[k] = nil
			self.numClients = self.numClients - 1	
			client:removeSelf() --EFM BUG?? shouldn't it stop?
		end
		self.numClients = 0
	end

	if( self.connectedToServer == true) then
		clientClass:disconnect()
		self.connectedToServer = false
	end

	serverClass:stop()
	clientClass:stop()

	self.serverRunning = false
	self.clientRunning = false

	self.myName  = "invalid"
	self.myFinalScore = "invalid"
	self.myDataTable  = invalid

	gem:post("CLIENT_STOPPED")
	gem:post("SERVER_STOPPED")
end

function networking:stopClient()
	dprint(1,"stopClient()")

	if( self.connectedToServer == true) then
		clientClass:disconnect()
		self.connectedToServer = false
	end

	clientClass:stop()
	self.clientRunning = false
	gem:post("CLIENT_STOPPED")
end

function networking:stopServer()
	dprint(1,"stopServer()")
	if( self.numClients > 0) then
		serverClass:disconnect()
		for k,v in pairs(self.clients) do 
			local client = self.clients[k]
			clients[k] = nil
			self.numClients = self.numClients - 1	
			client:removeSelf() --EFM BUG?? shouldn't it stop?
		end
		self.numClients = 0
	end

	serverClass:stop()
	self.serverRunning = false

	self.myName  = "invalid"
	self.myFinalScore = "invalid"
	self.myDataTable  = invalid

	gem:post("SERVER_STOPPED")
end


function networking:getClientByKey( key )
	return self.clients[key]
end

function networking:setClient( client )
	self.clients[client] = client
end

function networking:getClientsTable()
	return self.clients
end

function networking:getNumClients()
	return self.numClients
end

function networking:isConnectedToServer()
	return (self.connectedToServer == true)
end

--- Networking: Check Util
function networking:isConnectedToWWW( url )
	local url = url or "www.google.com" 
	local hostFound = true
	local con = socket.tcp()
	con:settimeout( 2 ) -- Timeout connection attempt after 2 seconds
                
	-- Check if socket connection is open
	if con:connect(url, 80) == nil then 
		hostFound = false
		dprint(1, "URL Not Found: " .. url )
	else
		dprint(1, "URL Found: " .. url )
	end

	return hostFound
end

----------------------------------------------------------------------
--	Special Utilities: Player Name, Score, Data					--
----------------------------------------------------------------------

function networking:setMyName( name  )
	if(self.serverRunning) then -- I am the server
		networking.myName = name
	elseif(self.clientRunning) then -- I am a client
		self:msgServer( "_RG_SETNAME_RG_" , { myName = name } )
	end
end

function networking:setMyFinalScore( finalScore  )
	if(self.serverRunning) then -- I am the server
		networking.myFinalScore = finalScore
	elseif(self.clientRunning) then -- I am a client
		self:msgServer( "_RG_SETFINALSCORE_RG_" , { myFinalScore = finalScore } )
	end
end

function networking:setMyData( dataTable  )
	if(self.serverRunning) then -- I am the server
		networking.myDataTable = dataTable
	elseif(self.clientRunning) then -- I am a client
		self:msgServer( "_RG_SETDATA_RG_" , { myDataTable = dataTable } )
	end
end


-- Server ONLY
function networking:clearMyName( )
	if(self.serverRunning) then -- I am the server
		networking.myName = "invalid"
		for k,v in pairs(networking.clients) do
			v.myName = "invalid"
		end
	end
end

function networking:clearMyFinalScore( )
	if(self.serverRunning) then -- I am the server
		networking.myFinalScore = "invalid"

		for k,v in pairs(networking.clients) do
			v.myFinalScore = "invalid"
		end
	end
end

function networking:clearMyData( )
	if(self.serverRunning) then -- I am the server
		networking.myDataTable = "invalid"

		for k,v in pairs(networking.clients) do
			v.myDataTable = "invalid"
		end
	end
end


-- ONLY FOR SERVER
-- Returns 'nil' if one or more names is missing
--
-- Because this returns 'nil' if all the names are not present, it 
-- makes POLLING for names/final-scores very easy.  
function networking:getNames( )  
	if(self.serverRunning) then -- I am the server
		local tmpTable =  {}
		local allFound = true
		
		if( self.myName == "invalid" ) then
			allFound = false
		else
			tmpTable[#tmpTable+1] = self.myName
		end		
		
		for key,aClient in pairs(self.clients) do
			if( aClient.myName == "invalid" ) then
				allFound = false
			else
				tmpTable[#tmpTable+1] = aClient.myName
			end
		end

		if( allFound ) then
			return tmpTable
		end
	end

	return nil
end

-- ONLY FOR SERVER
-- Returns 'nil' if one or more names or final-scores is missing
--
-- Because this returns 'nil' if all the names/final-scores are not present, it 
-- makes POLLING for names very easy.  
function networking:getFinalScores( )  
	if(self.serverRunning) then -- I am the server
		local tmpTable =  {}
		local allFound = true
		
		if( self.myName == "invalid" or self.myFinalScore == "invalid") then
			allFound = false
		else
			tmpTable[#tmpTable+1] = { name = self.myName, finalScore = self.myFinalScore }
		end		
		
		for key,aClient in pairs(self.clients) do
			if( aClient.myName == "invalid" or aClient.myFinalScore == "invalid") then
				allFound = false
			else
				tmpTable[#tmpTable+1] = { name = aClient.myName, finalScore = aClient.myFinalScore }
			end
		end

		if( allFound ) then
			return tmpTable
		end
	end

	return nil
end

-- ONLY FOR SERVER
-- Returns 'nil' if one or more names or data is missing
--
-- Because this returns 'nil' if all the names/data are not present, it 
-- makes POLLING for names/data very easy.  
function networking:getData( )  
	if(self.serverRunning) then -- I am the server
		local tmpTable =  {}
		local allFound = true
		
		if( self.myName == "invalid" or self.myDataTable == "invalid") then
			allFound = false
		else
			tmpTable[#tmpTable+1] = { name = self.myName, data = self.myDataTable }
		end		
		
		for key,aClient in pairs(self.clients) do
			if( aClient.myName == "invalid" or aClient.myDataTable == "invalid") then
				allFound = false
			else
				tmpTable[#tmpTable+1] = { name = aClient.myName, data = aClient.myDataTable }
			end
		end

		if( allFound ) then
			return tmpTable
		end
	end

	return nil
end



function networking:setClientPlayerScore( aClient, score  )
	aClient.playerScore = score
end

function networking:getClientPlayerScore( aClient  )
	return aClient.playerScore
end

function networking:getClientPlayerScores( aClient  ) -- EFM THIS IS WRONG
	local tmpTable =  {}
	for key,aClient in pairs(self.clients) do
		tmpTable[#tmpTable+1] = { aClient.playerName, aClient.playerScore }
		--tmpTable[aClient.playerScore] =  aClient.playerName
	end
	return tmpTable
end

function networking:clearClientPlayerScores( aClient  )
	for key,aClient in pairs(self.clients) do
		aClient.playerScore = 0
		aClient.gameOver = false
	end
end


----------------------------------------------------------------------
--						CALLBACK DEFINITIONS						--
----------------------------------------------------------------------

function networking:registerCallbacks()
	dprint(2,"ssk.networking - registerCallbacks()")

	-- SERVER
	Runtime:addEventListener("autolanPlayerJoined", server_PlayerJoined)
	Runtime:addEventListener("autolanPlayerDropped", server_PlayerDropped)

	-- CLIENT
	
	Runtime:addEventListener("autolanDoneScanning", client_DoneScanning)
	Runtime:addEventListener("autolanServerFound", client_ServerFound)
	Runtime:addEventListener("autolanConnected", client_ConnectedToServer)
	Runtime:addEventListener("autolanDisconnected", client_Disconnected)
	Runtime:addEventListener("autolanConnectionFailed", client_ConnectionFailed)

	-- BOTH
	Runtime:addEventListener("autolanReceived", dataReceived)

end


---- COMMON
dataReceived = function (event)	
	dprint(2,"Received message")

	if(networking.connectedToServer) then   --- I AM A CLIENT
		client_handleDataReceived(event)	

	else                         --- I AM THE SERVER		
		host_handleDataReceived(event)
	end

	return false -- Let others catch this too
end

---- SERVER
host_handleDataReceived = function (event)
	dprint(2,"host_handleDataReceived()")

	local client = event.client
	local msg = json.decode( event.message )

	-- Handle SPECIAL MESSAGES without fowarding
	-- _RG_SETNAME_RG_, _RG_SETFINALSCORE_RG_, _RG_SETDATA_RG_
	--
	if(msg.msgType == "_RG_SETNAME_RG_") then
		client.myName = msg.myName
	
	elseif(msg.msgType == "_RG_SETFINALSCORE_RG_") then
		client.myFinalScore = msg.myFinalScore

	elseif(msg.msgType == "_RG_SETDATA_RG_") then 
		client.myDataTable = msg.myDataTable
	
	else
		gem:post("MSG_FROM_CLIENT", { clientID = client, msgTable = msg } )

	end

	return true -- Do not let others catch this too
end

server_PlayerJoined = function (event)
	dprint(1,"server_PlayerJoined()" )

	local client = event.client

	client.myName  = "invalid"
	client.myFinalScore = "invalid"
	client.myDataTable  = invalid

	networking.clients[client] = client
	networking.numClients = networking.numClients + 1
	client.myJoinTime = system.getTimer() 
	gem:post("CLIENT_JOINED", { clientID = client } )

	return true -- Do not let others catch this too
end

server_PlayerDropped = function (event)
	dprint(1,"server_PlayerDropped()")

	local client = event.client

	dprint(2,"HOST - server_PlayerDropped() - " .. 
	" Dropped b/c " .. event.message .. 
	" connection was active for " .. system.getTimer() - networking.clients[client].myJoinTime .. " ms" )

	-- Immediately decrement client count
	networking.numClients = networking.numClients - 1	

	-- Post drop event to listeners with client info
	gem:post("CLIENT_DROPPED", { clientID = client, dropReason = event.message } )

	-- Finally, clear the client info
	-- Take player out of game and remove their name
	client.myName  = nil
	client.myFinalScore = nil
	client.myDataTable  = nil

	networking.clients[client] = nil --clear references to prevent memory leaks


	return true -- Do not let others catch this too
end

------ CLIENT
client_handleDataReceived = function (event)
	dprint(1,"client_handleDataReceived() " .. event.message)

	local theServer = event.client
	local msg = json.decode( event.message )

	gem:post("MSG_FROM_SERVER", { clientID = client, msgTable = msg } )

	return true -- Do not let others catch this too
end

client_DoneScanning = function (event)
	dprint(1,"client_DoneScanning()" )

	local myEvent = event
	gem:post("DONE_SCANNING_FOR_SERVERS", myEvent )

	return true -- Do not let others catch this too
end


client_ServerFound = function (event)
	dprint(1,"client_ServerFound()")
	dprint(2,"JOIN - client_ServerFound() - event.serverName == " .. event.serverName )
	dprint(2,"                            - event.serverIP   == " .. event.serverIP )

	local myEvent = event
	gem:post("SERVER_FOUND", myEvent )

	return true -- Do not let others catch this too
end

client_ConnectedToServer = function (event)
	dprint(1,"client_ConnectedToServer()")
	dprint(2,"JOIN - client_ConnectedToServer() - event.serverIP == " .. event.serverIP )

	networking.connectedToServer = true
	local myEvent = event
	gem:post( "CONNECTED_TO_SERVER",  myEvent )

	return true -- Do not let others catch this too
end

client_Disconnected = function (event)
	dprint(1,"client_Disconnected()")
	dprint(2,"JOIN - client_Disconnected() - event.message  == " .. event.message )
	dprint(2,"                             - event.serverIP == " .. event.serverIP )

	networking.connectedToServer = false
	local myEvent = event
	myEvent.dropReason = "Disconnected"
	gem:post( "SERVER_DROPPED",  myEvent )

	return true -- Do not let others catch this too
end

client_ConnectionFailed = function (event)
	dprint(1,"client_ConnectionFailed()")
	dprint(2,"JOIN - client_ConnectionFailed() - event.serverIP == " .. event.serverIP )

	networking.connectedToServer = false
	local myEvent = event
	myEvent.dropReason = "Dropped"
	gem:post("SERVER_DROPPED" ,  myEvent )

	return true -- Do not let others catch this too
end

return networking