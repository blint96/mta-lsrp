local screenWidth, screenHeight = guiGetScreenSize()
local baseX, baseY = 1366, 768
local browser = guiCreateBrowser((430 * baseX) / screenWidth, (200 * baseY) / screenHeight, (500 * baseX) / screenWidth, (600 * baseY) / screenHeight, true, true, false)

--[[local theBrowser = guiGetBrowser(browser)
addEventHandler("onClientBrowserCreated", theBrowser, 
	function()
		loadBrowserURL(source, "http://mta/local/html/login.html")
	end
)


-- Przykładowy event

addEvent("onClientLoginBrowserButtonClick", true)
addEventHandler("onClientLoginBrowserButtonClick", root, function(login, haslo) outputChatBox(login..", "..haslo) end)]]--