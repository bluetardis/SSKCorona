-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Standard Buttons & Sliders Callbacks
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSK library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSK or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSK and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Last Modified: 29 AUG 2012
-- =============================================================

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

local standardCallbacks = {}

-- ==================================================
-- == Simple table roller
-- ==
-- == * Used with push buttons.
-- == * Takes a table of button text values to initialize
-- == * Each button release changes to next text value in table (loops).
-- ==================================================
--[[
h sbc.prep_tableRoller
d Prepares a button to work with the sbc.tableRoller_CB() callback.
d <br>
d <br> These paired functions allow a pushbutton to be 
d associated with a table of strings.  Subsequently, each time the button is pressed and released, the button text
d will take on the next value in the table.  When the end of the table is reached, it will loop back to the first value.
d <br>
d <br>Note: The text is changed before the optional ''chainedCB'' is called.
d <br>Warning: This is meant to be used with push buttons and may act strangely if used with other button types.
s sbc.prep_tableRoller( button, srcTable [ , chainedCB [ , underBarSwap ] ]) 
s * button - Button to prepare.
s * srcTable - A table of strings used as labels for the push button.
s * chainedCB - (optional) A callback that is executed when the button is released. 
s* underBarSwap - (optional) If this is set to true, and if a string in ''srcTable'' has underbars in it, they will be replaced with spaces before setting the button text.
r None.
--]]
function standardCallbacks.prep_tableRoller( button, srcTable, chainedCB, underBarSwap ) 
	button._entryname = entryName
	button._srcTable = srcTable
	button._chainedCB = chainedCB
	button._underBarSwap = underBarSwap or false	
end

