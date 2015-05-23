local widget = require "widget"

-- local http = require("socket.http") -- Do not import socket libraries before the RevMob SDK.
local RevMob = require("revmob")

display.setStatusBar(display.HiddenStatusBar)

local Screen
Screen = {
  left = function() return display.screenOriginX end,
  top = function() return display.screenOriginY end,
  right = function() return display.viewableContentWidth - display.screenOriginX end,
  bottom = function() return display.viewableContentHeight - display.screenOriginY end,
  width = function() return Screen.right() - Screen.left() end,
  height = function() return Screen.bottom() - Screen.top() end
}

local function msg(message)
  print("[RevMob Sample App] " .. tostring(message))
  io.output():flush()
end

local COLOR1 = { 168/255, 226/255, 255/255, 255/255 }
local COLOR2 = { 159/255, 182/255, 205/255, 255/255 }
local COLOR3 = { 122/255, 197/255, 205/255, 255/255 }
local COLOR4 = { 120/255, 190/255, 230/255, 255/255 }
local COLOR5 = { 135/255, 206/255, 250/255, 255/255 }
local COLOR6 = { 128/255, 128/255, 128/255, 255/255 }

local function revmobListener(event)
  msg("Event: " .. event.type .. " - " .. event.ad)
  if event.type == "adReceived" then
  elseif event.type == "adNotReceived" then
  elseif event.type == "sessionIsStarted" then
  elseif event.type == "sessionNotStarted" then
  end
end

local AMAZON_APK = false

-- Change these apps ids for your own app ids, create in the RevMob console: http://revmob.com
local REVMOB_IDS = {
  [REVMOB_ID_IOS] = '5106be9d0639b41100000052',
  [REVMOB_ID_ANDROID] = '5106bea78e5bd71500000098',
}
if AMAZON_APK then REVMOB_IDS[REVMOB_ID_ANDROID] = '5106beb3f919861200000072' end

local logLevel = 2

local function locationHandler(event)
  -- Check for error (user may have turned off Location Services)
  if event.errorCode then
    native.showAlert( "GPS Location Error", event.errorMessage, {"OK"} )
    print( "Location error: " .. tostring( event.errorMessage ) )
  else
    RevMob.setUserLocationLatitude(event.latitude)
    RevMob.setUserLocationLongitude(event.longitude)
    RevMob.setUserLocationAccuracy(event.accuracy)
  end

  Runtime:removeEventListener( "location", locationHandler )
end

