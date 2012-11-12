-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Various Global Functions
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

-- Return first argument that is not nil
--[[
h _G.fnn
d Returns the first (passed) argument that is not set to ''nil''.
s fnn( ... )
s * ... - Any number of any type of arguments.
r None.
--]]
function _G.fnn( ... ) 
	for i = 1, #arg do
		local theArg = arg[i]
		if(theArg ~= nil) then return theArg end
	end
	return nil
end

---============================================================
-- Determine if an object is in fact a displayObject
-- 
--[[
h _G.isDisplayObject
d Used to check if an object is valid and has NOT had removeSelf() called yet.
s isDisplayObject( obj )
s * obj - The object to test.
r ''true'' if the object is a valid display object, ''false'' if it is not.
--]]
function _G.isDisplayObject( obj )
	if( obj and obj._class and obj._proxy) then return true end
	return false
end

---============================================================
-- Return a non-repeating random color
-- 
local lastColor = {}
local allColors = _G.allColors
local random = math.random
--[[
h _G.randomColor
d Returns a table containing a random color code from the set '''allColors''' defined in globals.lua.
s randomColor()
r A table containing a color code.
--]]
function _G.randomColor( )
	local curColor = allColors[random(1, #allColors)]
	while(curColor == lastColor) do
		curColor = allColors[random(1, #allColors)]
	end

	lastColor = curColor
	return curColor
end

---============================================================
-- Calculate Pascal's triangle to 'n' rows and return as a sequence
-- Modified: http://rosettacode.org/wiki/Pascal's_triangle#Lua
function _G.PascalsTriangle_row(t)
  local ret = {}
  t[0], t[#t+1] = 0, 0
  for i = 1, #t do ret[i] = t[i-1] + t[i] end
  return ret
end

function _G.PascalsTriangle(n)
  local t = {1}
  local full = nil

  for i = 1, n do
	if full then
		full = table.copy(full,t)
	else
		full = table.copy(t)
	end
    t = _G.PascalsTriangle_row(t)
  end
  return full
end

function _G.PascalsTriangle_lastRow(n)
  local t = {1}
  for i = 1, n do
    t = _G.PascalsTriangle_row(t)
  end
  return t
end


---============================================================
-- Calculate fibbonaci out to nth place (with caching for speedup)
-- http://en.literateprograms.org/Fibonacci_numbers_(Lua)
_G.fibs={[0]=0, 1, 1} 
--[[
h _G.fastfib
d Calculates the Fibbonaci sequence out to n places.
s fastfib( n )
s * n - Place to caclulate fibbonaci sequence to.
r A table containing all the elements of fibbonaci's sequence from 0 to the ''n''th place.
--]]
function _G.fastfib(n)
	for i=3,n do
		_G.fibs[i]=_G.fibs[i-1]+_G.fibs[i-2]
	end
	return _G.fibs[n]
end

---============================================================
-- rounds a number to the nearest decimal places
-- http://lua-users.org/wiki/FormattingNumbers
--[[
h _G.round
d Rounds a number to n decimal places.
s round( val, decimal )
s * val - The value to round.
s * n - Number of decimal places to round to.
r A floating point whose decimal places have been rounded to ''n'' places.
--]]
function _G.round(val, n)
  if (n) then
    return math.floor( (val * 10^n) + 0.5) / (10^n)
  else
    return math.floor(val+0.5)
  end
end


