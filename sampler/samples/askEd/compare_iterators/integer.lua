local integerBench = {}

-- Example for this question: http://forums.coronalabs.com/topic/48914-how-to-deal-with-arrays-of-a-lot-of-spawned-objects/#entry253053
-- and for Bud's private question.

function integerBench.run( group )
	local bench = ssk.easyBench
	local round = bench.round
	local mRand = math.random

	local function rcolor()
		return mRand(20,255)/255
	end

	-- Create a list 10,000 randomly chosen display objects
	local myObjects = {}
	for i = 1, 10000 do
		local x = mRand( left+20, right-20)
		local y = mRand( top+20, bottom-20)
		local type = mRand(1,2)
		if(type == 1) then
			tmp = display.newCircle( group, x, y, 20)
		else
			tmp = display.newRect( group, x, y, 40, 40 )
		end

		-- Store references using integer indexes
		myObjects[#myObjects+1] = tmp
	end

	-- Two tests that iterate over the list 'myObjects' but do no work
	--
	local function numericIteration_noWork()
		local tmp
		for i = 1, #myObjects do
			tmp = myObjects[i]
			-- Do some work here on 'tmp'
		end
	end

	local function numericIterationWithNilTest_noWork()
		local tmp
		for i = 1, #myObjects do
			tmp = myObjects[i]
			if( tmp == "" ) then
				-- Do nothing, this entry was erased
			else
				-- Do some work here on 'tmp'						
			end
		end
	end


	-- Two tests that iterate over the list 'myObjects' and randomly change the color of each object
	--
	local function numericIteration_withWork()
		local tmp
		for i = 1, #myObjects do
			tmp = myObjects[i]
			tmp:setFillColor(rcolor(),rcolor(),rcolor())
		end
	end

	local function numericIterationWithNilTest_withWork()
		local tmp
		for i = 1, #myObjects do
			tmp = myObjects[i]
			if( tmp == "" ) then
				-- Do nothing, this entry was erased
			else
				tmp:setFillColor(rcolor(),rcolor(),rcolor())			
			end
		end
	end

	-- Run each test 10 times to get a good measurement
	--
	local t1 = bench.measureTime(numericIteration_noWork,10)
	local t2 = bench.measureTime(numericIterationWithNilTest_noWork,10)
	local t3 = bench.measureTime(numericIteration_withWork,10)
	local t4 = bench.measureTime(numericIterationWithNilTest_withWork,10)

	-- Now let's remove 500 objects from the table and re-run the last test
	local count = 1
	for k,v in pairs( myObjects ) do
		if(k) then
			display.remove(v)
			myObjects[k] = ""
		end
		if( count >= 500 ) then break end
		count = count + 1
	end

	local t5 = bench.measureTime(numericIterationWithNilTest_withWork,10)

	local results = {}
	results[1] = "'#' iteration + No Work              x 10 iterations: " .. t1 .. " ms "
	results[2] = "'#' iteration + 'nil' Test + No Work x 10 iterations: " .. t2 .. " ms "
	results[3] = "'#' iteration + Work                 x 10 iterations: " .. t3 .. " ms "
	results[4] = "'#' iteration + 'nil' Test + Work    x 10 iterations: " .. t4 .. " ms "
	results[5] = "'#' iteration + 'nil' Test + Work + Sparse  x 10 iterations: " .. t5.. " ms "

	return results
end

return integerBench