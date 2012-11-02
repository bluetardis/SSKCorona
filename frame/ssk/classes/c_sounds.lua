-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2012 
-- =============================================================
-- Sound Manager
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

--EFM 
--[[
- Add ability to remove and purge sounds
- Build small library of basic sounds to go with ssk
--]]

audio.setMinVolume( 0.0 )
audio.setMaxVolume( 1.0 )

soundMgr               = {}
soundMgr.soundsCatalog = {}
soundMgr.effectsVolume = 0.8
soundMgr.musicVolume   = 0.8

--EFM need more channels and way of handling volume
--EFM need error checking code too
soundMgr.musicChannel   = audio.findFreeChannel() 
soundMgr.effectsChannel = soundMgr.musicChannel + 1 


-- ============= addEffect()
function soundMgr:addEffect( name, file, stream, preload  )
	local entry = {}
	self.soundsCatalog[name] = entry

	entry.name     = name
	entry.file     = file
	entry.stream   = fnn(stream,false)
	entry.preload  = fnn(preload,false)
	entry.isEffect = true

	if(entry.preload) then
		if(entry.stream) then
			entry.handle = audio.loadStream( entry.file )
		else
			entry.handle = audio.loadSound( entry.file )
		end
	end
end

-- ============= addMusic()
function soundMgr:addMusic( name, file, preload, fadein  )
	local entry = {}
	self.soundsCatalog[name] = entry

	entry.name     = name
	entry.file     = file
	entry.stream   = fnn(stream,false)
	entry.preload  = fnn(preload,false)
	entry.fadein   = fnn(fadein, 500 )
	entry.stream   = true
	entry.isEffect = false

	if(entry.preload) then
		entry.handle = audio.loadStream( entry.file )
	end
end

-- ============= setEffectsVolume()
function soundMgr:setEffectsVolume( value )
	self.effectsVolume = fnn(value or 1.0)
	if(self.effectsVolume < 0) then self.effectsVolume = 0 end
	if(self.effectsVolume > 1) then self.effectsVolume = 1 end
	audio.setVolume( soundMgr.effectsVolume, {channel = self.effectsChannel} )
	return self.effectsVolume
end

-- ============= getEffectsVolume()
function soundMgr:getEffectsVolume( value )
	return self.effectsVolume
end

-- ============= setMusicVolume()
function soundMgr:setMusicVolume( value )
	self.musicVolume = fnn(value or 1.0)
	if(self.musicVolume < 0) then self.musicVolume = 0 end
	if(self.musicVolume > 1) then self.musicVolume = 1 end
	audio.setVolume( soundMgr.musicVolume, {channel = self.musicChannel} )
	return self.musicVolume
end

-- ============= getMusicVolume()
function soundMgr:getMusicVolume( value )
	return self.musicVolume
end

-- ============= play()
function soundMgr:play( name )
	local entry = self.soundsCatalog[name]

	if(not entry) then
		print("Sound Manager - ERROR: Unknown sound: " .. name )
		return false
	end

	if(not entry.handle) then
		if(entry.stream) then
			entry.handle = audio.loadStream( entry.file )
		else
			entry.handle = audio.loadSound( entry.file )
		end
	end

	if(not entry.handle) then
		print("Sound Manager - ERROR: Failed to load sound: " .. name, entry.file )
		return false
	end

	if(entry.isEffect) then
		audio.setVolume( soundMgr.effectsVolume, {channel = self.effectsChannel} )
		audio.play( entry.handle, {channel = self.effectsChannel} )
	else
		audio.setVolume( soundMgr.musicVolume, {channel = self.musicChannel} )
		audio.play( entry.handle, {channel = self.musicChannel, loops = -1, fadein=entry.fadein} )
	end

	return true

end

-- ============= stop()
function soundMgr:stop( name )
	local entry = self.soundsCatalog[name]

	if(not entry) then
		print("Sound Manager - ERROR: Unknown sound: " .. name )
		return false
	end

	if(entry.isEffect) then
		audio.stop( self.effectsChannel )
	else
		audio.stop( self.musicChannel )
	end

	return true

end



return soundMgr