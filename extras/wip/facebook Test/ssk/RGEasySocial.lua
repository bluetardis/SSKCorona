local onFacebook6
local onTwitter5
local onTwitter6
local onMail


local function twitterListener( event )
	--table.print_r( event )
	if(event and event.action == "sent") then 
		print("AWESOME!  Successfully tweeted!  90 more seconds for you!")

	elseif(event and event.action == "cancelled") then 
		print("NOPE!  You cancelled the tweet.  No 90 seconds for you!")
	end
end

local function facebookListener( event )
	--table.print_r( event )
	if(event and event.action == "sent") then 
		print("AWESOME!  Successfully posted to Facebook!  90 more seconds for you!")

	elseif(event and event.action == "cancelled") then 
		print("NOPE!  You cancelled the post to faceBook.  No 90 seconds for you!")
	end
end



local function genericListener( event )
	table.dump( event )
end

local platVer = tonumber(string.sub(system.getInfo("platformVersion"),1,1)) or 1

onFacebook6 = function( msg, url )
	local msg = msg or "Test Twitter Msg"

	local options = {
		service = "facebook",
		message = msg,
		url = url,
		listener = facebookListener,
	}
	return native.showPopup( "social", options )
end

onTwitter5 = function( msg )
	local msg = msg or "Test Twitter Msg"

	local options = {
   		message = msg,
   		listener = twitterListener,
	}
	return native.showPopup( "twitter", options )
end


onTwitter6 = function( msg, url )

	local msg = msg or "Test Twitter Msg"

	local options = {
	   	service = "twitter",
	   	message = msg,
	   	url = url,
		listener = twitterListener,
	}
	return native.showPopup( "social", options )
end

--[[
 -- Worked! Requires 5+

	--if( oniOS ) then 
		local options = {
	   		message = msg
		}
		native.showPopup( "twitter", options )
	--end

-- Worked! (for iOS and sort of for Android) Requires 6+
		local options = {
		   service = "twitter",
		   message = msg,
		   url = "http://mobileapps.reelfx.com/reelfx/shaving-face"
		}
		native.showPopup( "social", options )

-- Worked! (for iOS but not for Android) Requires 6+

		local options = {
		   service = "facebook",
		   message = msg,
		   url = "http://mobileapps.reelfx.com/reelfx/shaving-face"
		}
		native.showPopup( "social", options )
--]]



onMail = function( subject, msg, isBodyHtml, to, attachment )

	local isBodyHtml = isBodyHtml or false
	if( isBodyHtml ) then
		msg = "<html><body>" .. msg .. "</body></html>"
	end
	local to = to
	if( type(to) == "string" ) then
		to = { to }
	end

	local options =
	{
		to = to,
		subject = subject,
		isBodyHtml = isBodyHtml,
		body = msg,
		listener = genericListener,
		attachment = attachment,
	}
	return native.showPopup("mail", options)		
end


local function dummyFB() print("Facebook not supported on this platform/OS version yet.") end
local function dummyTwitter() print("Twitter not supported on this platform/OS version yet.") end
local function dummyEmail() print("E-mail not supported on this platform/OS version yet.") end


local public = {}

if( oniOS and platVer >= 6 ) then
	print(">>>>>>>> RGEasySocial: oniOS and platVer >= 6")
	public.onFacebook = onFacebook6
	public.onTwitter = onTwitter6
	public.onEmail = onMail

elseif( oniOS and platVer >= 5 ) then
	print(">>>>>>>> RGEasySocial: oniOS and platVer >= 5")
	public.onFacebook = dummyFB
	public.onTwitter = onTwitter5
	public.onEmail = onMail

elseif( onAndroid ) then
	print(">>>>>>>> RGEasySocial: onAndroid")
	public.onFacebook = dummyFB
	public.onTwitter = onTwitter6
	public.onEmail = onMail
else
	print(">>>>>>>> RGEasySocial: Other")
	public.onFacebook = dummyFB
	public.onTwitter = dummyTwitter
	public.onEmail = onMail
end	

if( not ssk.social ) then
	ssk.social = public
end

return public