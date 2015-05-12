-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
--io.output():setvbuf("no") -- Don't use buffer for console messages
--display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

-- SSK Forward Declarations
local newCircle 	= ssk.display.newCircle
local newRect 		= ssk.display.newRect
local newImageRect 	= ssk.display.newImageRect
local easyIFC   	= ssk.easyIFC
local mRand 		= math.random

-- Lua and Corona Forward Declarations
local mRand 			= math.random
local getTimer 			= system.getTimer

local app = {}

-- Initialize the app
--
function app.init( group )
end

-- Stop, cleanup, and destroy the app.;
--
function app.cleanup( )
	ignore( "enterFrame", app.world )
end

-- Run the Game
--
function app.run( group )

	-- Locals
	--

	--easyIFC:presetPush( theDrawer, "default", left + 70, centerY - 70, 60, 60, "A", onPressed )

end

return app