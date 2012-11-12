-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Collision Calculator - Used to set up collisions using 'names' instead of numbers.
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

collisionsCalculatorManger = {}
	
--[[
h ssk.ccmgr:newCalculator
d Creates a blank (unconfigured) collision calculator.
s ssk.ccmgr:newCalculator()
r A collision calculator instance (''myCC'').
e local myCC = ssk.ccmgr:newCalculator()
--]]
	function collisionsCalculatorManger:newCalculator()

		collisionsCalculator = {}

		collisionsCalculator._colliderNum = {}
		collisionsCalculator._colliderCategoryBits = {}
		collisionsCalculator._colliderMaskBits = {}
		collisionsCalculator._knownCollidersCount = 0

--[[
h myCC:addName
d Add new 'named' collider type to known list of collider types, and 
d automatically assign a number to this collider type (16 Max).
s myCC:addName( colliderName )
s * colliderName - String containing name for new collider type.
r ''true'' if named type was successfully added to known colliders list, ''false'' otherwise.
e local myCC = ssk.ccmgr:newCalculator()
e
e myCC:addName("player")
e myCC:addName("enemy")
e myCC:addName("player bullet")
--]]
		function collisionsCalculator:addName( colliderName )

			if(not self._colliderNum[colliderName]) then
				-- Be sure we don't create more than 16 named collider types
				if( self._knownCollidersCount == 16 ) then
					return false
				end		

				local newColliderNum = self._knownCollidersCount + 1
		
				self._knownCollidersCount = newColliderNum
				self._colliderNum[colliderName] = newColliderNum
				self._colliderCategoryBits[colliderName] = 2 ^ (newColliderNum - 1)
				self._colliderMaskBits[colliderName] = 0
			end

			return true
		end

		-- PRIVATE - DO NOT USE IN YOUR GAME CODE
		function collisionsCalculator:configureCollision( colliderNameA, colliderNameB )
			--
			-- Verify both colliders exist before attempting to configure them:
			--
			if( not self._colliderNum[colliderNameA] ) then
				print("Error: collidesWith() - Unknown collider: " .. colliderNameA)
				return false
			end
			if( not self._colliderNum[colliderNameB] ) then
				print("Error: collidesWith() - Unknown collider: " .. colliderNameB)
				return false
			end
		
			-- Add the CategoryBit for A to B's collider mask and vice versa
			-- Note: The if() statements encapsulating this setup work ensure
			--       that the faked bitwise operation is only done once 
			local colliderCategoryBitA = self._colliderCategoryBits[colliderNameA]
			local colliderCategoryBitB = self._colliderCategoryBits[colliderNameB]
			if( (self._colliderMaskBits[colliderNameA] % (2 * colliderCategoryBitB) ) < colliderCategoryBitB ) then
				self._colliderMaskBits[colliderNameA] = self._colliderMaskBits[colliderNameA] + colliderCategoryBitB
			end
			if( (self._colliderMaskBits[colliderNameB] % (2 * colliderCategoryBitA) ) < colliderCategoryBitA ) then
				self._colliderMaskBits[colliderNameB] = self._colliderMaskBits[colliderNameB] + colliderCategoryBitA
			end

			return true
		end


--[[
h myCC:collidesWith
d Automatically configure named collider A to collide with one or more other named colliders.  
d Note: The algorithm used is fully associative, so configuring ''typeA'' to collide with ''typeB'' 
d automatically configures ''typeB'' too.
s myCC:collidesWith( colliderNameA, ... )
s * colliderNameA - A string containing the name of the collider that is being configured.
s * ... - One or more strings identifying previously added collider types that collide with colliderNameA.
r ''true'' if named type was successfully added to known colliders list, ''false'' otherwise.
e local myCC = ssk.ccmgr:newCalculator()
e
e myCC:addName("player")
e myCC:addName("enemy")
e myCC:addName("player bullet")
e
e myCC:collidesWith( "enemy", "player", "player bullet" )
d 
d Note: In this example, both "player" and "player bullet" are automatically configured as if this code had been called too:
d
e2 myCC:collidesWith( "player", "enemy" )  -- Automatically calculated by the first call
e2 myCC:collidesWith( "player bullet", "enemy" )  -- Automatically calculated by the first call
d
d This is nice because it keeps you from forgetting to fully associate collisions.
--]]
		function collisionsCalculator:collidesWith( colliderNameA, ... )
			for key, value in ipairs(arg) do
        		self:configureCollision( colliderNameA, value )
			end
		end

