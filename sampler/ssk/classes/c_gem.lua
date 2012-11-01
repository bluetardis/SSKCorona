-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Game Event Manager (uses Runtime Events and makes managing them simple)
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSK library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSK or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSK and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Last Modified: 29 AUG 2012
-- =============================================================
--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

local gameEventManger = {}

gameEventManger.eventsDB = {}
gameEventManger.eventGroupsDB = {}

--[[
h gem:add
d Registers a ''handler'' function with the global event ''eventName''.
d <br>Note: This has the same functionality as Runtime:addEventListener( eventName, handler ) and
d can be used as shorthand for it if you like.
s gem:add( eventName, handler [ , group ] )
s * eventName - A string containing the name of the event to add (register).
s * handler - The handle to a function which will process the event when it occurs.
s * group - (optional), A string containing a name under which to group this event-handler pairing.
r None.
e local fuction myHandler( event )
e end
e 
e ssk.gem:add( "My Event", myHandler )
--]]
function gameEventManger:add( eventName, handler, group )
	if(group) then
		if(not self.eventGroupsDB[group] ) then
			self.eventGroupsDB[group] = {}
		end

		local eventGroup = self.eventGroupsDB[group]
		eventGroup[handler] = eventName
	else
		self.eventsDB[handler] = eventName
	end
	Runtime:addEventListener( eventName, handler )
end

--[[
h gem:remove
d Un-registers a ''handler'' function with the global event ''eventName''.
d <br>Note: This has the same functionality as Runtime:removeEventListener( eventName, handler ) and
d can be used as shorthand for it if you like.
s gem:remove( eventName, handler )
s * eventName - A string containing the name of the event to add (register).
s * handler - The handle to a function which will process the event when it occurs.
r None.
e local fuction myHandler( event )
e end
e 
e ssk.gem:add( "My Event", myHandler )
e
e ssk.gem:remove( "My Event", myHandler )
e
--]]
function gameEventManger:remove( eventName, handler )
	Runtime:removeEventListener( eventName, handler )
	self.eventsDB[handler] = nil
end

--[[
h gem:removeGroup
d Automatically un-registers all handlers and event previously registered with gem:add() using a named ''group''.
s gem:removeGroup( group )
s * group - A string containing the name of a previously used event group.
r None.
e local fuction myHandler( event )
e end
e local fuction myHandler2( event )
e end
e 
e ssk.gem:add( "My Event", myHandler , "Level 1 Group")
e ssk.gem:add( "My Event Two", myHandler2, "Level 1 Group" )
e
e ssk.gem:removeGroup( "Level 1 Group" )
d
d The above code un-registers both "My Event" and "My Event Two" as well as their handlers.
--]]
function gameEventManger:removeGroup( group )

	if(not self.eventGroupsDB[group] ) then
		return
	end

	local eventGroup = self.eventGroupsDB[group]

	for k,v in pairs(eventGroup) do
		Runtime:removeEventListener( v, k )
	end

	self.eventGroupsDB[group] = {}
end


--[[
h gem:removeAll
d Automatically un-registers all non-grouped handlers and event previously that were registered with gem:add().
s gem:removeAll( )
r None.
e local fuction myHandler( event )
e end
e local fuction myHandler2( event )
e end
e 
e ssk.gem:add( "My Event", myHandler )
e ssk.gem:add( "My Event Two", myHandler2)
e
e ssk.gem:removeAll( )
d
d The above code un-registers both "My Event" and "My Event Two" as well as their handlers.
--]]
function gameEventManger:removeAll( ) -- Does not affect grouped events (yet)
	for k,v in pairs(self.eventsDB) do
		Runtime:removeEventListener( v, k )
	end
	self.eventsDB = {}
end

--[[
h gem:post
d Posts (dispatches) a named event.
d <br>Note: This has the same functionality as Runtime:dispatchEvent( { name = ''evenName'', } ) and
d can be used as shorthand for it if you like.
s gem:post( eventName [ , eparams ] )
s * eventName - A string specifying the event to post (dispatch).
s * eparams - (optional) extra data to pass as part of the event.
r None.
e local fuction myHandler( event )
e end
e local fuction myHandler2( event )
e     local name = event.name
e     local x,y = event.x, event.y
e     print( name, "got (x,y) ", x, y )
e end
e 
e ssk.gem:add( "My Event", myHandler )
e ssk.gem:add( "My Event Two", myHandler2)
e
e ssk.gem:post( "My Event Two", { x=10, y=20 }  )
d
d <br>Prints:<br>
d <br>My Event Two got (x,y) 10 20
d
--]]
function gameEventManger:post( eventName, eparams )
	local params = eparams or {}
	params.name = eventName
	--table.insert(params, "name", eventName)
	if( debugLevel > 1 ) then
		dprint(2,"gem:post() =>")
		for k,v in pairs(params) do 
			local ktype = type(k)
			local vtype = type(v)
			if( not (ktype == "number" or ktype == "string" or ktype == "boolean") ) then
				k = "other" 
			end
			if( not (vtype == "number" or vtype == "string" or vtype == "boolean") ) then
				v = "other" 
			end
			dprint(2, "   arg: " .. k .. " = " .. v)		
		end
		dprint(2,"----")
	end

	Runtime:dispatchEvent(params)
end

return gameEventManger