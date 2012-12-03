-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- io Add-ons
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
h io.exists
d Checks if file exists.
s io.exists( fileName [, base ] )
s * fileName - Name of file, optionally including subdirectory path.
s * path - (optional) System base path: 
s ** system.ResourceDirectory - (default) The directory where all application assets exist. Note: you should never create, modify, or add files to this directory.
s ** system.DocumentsDirectory - Used for files that need to persist between application sessions.
s ** system.TemporaryDirectory - A temporary directory. Files written to this directory are not guaranteed to exist in subsequent application sessions. They may or may not exist.
r ''true'' if file exists, ''false'' otherwise.
e if( io.exists( "playerStats.txt", system.DocumentsDirectory ) then
e    ... some work here
e end
--]]
function io.exists( fileName, base )
	local fileName = fileName
	if( base ) then
		fileName = system.pathForFile( fileName, base )
	end
	local f=io.open(fileName,"r")
	if (f == nil) then 
		return false
	end
	io.close(f)
	return true 
end


--EFM add docs
if( io.readFile ) then
	print("ERROR! io.readFile() exists already")
else
	print("NOTE io.readFile() created")
end
function io.readFile( fileName, base )
	local base = base or nil
	local fileContents

	if( io.exists( fileName, base ) == false ) then
		print("A", fileName)
		return nil
	end

	local fileName = fileName
	if( base ) then
		fileName = system.pathForFile( fileName, base )
	end

	print("B", fileName)
	
	local f=io.open(fileName,"r")
	if (f == nil) then 
		print("B")
		return nil
	end

	fileContents = f:read( "*a" )

	io.close(f)

	print("X")
	return fileContents
end
