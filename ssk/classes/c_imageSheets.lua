-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Image Sheets Manager - For use with new sprites functionality
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
--EFM Add 'old style' sheet loader

local sprite = require( "sprite" )

--[[ 
--]]


local imageSheets = {}
	imageSheets.spriteSheets = {}

	-- ==
	-- Sprite Sheets
	-- ==
	function imageSheets:sheetExists( sheetName )
		if( self.spriteSheets[sheetName] ) then return true end
		return false
	end

	function imageSheets:getSheet( sheetName )
		return self.spriteSheets[sheetName]
	end

	function imageSheets:destroySheet( sheetName )
		if( self.spriteSheets[sheetName] ) then 
			local theSheet = self.spriteSheets[sheetName]
			self.spriteSheets[sheetName] = nil
			return true 
		end
		return false
	end

	function imageSheets:createSheet( sheetName, sheetImg, sheetParams )
		if( not self.spriteSheets[sheetName] ) then 

			self.spriteSheets[sheetName] = graphics.newImageSheet( sheetImg, sheetParams )

			return self.spriteSheets[sheetName]
		end
		print("ERROR: f_sprites: imageSheets:createSheet( " .. sheetName .. " ) -- Already exists! " )
		return nil
	end


return imageSheets
