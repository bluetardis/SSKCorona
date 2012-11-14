-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Game Event Manager (uses Runtime Events and makes managing them simple)
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

local pointsFactory = {}
--[[
h ssk.points:new
d Create a new points instance.
d <br>Note: A points instance is a table of tabeles ,where each inner-table is a pair of x,y positions stored.  The points instance is organized like this: { {x=#, y=#}, {x=#, y=#}, ... }
s ssk.points:new( ... )
s * x,y pairs of points to initialize the list with.
r A points list (pointsInstance).
--]]
	function pointsFactory:new( ... )
		local pointsInstance = {}

--[[
h pointsInstance:add
d Appends any number of point x,y pairs to the points list.
s pointsInstance:add( x1,y1,... )
s * x1,y1,... - One or more pairs of x,y values.
r None.
--]]
		function pointsInstance:add(...)
			if(#arg % 2 == 1) then return end
			local i = 1
			while(i < #arg) do
				pointsInstance[#pointsInstance+1] = {x=arg[i],y=arg[i+1]}
				i = i + 2
			end			
		end

--[[
h pointsInstance:insert
d EFM
s pointsInstance:insert( index, x1,y1,... )
s * index - Numeric index starting at 1, indicating the point before which to insert the new points.
s * x1,y1,... - One or more pairs of x,y values.
r None.
--]]
		function pointsInstance:insert(index, ...)

			local index = index or 1
			if(#arg % 2 == 1) then return end
			local i = 1
			while(i < #arg) do
				table.insert( self, index, {x=arg[i],y=arg[i+1]} )
				i = i + 2
				index = index + 1
			end			
		end

--[[
h pointsInstance:get
d Gets a single point out of the points list.
s pointsInstance:get( index )
s * index - A number specifying the index of the point (startng at 1) to retrieve.
r A table containg the point in the form {x=#, y=#}.
--]]
		function pointsInstance:get(index)
			local index = index or 1
			return pointsInstance[index]
		end

--[[
h pointsInstance:remove
d Removes a single point from the points list
s pointsInstance:remove( index )
s * index - A number specifying the index of the point (startng at 1) to remove.
r A table containing the removed point in the form {x=#, y=#}.
--]]
		function pointsInstance:remove(index)
			local index = index or 1
			local element = table.remove( self, index )
			return element
		end

		-- Treat like a stack/queue (more efficient [overall] than add(), insert(), get(), remove() above)
--[[
h pointsInstance:push
d Treats points list like a stack/FILO and pushes one or more point sets onto the points list top (end).
s pointsInstance:push( x1,y1,... )
s * x1,y1,... - One or more pairs of x,y values.
r None.
--]]
		function pointsInstance:push(...)
			if(#arg % 2 == 1) then return end
			local i = 1
			while(i < #arg) do
				pointsInstance[#pointsInstance+1] = {x=arg[i],y=arg[i+1]}
				i = i + 2
			end
		end
--[[
h pointsInstance:peek
d Treats points list like a stack/FILO and retrieves the point at the top (end) of the points list.
s pointsInstance:peek( )
r A table containing the retrieved point in the form {x=#, y=#}.
--]]
		function pointsInstance:peek()
			return self[#self]
		end
--[[
h pointsInstance:pop
d Treats points list like a stack/FILO and pops the point at the top (end) off the points list.
s pointsInstance:pop( )
r A table containing the popped point in the form {x=#, y=#}.
--]]
		function pointsInstance:pop()
			if( not #self ) then return nil end
			local element = self[#self]
			self[#self] = nil
			return element
		end
		-- add head variants (above are always tail of queue) (same efficiency as add(), insert(), get(), remove() above)
--[[
h pointsInstance:push_head
d Treats points list like a queue/FIFO and pushes one or more point sets (in reverse order) onto the points list front. Like calling ''insert(1, x1,y1)'', ''insert(1, x2,y2)'', ..., ''insert(1, xN,yN)'', 
s pointsInstance:push_head( x1,y1,... )
s * x1,y1,... - One or more pairs of x,y values.
r None.
--]]
		function pointsInstance:push_head(...)
			if(#arg % 2 == 1) then return end
			local i = 1
			while(i < #arg) do
				table.insert( self, 1, {x=arg[i],y=arg[i+1]} )
				i = i + 2
			end			
		end
--[[
h pointsInstance:peek_head
d Treats points list like a queue/FIFO and retrieves the point at the front of the points list. Like a ''get'' at 1.
s pointsInstance:peek_head( )
r A table containing the retrieved point in the form {x=#, y=#}.
--]]
		function pointsInstance:peek_head()
			return self[1]
		end

--[[
h pointsInstance:pop_head
d Treats points list like a queue/FIFO and pops the point at the front off the points list. Like a ''remove'' at 1.
s pointsInstance:pop_head( )
r A table containing the popped point in the form {x=#, y=#}.
--]]
		function pointsInstance:pop_head(x,y)
			local element = table.remove( self, 1 )
			return element
		end

		-- If any points were passed, add them now
		pointsInstance:add( unpack( arg ) )

		return pointsInstance
	end

return pointsFactory