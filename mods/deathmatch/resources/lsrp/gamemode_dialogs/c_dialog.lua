--486 x 190
local sx,sy = guiGetScreenSize()
local base_x, base_y = 1366, 768
--[[
-----------------------------------------
--  Statsy gracza
-----------------------------------------
]]--
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        wnd_stats = guiCreateWindow(0.36, 0.28, 0.28, 0.39, "Informacje o graczu", true)
        guiWindowSetSizable(wnd_stats, false)

        grid_stats = guiCreateGridList(0.05, 0.08, 0.89, 0.65, true, wnd_stats)
        guiGridListAddColumn(grid_stats, "Typ", 0.5)
        guiGridListAddColumn(grid_stats, "Wartość", 0.5)
        for i = 1, 10 do
            guiGridListAddRow(grid_stats)
        end
        guiGridListSetItemText(grid_stats, 0, 1, "-", false, false)
        guiGridListSetItemText(grid_stats, 0, 2, "-", false, false)
        guiGridListSetItemText(grid_stats, 1, 1, "-", false, false)
        guiGridListSetItemText(grid_stats, 1, 2, "-", false, false)
        guiGridListSetItemText(grid_stats, 2, 1, "-", false, false)
        guiGridListSetItemText(grid_stats, 2, 2, "-", false, false)
        guiGridListSetItemText(grid_stats, 3, 1, "-", false, false)
        guiGridListSetItemText(grid_stats, 3, 2, "-", false, false)
        guiGridListSetItemText(grid_stats, 4, 1, "-", false, false)
        guiGridListSetItemText(grid_stats, 4, 2, "-", false, false)
        guiGridListSetItemText(grid_stats, 5, 1, "-", false, false)
        guiGridListSetItemText(grid_stats, 5, 2, "-", false, false)
        guiGridListSetItemText(grid_stats, 6, 1, "-", false, false)
        guiGridListSetItemText(grid_stats, 6, 2, "-", false, false)
        guiGridListSetItemText(grid_stats, 7, 1, "-", false, false)
        guiGridListSetItemText(grid_stats, 7, 2, "-", false, false)
        guiGridListSetItemText(grid_stats, 8, 1, "-", false, false)
        guiGridListSetItemText(grid_stats, 8, 2, "-", false, false)
        guiGridListSetItemText(grid_stats, 9, 1, "-", false, false)
        guiGridListSetItemText(grid_stats, 9, 2, "-", false, false)
        guiSetAlpha(grid_stats, 0.80)
        btn_stats_close = guiCreateButton(0.31, 0.78, 0.38, 0.16, "Zamknij", true, wnd_stats)    
        guiSetVisible(wnd_stats, false)

        -- sortowanie
        guiGridListSetSortingEnabled ( grid_stats, false )

        -- close btn
        addEventHandler("onClientGUIClick", btn_stats_close, function() guiSetVisible(wnd_stats, false) showCursor(false) guiSetInputEnabled(false) end, false)
    end
)

function showPlayerStats(thePlayer)
    -- Konto globalne
    guiGridListSetItemText(grid_stats, 0, 1, "Konto globalne", false, false)
    guiGridListSetItemText(grid_stats, 0, 2, getElementData(thePlayer, "player.gname"), false, false)
    -- Czas gry
    guiGridListSetItemText(grid_stats, 1, 1, "Czas gry", false, false)
    local minutes = tonumber(getElementData(thePlayer, "player.minutes"))
    if minutes < 10 then minutes = "0"..minutes  end
    guiGridListSetItemText(grid_stats, 1, 2, getElementData(thePlayer, "player.hours").."h "..minutes.."m", false, false)
    -- HP
    guiGridListSetItemText(grid_stats, 2, 1, "Zdrowie", false, false)
    guiGridListSetItemText(grid_stats, 2, 2, math.floor(tonumber(getElementHealth(thePlayer))), false, false)
    -- Gotówka
    guiGridListSetItemText(grid_stats, 3, 1, "Gotówka", false, false)
    guiGridListSetItemText(grid_stats, 3, 2, "$"..getElementData(thePlayer, "player.cash"), false, false)
    -- Stan konta bankowego
    guiGridListSetItemText(grid_stats, 4, 1, "Stan konta", false, false)
    guiGridListSetItemText(grid_stats, 4, 2, "$"..getElementData(thePlayer, "player.bankcash"), false, false)
    -- Numer konta
    guiGridListSetItemText(grid_stats, 5, 1, "Nr konta", false, false)
    guiGridListSetItemText(grid_stats, 5, 2, "000000000", false, false)
    -- Skin
    guiGridListSetItemText(grid_stats, 6, 1, "Skin", false, false)
    guiGridListSetItemText(grid_stats, 6, 2, getElementModel(thePlayer), false, false)
    -- Styl chodzenia
    guiGridListSetItemText(grid_stats, 7, 1, "Styl chodu", false, false)
    guiGridListSetItemText(grid_stats, 7, 2, "null", false, false)
    -- Skill strzelania
    guiGridListSetItemText(grid_stats, 8, 1, "Skill strzelania", false, false)
    guiGridListSetItemText(grid_stats, 8, 2, math.floor(tonumber(getElementData(thePlayer, "player.shooting"))).."%", false, false)
    --[[ -- Przebieg
    guiGridListSetItemText(grid_stats, 9, 1, "Przebieg", false, false)
    guiGridListSetItemText(grid_stats, 9, 2, round(getElementData(theVehicle, "vehicle.mileage")).." km", false, false)
    ]]--

    guiSetText(wnd_stats, playerRealName(thePlayer).." (UID: "..getElementData(thePlayer, "player.uid")..")")

    guiSetVisible(wnd_stats, true)
    guiSetInputEnabled(true)
    showCursor(true)