--[[
h myCC:getCategoryBits
d Get category bits for the named collider.
d Note: Rarely used.  Use the getCollisionFilter() function instead.
s myCC:getCategoryBits( colliderName  )
s * colliderName - A string containing the name of the collider you want the ''CategoryBits'' for.
r A number representing the ''CategoryBits'' for the named collider.
e local myCC = ssk.ccmgr:newCalculator()
e
e myCC:addName("player")
e myCC:addName("enemy")
e myCC:addName("player bullet")
e
e myCC:collidesWith( "enemy", "player", "player bullet" )
e
e print('Category bits for "player" are:' .. myCC:getCategoryBits( "player" ))
e print('Category bits for "enemy" are:' .. myCC:getCategoryBits( "enemy" ))
e print('Category bits for "player bullet" are:' .. myCC:getCategoryBits( "player bullet" ))
d
d <br>Prints:<br>
d Category bits for "player" are: 2<br>
d Category bits for "enemy" are: 5<br>
d Category bits for "player bullet" are: 2<br>
d
--]]
		function collisionsCalculator:getCategoryBits( colliderName )
			return self._colliderMaskBits[colliderName] 
		end

--[[
h myCC:getMaskBits
d Get mask bits for the named collider.
d Note: Rarely used.  Use the getCollisionFilter() function instead.
s myCC:getMaskBits( colliderName  )
s * colliderName - A string containing the name of the collider you want the ''MaskBits'' for.
r A number representing the ''MaskBits'' for the named collider.
e local myCC = ssk.ccmgr:newCalculator()
e
e myCC:addName("player")
e myCC:addName("enemy")
e myCC:addName("player bullet")
e
e myCC:collidesWith( "enemy", "player", "player bullet" )
e
e print('Mask bits for "player" are:' .. myCC:getMaskBits( "player" ))
e print('Mask bits for "enemy" are:' .. myCC:getMaskBits( "enemy" ))
e print('Mask bits for "player bullet" are:' .. myCC:getMaskBits( "player bullet" ))
d
d <br>Prints:<br>
d Mask bits for "player" are: 1<br>
d Mask bits for "enemy" are: 2<br>
d Mask bits for "player bullet" are: 4<br>
d
--]]
		function collisionsCalculator:getMaskBits( colliderName )
			return self._colliderCategoryBits[colliderName] 
		end

--[[
h myCC:getCollisionFilter
d Get collision filter for the named collider.
s myCC:getCollisionFilter( colliderName  )
s * colliderName - A string containing the name of the collider you want the ''CollisionFilter'' for.
r A table representing the ''CollisionFilter'' for the named collider.  This table contains both the 
r ''CategoryBits'' and the ''MaskBits''.
e local myCC = ssk.ccmgr:newCalculator()
e
e myCC:addName("player")
e myCC:addName("enemy")
e myCC:addName("player bullet")
e
e myCC:collidesWith( "enemy", "player", "player bullet" )
e
e local playerCollisionFilter = myCC:getCollisionFilter( "player" )
--]]
		function collisionsCalculator:getCollisionFilter( colliderName )
			local collisionFilter =  
			{ 
	   		categoryBits = self._colliderCategoryBits[colliderName],
	   		maskBits     = self._colliderMaskBits[colliderName], 
			}  

			return collisionFilter
		end


--[[
h myCC:dump
d (Debug Feature) Prints collider names, numbers, category bits, and masks.
s myCC:dump()
r None.
e local myCC = ssk.ccmgr:newCalculator()
e
e myCC:addName("player")
e myCC:addName("enemy")
e myCC:addName("player bullet")
e
e myCC:collidesWith( "enemy", "player", "player bullet" )
e
e myCC:dump()
d
d Prints:
d
e2 *********************************************
e2 
e2 Dumping collision settings...
e2 name           | num | cat bits | col mask
e2 -------------- | --- | -------- | --------
e2 player         | 1   | 1        | 2
e2 player bullet  | 3   | 4        | 2
e2 enemy          | 2   | 2        | 5
e2 
e2 *********************************************
--]]
		function collisionsCalculator:dump()
			print("*********************************************\n")
			print("Dumping collision settings...")
			print("name           | num | cat bits | col mask")
			print("-------------- | --- | -------- | --------")
			for colliderName, colliderNum in pairs(self._colliderNum) do
				print(colliderName:rpad(15,SPC) .. "| ".. 
		      		tostring(colliderNum):rpad(4,SPC) .. "| ".. 
			  		tostring(self._colliderCategoryBits[colliderName]):rpad(9,SPC) .. "| ".. 
			  		tostring(self._colliderMaskBits[colliderName]):rpad(8,SPC))
			end

			print("\n*********************************************\n")
		end

		return collisionsCalculator
	end

return collisionsCalculatorManger
