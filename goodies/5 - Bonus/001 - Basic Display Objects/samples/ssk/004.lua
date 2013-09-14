-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2013
-- =============================================================

local group = display.newGroup()

-- Background to make text easier to see (NOT PART OF RECIPE)
local backImage = display.newImageRect( group, "images/interface/backImage2.jpg", 160, 480 )
backImage.rotation = 90
backImage.x = centerX
backImage.y = centerY

-- Text  (BLUE)
local text = ssk.labels:quickLabel( group, "Basic Text", centerX, centerY - 30, native.systemFont, 48, _RED_  )

-- Embossed Text ( RED, WHITE, BLUE )
local embossed = ssk.labels:quickEmbossedLabel( group, "Embossed Text", centerX, centerY + 30, native.systemFont, 48, _WHITE_, _RED_, _BLUE_ )



return group
