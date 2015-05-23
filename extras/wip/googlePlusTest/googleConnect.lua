---
-- Connecting with Google via OAUTH2
-- @version 1.0
-- @author Cassiozen
-- @license MIT License
---

--module(...,package.seeall)
local socket = require("socket")
local json = require("json")
local credentials
local connectCallback

local authenticateUser
local saveRefreshToken
local requestCredentialsCallback
local requestCredentials
local requestToken
local redirectCallback
local startServer


local options = {}
--options.client_id = "abcdefg.apps.googleusercontent.com" --EFM
--options.client_secret = "abcdefg" --EFM

options.scope = "https://www.googleapis.com/auth/userinfo.email+https://www.googleapis.com/auth/userinfo.profile" -- Set your desired scopes. More info at https://developers.google.com/accounts/docs/OAuth2Login#scopeparameter
options.response_type = "code"
options.redirect_uri = "http://localhost:9004"
--options.redirect_uri = "https://www.roamgingamer.com/oauth2callback" --EFM


local g = {}

-- Opens a webpopup so user can login at google and authorize app. Starts internal TCP server to listen to Google's redirect
authenticateUser = function()
	print("authenticateUser")
	startServer()
	local authUrl = string.format("https://accounts.google.com/o/oauth2/auth?scope=%s&redirect_uri=%s&response_type=%s&client_id=%s", options.scope, options.redirect_uri, options.response_type, options.client_id)
	local function cb(event)
		table.print_r(event)
	end
	--native.showWebPopup( 10, 40, 300, 440, authUrl, { urlRequest = cb } )	
	native.showWebPopup( 10, 40, 300, 440, authUrl)	
end

-- Saves the user's refresh token on a json file
saveRefreshToken = function()
    local file = io.open(system.pathForFile("googleAccount.json", system.DocumentsDirectory), "w")
    if file then
        file:write( json.encode({refreshToken = credentials["refresh_token"]}) )
        io.close( file )
    end
end

-- Callback for requestCredentials and requestToken methods
-- Gets the user token and call's the callback passed as parameter on g.connect
requestCredentialsCallback = function( event )
	table.print_r(event)
	-- Prepares the table to return
	local connectedResponse = {
    	name = "connected",
    	response = event.response
	}
	-- Check for connection errors
    if ( event.isError ) then
    	connectedResponse.isError = true
    	pcall(connectCallback, connectedResponse)
    else
        credentials = json.decode(event.response)
         -- Check if user hasn't revoked access
        if (credentials["error"]) then
        	-- If so, delete the refreshtoken persisted data and try login in again
			os.remove( system.pathForFile("googleAccount.json", system.DocumentsDirectory) )
			authenticateUser()
			return
        end
        -- If there's a refrsh token, save it on a json file for later use
        if(credentials["refresh_token"]) then saveRefreshToken() end
        connectedResponse.isError = false
        pcall(connectCallback, connectedResponse)
    end
    connectCallback = nil
end

-- Request user's access and refresh tokens
requestCredentials = function(code)
	local params = {}
	params.body = string.format("code=%s&client_id=%s&client_secret=%s&redirect_uri=%s&grant_type=authorization_code", code, options.client_id, options.client_secret, options.redirect_uri)
	network.request( "https://accounts.google.com/o/oauth2/token", "POST", requestCredentialsCallback, params)
end

-- Request a new user's access token using a refresh token
requestToken = function(refreshToken)
	local params = {}
	params.body = string.format("refresh_token=%s&client_id=%s&client_secret=%s&grant_type=refresh_token", refreshToken, options.client_id, options.client_secret)
	network.request( "https://accounts.google.com/o/oauth2/token", "POST", requestCredentialsCallback, params)
end

-- Listen to the httprequest google does on local ServerSocket
redirectCallback =  function (request)
	-- Sample succes request
	-- GET /?code=4/lNorA-RhjdU87F7XfTV3ib8oeqOX.ItKgfHhj74fHshQV0ieZDAqsb31Aqui HTTP/1.1
	-- Sample error response
	-- GET /?error=access_denied HTTP/1.1

	-- Check if the returned request header contains a code or an error
	-- TODO: Check if this regexes are really working on all conditions on all kinds of users
	local errors = string.match(request, "GET /??error=([%w_/.=?]+)")
	local code = string.match(request, "GET /??code=([%w--_/.=?]+)")
	if(errors or not code) then
		-- Something went wrong. Try authenticating again
		authenticateUser()
		return
	else 
		native.cancelWebPopup()
		requestCredentials(code)
	end

end

-- Starts a local TCP server to listen to Google redirect callback
startServer = function()
	-- Create Socket
	local tcpServerSocket , err = socket.tcp()
	local backlog = 0

	-- Check Socket
	if tcpServerSocket == nil then
	return nil , err
	end

	-- Allow Address Reuse
	tcpServerSocket:setoption( "reuseaddr" , true )

	-- Bind Socket
	local res, err = tcpServerSocket:bind( "*" , "9004" )
	if res == nil then
	return nil , err
	end

	-- Check Connection
	res , err = tcpServerSocket:listen( backlog )
	if res == nil then
	return nil , err
	end

	serverTimer = timer.performWithDelay(10, function() 
		tcpServerSocket:settimeout( 0 )
		client = tcpServerSocket:accept()
		if (client ~= nil) then
			ip, port = client:getpeername()
			print(">>>>>>>>>>>> Got connection from ".. ip .. " on port " .. port)

			local request, err = client:receive()
			if not err then
				client:close()
				timer.cancel(serverTimer)
				redirectCallback(request)
			end
		end
	end, 0)
end


g.connect = function(callback) 
	connectCallback = callback

	local file = io.open(system.pathForFile("googleAccount.json", system.DocumentsDirectory), "r")
	-- First, check if it's a saved refresh token, so we can authenticate user without prompting him to enter login and password
    if file then
    	print("CONNECT - FOUND TOKEN FILE")
        local googleAccount = json.decode(file:read( "*a" ))
        io.close( file )
        requestToken(googleAccount["refreshToken"])
    -- If we don't have a refresh token, open a webPopup so he can log in
    else
    	print("CONNECT - DID NOT FIND TOKEN FILE")
    	authenticateUser()
	end
end

g.api = function(url, method, callback)
	local apiResponse = {
    	name = "apiResponse",
	}
	if(not credentials) then
		apiResponse.isError = true
		apiResponse.response = "Token not aquired."
		pcall(callback, apiResponse)
	else
		local headers = {}
		headers["Authorization"] = "Bearer " .. credentials["access_token"]
		local params = {}
		params.headers = headers

		network.request(url, method, function(event) 
			apiResponse.isError = event.isError
			apiResponse.response = event.response
			pcall(callback, apiResponse)
		end,  params)
	end
end

return g
