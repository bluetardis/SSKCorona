-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Math Add-ons
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


--[[
h math.pointInRect
d Tests if a point is within the bounds of the specified rectangle.
s math.pointInRect( pointX, pointY, left, top, width, height )
s * pointX - x-position of point
s * pointY - y-position of point
s * left - Left-most x-position of rectangle.
s * top - Top-most y-position of rectangle.
s * width - Rectangle width.
s * height - Rectangle height.
r ''true' if point is within (or on edge) of rectangle, ''false'' otherwise.
e local pointA = { x=10, y=10 }
e local pointB = { x=10, y=11 }
e
e if( math.pointInRect( pointA.x, pointA.y, 0, 0, 10, 10 ) ) then
e    print("Point A is in the rectangle.")
e else 
e    print("Point A is not in the rectangle.")
e end
e
e if( math.pointInRect( pointB.x, pointB.y, 0, 0, 10, 10 ) ) then
e    print("Point B is in the rectangle.")
e else 
e    print("Point B is not in the rectangle.")
e end
e
d
d Prints:<br>
d Point A is in the rectangle.<br>
d Point B is not in the rectangle.<br>
--]]


-- from http://pastebin.com/3BwbxLjn (modified)
math.pointInRect = function( pointX, pointY, left, top, width, height )
	if( pointX >= left and pointX <= left + width and 
	    pointY >= top and pointY <= top + height ) then 
	   return true
	else
		return false
	end
end