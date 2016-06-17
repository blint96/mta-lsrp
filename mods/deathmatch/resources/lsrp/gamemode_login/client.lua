function createLoginWindow()
    -- nowy
    wnd_login = guiCreateWindow(0.34, 0.53, 0.33, 0.22, "Panel logowania", true)
   	guiWindowSetSizable(wnd_login, false)
   	guiWindowSetMovable(wnd_login, false)

    btn_login = guiCreateButton(0.33, 0.69, 0.33, 0.23, "Zaloguj", true, wnd_login)
    tbox_login = guiCreateEdit(0.17, 0.45, 0.65, 0.19, "", true, wnd_login)
    guiEditSetMasked(tbox_login, true)
    lab_login = guiCreateLabel(0.17, 0.21, 0.65, 0.18, "Wpisz poniżej hasło do swojego konta - zazwyczaj jest ono takie\nsamo jak do forum LS-RP.", true, wnd_login)    
end

function clientSubmitLogin(button, state)
	if button == "left" and state == "up" then

		local password = guiGetText(tbox_login)
		setPedLookAt(getLocalPlayer(), 0.0, 0.0, 0.0, 1, 1)

		if string.len(password) > 1 then
			triggerServerEvent("submitServerLogin", getRootElement(), password)
		else
			outputChatBox("#990000Nie wpisałeś żadnego hasła!", 255, 255, 255, true);
			return
		end

		guiSetInputEnabled(false)
		guiSetVisible(wnd_login, false)
		showCursor(false)
	end
end

function setPlayerToLoginHandler()
	createLoginWindow()
	addEventHandler("onClientGUIClick", btn_login, clientSubmitLogin, false)

	if(wnd_login ~= nil) then
	   	guiSetVisible(wnd_login, true)
	end

	showCursor(true)
	guiSetInputEnabled(true)

	guiEditSetCaretIndex ( tbox_login, 0 )
	guiBringToFront(wnd_login)
end
addEvent( "setPlayerToLogin", true )
addEventHandler( "setPlayerToLogin", getLocalPlayer(), setPlayerToLoginHandler )

addEventHandler("onClientResourceStart", resourceRoot,
    function()
	    --[[createLoginWindow()
	    addEventHandler("onClientGUIClick", btn_login, clientSubmitLogin, false)

	    if(wnd_login ~= nil) then
	    	guiSetVisible(wnd_login, true)
	    end]]--

	    showCursor(true)
	    guiSetInputEnabled(true)

	    -- Poprawka z obiektami
	    engineSetAsynchronousLoading( true, true )

	    --[[guiEditSetCaretIndex ( tbox_login, 0 )
	    guiBringToFront(wnd_login)]]--
	end
)

--[[
	ZUPEŁNIE NOWE LOGOWANIE
]]--
local screenX, screenY = guiGetScreenSize()
local rX, rY = 1366, 768
local startCamX, startCamY, startCamZ = 1782, -1053, 146
local startCamLookAtX, startCamLookAtY, startCamLookAtZ = 1559, -1303, 16
local lsound = nil
local volume = 0.5
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), function()
    fadeCamera(true)
	setCameraTarget(localPlayer, localPlayer)

	lsound = playSound("http://pliki.ls-rp.net/mta/login.mp3")
	setSoundVolume(lsound, 0.5)

    setCameraMatrix ( startCamX, startCamY, startCamZ, startCamLookAtX, startCamLookAtY, startCamLookAtZ, 0, 90)
    showPlayerLoginForm( )
   	end
)

function loginForm()
	exports.score_wisb:dxDrawBlurredRectangle(0, 0, screenX, screenY)
	dxDrawImage ( (480 * screenX) / rX, (40 * screenY) / rY , (400 * screenX) / rX, (110 * screenY) / rY, "gamemode_dialogs/login-logo.png")
end

function closePlayerLoginForm(skip)
	removeEventHandler("onClientRender",getRootElement(), loginForm)
	local x, y, z = getElementPosition(localPlayer)
	if not skip then exports.rp_bus:smoothMoveCamera(startCamX, startCamY, startCamZ, startCamLookAtX, startCamLookAtY, startCamLookAtZ,x+2, y+4, z+5, x, y, z, 10000) end
	
	local time = 10100
	setTimer(function() volume = volume - 0.005 setSoundVolume(lsound, volume) end, 100, 100)
	setTimer(function() if not skip then setCameraTarget(localPlayer) end setCameraClip(true, true) showChat(true) destroyElement(lsound) end, time, 1)
end
addEvent("closePlayerLoginForm", true)
addEventHandler("closePlayerLoginForm", getRootElement(), closePlayerLoginForm)

function showPlayerLoginForm()
	addEventHandler("onClientRender",getRootElement(), loginForm)
	showChat(false)
	setCameraClip (false, false)
	setElementCollidableWith(getCamera (), localPlayer, false)
end