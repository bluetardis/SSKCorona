-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Table Add-ons
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

local json = require( "json" )

--[[
h table.combineUnique
d Combines n tables into a single table containing only unique members from each source table.
d <br>'''Warning:''' Resulting table is not integer indexed.
d <br>'''Warning 2:''' Order is not maintained
s table.combineUnique( ... )
s * ... - One or more tables
r New table containing all unique values from passed tables.
e local table1 = { 1, 2 }
e local table2 = { 6, 2, 3, 4}
e local table3 = table.combineUnique( table1, table2 )
e for k,v in pairs( table3 ) do
e    print(v)
e end
e
d
d Prints:<br>
d 1<br>
d 2<br>
d 3<br>
d 4<br>
d 6<br>
--]]
function table.combineUnique( ... )
	local newTable = {}
	
	for i=1, #arg do
		for k,v in pairs( arg[i] ) do
			newTable[v] = v
		end
	end

	return newTable
end

--[[
h table.combineUnique_i
d Combines n tables into a single table containing only unique members from each source table.
d <br>'''Warning:''' Order is not maintained
s table.combineUnique_i( ... )
s * ... - One or more tables
r New integer indexed table containing all unique values from passed tables.
e local table1 = { 1, 2 }
e local table2 = { 6, 2, 3, 4}
e local table3 = table.combineUnique_i( table1, table2 )
e for i = 1, #table3 do
e    print(table3[i])
e end
e
d
d Prints:<br>
d 1<br>
d 2<br>
d 3<br>
d 4<br>
d 6<br>
--]]
function table.combineUnique_i( ... )
	local newTable = {}
	local tmpTable = table.combineUnique( unpack(arg) )
	
	local i = 1

	for k,v in pairs( tmpTable ) do
		newTable[i] = tmpTable[k]
		i = i+1
	end

	return newTable
end

--[[
h table.shallowCopy
d Copies single-level tables; handles non-integer indexes; does not copy metatable
s table.shallowCopy( src [ , dst ])
s * src - Source table to copy value from.
s * dst - (optional) Destination table to copy to.  If not supplied, blank table is created.
r ''dst'' table if provided, else new table with all first-level values copied into table.
e local srcTable = { x=10, y=100 }
e local newTable = table.shallowCopy( srcTable )
e print( srcTable.x )
e print( newTable.x )
e newTable.x = 50
e print( srcTable.x )
e print( newTable.x )
e
d
d Prints:<br>
d 10<br>
d 10<br>
d 10<br>
d 50<br>
--]]
function table.shallowCopy( src, dst )
	local dst = dst or {}
	for k,v in pairs(src) do 
		dst[k] = v
	end
	return dst
end

--[[
h table.deepCopy
d Copies multi-level tables; handles non-integer indexes; does not copy metatable
s table.deepCopy( src [ , dst ])
s * src - Source table to copy value from.
s * dst - (optional) Destination table to copy to.  If not supplied, blank table is created.
r ''dst'' table if provided, else new table with all first-level values copied into table.
e local srcTable = { a={x=10, y=100}, b=a={x=20, y=50} }
e local srcTable = { a={x=10, y=100}, b={x=20, y=50} }
e local newTable = table.deepCopy( srcTable )
e print( srcTable.a.x )
e print( newTable.a.x )
e newTable.a.x = 50
e print( srcTable.a.x )
e print( newTable.a.x )
e
d
d Prints:<br>
d 10<br>
d 10<br>
d 10<br>
d 50<br>
--]]
function table.deepCopy( src, dst )
	local dst = dst or {}
	for k,v in pairs(src) do 
		if( type(v) == "table" ) then
			dst[k] = table.deepCopy( v, nil )
		else
			dst[k] = v
		end		
	end
	return dst
end

--[[
h table.save
d Saves table to file (Uses JSON library as intermediary)
s table.save( theTable, fileName [, base ] )
s * theTable - Table to save to file.
s * fileName - Destination file name, including relative path.
s * base - (optional) System base path: 
s ** system.ResourceDirectory - (default) The directory where all application assets exist. Note: you should never create, modify, or add files to this directory.
s ** system.DocumentsDirectory - Used for files that need to persist between application sessions.
s ** system.TemporaryDirectory - A temporary directory. Files written to this directory are not guaranteed to exist in subsequent application sessions. They may or may not exist.
r ''true'' on success, ''false'' otherwise.
--]]
function table.save( theTable, fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	fh = io.open( path, "w" )
	if(fh) then
		fh:write(json.encode( theTable ))
		io.close( fh )
		return true
	end	
	return false
end

--[[
h table.load
d Loads table from file (Uses JSON library as intermediary)
s table.load( fileName [, base ] )
s * fileName - Source file name, including relative path.
s * base - (optional) System base path: 
s ** system.ResourceDirectory - (default) The directory where all application assets exist. Note: you should never create, modify, or add files to this directory.
s ** system.DocumentsDirectory - Used for files that need to persist between application sessions.
s ** system.TemporaryDirectory - A temporary directory. Files written to this directory are not guaranteed to exist in subsequent application sessions. They may or may not exist.
r Table containing file contents or nil on failure.
--]]
function table.load( fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	local fh, reason = io.open( path, "r" )
	
	if fh then
		local contents = fh:read( "*a" )
		io.close( fh )
		local newTable = json.decode( contents )
		return newTable
	else
		return nil
	end
end

--[[
h table.dump
d Dumps indexes and values inside single-level table (for debug)
s table.dump( theTable [, padding ] )
s * theTable - Name of file, optionally including subdirectory path.
s * padding - (optional) Number of spaces to use for padding.  Must be 1 or more. (Default == 30)
r None.
e local srcTable = { a={x=10, y=100}, b={x=20, y=50}, x = 10, y = 20 }
e table.dump(srcTable, 10)
e 
d
d
d Prints (similar):<br>
d Table Dump:<br>
d -----<br>
d a (string) == table: 07819368 (table)<br>
d x (string) == 10 (number)<br>
d y (string) == 20 (number)<br>
d b (string) == table: 078163E8 (table)<br>
d -----<br>
--]]
function table.dump(theTable, padding )
	local padding = padding or 30
	print("\Table Dump:")
	print("-----")
	if(theTable) then
		for k,v in pairs(theTable) do 
			local key = tostring(k)
			local value = tostring(v)
			local keyType = type(k)
			local valueType = type(v)
			local keyString = key .. " (" .. keyType .. ")"
			local valueString = value .. " (" .. valueType .. ")" 

			keyString = keyString:rpad(padding)
			valueString = valueString:rpad(padding)

			print( keyString .. " == " .. valueString ) 
		end
	else
		print("empty")
	end
	print("-----\n")
end


