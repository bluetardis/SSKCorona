-- *** 
-- *** This was the starting point for my more recent code in SSK
-- *** 
-- *** 
-- *** The purpose of this experiment was to find a way to automatically
-- *** clean up Runtime listers, timers, etc. when objects they are associated
-- *** with get destroyed.
-- *** 

-- =============================================================
-- RGAutoclean.lua - Automatically remove listeners and timers when 
-- objects are removed/deleted.
-- =============================================================
local physics = require "physics"
-- EFM - Add code to automatically remove body?

--
-- Table and Runtime Listeners
--
local runtimeListeners = { "enterFrame" }
local function onFinalize( self )
	local tableListeners = self._tableListeners or {}
	for k, v in pairs( tableListeners ) do
		--print("Removing tl ", k )
		--table.dump(self)
		self:removeEventListener( k, v )
		self[v] = nil
	end

	-- Remove Runtime listeners	
	local runtimeListeners = self.__runtimeListeners or {}
	--table.dump(self,nil,"onFinalize")
	--table.dump(runtimeListeners,nil,"onFinalize")
	--for i = 1, #runtimeListeners do
	if( runtimeListeners ) then
		for k, v in pairs( runtimeListeners ) do
			--print(i,runtimeListeners[i])
			--print("Removing rl ", k, v )
			ignore( k, v )
			runtimeListeners[k] = nil
		end
	else 
		--print("Warning Function Listener")
	end

	-- timer
	if( self.__myTimer ) then
		timer.cancel( self.__myTimer )
		self.__myTimer = nil
	elseif( self.timer ) then
		--timer.cancel( self )
		self.timer = function() end
	end

	-- Body
	if( self.__hasBody ) then		
		physics.removeBody( self )
	end
	--print( self, "onFinalize @ ", system.getTimer() )
end

-- Runtime Listeners
--
local Runtime_addEventListener = Runtime.addEventListener

Runtime.addEventListener = function( self, eventName, listener )
	Runtime_addEventListener( self, eventName, listener )	
	if( type( listener ) == "table" )  then
		--print("BOB", self, eventName, listener )
		if( listener.__runtimeListeners == nil ) then
			listener.__runtimeListeners = {}
		end
		listener.__runtimeListeners[eventName] = listener
	end
end


-- Table Listeners
--
local function genAutoCleaner( library, funcName )
	local oldFunc = library[funcName]
	library[funcName] = function( ... )
		local obj = oldFunc( unpack( arg ) )
		--obj.__addEventListener 		= obj.addEventListener
		--obj.__removeEventListener 	= obj.removeEventListener
		--obj.addEventListener 		= addEventListener
		--obj.removeEventListener 	= removeEventListener
		obj.finalize = onFinalize
		obj:addEventListener( "finalize" )
		return obj
	end
end
local function genAutoCleaner( library, funcName )
	local oldFunc = library[funcName]
	library[funcName] = function( ... )
		local obj = oldFunc( unpack( arg ) )
		--obj.__addEventListener 		= obj.addEventListener
		--obj.__removeEventListener 	= obj.removeEventListener
		--obj.addEventListener 		= addEventListener
		--obj.removeEventListener 	= removeEventListener
		obj.__autoClean = onFinalize
		return obj
	end
end


genAutoCleaner( display, "newCircle" )
genAutoCleaner( display, "newContainer" )
genAutoCleaner( display, "newEmbossedText" )
genAutoCleaner( display, "newEmitter" )
genAutoCleaner( display, "newGroup" )
genAutoCleaner( display, "newImage" )
genAutoCleaner( display, "newImageRect" )
genAutoCleaner( display, "newLine" )
genAutoCleaner( display, "newPolygon" )
genAutoCleaner( display, "newRect" )
genAutoCleaner( display, "newRoundedRect" )
genAutoCleaner( display, "newSnapshot" )
genAutoCleaner( display, "newSprite" )
genAutoCleaner( display, "newText" )

-- Timers
local timer_performWithDelay = timer.performWithDelay
timer.performWithDelay = function( delay, listener, iterations )
	iteration = iterations or 1
	if( type(listener) == "function" ) then
		return timer_performWithDelay( delay, listener, iterations )
	else
		listener.__myTimer = timer_performWithDelay( delay, listener, iterations )
		return listener.__myTimer
	end
end

-- Physics
--
local physics_addBody = physics.addBody

physics.addBody = function( obj, ... )
	obj.__hasBody = physics_addBody( obj, unpack( arg ) )
	return obj.__hasBody
end


--[[

local test = display.newCircle( 100, 100, 10 )
test.myName = "Bill"
test.touch = function( self, event )
end
test:addEventListener("touch")


test.enterFrame = function( self )
	print("In enterframe ", system.getTimer())
end

listen( "enterFrame", test )

--table.print_r(test)

test.timer = 	function( self ) 
		print("Do remove @  ", system.getTimer() )
		display.remove( self ) 
		post("onBob")
		--table.print_r( self )
	end
timer.performWithDelay( 500, test )

test.onBob = function( self )
	print(self.myName)
	table.print_r(self)
end; listen( "onBob", test )

post("onBob")
--]]