--[[
h sbc.tableRoller_CB
d A standard callback designed to work with push buttons.
d <br>
d <br>Warning: prep_tableRoller() must be called first before you attach this callback to a button.
d <br>
d <br>Warning: This is meant to be used with sliders and may act strangely if attached to other 'button' types.
d <br>
d <br>'''See prep_tableRoller() for details of syntax and usage'''.
--]]
function standardCallbacks.tableRoller_CB( event ) 
	local target        = event.target
	local srcTable		= target._srcTable
	local chainedCB     = target._chainedCB
	local underBarSwap  = target._underBarSwap
	local curText       = target:getText()
	local retVal        = true

	if(underBarSwap) then
		curText = curText:spaces2underbars(curText)
	end

	local j = 0
	for i = 1, #srcTable do
		dprint(2,tostring(srcTable[i]) .. " ?= " .. curText )
		if( tostring(srcTable[i]) == curText ) then
			j = i
			break
		end
	end

	j = j + 1

	if(j > #srcTable) then
		j = 1
	end

	if(underBarSwap) then
		target:setText( srcTable[j]:underbars2spaces() )
	else
		target:setText( srcTable[j] )
	end	

	if( chainedCB ) then
		retVal = chainedCB( event )
	end

	return retVal
end

-- ==================================================
-- == Set a Table Object from a list of values 
-- == each time the button is pressed.
-- ==================================================
--[[
h sbc.prep_table2TableRoller
d Prepares a button to work with the sbc.table2TableRoller_CB() callback. 
d <br>
d <br> These paired functions allow a pushbutton to be 
d associated with a table of strings.  Subsequently, each time the button is pressed and released, the button text
d will take on the next value in the table.  When the end of the table is reached, it will loop back to the first value.
d <br>
d <br>In addition to updating the text value of the button, a field in ''dstTable'' is also given the new value.  This makes it
d easy to set up options tables whose fields take multiple string values to configure a game/app.
d <br>
d <br>Note: The button text and the field in ''dstTable'' are both updated before the optional ''chainedCB'' is called.
d <br>Warning: This is meant to be used with push buttons and may act strangely if used with other button types.
d
s sbc.prep_table2TableRoller( button, dstTable, entryName, srcTable [ , chainedCB ]) 
s * button - Button to prepare.
s * dstTable - The table that sbc.table2TableRoller_CB() updates.
s * entryName - A string (no spaces allowed) specifying the field in ''dstTable'' that sbc.table2TableRoller_CB() should update.
s * srcTable - A table of strings used as labels for the push button.
s * chainedCB - (optional) A callback that is executed when the button is released. 
r None.
--]]
function standardCallbacks.prep_table2TableRoller( button, dstTable, entryName, srcTable, chainedCB ) 
	button._dstTable = dstTable
	button._entryname = entryName
	button._srcTable = srcTable
	button._chainedCB = chainedCB
end

--[[
h sbc.table2TableRoller_CB
d A standard callback designed to work with push buttons.
d <br>
d <br>Warning: prep_table2TableRoller() must be called first before you attach this callback to a button.
d <br>
d <br>Warning: This is meant to be used with sliders and may act strangely if attached to other 'button' types.
d <br>
d <br>'''See prep_table2TableRoller() for details of syntax and usage'''.
--]]
function standardCallbacks.table2TableRoller_CB( event ) 
	local target      = event.target
	local dstTable   = target._dstTable
	local entryName   = target._entryname
	local srcTable = target._srcTable
	local chainedCB   = target._chainedCB
	local curText     = target:getText()
	local retVal      = true

	local j = 0
	for i = 1, #srcTable do
		if( srcTable[i] == curText ) then
			j = i
			break
		end
	end

	j = j + 1

	if(j > #srcTable) then
		j = 1
	end

	target:setText( srcTable[j] )
	dstTable[entryName] = srcTable[j] 

	if( chainedCB ) then
		retVal = chainedCB( event )
	end

	return retVal
end

-- ==================================================
-- == Toggle a table value between true and false,
-- == each time the button is pressed.
-- ==================================================
--[[
h sbc.prep_tableToggler
d Prepares a toggle or radio button to work with the sbc.tableToggler_CB() callback. 
d <br>
d <br> These paired functions allow a toggle button to update a named field within a table to match the ''true''/''false'' status of the button's toggle state.
d <br>
d <br>Warning: This is meant to be used with toggle and radio buttons.  It may act strangely if attached to a push button.
d
s sbc.prep_tableToggler( button, dstTable, entryName [ , chainedCB ] ) 
s * button - Button to prepare.
s * dstTable - The table that sbc.tableToggler_CB() updates.
s * entryName - A string (no spaces allowed) specifying the field in ''dstTable'' that sbc.tableToggler_CB() should update.
s * chainedCB - (optional) A callback that is executed when the button is toggled. 
r None.
--]]

function standardCallbacks.prep_tableToggler( button, dstTable, entryName, chainedCB ) 
	button._dstTable = dstTable
	button._entryname = entryName
	button._chainedCB = chainedCB

	dprint(2,"*******************************")
	dprint(2,entryName .. " == " ..  tostring(dstTable[entryName]) )
	if(dstTable[entryName] == true ) then
		button:toggle()
	end
end

--[[
h sbc.tableToggler_CB
d A standard callback designed to work with toggle and radio buttons.  
d <br>
d <br>Warning: prep_tableToggler() must be called first before you attach this callback to a button.
d <br>
d <br>Warning: This is meant to be used with sliders and may act strangely if attached to other 'button' types.
d <br>
d <br>'''See prep_tableToggler() for details of syntax and usage'''.
--]]
function standardCallbacks.tableToggler_CB( event ) 
	local target      = event.target
	local dstTable   = target._dstTable
	local entryName   = target._entryname
	local chainedCB   = target._chainedCB
	local retVal      = true

	if(not dstTable) then
		return retVal
	end

	dstTable[entryName] = target:pressed() 

	if( chainedCB ) then
		retVal = chainedCB( event )
	end

	return retVal
end


-- ==================================================
-- == Horizontal Sliders
-- ==================================================
--[[
h sbc.prep_horizSlider2Table
d Prepares a slider to work with the sbc.horizSlider2Table_CB() callback. 
d <br>
d <br> These paired functions allow a toggle button to update a named field within a table to match the value of the slider.
d <br>
d <br>Warning: This is meant to be used with sliders and may act strangely if attached to other 'button' types.
d
s sbc.prep_horizSlider2Table( button, dstTable, entryName [ , chainedCB ] ) 
s * button - Button to prepare.
s * dstTable - The table that sbc.horizSlider2Table_CB() updates.
s * entryName - A string (no spaces allowed) specifying the field in ''dstTable'' that sbc.horizSlider2Table_CB() should update.
s * chainedCB - (optional) A callback that is executed when the slider is moved. 
r None.
--]]
function standardCallbacks.prep_horizSlider2Table( button, dstTable, entryName, chainedCB ) 
	button._dstTable = dstTable
	button._entryname = entryName
	button._chainedCB = chainedCB

	local value = dstTable[entryName]

	local knob = button.myKnob

	button:setValue( value )
end

--[[
h sbc.horizSlider2Table_CB
d A standard callback designed to work with sliders.  
d <br>
d <br>Warning: prep_horizSlider2Table() must be called first before you attach this callback to a slider.
d <br>
d <br>'''See prep_horizSlider2Table() for details of syntax and usage'''.
--]]
function standardCallbacks.horizSlider2Table_CB( event )
	local target     = event.target
	local myKnob     = target.myKnob
	local dstTable   = target._dstTable
	local entryName  = target._entryname
	local chainedCB  = target._chainedCB

	local retVal = true

	local newX = event.x

	local left = (target.x - target.width/2) + myKnob.width/2
	local right = (target.x + target.width/2) - myKnob.width/2
	local width = right-left

	if(newX < left) then
		newX = left
	elseif(newX > right) then
		newX = right
	end

	myKnob.x = newX

	target.value = (newX-left) / width
	target.value = tonumber(string.format("%1.2f", target.value))

	dprint(2, tostring(entryName) .. " Knob value == " .. target.value)

	if(dstTable and entryName) then
		dstTable[entryName] = target.value 
	end

	if( chainedCB ) then
		retVal = chainedCB( event )
	end

	return retVal
end
return standardCallbacks