end
addEvent( "showPlayerStats", true )
addEventHandler( "showPlayerStats", getLocalPlayer(), showPlayerStats )

--[[
-----------------------------------------
--  Koniec statsów gracza
-----------------------------------------
]]--

--[[
    Info drzwi
]]--

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        wnd_door = guiCreateWindow(0.30, 0.75, 0.38, 0.18, "Informacja", true)
        guiWindowSetSizable(wnd_door, false)
        guiWindowSetMovable ( wnd_door, false )

        wnd_door_lab = guiCreateLabel(0.27, 0.21, 0.69, 0.68, "Test", true, wnd_door)
        guiLabelSetVerticalAlign(wnd_door_lab, "center")    
        guiLabelSetHorizontalAlign (wnd_door_lab, "left", true)

        wnd_door_image = guiCreateStaticImage ( 0.07, 0.37, 0.15, 0.40, "gamemode_dialogs/enter.png", true, wnd_door )
        guiSetVisible(wnd_door, false)
    end
)

function hideDoorInfo()
    guiSetVisible(wnd_door, false)
end

function showDoorInfo(message, interval, icon, door)
    local hide_in = tonumber(interval) * 1000
    guiSetText ( wnd_door_lab, message )
    guiSetVisible( wnd_door, true)
    guiStaticImageLoadImage(wnd_door_image, icon)
    setTimer ( hideDoorInfo, hide_in, 1 )

    guiSetText(wnd_door, getElementData(door, "door.name").." ("..getElementData(door, "id")..")")
end
addEvent( "showDoorInfo", true )
addEventHandler( "showDoorInfo", localPlayer, showDoorInfo )

--[[ 
        Popup!
 ]] --
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        popup_wnd = guiCreateWindow(0.30, 0.75, 0.38, 0.18, "Informacja", true)
        guiWindowSetSizable(popup_wnd, false)
        guiWindowSetMovable ( popup_wnd, false )

        popup_lab = guiCreateLabel(0.27, 0.21, 0.69, 0.68, "Test", true, popup_wnd)
        guiLabelSetVerticalAlign(popup_lab, "center")    
        guiLabelSetHorizontalAlign (popup_lab, "left", true)

        guiCreateStaticImage ( 0.07, 0.37, 0.20, 0.40, "gamemode_dialogs/info.png", true, popup_wnd )
        guiSetVisible(popup_wnd, false)
    end
)

function hidePopup()
    guiSetVisible(popup_wnd, false)
end

function showPopup(message, interval)
    local hide_in = tonumber(interval) * 1000
    guiSetText ( popup_lab, message )
    guiSetVisible( popup_wnd, true)
    setTimer ( hidePopup, hide_in, 1 )
end
addEvent( "showPopup", true )
addEventHandler( "showPopup", localPlayer, showPopup )

--[[
    Okienko /a /admins
]]--

function fillAdminsTable(admins)
    guiGridListClear(grid_admins)

    -- i zapełnienie
    for i=0, table.getn(admins) do
        guiGridListAddRow(grid_admins)
    end

    for i=0, table.getn(admins) do
        guiGridListSetItemText(grid_admins, i, 1, admins[i][1], false, false) --id
        guiGridListSetItemText(grid_admins, i, 2, admins[i][2], false, false) --ranga
        guiGridListSetItemText(grid_admins, i, 3, admins[i][3], false, false) --nick
    end

    guiSetVisible(wnd_admins, true)
    showCursor(true)
    guiSetInputEnabled(true)
