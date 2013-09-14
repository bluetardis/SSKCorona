-- =============================================================
-- main.lua
-- =============================================================
-- Empty Project Using SSKCorona Library
-- =============================================================
--
-- Register a dummy handler 'FIRST' if we are using the simulator
--
-- Tip: If you don't do this early, you'll get pop-ups in the simulator (and on devices)
--      This is great for device debugging, but I personally prefer the console output
--      when using the console
--
if( system.getInfo( "environment" ) == "simulator" ) then
	local function myUnhandledErrorListener( event )
		return true
	end
	Runtime:addEventListener("unhandledError", myUnhandledErrorListener)
end

----------------------------------------------------------------------
--	1. Requires
----------------------------------------------------------------------
-- Load SSK Globals & Libraries
--
require "ssk.globals"
require "ssk.loadSSK"


----------------------------------------------------------------------
--	2. Initialization
----------------------------------------------------------------------
io.output():setvbuf("no") -- Don't use buffer for console messages
display.setStatusBar(display.HiddenStatusBar)  -- Hide that pesky bar

local physics = require("physics")
physics.start()
physics.setGravity(0,10)
--physics.setDrawMode( "hybrid" )


----------------------------------------------------------------------
-- 3. Declarations
----------------------------------------------------------------------
-- Additional Globls, Locals, and Function Forward Declartions


----------------------------------------------------------------------
-- 4. Definitions
----------------------------------------------------------------------
-- Local and Global Function Implementations


----------------------------------------------------------------------
-- 5. Execution
----------------------------------------------------------------------
local samples_pure = {}
samples_pure[1] = "samples.pure.001"
samples_pure[2] = "samples.pure.002"
samples_pure[3] = "samples.pure.003"
samples_pure[4] = "samples.pure.004"
samples_pure[5] = "samples.pure.005"
samples_pure[6] = "samples.pure.006"

local samples_ssk = {}
samples_ssk[1] = "samples.ssk.001"
samples_ssk[2] = "samples.ssk.002"
samples_ssk[3] = "samples.ssk.003"
samples_ssk[4] = "samples.ssk.004"
samples_ssk[5] = "samples.ssk.005"
samples_ssk[6] = "samples.ssk.006"
samples_ssk[7] = "samples.ssk.007"
samples_ssk[8] = "samples.ssk.008"
samples_ssk[9] = "samples.ssk.009"
samples_ssk[10] = "samples.ssk.010"

local function showSamples( num )

	if(num <= #samples_pure) then
		local pureSample = require( samples_pure[num] )
		local sskSample = require( samples_ssk[num] )
		pureSample.y = pureSample.y - h/4
		sskSample.y = sskSample.y + h/4

		 display.newText("#" .. num .. " Pure", 10, 10, native.systemFont, 24)
		 display.newText("#" .. num .. " SSK", 10, h/2 + 10, native.systemFont, 24)
		 
		 local tmp = display.newLine(0,h/2, w, h/2)
		 tmp.width = 6
		 
		 local tmp = display.newLine(0,h/2, w, h/2)
		 tmp:setColor(0,0,0)
		 tmp.width = 2
	else
		display.newText("#" .. num .. " SSK (only)", 10, 10, native.systemFont, 24)
		local sskSample = require( samples_ssk[num] )
	end 
end

showSamples( 1 )
--showSamples( math.random(1,10) )


