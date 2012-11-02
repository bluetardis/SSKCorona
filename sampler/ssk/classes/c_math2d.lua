-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- 2D Math Library (for operating on display objects)
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
--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

--[[  All standard math functions
math.abs   math.acos  math.asin  math.atan math.atan2 math.ceil
math.cos   math.cosh  math.deg   math.exp  math.floor math.fmod
math.frexp math.huge  math.ldexp math.log  math.log10 math.max
math.min   math.modf  math.pi    math.pow  math.rad   math.random
math.randomseed       math.sin   math.sinh math.sqrt  math.tanh
math.tan
--]]

-- Localize math functions for speedup
local mDeg  = math.deg
local mRad  = math.rad
local mCos  = math.cos
local mSin  = math.sin
local mAcos = math.acos
local mAsin = math.asin
local mSqrt = math.sqrt
local mCeil = math.ceil
local mFloor = math.floor
local mAtan2 = math.atan2

local mPi = math.pi


local math2do = {}

-- **** 
-- **** Vector Addition
-- **** 
--[[
h math2d.add
d Calculates the sum of two vectors: <x1, y1> + <x2, y2> == <x1 + x2 , y1 + y2>
s math2d.add( ... [ , altRet ])
s * ... - Four number values x1, y1, x2, y2 representing the vectors to be added. 
s * altRet - (optional) This tells the function to return a table containing fields (x,y) instead of two numbers (x,y).
s '''OR'''
s * ... - Two objects or tables each containing x and y fields representing the vectors.
s * altRet - (optional) This tells the function to return two numbers (x,y) instead of a table containing fields (x,y).
r Two numbers or a table depending upon the inputs and the (optional) ''altRet''.
e local x1,y1 = 10,10
e local x2,y2 = 15,-10
e local vx,vy = ssk.math2d.add( x1, y1, x2, y2 )        -- Return two numbers
e local vec   = ssk.math2d.add( x1, y1, x2, y2, true )  -- Return a table
e
e print("Results: ", vx,vy ) -- Print the numbers
e print("Results: ", vec.x,vec.y ) -- Print the table fields
d
d Prints:<br>
d Results: 25 0<br>
d Results: 25 0<br>
d <br>
e2 local obj1 = { x = 100, y = 100 }
e2 local obj2 = { x = 50,  y = -50 }
e2 local vec   = ssk.math2d.add( obj1, obj2 )       -- Return a table
e2 local vx,vy = ssk.math2d.add( obj1, obj2, true ) -- Return two numbers
e2
e2 print("Results: ", vec.x,vec.y ) -- Print the table fields
e2 print("Results: ", vx,vy ) -- Print the numbers
d
d Prints:<br>
d Results: 150 50<br>
d Results: 150 50<br>
d <br>
--]]
function math2do.add( ... ) -- ( objA, objB [, altRet] ) or ( x1, y1, x2, y2, [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local x,y = arg[1] + arg[3], arg[2] + arg[4]

		if(arg[5]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local x,y = arg[1].x + arg[2].x, arg[1].y + arg[2].y
			
		if(arg[3]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end

-- **** 
-- **** Vector Subtraction
-- **** 
--[[
h math2d.sub
d Calculates the difference of two vectors: <x2, y2> + <x1, y1> == <x2 - x1 , y2 - y1>
s math2d.sub( ... [ , altRet ])
s * ... - Four number values x1, y1, x2, y2 representing the vectors to be subtracted. 
s * altRet - (optional) This tells the function to return a table containing fields (x,y) instead of two numbers (x,y).
s '''OR'''
s * ... - Two objects or tables each containing x and y fields representing the vectors.
s * altRet - (optional) This tells the function to return two numbers (x,y) instead of a table containing fields (x,y).
s '''Important: The order of operations for this function is: <x2, y2> - <x1, y1>'''
r Two numbers or a table depending upon the inputs and the (optional) ''altRet''.
e local x1,y1 = 10,10
e local x2,y2 = 15,-10
e local vx,vy = ssk.math2d.sub( x1, y1, x2, y2 )        -- Return two numbers
e local vec   = ssk.math2d.sub( x1, y1, x2, y2, true )  -- Return a table
e
e print("Results: ", vx,vy ) -- Print the numbers
e print("Results: ", vec.x,vec.y ) -- Print the table fields
d
d Prints:<br>
d Results: 5 -20<br>
d Results: 5 -20<br>
d <br>
e2 local obj1 = { x = 100, y = 100 }
e2 local obj2 = { x = 50,  y = -50 }
e2 local vec   = ssk.math2d.sub( obj1, obj2 )       -- Return a table
e2 local vx,vy = ssk.math2d.sub( obj1, obj2, true ) -- Return two numbers
e2
e2 print("Results: ", vec.x,vec.y ) -- Print the table fields
e2 print("Results: ", vx,vy ) -- Print the numbers
d
d Prints:<br>
d Results: -50 -150<br>
d Results: -50 -150<br>
d <br>
--]]
function math2do.sub( ... ) -- ( objA, objB [, altRet] ) or ( x1, y1, x2, y2, [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local x,y = arg[3] - arg[1], arg[4] - arg[2]

		if(arg[5]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local x,y = arg[2].x - arg[1].x, arg[2].y - arg[1].y
			
		if(arg[3]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end


-- **** 
-- **** Vector dot Product
-- **** 
--[[
h math2d.dot
d Calculates the dot (inner) product of two vectors: <x1, y1> . <x2, y2> == x1 * x2 + y1 * y2
s math2d.dot( ... )
s * ... - Four number values x1, y1, x2, y2 representing the vectors to be multiplied. 
s '''OR'''
s * ... - Two objects or tables each containing x and y fields representing the vectors.
r A number representing the dot (inner) product of the two input vectors.
e local x1,y1 = 1,-1
e local x2,y2 = 1,0
e local dot   = ssk.math2d.dot( x1, y1, x2, y2 )        
e
e print("The dot product: ", dot )
d
d Prints:<br>
d The dot product: 1<br>
d <br>
e2 local obj1 = { x = 1, y = 1 }
e2 local obj2 = { x = -1,  y = -1 }
e2 local dot  = ssk.math2d.dot( obj1, obj2 ) 
e2
e print("The dot product: ", dot )
d
d Prints:<br>
d The dot product: -2<br>
d <br>
--]]
function math2do.dot( ... ) -- ( objA, objB ) or ( x1, y1, x2, y2 )
	local retVal = 0
	if( type(arg[1]) == "number" ) then
		retVal = arg[1] * arg[3] + arg[2] * arg[4]
	else
		retVal = arg[1].x * arg[2].x + arg[1].y * arg[2].y
	end

	return retVal
end

-- **** 
-- **** Vector length
-- **** 
--[[
h math2d.length
d Calculates the length of vector <x1, y1> == math.sqrt( x1 * x1 + y1 * y1 )
s math2d.length( ... )
s * ... - Two number values x1, y1 representing the vector whose length is to be calculated.
s '''OR'''
s * ... - One object or table containing x and y fields representing the vector whose length is to be calculated.
r Two numbers or a table depending upon the inputs and the (optional) ''altRet''.
e local x1,y1 = 0.7071, -0.7071
e local len   = ssk.math2d.length( x1, y1 ) 
e
e print("Length: ", len ) -- Print the numbers
d
d Prints:<br>
d Length: 1<br>
d <br>
e2 local obj1 = { x = 1, y = -1 }
e2 local len  = ssk.math2d.length( obj1 )
e2
e print("Length: ", len ) -- Print the numbers
d
d Prints:<br>
d Length: 1.4142135623731<br>
d <br>
--]]
function math2do.length( ... ) -- ( objA ) or ( x1, y1 )
	local len
	if( type(arg[1]) == "number" ) then
		len = mSqrt(arg[1] * arg[1] + arg[2] * arg[2])
	else
		len = mSqrt(arg[1].x * arg[1].x + arg[1].y * arg[1].y)
	end
	return len
end

-- **** 
-- **** Vector square length
-- **** 
--[[
h math2d.squarelength
d Calculates the squared length of vector <x1, y1> == x1 * x1 + y1 * y1
s math2d.squarelength( ... )
s * ... - Two number values x1, y1 representing the vector whose squared length is to be calculated.
s '''OR'''
s * ... - One object or table containing x and y fields representing the vector whose squared length is to be calculated.
r Two numbers or a table depending upon the inputs and the (optional) ''altRet''.
e local x1,y1 = 0.7071, -0.7071
e local len   = ssk.math2d.squarelength( x1, y1 ) 
e
e print("Length: ", len ) -- Print the numbers
d
d Prints:<br>
d Length: 1<br>
d <br>
e2 local obj1 = { x = 1, y = -1 }
e2 local len  = ssk.math2d.squarelength( obj1 )
e2
e print("Length: ", len ) -- Print the numbers
d
d Prints:<br>
d Length: 2<br>
d <br>
--]]
function math2do.squarelength( ... ) -- ( objA ) or ( x1, y1 )
	local squareLen
	if( type(arg[1]) == "number" ) then
		squareLen = arg[1] * arg[1] + arg[2] * arg[2]
	else
		squareLen = arg[1].x * arg[1].x + arg[1].y * arg[1].y
	end
	return squareLen
end

-- **** 
-- **** Vector scale
-- **** 
--[[
h math2d.scale
d Calculates a scaled vector scale * <x1, y1> = <scale * x1, scale * y1>
s math2d.scale( ..., scale [ , altRet ])
s * ... - Two number values x1, y1 representing the vector to be scaled to be added. 
s * scale - A number representing the amount to scale the vector by.
s * altRet - (optional) This tells the function to return a table containing fields (x,y) instead of two numbers (x,y).
s '''OR'''
s * ... - One object or table containing x and y fields representing the vector to be scaled to be added. 
s * scale - A number representing the amount to scale the vector by.
s * altRet - (optional) This tells the function to return two numbers (x,y) instead of a table containing fields (x,y).
r Two numbers or a table depending upon the inputs and the (optional) ''altRet''.
e local x1,y1 = 10,10
e local vx,vy = ssk.math2d.scale( x1, y1, 0.1 )        -- Return two numbers
e local vec   = ssk.math2d.scale( x1, y1, 0.1, true )  -- Return a table
e
e print("Results: ", vx,vy ) -- Print the numbers
e print("Results: ", vec.x,vec.y ) -- Print the table fields
d
d Prints:<br>
d Results: 1 1<br>
d Results: 1 1<br>
d <br>
e2 local obj1 = { x = 10, y = -6 }
e2 local vec   = ssk.math2d.scale( obj1, 5.5)       -- Return a table
e2 local vx,vy = ssk.math2d.scale( obj1, 5.5, true ) -- Return two numbers
e2
e2 print("Results: ", vec.x,vec.y ) -- Print the table fields
e2 print("Results: ", vx,vy ) -- Print the numbers
d
d Prints:<br>
d Results: 55 -33<br>
d Results: 55 -33<br>
d <br>
--]]
function math2do.scale( ... ) -- ( objA, scale [, altRet] ) or ( x1, y1, scale, [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local x,y = arg[1] * arg[3], arg[2] * arg[3]

		if(arg[4]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local x,y = arg[1].x * arg[2], arg[1].y * arg[2]
			
		if(arg[3]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end

-- **** 
-- **** Vector normalize
-- **** 
--[[
h math2d.normalize
d Calculates the normalized (unit length) version of a vector.  A normalized vector has a length of 1.
s math2d.normalize( ... [ , altRet ])
s * ... - Two number values x1, y1 representing the vector to be normalized.
s * altRet - (optional) This tells the function to return a table containing fields (x,y) instead of two numbers (x,y).
s '''OR'''
s * ... - One object or table containing x and y fields representing the vector to be normalized.
s * altRet - (optional) This tells the function to return two numbers (x,y) instead of a table containing fields (x,y).
r Two numbers or a table depending upon the inputs and the (optional) ''altRet''.
e local x1,y1 = 1,-1
e local vx,vy = ssk.math2d.normalize( x1, y1 )        -- Return two numbers
e local vec   = ssk.math2d.normalize( x1, y1, true )  -- Return a table
e
e print("Results: ", vx,vy ) -- Print the numbers
e print("Results: ", vec.x,vec.y ) -- Print the table fields
d
d Prints:<br>
d Results: 0.70710678118655 -0.70710678118655<br>
d Results: 0.70710678118655 -0.70710678118655<br>
d <br>
e2 local obj1 = { x = 100, y = 50 }
e2 local vec   = ssk.math2d.normalize( obj1 )       -- Return a table
e2 local vx,vy = ssk.math2d.normalize( obj1, true ) -- Return two numbers
e2
e2 print("Results: ", vec.x,vec.y ) -- Print the table fields
e2 print("Results: ", vx,vy ) -- Print the numbers
d
d Prints:<br>
d Results: 0.89442719099992 0.44721359549996<br>
d Results: 0.89442719099992 0.44721359549996<br>
d <br>
--]]
function math2do.normalize( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local len = math2do.length( arg[1], arg[2], false )
		local x,y = arg[1]/len,arg[2]/len

		if(arg[3]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local len = math2do.length( arg[1], arg[2], true )
		local x,y = arg[1].x/len,arg[1].y/len
			
		if(arg[2]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end


-- **** 
-- **** Vector normals
-- **** 
--[[
h math2d.normals
d Returns the two normal vectors for a vector. (Every vector has two normal vectors. i.e. Vectors at 90-degree angles to the original vector.)
d <br>Warning: These normal vectors are not normalized and may need more processing to be useful in other calculations.
s math2d.normals( ... [ , altRet ])
s * ... - Two number values x1, y1 representing the vector whose normals are to be calculated.
s * altRet - (optional) This tells the function to return a two tables { x=nx1, y=ny1 }, { x=nx2, y=ny2 } instead of four numbers.
s '''OR'''
s * ... - One object or table containing x and y fields representing the vector whose normals are to be calculated.
s * altRet - (optional) This tells the function to return four numbers nx1, ny1, nx2, ny2 two tables.
r Four numbers or two tables depending upon the inputs and the (optional) ''altRet''.
e local x1,y1 = 10,10
e local x2,y2 = 15,-10
e
e local nx1,ny1,nx2,ny2 = ssk.math2d.normals( x1, y1 )        -- Return four numbers
e local vec1, vec2      = ssk.math2d.normals( x1, y1, true )  -- Return two tables
e
e print("Results: ", nx1,ny1,nx2,ny2 )             -- Print the numbers
e print("Results: ", vec1.x,vec1.y,vec2.x,vec2.y ) -- Print the table fields
d
d Prints:<br>
d Results: -10 10 10 -10<br>
d Results: -10 10 10 -10<br>
d Results: 25 0<br>
d Results: 25 0<br>
d <br>
e2 local obj1 = { x = 100, y = 100 }
e2 local obj2 = { x = 50,  y = -50 }
e2
e2 local vec1,vec2       = ssk.math2d.normals( obj1 )       -- Return two tables
e2 local nx1,ny1,nx2,ny2 = ssk.math2d.normals( obj1, true ) -- Return four numbers
e2
e print("Results: ", vec1.x,vec1.y,vec2.x,vec2.y ) -- Print the table fields
e print("Results: ", nx1,ny1,nx2,ny2 )             -- Print the numbers
d
d Prints:<br>
d Results: -100 100 100 -100<br>
d Results: -100 100 100 -100<br>
d <br>
--]]
function math2do.normals( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local nx1,ny1,nx2,ny2 = -arg[1], arg[2], arg[1], -arg[2]

		if(arg[3]) then
			return { x=nx1, y=ny1 }, { x=nx2, y=ny2 }
		else
			return nx1,ny1,nx2,ny2
		end
	else
		local nx1,ny1,nx2,ny2 = -arg[1].x, arg[1].y, arg[1].x, -arg[1].y
			
		if(arg[2]) then
			return nx1,ny1,nx2,ny2			
		else
			return { x=nx1, y=ny1 }, { x=nx2, y=ny2 }
		end
	end
end

-- **** 
-- **** Vector to Angle
-- **** 
--[[
h math2d.vector2Angle
d Converts a screen-space vector to a display object angle (rotation).
d <br>Warning: These are not calulated in the trasitional cartesian/polar -space.
s math2d.vector2Angle( ... )
s * ... - Two number values x1, y1 representing the vector to be converted to an angle.
s * altRet - (optional) This tells the function to return a table containing fields (x,y) instead of two numbers (x,y).
s '''OR'''
s * ... - One object or table containing x and y fields representing the vector to be converted to an angle.
r A numeric value in the range [ 0.0, 360.0 ) representing the angle of the passed vector in terms of display object rotation.
e local x1,y1 = 1,0
e local angle = ssk.math2d.vector2Angle( x1, y1 ) 
e
e print("The angle: ", angle )
d
d Prints:<br>
d The angle: 90<br>
d <br>
e2 local obj1  = { x = 0, y = -1 }
e2 local angle = ssk.math2d.vector2Angle( obj1 )
e2
e print("The angle: ", angle )
d
d Prints:<br>
d The angle: 0<br>
d <br>
--]]
function math2do.vector2Angle( ... ) -- ( objA ) or ( x1, y1 )
	local angle
	if( type(arg[1]) == "number" ) then
		angle = mCeil(mAtan2( (arg[2]), (arg[1]) ) * 180 / mPi) + 90
	else
		angle = mCeil(mAtan2( (arg[1].y), (arg[1].x) ) * 180 / mPi) + 90
	end
	return angle
end

-- **** 
-- **** Angle to Vector
-- **** 
--[[
h math2d.angle2Vector
d Converts a display object angle (rotation) into a screen-space vector.
d <br>Note: These vectors are always normalized and ready for additional calculations if wanted.
d <br>Warning: These are not calulated in the trasitional cartesian/polar -space.
s math2d.angle2Vector( angle [ , altRet ])
s * angle - The angle to be converted to a vector.
s * altRet - (optional) This tells the function to return a table containing fields (x,y) instead of two numbers (x,y).
r Two numbers or a table depending upon the inputs and the (optional) ''altRet''.
e local angle = 135
e local vx,vy = ssk.math2d.angle2Vector( angle )        -- Return two numbers
e local vec   = ssk.math2d.angle2Vector( angle, true )  -- Return a table
e
e print("The vector: ", vx,vy ) -- Print the numbers
e print("The vector: ", vec.x,vec.y ) -- Print the table fields
d
d Prints:<br>
d The vector: 0.70710678118655 0.70710678118655<br>
d The vector: 0.70710678118655 0.70710678118655<br>
d <br>
--]]
function math2do.angle2Vector( angle, tableRet )
	local screenAngle = mRad(-(angle+90))
	local x = mCos(screenAngle) 
	local y = mSin(screenAngle) 

	if(tableRet == true) then
		return { x=-x, y=y }
	else
		return -x,y
	end
end

-- **** 
-- **** Cartesian to Screen Coordinates (and viceversa)
-- **** 
--[[
h math2d.cartesian2Screen
d Converts cartesian coordinates to the equivalent screen coordinates.
s math2d.cartesian2Screen( ... [ , altRet ])
s * ... - Two number values x1, y1 representing the vector to be converted. 
s * altRet - (optional) This tells the function to return a table containing fields (x,y) instead of two numbers (x,y).
s '''OR'''
s * ... - One object or table containing x and y fields representing the vector to be converted. 
s * altRet - (optional) This tells the function to return two numbers (x,y) instead of a table containing fields (x,y).
r Two numbers or a table depending upon the inputs and the (optional) ''altRet''.
e local x1,y1 = 10,10
e local vx,vy = ssk.math2d.cartesian2Screen( x1, y1 )        -- Return two numbers
e local vec   = ssk.math2d.cartesian2Screen( x1, y1, true )  -- Return a table
e
e print("Results: ", vx,vy ) -- Print the numbers
e print("Results: ", vec.x,vec.y ) -- Print the table fields
d
d Prints:<br>
d Results: 10 -10<br>
d Results: 10 -10<br>
d <br>
e2 local obj1 = { x = 100, y = 100 }
e2 local vec   = ssk.math2d.cartesian2Screen( obj1 )       -- Return a table
e2 local vx,vy = ssk.math2d.cartesian2Screen( obj1, true ) -- Return two numbers
e2
e2 print("Results: ", vec.x,vec.y ) -- Print the table fields
e2 print("Results: ", vx,vy ) -- Print the numbers
d
d Prints:<br>
d Results: 100 -100<br>
d Results: 100 -100<br>
d <br>
--]]
function math2do.cartesian2Screen( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		if(arg[3]) then
			return { x=arg[1], y=-arg[2] }
		else
			return arg[1],-arg[2]
		end
	else
		if(arg[2]) then
			return arg[1].x,-arg[1].y
		else
			return { x=arg[1].x, y=-arg[1].y }
		end
	end
end
--[[
h math2d.screen2Cartesian
d Converts screen coordinates to the equivalent cartesian coordinates.
s math2d.screen2Cartesian( ... [ , altRet ])
s * ... - Two number values x1, y1 representing the vector to be converted. 
s * altRet - (optional) This tells the function to return a table containing fields (x,y) instead of two numbers (x,y).
s '''OR'''
s * ... - One object or table containing x and y fields representing the vector to be converted. 
s * altRet - (optional) This tells the function to return two numbers (x,y) instead of a table containing fields (x,y).
r Two numbers or a table depending upon the inputs and the (optional) ''altRet''.
e local x1,y1 = 10,10
e local vx,vy = ssk.math2d.screen2Cartesian( x1, y1 )        -- Return two numbers
e local vec   = ssk.math2d.screen2Cartesian( x1, y1, true )  -- Return a table
e
e print("Results: ", vx,vy ) -- Print the numbers
e print("Results: ", vec.x,vec.y ) -- Print the table fields
d
d Prints:<br>
d Results: 10 -10<br>
d Results: 10 -10<br>
d <br>
e2 local obj1 = { x = 100, y = 100 }
e2 local vec   = ssk.math2d.screen2Cartesian( obj1 )       -- Return a table
e2 local vx,vy = ssk.math2d.screen2Cartesian( obj1, true ) -- Return two numbers
e2
e2 print("Results: ", vec.x,vec.y ) -- Print the table fields
e2 print("Results: ", vx,vy ) -- Print the numbers
d
d Prints:<br>
d Results: 100 -100<br>
d Results: 100 -100<br>
d <br>
--]]
function math2do.screen2Cartesian( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		if(arg[3]) then
			return { x=arg[1], y=-arg[2] }
		else
			return arg[1],-arg[2]
		end
	else
		if(arg[2]) then
			return arg[1].x,-arg[1].y
		else
			return { x=arg[1].x, y=-arg[1].y }
		end
	end
end



-- EFM verify all below before documenting

--EFM BELOW FUNCTIONS NEED SOME WORK TO BRING THEM IN LINE WITH alternate return protocols
--EFM BELOW FUNCTIONS NEED SOME WORK TO BRING THEM IN LINE WITH alternate return protocols
--EFM BELOW FUNCTIONS NEED SOME WORK TO BRING THEM IN LINE WITH alternate return protocols
--EFM BELOW FUNCTIONS NEED SOME WORK TO BRING THEM IN LINE WITH alternate return protocols

-- **** 
-- **** tweenAngle - Delta between an objA and vector2Angle(objA, objB)
-- ****            - Returns vector2Angle as second return value (for cases where you need it too) :)
-- **** 
function math2do.tweenAngle( objA, objB )
	local vx,vy      = math2do.sub( objA.x, objA.y, objB.x, objB.y )
	vx,vy            = math2do.normalize(vx,vy)
	local vecAngle   = ssk.m2d.vector2Angle(vx,vy)
	local tweenAngle = vecAngle - objA.rotation

	dprint(3,"     vx,vy == " .. vx,vy)
	dprint(3,"  vecAngle == " .. vecAngle)
	dprint(3,"tweenAngle == " .. tweenAngle)

	return tweenAngle,vecAngle
end

-- **** 
-- **** tweenDist - Distance between objA and objB (EFM fix this and others that return 'extras' to use objects not numbers)
-- ****           - Returns sub( objA, objB ) as second, third value (for cases where you need them too) :)
-- **** 

function math2do.tweenDist( objA, objB )
	local vx,vy = math2do.sub( objA.x, objA.y, objB.x, objB.y )
	local vecLen  = math2do.length(vx,vy)

	dprint(3,"     vx,vy == " .. vx,vy)
	dprint(3,"    vecLen == " .. vecLen)

	return vecLen,vx,vy
end

-- **** 
-- **** tweenData - Returns all data between two objects (in this order)
-- ****
-- ****      vx,vy - equivalent to objMath2d.sub(objA,objB)
-- ****      nx,ny - equivalent to ssk.math2do.normalize(vx,vy)
-- ****     vecLen - equivalent to ssk.math2do.length( vx, vy )
-- ****   vecAngle - equivalent to objMath2d.vector2Angle( objA, objB)
-- **** tweenAngle - equivalent to objMath2d.tweenAngle( objA, objB)
-- **** 

function math2do.tweenData( objA, objB )
	local vx,vy      = math2do.sub( objA.x, objA.y, objB.x, objB.y )
	local nx,ny      = math2do.normalize(vx,vy)
	local vecLen     = math2do.length(vx,vy)
	local vecAngle   = math2do.vector2Angle(nx,ny)
	local tweenAngle = vecAngle - objA.rotation

	dprint(3,"     vx,vy == " .. vx,vy)
	dprint(3,"     nx,ny == " .. nx,ny)
	dprint(3,"    vecLen == " .. vecLen)
	dprint(3,"  vecAngle == " .. vecAngle)
	dprint(3,"tweenAngle == " .. tweenAngle)
	dprint(3,"tweenAngle == " .. tweenAngle)			

	return vx,vy,nx,ny,vecLen,vecAngle,tweenAngle
end

return math2do