end
addEvent("fillAdminsTable", true)
addEventHandler("fillAdminsTable", localPlayer, fillAdminsTable)

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        wnd_admins = guiCreateWindow(0.39, 0.29, 0.30, 0.40, "Administratorzy w grze", true)
        guiWindowSetMovable(wnd_admins, false)
        guiWindowSetSizable(wnd_admins, false)

        -- close btn
        btn_admins_close = guiCreateButton(0.31, 0.82, 0.38, 0.13, "Zamknij", true, wnd_admins)
        addEventHandler("onClientGUIClick", btn_admins_close, function() guiSetVisible(wnd_admins, false) showCursor(false) guiSetInputEnabled(false) end, false)

        grid_admins = guiCreateGridList(0.04, 0.09, 0.93, 0.70, true, wnd_admins)

        guiGridListAddColumn(grid_admins, "ID", 0.3)
        guiGridListAddColumn(grid_admins, "Ranga", 0.3)
        guiGridListAddColumn(grid_admins, "Admin", 0.3)
        guiSetVisible(wnd_admins, false) 
    end
)


--[[
    Okienko tutoriala
]]--
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        -- dodajemy binda na zamykanie tego
        bindKey ( "arrow_d", "down", closeTutorialByBind )

        wnd_tut = guiCreateWindow(0.30, 0.32, 0.42, 0.38, "Wprowadzenie", true)
        guiWindowSetMovable(wnd_tut, false)
        guiWindowSetSizable(wnd_tut, false)
        guiSetAlpha(wnd_tut, 0.70)

        lab_tut_main = guiCreateLabel(0.06, 0.30, 0.90, 0.55, "Witaj na Los Santos Role Play, jest to serwer przystosowany do rozgrywki w trybie RP. Po krótce wszystko co się tutaj dzieje odzwierciedla w niewielkim stopniu życie rzeczywiste a gracz pełni rolę aktora, który kreuje swoją postać!\n\nMusisz mieć na uwadze wszystko co robisz, ponieważ będzie to za sobą ponosiło mniejsze lub większe konsekwencje. Na przykład kradnąc narażasz postać na to, że zostanie aresztowana przez LSPD czyli tutejszą policję.", true, wnd_tut)
        guiSetFont(lab_tut_main, "clear-normal")
        guiLabelSetHorizontalAlign(lab_tut_main, "left", true)
        lab_tut_ext = guiCreateLabel(0.68, 0.91, 0.31, 0.05, "Kliknij strzałkę w dół, by zamknąć okno", true, wnd_tut)
        guiSetAlpha(lab_tut_ext, 0.49)
        guiSetFont(lab_tut_ext, "default-small")   

        -- logo
        img_tut_main = guiCreateStaticImage ( 0.0, 0.10, 0.15, 0.15, "gamemode_dialogs/f_icon.png", true, wnd_tut )
        lab_tut_logo = guiCreateLabel(0.15, 0.10, 0.50, 0.15, "LS-RP.net", true, wnd_tut)
        local font = guiCreateFont("gamemode_replacements/fonts/DustHome.ttf", 24)
        guiSetFont(lab_tut_logo, font)

        guiSetVisible(wnd_tut, false)
    end
)

function closeTutorialByBind()
    if getElementData(getLocalPlayer(), "player.tutorial") == true then
        hideTutorial()
    end
end

function hideTutorial()
    guiSetVisible(wnd_tut, false)
    setElementData(localPlayer, "player.tutorial", false)
end

function showTutorial(message)
    guiSetText ( lab_tut_main, message )
    guiSetVisible( wnd_tut, true)
    setElementData(localPlayer, "player.tutorial", true)
end
addEvent( "showTutorial", true )
addEventHandler( "showTutorial", localPlayer, showTutorial )

-- test
addCommandHandler("test3", function() showTutorial("Witaj na Los Santos Role Play, jest to serwer przystosowany do rozgrywki w trybie RP. Po krótce wszystko co się tutaj dzieje odzwierciedla w niewielkim stopniu życie rzeczywiste a gracz pełni rolę aktora, który kreuje swoją postać!\n\nMusisz mieć na uwadze wszystko co robisz, ponieważ będzie to za sobą ponosiło mniejsze lub większe konsekwencje. Na przykład kradnąc narażasz postać na to, że zostanie aresztowana przez LSPD czyli tutejszą policję.") end)