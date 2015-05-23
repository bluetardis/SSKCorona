local json = require "json"
require "ssk.loadSSK"

local fileMgr = ssk.GGFile:new()

fileMgr:copyBinary( "mm.png.txt", system.ResourceDirectory, "mm.png", system.DocumentsDirectory )

local facebook = require("facebook")

local facebookAppID = "1234567890"  -- Ed

local function listener( event )
	table.print_r(event)

    print( "event.name", event.name )  --"fbconnect"
    print( "event.type:", event.type ) --type is either "session", "request", or "dialog"
    print( "isError: " .. tostring( event.isError ) )
    print( "didComplete: " .. tostring( event.didComplete ) )

    local response = event.response
    if( response and string.len( response ) > 0 ) then
    	response = json.decode( response )
    	table.dump(response, nil, "DUMPED FB RESPONSE")
    	table.dump(response.data[1], nil, "DUMPED FB RESPONSE")
    end

    --"session" events cover various login/logout events
    --"request" events handle calls to various Graph API calls
    --"dialog" events are standard popup boxes that can be displayed

    if ( "session" == event.type ) then
        --options are: "login", "loginFailed", "loginCancelled", or "logout"
        if ( "login" == event.phase ) then
            local access_token = event.token
            --code for tasks following a successful login
        end

    elseif ( "request" == event.type ) then
        print("facebook request")
        if ( not event.isError ) then
            local response = json.decode( event.response )
            --process response data here
        end

    elseif ( "dialog" == event.type ) then
        print( "dialog", event.response )
        --handle dialog results here
    end
end
print("attempting to login to facebook", facebookAppID)
--facebook.login( facebookAppID, listener, { "publish_stream", "user_friends", "email" } )
--facebook.login( facebookAppID, listener, { "publish_stream", "user_friends", "email" } )
--facebook.login( facebookAppID, listener, { "publish_stream", "user_friends", "read_friendlists" } )
facebook.login( facebookAppID, listener, { "user_friends" } )

--facebook.request( "me/feed", "POST", { message="Hello Facebook" } )
--facebook.request( "me/friendslist", "GET", { message="Hello Facebook" } )



local function onComplete( event )
    print( "event.name:", event.name )
    print( "event.type:", event.type )

    if ( event.data ) then
        print( "{" )

        for k, v in pairs( event.data ) do
            print( k, ":", v )
        end

        print( "}" )
    end
end

----[[
timer.performWithDelay( 100,
	function()
	 --facebook.showDialog( "friends", onComplete )
	 --facebook.request( "me/friendlists", "GET", { list_type = "acquaintances"}  )
	 --facebook.request( "me/friendlists", "GET", { list_type = "close_friends"}  )
	 facebook.request( "me", "GET", {} )

	 -- Show the friends picker
	--facebook.showDialog( "friends", onComplete )
	end )
--]]	


timer.performWithDelay( 5000,
	function()
	 --facebook.showDialog( "friends", onComplete )
	--facebook.request( "me/friends", "GET", { }  )

--[[
	facebook.showDialog( "feed", { name = "MM Test Post", 
				                           link = "http://roaminggamer.com/",
				                           caption = "Test MM Caption",
				                           description = "Test MM Message",
				                           ref = "12345"  } )
--]]				                           

	end )


--[[

local allAccounts
local gcbs
local gcbf

local tests = {}
local curTest = 1

tests[1] = function()
	print("------------------------\n Getting account data.")
	tf.getAccount( { onSuccess = gcbs, onFail = gcbf } )
end


tests[2] = function()
	print("------------------------\n Getting own friends")
	tf.getOwnFriends( { onSuccess = gcbs, onFail = gcbf } )
end

tests[3] = function()
	print("------------------------\n Getting own followers")
	tf.getOwnFollowers( { onSuccess = gcbs, onFail = gcbf } )
end

tests[4] = function()
	print("------------------------\n Getting friends of", allAccounts[1].twitter_screen_name)
	tf.getFriendsOf( { screen_name = allAccounts[1].twitter_screen_name,  onSuccess = gcbs, onFail = gcbf } )
end

tests[5] = function()
	print("------------------------\n Getting followers of", allAccounts[1].twitter_screen_name)
	tf.getFollowersOf( { screen_name = allAccounts[1].twitter_screen_name,  onSuccess = gcbs, onFail = gcbf } )
end

--]]

--[[
tests[4] = function()
	print("------------------------\n Tweeting w/ image")
	local imgFullPath = system.pathForFile(  "mm.png", system.DocumentsDirectory )
	tf.tweet( { message = "App connect test - success!", imageFullPath = imgFullPath, onSuccess = gcbs, onFail = gcbf } )
end
--]]

--[[
gcbs = function( event, more )
	print("SUCCESS", event, more )
	table.print_r(event)
	print( tf.getLastResponse() )
	print( tf.getLastError() )
	curTest = curTest + 1
	if(curTest > #tests) then return end
	tests[curTest]()
end

gcbf = function( event, more )
	print("FAIL", event, more )
	table.print_r(event)
	print( tf.getLastResponse() )
	print( tf.getLastError() )
	curTest = curTest + 1
	if(curTest > #tests) then return end
	tests[curTest]()
end


timer.performWithDelay( 1000, 
	function()
		
		table.print_r(tf)
		allAccounts = tf.returnAllStoredAccounts()
		table.print_r( allAccounts )
		tests[curTest]()
	end )

--]]


--[[


-- Starts a local TCP server to listen to Google redirect callback
local startServer = function()
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
	local res, err = tcpServerSocket:bind( "*" , "9006" )
	if res == nil then
	return nil , err
	end

	-- Check Connection
	res , err = tcpServerSocket:listen( backlog )
	if res == nil then
	return nil , err
	end

	local serverTimer = timer.performWithDelay(10, function() 
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

startServer()

local redirect = url_encode( "http://localhost:9006" )
--system.openURL( "https://www.facebook.com/v2.0/dialog/oauth?client_id=587740081284791&redirect_uri={" .. redirect .. "}" )
system.openURL( "https://www.facebook.com/v2.0/dialog/oauth?client_id=587740081284791&redirect_uri={http://localhost:9006}" )

]]




