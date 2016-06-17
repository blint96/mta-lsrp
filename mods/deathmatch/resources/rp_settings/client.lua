local screenX, screenY = guiGetScreenSize()
local baseX, baseY = 1366, 768
local is_apply = false
local stage = 0

function hasbit(x, p)
  return x % (p + p) >= p       
end

-- Stwórz GUI
-- Potem ustawić trzeba widoczność tych buttonów, żeby się nie nakładały z innymi GUI w grze
-- UWAGA!
-- Jak pododaje guziki do shaderów to trzeba je umieścic w changeSettingsPage, pzdr
addEventHandler("onClientResourceStart", root, 
	function()
		btn_settings_option_first = guiCreateButton ( (350 / baseX) * screenX, (150 / baseY) * screenY, (340 / baseX) * screenX, 100, "Klik!", false )
		addEventHandler("onClientGUIClick", btn_settings_option_first, function() changeSettingsPage(1) end, false)
		guiSetAlpha ( btn_settings_option_first, 0.0 )
		guiSetVisible( btn_settings_option_first, false )

		btn_settings_option_second = guiCreateButton ( (350 / baseX) * screenX, (280 / baseY) * screenY, (340 / baseX) * screenX, 100, "Klik!", false )
		addEventHandler("onClientGUIClick", btn_settings_option_second, function() changeSettingsPage(2) end, false)
		guiSetAlpha ( btn_settings_option_second, 0.0 )
		guiSetVisible( btn_settings_option_second, false )
		
		btn_settings_option_third = guiCreateButton ( (350 / baseX) * screenX, (410 / baseY) * screenY, (340 / baseX) * screenX, 100, "Klik!", false )
		addEventHandler("onClientGUIClick", btn_settings_option_third, function() setSettingsWindow( not is_apply ) end, false)
		guiSetAlpha ( btn_settings_option_third, 0.0 )
		guiSetVisible( btn_settings_option_third, false )

		-- Guziczki od shaderów
		btn_shader_water = guiCreateStaticImage ( (340 / baseX) * screenX, (150 / baseY) * screenY, (128 / baseY) * screenY, (128 / baseY) * screenY, "icons/waterico.png", false, nil )
		guiSetProperty( btn_shader_water, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
		guiSetVisible( btn_shader_water, false )

		btn_shader_visible = guiCreateStaticImage ( (500 / baseX) * screenX, (150 / baseY) * screenY, (128 / baseY) * screenY, (128 / baseY) * screenY, "icons/blurico.png", false, nil )
		guiSetProperty( btn_shader_visible, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
		guiSetVisible( btn_shader_visible, false )

		btn_shader_roadshine = guiCreateStaticImage ( (660 / baseX) * screenX, (150 / baseY) * screenY, (128 / baseY) * screenY, (128 / baseY) * screenY, "icons/roadico.png", false, nil )
		guiSetProperty( btn_shader_roadshine, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
		guiSetVisible( btn_shader_roadshine, false )

		btn_shader_carpaint = guiCreateStaticImage ( (820 / baseX) * screenX, (150 / baseY) * screenY, (128 / baseY) * screenY, (128 / baseY) * screenY, "icons/carico.png", false, nil )
		guiSetProperty( btn_shader_carpaint, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
		guiSetVisible( btn_shader_carpaint, false )

		btn_shader_contrast = guiCreateStaticImage ( (980 / baseX) * screenX, (150 / baseY) * screenY, (128 / baseY) * screenY, (128 / baseY) * screenY, "icons/contrastico.png", false, nil )
		guiSetProperty( btn_shader_contrast, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
		guiSetVisible( btn_shader_contrast, false )

		addEventHandler("onClientGUIClick", btn_shader_water, function() setTimer(changeShaderButtonColour, 250, 1) triggerServerEvent("onPlayerChangeShaderStatus", getRootElement(), getLocalPlayer(), 2)  end, false)
		addEventHandler("onClientGUIClick", btn_shader_visible, function() setTimer(changeShaderButtonColour, 250, 1) triggerServerEvent("onPlayerChangeShaderStatus", getRootElement(), getLocalPlayer(), 4)  end, false)
		addEventHandler("onClientGUIClick", btn_shader_roadshine, function() setTimer(changeShaderButtonColour, 250, 1) triggerServerEvent("onPlayerChangeShaderStatus", getRootElement(), getLocalPlayer(), 8)  end, false)
		addEventHandler("onClientGUIClick", btn_shader_carpaint, function() setTimer(changeShaderButtonColour, 250, 1) triggerServerEvent("onPlayerChangeShaderStatus", getRootElement(), getLocalPlayer(), 16)  end, false)
		addEventHandler("onClientGUIClick", btn_shader_contrast, function() setTimer(changeShaderButtonColour, 250, 1) triggerServerEvent("onPlayerChangeShaderStatus", getRootElement(), getLocalPlayer(), 32)  end, false)

		-- Guziczki od ustawień ogólnych
		btn_setting_nick = guiCreateStaticImage ( (340 / baseX) * screenX, (150 / baseY) * screenY, (128 / baseY) * screenY, (128 / baseY) * screenY, "icons/mynick.png", false, nil )
		guiSetProperty( btn_setting_nick, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
		guiSetVisible( btn_setting_nick, false )

		btn_setting_desc = guiCreateStaticImage ( (500 / baseX) * screenX, (150 / baseY) * screenY, (128 / baseY) * screenY, (128 / baseY) * screenY, "icons/mydesc.png", false, nil )
		guiSetProperty( btn_setting_desc, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
		guiSetVisible( btn_setting_desc, false )

		addEventHandler("onClientGUIClick", btn_setting_nick, function() setTimer(changeGeneralButtonColour, 250, 1) triggerServerEvent("onPlayerChangeOwnNickVisibility", getRootElement(), getLocalPlayer()) end, false)

		-- Binda dodać trzeba
		bindKey ( "F1", "up", bindSettings )
	end
)

function changeGeneralButtonColour()
	-- własny nick
	local showtags = tonumber(getElementData(localPlayer, "player.showtags"))
	if showtags > 0 then 
		guiSetProperty( btn_setting_nick, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
	else
		guiSetProperty( btn_setting_nick, "ImageColours", "tl:99CC0000 tr:99CC0000 bl:FFFFFFFF br:FFFFFFFF")
	end
end

function changeShaderButtonColour()
	local shaders = tonumber(getElementData(localPlayer, "player.shaders"))
	-- pokaż ikonkę od shadera wody
	if (hasbit(shaders, 2)) then
		guiSetProperty( btn_shader_water, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
	else
		guiSetProperty( btn_shader_water, "ImageColours", "tl:99CC0000 tr:99CC0000 bl:FFFFFFFF br:FFFFFFFF")
	end

	-- ikonka visible
	if (hasbit(shaders, 4)) then
		guiSetProperty( btn_shader_visible, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
	else
		guiSetProperty( btn_shader_visible, "ImageColours", "tl:99CC0000 tr:99CC0000 bl:FFFFFFFF br:FFFFFFFF")
	end

	-- ikonka roadshine
	if (hasbit(shaders, 8)) then
		guiSetProperty( btn_shader_roadshine, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
	else
		guiSetProperty( btn_shader_roadshine, "ImageColours", "tl:99CC0000 tr:99CC0000 bl:FFFFFFFF br:FFFFFFFF")
	end

	-- ikonka carpaint
	if (hasbit(shaders, 16)) then
		guiSetProperty( btn_shader_carpaint, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
	else
		guiSetProperty( btn_shader_carpaint, "ImageColours", "tl:99CC0000 tr:99CC0000 bl:FFFFFFFF br:FFFFFFFF")
	end

	-- ikonka contrast
	if (hasbit(shaders, 32)) then
		guiSetProperty( btn_shader_contrast, "ImageColours", "tl:9900CC00 tr:9900CC00 bl:FFFFFFFF br:FFFFFFFF")
	else
		guiSetProperty( btn_shader_contrast, "ImageColours", "tl:99CC0000 tr:99CC0000 bl:FFFFFFFF br:FFFFFFFF")
	end
end

-- Zmiana guziczków, etc
-- Zmiana koloru shaderów/sprawdzanie shaderów jak zmienia strone na shadery <-- ISTOTNE
function changeSettingsPage(page)
	stage = page
	guiSetVisible( btn_settings_option_first, false )
	guiSetVisible( btn_settings_option_second, false )
	guiSetVisible( btn_settings_option_third, false )
	guiSetVisible( btn_shader_water, false )
	guiSetVisible( btn_shader_visible, false )
	guiSetVisible( btn_shader_roadshine, false )
	guiSetVisible( btn_shader_carpaint, false )
	guiSetVisible( btn_shader_contrast, false )
	guiSetVisible( btn_setting_nick, false )
	guiSetVisible( btn_setting_desc, false )

	if page == 1 then 
		changeShaderButtonColour()
		guiSetVisible( btn_settings_option_third, true )
		guiSetVisible( btn_shader_water, true )
		guiSetVisible( btn_shader_visible, true )
		guiSetVisible( btn_shader_roadshine, true )
		guiSetVisible( btn_shader_carpaint, true )
		guiSetVisible( btn_shader_contrast, true )
	end

	if page == 2 then 
		guiSetVisible( btn_settings_option_third, true )
		guiSetVisible( btn_setting_nick, true )
		guiSetVisible( btn_setting_desc, true )
	end 
end

local font = dxCreateFont("calibri.ttf", 24)
local font_min = dxCreateFont("calibri.ttf", 20)

function showSettings()
	exports.score_wisb:dxDrawBlurredRectangle(0, 0, screenX, screenY)
	dxDrawRectangle ( 0, 0, screenX, screenY, 0x66003366 )

	--local font = dxCreateFont("calibri.ttf", 24)
	--local font_min = dxCreateFont("calibri.ttf", 20)

	-- Menu główne
	if stage == 0 then 
		-- Main text`
		dxDrawText("Menu gry", (340 / baseX) * screenX, (100 / baseY) * screenY, (340 / baseX) * screenX, 100, tocolor(200, 200, 200), 1, font)
	
		-- Ustawienia grafiki
		dxDrawRectangle ( (340 / baseX) * screenX, (150 / baseY) * screenY, (400 / baseX) * screenX, (100 / baseY) * screenY, 0x99003366 )
		dxDrawText("Ustawienia grafiki", (350 / baseX) * screenX, (180 / baseY) * screenY, (340 / baseX) * screenX, 100, tocolor(200, 200, 200), 1, font_min)
	
		-- Ustawienia ogólne
		dxDrawRectangle ( (340 / baseX) * screenX, (280 / baseY) * screenY, (400 / baseX) * screenX, (100 / baseY) * screenY, 0x99003366 )
		dxDrawText("Ustawienia ogólne", (350 / baseX) * screenX, (310 / baseY) * screenY, (340 / baseX) * screenX, 100, tocolor(200, 200, 200), 1, font_min)
	
		-- Wyjście
		dxDrawRectangle ( (340 / baseX) * screenX, (410 / baseY) * screenY, (400 / baseX) * screenX, (100 / baseY) * screenY, 0x99003366 )
		dxDrawText("Wyjście", (350 / baseX) * screenX, (440 / baseY) * screenY, (340 / baseX) * screenX, 100, tocolor(200, 200, 200), 1, font_min)
	end

	-- Grafika/shadery
	if stage == 1 then
		-- Main text`
		dxDrawText("Ustawienia grafiki", (340 / baseX) * screenX, (100 / baseY) * screenY, (340 / baseX) * screenX, 100, tocolor(200, 200, 200), 1, font)

		-- Wyjście
		dxDrawRectangle ( (340 / baseX) * screenX, (410 / baseY) * screenY, (400 / baseX) * screenX, (100 / baseY) * screenY, 0x99003366 )
		dxDrawText("Wyjście", (350 / baseX) * screenX, (440 / baseY) * screenY, (340 / baseX) * screenX, 100, tocolor(200, 200, 200), 1, font_min)
	end

	-- Ogólne
	if stage == 2 then 
		-- Main text`
		dxDrawText("Ustawienia ogólne", (340 / baseX) * screenX, (100 / baseY) * screenY, (340 / baseX) * screenX, 100, tocolor(200, 200, 200), 1, font)

		-- Wyjście
		dxDrawRectangle ( (340 / baseX) * screenX, (410 / baseY) * screenY, (400 / baseX) * screenX, (100 / baseY) * screenY, 0x99003366 )
		dxDrawText("Wyjście", (350 / baseX) * screenX, (440 / baseY) * screenY, (340 / baseX) * screenX, 100, tocolor(200, 200, 200), 1, font_min)
	end
end

function bindSettings(key, keyState)
	setSettingsWindow(not is_apply)
end

function setSettingsWindow(toggle)
	toggleSettingsWindow(toggle)
	guiSetVisible(btn_settings_option_first, toggle)
	guiSetVisible(btn_settings_option_second, toggle)
	guiSetVisible(btn_settings_option_third, toggle)
	showCursor(toggle)
	setPedFrozen(localPlayer, toggle)

	if not toggle then 
		guiSetVisible( btn_shader_water, false )
		guiSetVisible( btn_shader_visible, false )
		guiSetVisible( btn_shader_roadshine, false )
		guiSetVisible( btn_shader_carpaint, false )
		guiSetVisible( btn_shader_contrast, false )
		guiSetVisible( btn_setting_nick, false )
		guiSetVisible( btn_setting_desc, false )
	end
end

function toggleSettingsWindow(toggle)
	if (toggle) and (not is_apply) then 
		-- włącz
		is_apply = true
		stage = 0
		addEventHandler ( "onClientRender", root, showSettings )
		showChat(false)
	end

	if (not toggle) and (is_apply) then
		-- wyłącz
		is_apply = false
		removeEventHandler ( "onClientRender", root, showSettings )
		showChat(true)
	end 
end
addCommandHandler("settings", function() setSettingsWindow(not is_apply) end)

-- testowa komenda
addCommandHandler( "status",
	function( )
		local info = dxGetStatus( )
		for k, v in pairs( info ) do
			outputChatBox( k .. " : " .. tostring( v ) )
		end
	end
)