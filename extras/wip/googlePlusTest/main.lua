require "ssk.loadSSK"
local json = require("json")

--[[
local googleConnect =  require "googleConnect"


local function cb( event )

	print("BOOMB")
	table.print_r(event)
end

print("FUNKTASTIC")

local button

timer.performWithDelay( 5000, 
	function() 
		print("POOKA")
		googleConnect.connect(cb)

		button = display.newRect( 0, 0, 100, 100)
		button.touch = function( self, event )
		end; addEventLis


	end )

--]]

print("FUNKTASTIC")	

local googleConnect =  require "googleConnect"
local function connectCallback(event)
	print("IN CONNECT CALLBACK ==============>")
	--table.print_r(event)
	table.dump(event)
	print("<=============== IN CONNECT CALLBACK")
    if(not event.isError) then
        googleConnect.api("https://www.googleapis.com/oauth2/v1/userinfo", "GET", function(event)
        	print("GOT USER INFO ==============>")
        	table.dump(event)
        	local response = json.decode( event.response )
        	table.dump(response)
        	print("<=============== GOT USER INFO")
            --print(event.response)
        end)
    else
    end
end
googleConnect.connect(connectCallback)

--[[

timer.performWithDelay( 10000,
	function()
		print("FUNKY")
		googleConnect.api("https://www.googleapis.com/oauth2/v1/userinfo", "GET", 
			function(event)  
				print(event.response)
        	end )
	end )


-- PEOPLE LIST: ??? what is YOUR_API_KEY
-- GET https://www.googleapis.com/plus/v1/people/115993784358801200530/people/visible?key={YOUR_API_KEY}
-- What? {YOUR_API_KEY} https://developers.google.com/explorer-help/
-- https://developers.google.com/+/api/latest/people/list 

timer.performWithDelay( 20000,
	function()
		print("MUNKY")
		googleConnect.api("https://www.googleapis.com/plus/v1/people/115993784358801200530/people/visible", "GET", 
			function(event)  
				print(event.response)
        	end )
	end )

--]]