local labels = {
  {'Start Session', COLOR1, function()
    -- RevMob.startSession(REVMOB_IDS)
    RevMob.startSessionWithListener(REVMOB_IDS, revmobListener)
    RevMob.setUserGender("male")
    RevMob.setUserAgeRangeMin(18)
    RevMob.setUserAgeRangeMax(25)
    RevMob.setUserBirthday("1995/01/01")
    RevMob.setUserPage("http://twitter.com/revmob")
    local interests = {"corona", "apps", "mobile"}
    RevMob.setUserInterests(interests)

    Runtime:addEventListener( "location", locationHandler )
  end },

  {'Test With Ads', COLOR1, function()
    RevMob.setTestingMode(RevMob.TEST_WITH_ADS)
  end },

  {'Test Without Ads', COLOR1, function()
    RevMob.setTestingMode(RevMob.TEST_WITHOUT_ADS)
  end },

  {'Disable Testing', COLOR1, function()
    RevMob.setTestingMode(RevMob.TEST_DISABLED)
  end },

  {'Show Fullscreen', COLOR2, function()
    local PLACEMENT_IDS = { [REVMOB_ID_IOS] = '5107dfdeb909351500000071', [REVMOB_ID_ANDROID] = '5107dfc2b90935a8030000a5' }
    if AMAZON_APK then PLACEMENT_IDS = { [REVMOB_ID_ANDROID] = '5107df21b90935a8030000a3' } end
    RevMob.showFullscreen(revmobListener, PLACEMENT_IDS)
  end },

  {'Pre-load Fullscreen', COLOR2, function()
    preloadedFullscreen = RevMob.createFullscreen(revmobListener, PLACEMENT_IDS)
  end },

  {'Show Loaded Fullscreen', COLOR2, function()
    if (preloadedFullscreen ~= nil) then preloadedFullscreen:show() end
  end },


  {'Show Banner', COLOR3, function()
    local PLACEMENT_IDS = { [REVMOB_ID_IOS] = '5107dfde9c1d2f160000005f', [REVMOB_ID_ANDROID] = '5107df92492ceb1200000091' }
    if AMAZON_APK then REVMOB_IDS[REVMOB_ID_ANDROID] = '5107de36152a9b0a00000060' end
    banner = RevMob.createBanner({listener = revmobListener }, PLACEMENT_IDS)
    bannerVisible = true
  end },
  {'Show Custom Banner', COLOR3, function()
    banner = RevMob.createBanner({listener = revmobListener, x = 50, y = 50, width = 200, height = 40 }, PLACEMENT_IDS)
    bannerVisible = true
  end },
  {'Hide/Show Banner', COLOR3, function()
    if banner then if bannerVisible then banner:hide() bannerVisible = false else banner:show() bannerVisible = true end end
  end },
  {'Change Banner', COLOR3, function()
    if banner then
      banner:setPosition(banner.x + 1, banner.y + 1)
      banner:setDimension(banner.width - 1, banner.height - 1)
    end
  end },
  {'Release Banner', COLOR3, function()
    if banner then banner:release() end
  end },


  {'Open Link', COLOR4, function()
    local PLACEMENT_IDS = { [REVMOB_ID_IOS] = '5107dfddb90935a8030000a7', [REVMOB_ID_ANDROID] = '5107dfe02513d00a00000031' }
    if AMAZON_APK then REVMOB_IDS[REVMOB_ID_ANDROID] = '5107df289c1d2f0e000000ad' end
    RevMob.openAdLink(revmobListener, PLACEMENT_IDS)
  end },

  {'Pre-load Link', COLOR4, function()
    preloadedLink = RevMob.createAdLink(revmobListener, PLACEMENT_IDS)
  end },

  {'Open Loaded Link', COLOR4, function()
    if preloadedLink then preloadedLink:open() end
  end },

  {'Show Pop-up', COLOR5, function()
    local PLACEMENT_IDS = { [REVMOB_ID_IOS] = '5107dfdc2513d00d0000007a', [REVMOB_ID_ANDROID] = '5107dfdf9c1d2f0e000000af' }
    if AMAZON_APK then REVMOB_IDS[REVMOB_ID_ANDROID] = '5107df30492ceb1600000025' end
    RevMob.showPopup(revmobListener, PLACEMENT_IDS)
  end },

  {'Pre-load Pop-up', COLOR5, function()
    preloadedPopup = RevMob.createPopup(revmobListener, PLACEMENT_IDS)
  end },

  {'Show Loaded Pop-up', COLOR5, function()
    if preloadedPopup then preloadedPopup:show() end
  end },

  {'Print Env Info', COLOR6, function()
    RevMob.printEnvironmentInformation(REVMOB_IDS)
  end },

  {'Change timeout: 1s', COLOR6, function()
    RevMob.setTimeoutInSeconds(1)
  end },

  {'Change timeout: 5s', COLOR6, function()
    RevMob.setTimeoutInSeconds(5)
  end },

  {'Change log level', COLOR6, function()
    logLevel = (logLevel + 1) % 3
    msg('Log level: ' .. tostring(logLevel))
    RevMob.setLogLevel(logLevel)
  end },

  {'Close Sample App', COLOR6, function()
    os.exit()
  end }
}

local createMenu = function()
  local left = function(i)
    if (i % 3 == 0) then
      left = 210
    elseif (i % 3 == 2) then
      left = 110
    elseif (i % 3 == 1) then
      left = 10
    end
    return left
  end
  local top = function(i)
    local space = 50
    if (i % 3 == 0) then
      top = (i) / 3 * space
    elseif (i % 3 == 2) then
      top = (i + 1) / 3 * space
    elseif (i % 3 == 1) then
      top = (i + 2) / 3 * space
    end
    return top
  end
  local textSize = function(i)
    if (string.len(i) <= 16) then
      textSize = 10
    elseif (string.len(i) <= 20) then
      textSize = 8
    elseif (string.len(i) <= 25) then
      textSize = 7
    end
    return textSize
  end

  for i, v in ipairs(labels) do
    local button = widget.newButton({
      label = v[1],
      labelColor = { default = {255, 255, 255}},
      left = left(i),
      top = top(i),
      labelYOffset = 0,
      fontSize = textSize(v[1]),
      width = 100,
      onRelease = function(event) return true end
    })
    button:setFillColor(v[2][1], v[2][2], v[2][3])
    button.tap = function(event)
      msg(v[1])
      v[3]()
      return true
    end
    button.touch = function(event) return true end
    button:addEventListener("tap", button)
    button:addEventListener("touch", button)
  end
end

local onSystem = function( event )
  if event.type == "applicationStart" then
    msg("Application Start")
  elseif event.type == "applicationExit" then
    msg("Application Exit")
  elseif event.type == "applicationSuspend" then
    msg("Application Suspend")
  elseif event.type == "applicationResume" then
    msg("Application Resume")
  end
end

createMenu()

Runtime:addEventListener( "system", onSystem )
