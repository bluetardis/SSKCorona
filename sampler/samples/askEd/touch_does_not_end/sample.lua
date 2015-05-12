-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
local public = {}

-- =============================================================
-- init( group )
-- Code that needs to run before the sample can be executed goes here.
-- This is usually stuff like loading sprites, sound files, or prepping
-- data.
--
-- group - A display group for you to place any visual content into.
--         This group is managed for you and should not be destroyed by
--         your code.
-- =============================================================
function public.init( group )
	print("Did init @ ", system.getTimer() )
end

-- =============================================================
-- cleanup()
-- Any special cleanup code goes here.  
--
-- The module itself will be destroyed as well as all content rendered into
-- the group, so you don't need to do that.
-- =============================================================
function public.cleanup( )
	print("Did cleanup @ ", system.getTimer() )
end

-- =============================================================
-- run( group )
--
-- group - A display group for you to place any visual content into.
--         This group is managed for you and should not be destroyed by
--         your code. 
-- =============================================================
function public.run( group )
	print("Started running @ ", system.getTimer(), group )

	-- Localizations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC
	
	-- Touch hander for all cubes
	local function touchCallback( self, event )

		local phase = event.phase
		local target = event.target
		local currentStage = display.getCurrentStage()
		local lastTarget = currentStage.lastTarget

		if(lastTarget and lastTarget ~= target) then
			event.target = lastTarget
			event.phase = "ended"
			currentStage.lastTarget = nil
			lastTarget:touch( event )
		end

		--print(phase, target)
		if( phase == "began" ) then
			self:setFillColor( unpack( _BLUE_ ) )
			currentStage.lastTarget = target
			return true

		elseif( phase == "moved" ) then
			self:setFillColor( unpack( _GREEN_ ) )
			currentStage.lastTarget = target
			return true

		elseif( phase == "ended" ) then
			self:setFillColor( unpack( _RED_ ) )
			return true
			
		elseif( phase == "cancelled" ) then
			self:setFillColor( unpack( _BLACK_ ) )
			currentStage.lastTarget = nil
			return true

		else
			self:setFillColor( unpack( _ORANGE_ ) )
			return true
		end
	end

	-- Create a sample touch grid
	--
	local size = round(fullw/12)

	local startX = left
	local startY = bottom - size * 3
	local curX = startX
	local curY = startY

	while( curX <= right ) do
		while( curY <= bottom ) do
			local block = newRect( group, curX, curY,
				                   { size = size, fill = _DARKGREY_, strokeWidth = 1, 
				                     touch = touchCallback } )
			curY = curY + size
		end
		curX = curX + size
		curY = startY
	end

	-- Create a Legend
	--
	local eventNames = { "began", "moved", "ended", "cancelled", "other" }
	local eventColors = { _BLUE_, _GREEN_, _RED_, _BLACK_, _ORANGE_ }
	local tween = size + 20
	local firstBlock = centerX - (#eventNames * tween)/2 + size/2

	for i = 1, #eventNames do
		local block = newRect(group, firstBlock + (i-1) * tween , startY - 100, 
			{ size = size, fill = eventColors[i], strokeWidth = 1 } )
		easyIFC:quickLabel( group, eventNames[i], block.x , block.y + block.contentHeight/2 + 15, gameFont, 10 )
	end
	easyIFC:quickLabel( group, "Phase Colors", centerX,  startY - 130 - size/2, gameFont, 24 )

end

-- =============================================================
-- More... add any additional functions you need below
-- =============================================================


-- =============================================================
-- Functions below this marker are optional.
-- They are used by the sampler to provide more details about the
-- sample and to do special sampler-only setup or cleanup.
-- =============================================================
function public.about()
	local altName = "Touch Does Not End (OCT 2012)"
	local description = 
	'<font size="22" color="SteelBlue">Toes Does Not End Off-screen (OCT 2012)</font><br><br><br>'

	

	local video = "https://www.youtube.com/watch?v=DQ_lKayyClk" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end
function public.samplerSetup( group )
	print("Did sampler setup @ ", system.getTimer() )
end
function public.samplerCleanup( group )
	print("Did sampler cleanup @ ", system.getTimer() )
end

return public