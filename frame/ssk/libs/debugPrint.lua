-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Debug Printer
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

--[[  USAGE:
local debugLevel = 1 -- Comment out to get global debugLevel from main.lua
local dp = debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

dprint( 2, "Some message", "that should", "only print at level 2 or higher")
--]]


--[[
d To use a debug printer in your own code do the following:<br>
d <br>
d At the top of your code/file, add these lines:<br>
e2 --local debugLevel = 1 -- Comment out to get global debugLevel from main.lua
e2 local dp = ssk.debugPrinter.newPrinter( debugLevel )
e2 local dprint = dp.print
d
d Later to call the debug printer in this file use code like this:
e2
e2 dprint( 2, "Some message", "that should", "only print at level 2 or higher")
d<br>
--]]

local dp = {}

--[[
h ssk.debugprinter.newPrinter
d Creates a new debug printer that only prints messages at the specified ''debugLevel'' or higher.
s debugprinter.newPrinter( debugLevel )
s * debugLevel - Level at which debug messages will print. i.e. This message-level or higher prints.
r A new printer instance.
d
e
d See usage instructions on \[\[Ssk.debugprinter| debugprinter\]\] page to see how this is used.
--]]
	function dp.newPrinter( debugLevel )

		if(debugLevel == nil) then
			print("Warning: Passed nil when initializing debugLevel in dp.newPrinter()")
		end

		local thePrinter = {}

		-- Debug messaging level: 
		-- 0  - None
		-- 1  - Basic messages
		-- 2  - Intermediate debug output
		-- 3+ - Full debug output (may be very noisy)
		thePrinter.debugLevel = debugLevel or 0

--[[
h printerInstance:setLevel
d Changes the debug level for this debug printer instance.
s printerInstance:setLevel( debugLevel )
s * debugLevel - Level at which debug messages will print. i.e. This message-level or higher prints.
r None.
--]]
		function thePrinter:setLevel( level )
			self.debugLevel = level			
		end

--[[
h printerInstance:print
d Changes the debug level for this debug printer instance.
s printerInstance:print( level, ... )
s * level - Debug message-level for this message.
s * ... - The message to print.
r None.
d
e
d See usage instructions on \[\[Ssk.debugprinter| debugprinter\]\] page to see how this is used.
--]]
		function thePrinter.print( level, ... )
			if(thePrinter.debugLevel >= level ) then
				print( unpack(arg) )
			end
		end

		return thePrinter
	end

return dp
