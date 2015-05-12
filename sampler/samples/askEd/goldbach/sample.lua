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

	public.isRunning = false

end

-- =============================================================
-- run( group )
--
-- group - A display group for you to place any visual content into.
--         This group is managed for you and should not be destroyed by
--         your code. 
-- =============================================================
function public.run( group )

	public.isRunning = true

	-- Localizations
	local newCircle 	= ssk.display.newCircle
	local newRect 		= ssk.display.newRect
	local newImageRect 	= ssk.display.newImageRect
	local easyIFC   	= ssk.easyIFC
	local mRand 		= math.random

	local maxIter = 10000
	local primes = {}
	local fails = {}

	local msg1 = easyIFC:quickLabel( group, "Generating List of Primes...", centerX, centerY - 50, gameFont, 10, _W_ )
	local msg2 = easyIFC:quickLabel( group, "Testing Goldbach's Conjecture...", centerX, centerY, gameFont, 10, _W_ )
	local msg3= easyIFC:quickLabel( group, "Testing Goldbach's Conjecture...", centerX, centerY + 50, gameFont, 10, _W_ )
	msg2.isVisible = false
	msg3.isVisible = false

	local function primeTest(n)
		for i = 2, n^(1/2) do
			if (n % i) == 0 then
				return false
			end
		end
		return true
	end


	-- Warning uses brute force!
	local function findGoldbachSums( num )
		local start 
		for i = 1, #primes do
			if(primes[i] > num) then 
				start = i-1
				break
			elseif( i == #primes ) then
				start = i
			end
		end
		if(not start) then 
			return 0,0,false
		end
		for i = start, 1, -1 do
			local a = primes[i]
			for k = start, 1, -1 do			
				local b = primes[k]
				if(a+b == num) then
					return a,b,true
				end
			end
		end
		return 0,0,false
	end
	local function testGoldbachConjecture( min, max )
		local passed = true
		for i = min, max do
			if( i % 2 == 0 ) then -- Even number, test it				
				local a,b,pass = findGoldbachSums( i )
				passed = passed and pass
				if( not pass ) then
					fails[#fails+1] = i
				end
			end
		end
		return passed
	end


	local function doTest()
		if( not public.isRunning ) then return end
		msg2.isVisible = true

		-- Test all even numbers between 3 and .. maxIter
		local startTime = system.getTimer()
		local passed = testGoldbachConjecture( 3, maxIter )
		local endTime = system.getTimer()

		if( passed ) then
			msg2.text = "All even numbers between 3 and " .. maxIter .. " are the sum of two prime numbers."
		else
			msg2.text = "Found the follwing even numbers that are not the sum of two primes! (See console.)"
			for i = 1, #fails do
				print(i)
			end
		end
		msg3.text = "Test ran for " .. (endTime - startTime) .. " milliseconds."
		msg3.isVisible = true
	end

	local function genPrimes()
		if( not public.isRunning ) then return end
		-- Build list of primes
		for i = 1, maxIter do
			if( primeTest(i) ) then
				primes[#primes+1] = i			
			end
		end
		msg1.text = "There are " .. #primes .. " prime numbers between 1 and " .. maxIter
		timer.performWithDelay( 500, doTest )
	end


	timer.performWithDelay( 500, genPrimes )
	
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
	local altName = "Goldbach (JUN 2014)"
	local description = 
	'<font size="22" color="SteelBlue">' .. "Goldbach's" .. ' Conjecture (JUN 2014)</font><br><br><br>' ..
    'From this post:<a href = "https://forums.coronalabs.com/topic/48896-ask-ed/">CLICK HERE</a><br><br>'
	

	local video = "" -- "https://www.youtube.com/watch?v=-nCESqeKXCY"

	return altName, description, video
end
function public.samplerSetup( group )
	print("Did sampler setup @ ", system.getTimer() )
end
function public.samplerCleanup( group )
	print("Did sampler cleanup @ ", system.getTimer() )
end

return public