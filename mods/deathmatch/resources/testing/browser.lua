requestBrowserDomains({"google.com", "youtube.com", "twitch.tv", "pandora.com", "twitch.tv", "www.twitch.tv", "static-cdn.jtvnw.net", "www-cdn.jtvnw.net", "api.twitch.tv", "web-cdn.ttvnw.net", "media-cdn.twitch.tv", "player.twitch.tv"}) -- request browser domain

local sx, sy = guiGetScreenSize();
local webView = Browser(640, 480, true, true)

local lines = false
local music = false

local dot = dxCreateTexture(1,1)
local white = tocolor(255,255,255,255)


--[[ addEventHandler("onClientBrowserCreated", webView,
     function()
          	-- Load HTML UI
          	webView:loadURL("html/login.html")
 			addEventHandler("onClientRender", root, webBrowserRender)
 			focusBrowser (webView)
     end
)

function dxDrawRectangle3D(x,y,z,w,h,c,r,...)
        local lx, ly, lz = x+w, y+h, (z+tonumber(r or 0)) or z
	return dxDrawMaterialLine3D(x,y,z, lx, ly, lz, dot, h, c or white, ...)
end ]]--

-- PRZEGLĄDARA
local screenWidth, screenHeight = guiGetScreenSize()
local browser = createBrowser(640, 480, false, false)

function browserRender()
	--local x, y, z = 1569, -1310, 16
	--dxDrawMaterialLine3D(x, y, 26.25, x, y, 15.75, browser, 15.2, tocolor(255, 255, 255, 255), x, y+1, 19)

	if lines then 
		dxDrawLine(0, 0, sx, 0, tocolor(0, 200, 0), 2)
		dxDrawLine(0, sy, sx, sy, tocolor(0, 200, 0), 2)
		dxDrawLine(sx/2, 0, sx/2, sy, tocolor(0, 0, 0), 2)

		dxDrawLine(0, sy/2, sx, sy/2, tocolor(0, 0, 0), 2)

		dxDrawLine(0, 0, sx, sy, tocolor(0, 200, 200), 2)
		dxDrawLine(sx, 0, 0, sy, tocolor(0, 200, 200), 2)
	end

	local sx, sy, sz = 1552, -1325, 34
	dxDrawMaterialLine3D(sx, sy, sz, sx, sy, 12.75, browser, 33.2, tocolor(255, 255, 255, 255), sx, sy+1, 19)

	local px, py, pz = getElementPosition(localPlayer)
	local distance = getDistanceBetweenPoints3D(sx, sy, sz, px, py, pz)

	if distance > 100.0 then 
		setBrowserRenderingPaused(browser, true)
		setBrowserVolume(browser, 0.0)
	else
		local volume = ((100 - distance) / 100) - 0.5
		if volume < 0 then
			volume = 0.01
		end

		setBrowserVolume(browser, volume)
		setBrowserRenderingPaused(browser, false)
	end
end

addEventHandler("onClientBrowserCreated", browser, 
	function()
		--loadBrowserURL(browser, "http://www.youtube.com/embed/XnvTFrZ6xsg?rel=0&autoplay=1")
		--loadBrowserURL(browser, "http://www.youtube.com/embed/XnvTFrZ6xsg?rel=0&autoplay=1")
		-- Http://www.twitch.tv/m0e_tv
		loadBrowserURL(browser, "http://player.twitch.tv/?channel=taketv")
		--loadBrowserURL(browser, "http://www.youtube.com/embed/iTa7QH8eJB4?rel=0&autoplay=1")
		addEventHandler("onClientRender", root, browserRender)
	end
)