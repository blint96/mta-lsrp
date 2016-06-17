
-- Lista postaci
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        wnd_charlist = guiCreateWindow(0.34, 0.22, 0.31, 0.61, "", true)
        guiWindowSetSizable(wnd_charlist, false)

        grid_charlist = guiCreateGridList(0.03, 0.07, 0.93, 0.81, true, wnd_charlist)
        guiGridListAddColumn(grid_charlist, "#Nr", 0.2)
        guiGridListAddColumn(grid_charlist, "Postać", 0.8)
        for i = 1, 2 do
            guiGridListAddRow(grid_charlist)
        end
        guiGridListSetItemText(grid_charlist, 0, 1, "-", false, false)
        guiGridListSetItemText(grid_charlist, 0, 2, "-", false, false)
        guiGridListSetItemText(grid_charlist, 1, 1, "-", false, false)
        guiGridListSetItemText(grid_charlist, 1, 2, "-", false, false)
        btn_charlist = guiCreateButton(0.03, 0.91, 0.93, 0.07, "Wybierz postać", true, wnd_charlist)
        addEventHandler("onClientGUIClick", btn_charlist, playerSelectCharacter, false)
        guiSetProperty(btn_charlist, "NormalTextColour", "FFAAAAAA")    
        guiSetVisible(wnd_charlist, false)
    end
)

function playerSelectCharacter()
	local char_uid = guiGridListGetItemText ( grid_charlist, guiGridListGetSelectedItem ( grid_charlist ), 1 )
    triggerServerEvent( "onPlayerSelectCharacterByUid", getRootElement(), getLocalPlayer(), char_uid )

    showCursor(false)
    guiSetInputEnabled(false)
    guiSetVisible(wnd_charlist, false)
end

function showPlayerCharactersList(charlist)
	guiGridListClear(grid_charlist)
	for i = 0, table.getn(charlist) do
        guiGridListAddRow(grid_charlist)
    end

    for i=0, table.getn(charlist) do
        guiGridListSetItemText(grid_charlist, i, 1, charlist[i]["char_uid"], false, false) -- uid
        guiGridListSetItemText(grid_charlist, i, 2, charlist[i]["char_name"]:gsub("_", " "), false, false) -- name
    end

    guiSetVisible(wnd_charlist, true)
    cef_close()
end
addEvent("showPlayerCharactersList", true)
addEventHandler("showPlayerCharactersList", localPlayer, showPlayerCharactersList)



local screenWidth, screenHeight = guiGetScreenSize()
local baseX, baseY = 1366, 768
local browser = guiCreateBrowser((430 * screenWidth) / baseX, (200 * screenHeight) / baseY, (500 * screenWidth) / baseX, (600 * screenHeight) / baseY, true, true, false)

local theBrowser = guiGetBrowser(browser)
addEventHandler("onClientBrowserCreated", theBrowser, 
	function()
		loadBrowserURL(source, "http://mta/local/gamemode_login/cef_login/login.html")
	end
)

function cef_checkLogin(login, password)
	triggerServerEvent("cefCheckLogin", getRootElement(), localPlayer, login, password)
end

function cef_close()
	setTimer(function() destroyElement(browser) end, 50, 1)
end


-- Przykładowy event
-- niszczenie: setTimer(function() destroyElement(browser) end, 100, 1)

addEvent("onClientLoginBrowserButtonClick", true)
addEventHandler("onClientLoginBrowserButtonClick", root, function(login, haslo) cef_checkLogin(login, haslo) end)