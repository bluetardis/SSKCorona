-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}


function public.init( group )
end

function public.cleanup( )
end

function public.run( group )
	-- Localizations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC
	local mRand 		= math.random



	local function createRandomList( count )
		local list = {}
		for i = 1, count do
			local entry = { x = centerX + mRand( -w/2, w/2 ), 
			                y = centerY + mRand( -h/2, h/2), 
			                time = mRand( 4000, 8000 ) }
			list[i] = entry
		end
		list[#list+1] = { x = centerX, y = centerY }
		return list
	end

	local function moveRandomly( self )

		if(self.index > #self.myList) then return end
		local entry = self.myList[self.index]
		self.index = self.index + 1
		transition.to( self, { x = entry.x, y = entry.y, entry.time, onComplete = self.move } )
	end

	local function doTest( color )
		local obj = display.newCircle( group, 0, 0, 20 )
		obj:setFillColor(unpack(color))
		obj.myList = createRandomList( 20 )

		obj.move = moveRandomly
		obj.index = 1

		obj:move()
	end



	doTest( { 1, 1, 0 } )
	timer.performWithDelay( 1000, function() doTest( { 1, 0, 0 } ) end )
	timer.performWithDelay( 2000, function() doTest( { 1, 0, 1 } ) end )
	timer.performWithDelay( 3000, function() doTest( { 0, 1, 1 } ) end )
end

function public.about()
	local altName = "Random Mover (JUL 2014)"
	local description = 
	'<font size="22" color="SteelBlue">Random Mover (JUL 2014)</font><br><br><br>' ..
    'From this post:<a href = "https://forums.coronalabs.com/topic/49797-moving-an-object-first-randomly-then-to-center/">CLICK HERE</a><br><br>'
	
	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end

return public