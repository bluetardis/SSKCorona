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
--[[
h ssk.sounds:addEffect
d Creates a record for a new sound effect and optionally prepares it.
s ssk.sounds:addEffect( name, file, stream, preload  )
s * name - A string containing the name for this new effect.
s * file - A string cotaining the path and name of the sound file to use for this effect.
s * stream - A boolean value indicating whether this sound should be streamed or loaded all at once.  The default is ''false'', meaning to load all at once.
s * preload - A boolean value specifying whether to load this sound immediately, or to wait until it is needed/used.  The default is ''false'', meaning to wait.
r None.
--]]
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
--[[
h ssk.sounds:addEffect
d Creates a record for a new music track and optionally prepares it.
s ssk.sounds:addMusic( name, file, preload, fadein, stream  )
s * name - A string containing the name for this new music.
s * file - A string cotaining the path and name of the sound file to use for this music.
s * preload - A boolean value specifying whether to load this sound immediately, or to wait until it is needed/used.  The default is ''false'', meaning to wait.
s * fadein - A numeric value specifying the fade in time (0 for none) for this music track. The default is 500 ms.
s * stream - A boolean value indicating whether this sound should be streamed or loaded all at once.  The default is ''true'', meaning load it in small bits over time.
r None.
--]]
function soundMgr:addMusic( name, file, preload, fadein, stream  )
	local entry = {}
	self.soundsCatalog[name] = entry

	entry.name     = name
	entry.file     = file
	entry.stream   = fnn(stream,true)
	entry.preload  = fnn(preload,false)
	entry.fadein   = fnn(fadein, 500 )
	entry.stream   = true
	entry.isEffect = false

	if(entry.preload) then
		entry.handle = audio.loadStream( entry.file )
	end
end

-- ============= setEffectsVolume()
--[[
h ssk.sounds:setEffectsVolume
d Set the volume level for all sound effects played through the sound manager.
s ssk.sounds:setEffectsVolume( value )
s * value - A floating-point number in the range [0.0, 1.0] representing the new sound effects value. Values outside this range are capped.
r A floating-point number in the range [0.0, 1.0] representing the new sound effects value.
--]]
function soundMgr:setEffectsVolume( value )
	self.effectsVolume = fnn(value or 1.0)
	if(self.effectsVolume < 0) then self.effectsVolume = 0 end
	if(self.effectsVolume > 1) then self.effectsVolume = 1 end
	audio.setVolume( soundMgr.effectsVolume, {channel = self.effectsChannel} )
	return self.effectsVolume
end

-- ============= getEffectsVolume()
--[[
h ssk.sounds:getEffectsVolume
d Gets the volume level for all sound effects played through the sound manager.
s ssk.sounds:getEffectsVolume( )
r A floating-point number in the range [0.0, 1.0] representing the new sound effects value.
--]]
function soundMgr:getEffectsVolume( )
	return self.effectsVolume
end

-- ============= setMusicVolume()
--[[
h ssk.sounds:setMusicVolume
d Set the volume level for all music tracks played through the sound manager.
s ssk.sounds:setMusicVolume( value )
s * value - A floating-point number in the range [0.0, 1.0] representing the new music tracks value. Values outside this range are capped.
r A floating-point number in the range [0.0, 1.0] representing the new music tracks value.
--]]
function soundMgr:setMusicVolume( value )
	self.musicVolume = fnn(value or 1.0)
	if(self.musicVolume < 0) then self.musicVolume = 0 end
	if(self.musicVolume > 1) then self.musicVolume = 1 end
	audio.setVolume( soundMgr.musicVolume, {channel = self.musicChannel} )
	return self.musicVolume
end

-- ============= getMusicVolume()
--[[
h ssk.sounds:getMusicVolume
d Gets the volume level for all music tracks played through the sound manager.
s ssk.sounds:getMusicVolume( )
r A floating-point number in the range [0.0, 1.0] representing the new music tracks value.
--]]
function soundMgr:getMusicVolume(  )
	return self.musicVolume
end

-- ============= play()
--[[
h ssk.sounds:play
d Plays a named sound effect or music track.
s ssk.sounds:play( name )
s * name - A string containing the name of a previously configured sound effect or music track.
r ''true'' if the effect/music was effectively started, ''false'' otherwise.
--]]
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
--[[
h ssk.sounds:stop
d Stops a currently-playing named sound effect or music track.
s ssk.sounds:stop( name )
s * name - A string containing the name of a previously configured sound effect or music track.
r ''true'' if the effect/music was effectively stopped, ''false'' otherwise.
--]]
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