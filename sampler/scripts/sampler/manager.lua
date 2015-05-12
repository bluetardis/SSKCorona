-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- Sample Manager
-- =============================================================
local sampleMgr = {}

local samplesDB

sampleMgr.autoUpdate = false and onSimulator

function sampleMgr.discover()
	samplesDB = table.load( "samplesDB.json", system.ResourceDirectory ) or  {}

	if( onSimulator ) then
		local rgFiles 		= ssk.rgFiles
		local files = rgFiles.getFilesInDirectory("samples")

		-- ignore the incoming folder
		for k,v in pairs( files ) do
			if( string.match( v, "_incoming" ) ) then
				files[k] = nil
			end
		end

		local flatNames = {}
		local altNames = {}
		local descriptions = {}
		local videos = {}
		for k,v in pairs( files ) do
			local tmp = rgFiles.getFilesInDirectory("samples/" .. v )
			--table.dump(tmp)

			for i = 1, #tmp do
				flatNames[#flatNames+1] = "samples." .. v .. "." .. tmp[i] .. ".sample"
				--print(flatNames[#flatNames])
				--flatNames[i] = tmp[i]
			end
			table.sort( flatNames )
		end
		table.sort(files)

		for i = 1, #flatNames do
			local path = flatNames[i]
			local sample = require( path )
			if( sample.about ) then
				local altName,description,video = sample.about() 
				--print(path, altName)
				package.loaded[path] = nil
				_G[path] = nil	
				altNames[path] = altName
				descriptions[path] = description
				videos[path] = video or ""
			else
				local parts = string.split( path, "%." )
				altNames[path] = parts[#parts-1]
			end
		end


		samplesDB = {}
		samplesDB.flat 	= flatNames
		samplesDB.alt 	= altNames
		samplesDB.descr = descriptions
		samplesDB.videos = videos

		local categories = {}
		samplesDB.categories = categories
		for i = 1, #flatNames do
			local path = flatNames[i]
			local parts = string.split( path, "%." )
			--table.dump(parts,nil,path)
			if( table.indexOf(categories, parts[2] ) == nil ) then
				categories[#categories+1] = parts[2]
			end
		end
		--print("A -------------------------")
		--table.print_r(samplesDB)
		--print("B -------------------------")
		if( sampleMgr.autoUpdate ) then
			table.save( samplesDB , "samplesDB.json" )
			print("UPDATED? ", rgFiles.copyDocumentToResource( "samplesDB.json" ) )
		end
	end
end

function sampleMgr.getCategories()
	local categories = samplesDB.categories
	--table.sort(categories)
	return categories
end

function sampleMgr.getSamples( category )
	local samples = {}
	local root = "samples." .. category 
	for k, v in pairs( samplesDB.flat ) do
		local parts = string.split( v, "%." )
		if( parts[2] == category ) then		
			--print("matched category", v)	
			samples[#samples+1] = v
		end
	end
	table.sort(samples)
	for k,v in pairs(samples) do
		samples[k] = samplesDB.alt[v]
	end
	return samples
end

function sampleMgr.getSamplePath( category, name )	
	for k,v in pairs( samplesDB.alt ) do
		local parts = string.split( k, "%." )
		if( v == name and parts[2] == category ) then
			--print("Exact match: ", k )
			return k
		end		
	end	
	return nil
end

function sampleMgr.getDescriptionVideo( path )	
	--table.print_r(samplesDB.descr,nil, path )
	--table.print_r(samplesDB.videos,nil, path)
	local descr = (samplesDB and samplesDB.descr) and samplesDB.descr[path] or ""
	local video = (samplesDB and samplesDB.videos) and samplesDB.videos[path] or ""
	return descr, video
end

function sampleMgr.getSamplesCount( )
	return table.count(samplesDB.flat)
end


return sampleMgr

-- OLD KEEP FOR FUTURE UPDATES
--
--[[
		local added = false 
		local removed = false
		for k,v in pairs( files ) do
			if( table.indexOf(samplesDB, v) == nil ) then
				added = true
				--print("Added", v)
			end
		end

		for k,v in pairs( samplesDB ) do
			if( table.indexOf(files, v) == nil ) then
				removed = true
				--print("Removed", v)
			end
		end

		samplesDB = {}
		samplesDB.db = files

		table.save( samplesDB , "samplesDB.json" )

		if( not sampleMgr.autoUpdate and ( added or removed ) ) then
			local msg = (added and removed) and 
				"Detected samples new and removed." 
				or (added and "Detected new samples."  or
					"Detected removed samples." )
			local function onYes()
				print("UPDATED? ", rgFiles.copyDocumentToResource( "samplesDB.json" ) )
			end
			local function onNo()
			end
			ssk.misc.easyAlert( "Update Database?", msg, { {"Yes", onYes}, {"No", onNo} } )
		elseif( sampleMgr.autoUpdate ) then
			print("UPDATED? ", rgFiles.copyDocumentToResource( "samplesDB.json" ) )
		end
--]]
-- OLD KEEP FOR FUTURE UPDATES