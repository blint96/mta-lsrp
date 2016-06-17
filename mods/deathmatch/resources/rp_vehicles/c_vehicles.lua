


function isVehicleSpawned(uid)
    local spawned = false
    for k, v in pairs(getElementsByType("vehicle")) do
        if tonumber(getElementData(v, "vehicle.uid")) == tonumber(uid) then
            spawned = true
            break
        end
    end

    if spawned then
        return true
    else 
        return false 
    end
end

-- przyda sie
function getVehicleIDByUID(uid)
    for k, v in pairs(getElementsByType("vehicle")) do
        if tonumber(getElementData(v, "vehicle.uid")) == tonumber(uid) then
            return tonumber(getElementData(v, "id"))
        end
    end
    return false
end

-- dodawanie pojazdów do grida
function fillVehicles(vehicles)
    setElementData(getLocalPlayer(), "player.vehicles", vehicles)

    local index = 1
    for i = 0, #vehicles do
        guiSetVisible(veh_wnd_veh[index], true)
        guiSetText(veh_wnd_veh[index], vehicles[i][1])

        -- info o tym czy zespawnowany, czy też nie
        if(isVehicleSpawned(tonumber(vehicles[i][0]))) == false then
            -- jeśli nie jest zespawnowany to chowamy labelka
            guiSetVisible(veh_spawn_inf[index], false)
            guiSetVisible(veh_desc_btn_find[index], false)
        else
            -- no a jeśli jest to pokazujemy, plus trzeba dodać tekst ładny
            guiSetVisible(veh_desc_btn_find[index], true)
            guiSetVisible(veh_spawn_inf[index], true)
            guiSetText(veh_spawn_inf[index], "Pojazd zespawnowany (ID: ".. getVehicleIDByUID(tonumber(vehicles[i][0])) .. ")")
        end

        -- opis pojazdu
        if veh_desc[vehicles[i][2]] ~= nil then
            guiSetText(veh_desc_lab[index], veh_desc[vehicles[i][2]])
        else 
            guiSetText(veh_desc_lab[index], "Brak wgranego opisu.")
        end
        guiStaticImageLoadImage(veh_desc_img[index], "images/vehicles/".. vehicles[i][2] ..".png")
        index = index + 1
    end
end
addEvent( "fillVehicles", true )
addEventHandler( "fillVehicles", localPlayer, fillVehicles )

-- Namierzanie z GUI
function findMyVehicle()
    local current = getCurrentVehicleFromList(guiGetSelectedTab(veh_wnd_tab_veh)) -- 1 lub 2 lub 3 etc.
    local uid = tonumber(getElementData(getLocalPlayer(), "player.vehicles")[current-1][0])

    if isVehicleSpawned(uid) == false then
        triggerServerEvent("showVehiclePopup", getRootElement(), getLocalPlayer(), "Ten pojazd nie jest zespawnowany.", 6)
    else
        -- namierz
        triggerServerEvent("callFindMyVehicle", getRootElement(), getLocalPlayer(), uid)
    end
end

-- spawnowanie z GUI
function spawnVehicleFromList()
    local current = getCurrentVehicleFromList(guiGetSelectedTab(veh_wnd_tab_veh)) -- 1 lub 2 lub 3 etc.
    local uid = tonumber(getElementData(getLocalPlayer(), "player.vehicles")[current-1][0])

    if isVehicleSpawned(uid) == false then
        triggerServerEvent("showVehiclePopup", getRootElement(), getLocalPlayer(), "Pojazd został zespawnowany.", 6)
        triggerServerEvent("LoadVehicle", getRootElement(), uid)
        refreshVehicleWindow()
    else 
        triggerServerEvent("showVehiclePopup", getRootElement(), getLocalPlayer(), "Pojazd został odspawnowany.", 6)
        triggerServerEvent("UnspawnVehicle", getRootElement(), getVehicleIDByUID(uid))
        refreshVehicleWindow()
    end
end

function getCurrentVehicleFromList(tab)
    if tab == veh_wnd_veh[1] then return 1 end
    for i = 1, 5 do
        if tab == veh_wnd_veh[i] then return i end
    end
end

-- pokazywarka ładna
function showPlayerVehiclesClient()
    -- przygotuj widok
    for i=1, 5 do
        guiSetVisible(veh_wnd_veh[i], false)
    end

    triggerServerEvent ("ListPlayerVehicles", getRootElement(), getLocalPlayer(), tonumber(getElementData(getLocalPlayer(), "player.uid")) )
    guiSetVisible(veh_wnd, true)
    showCursor(true)
    guiSetInputEnabled(true)
end
addEvent( "showPlayerVehiclesClient", true )
addEventHandler( "showPlayerVehiclesClient", localPlayer, showPlayerVehiclesClient )

function hidePlayerVehiclesClient()
    guiSetVisible(veh_wnd, false)
    showCursor(false)
    guiSetInputEnabled(false)
end

-- refresh gui z pojazdami
function refreshVehicleWindow()
    hidePlayerVehiclesClient()
    showPlayerVehiclesClient()
end

-- tablice na ten interfejs
veh_wnd_veh = {}
veh_desc_lab = {}
veh_desc_btn = {}
veh_desc_img = {}
veh_spawn_inf = {}
veh_desc_btn_find = {}

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        veh_wnd = guiCreateWindow(0.32, 0.29, 0.37, 0.50, "Pojazdy", true)
        guiWindowSetSizable(veh_wnd, false)

        veh_wnd_tab_veh = guiCreateTabPanel(0.02, 0.07, 0.95, 0.77, true, veh_wnd)

		-- zakładka wozu pierwszego
        veh_wnd_veh[1] = guiCreateTab("Pojazd 1", veh_wnd_tab_veh)
        veh_desc_img[1] = guiCreateStaticImage( 0.05, 0.07, 0.40, 0.27, "images/vehicles/558.png", true, veh_wnd_veh[1] )
        veh_desc_lab[1] = guiCreateLabel(0.05, 0.37, 0.90, 0.27, "Jakiś tam opis wozu się tutaj zrobi.", true, veh_wnd_veh[1])
        veh_desc_btn[1] = guiCreateButton(0.05, 0.80, 0.30, 0.10, "Spawn/Unspawn", true, veh_wnd_veh[1])
        veh_spawn_inf[1] = guiCreateLabel(0.48, 0.15, 0.50, 0.10, "Pojazd zespawnowany (ID: 0)", true, veh_wnd_veh[1])
        veh_desc_btn_find[1] = guiCreateButton(0.65, 0.80, 0.30, 0.10, "Namierz", true, veh_wnd_veh[1])

        guiLabelSetHorizontalAlign (veh_desc_lab[1], "left", true)
        addEventHandler("onClientGUIClick", veh_desc_btn[1], spawnVehicleFromList, false)
        addEventHandler("onClientGUIClick", veh_desc_btn_find[1], findMyVehicle, false)

		-- zakładka wozu drugiego
        veh_wnd_veh[2] = guiCreateTab("Pojazd 2", veh_wnd_tab_veh)
        veh_desc_img[2] = guiCreateStaticImage( 0.05, 0.07, 0.40, 0.27, "images/vehicles/558.png", true, veh_wnd_veh[2] )
        veh_desc_lab[2] = guiCreateLabel(0.05, 0.37, 0.90, 0.27, "Jakiś tam opis wozu się tutaj zrobi.", true, veh_wnd_veh[2])
        veh_desc_btn[2] = guiCreateButton(0.05, 0.80, 0.30, 0.10, "Spawn/Unspawn", true, veh_wnd_veh[2])
        veh_spawn_inf[2] = guiCreateLabel(0.48, 0.15, 0.50, 0.10, "Pojazd zespawnowany (ID: 0)", true, veh_wnd_veh[2])
        veh_desc_btn_find[2] = guiCreateButton(0.65, 0.80, 0.30, 0.10, "Namierz", true, veh_wnd_veh[2])

        guiLabelSetHorizontalAlign (veh_desc_lab[2], "left", true)
        addEventHandler("onClientGUIClick", veh_desc_btn[2], spawnVehicleFromList, false)
        addEventHandler("onClientGUIClick", veh_desc_btn_find[2], findMyVehicle, false)

        -- zakładka wozu trzeciego
        veh_wnd_veh[3] = guiCreateTab("Pojazd 3", veh_wnd_tab_veh)
        veh_desc_img[3] = guiCreateStaticImage( 0.05, 0.07, 0.40, 0.27, "images/vehicles/558.png", true, veh_wnd_veh[3] )
        veh_desc_lab[3] = guiCreateLabel(0.05, 0.37, 0.90, 0.27, "Jakiś tam opis wozu się tutaj zrobi.", true, veh_wnd_veh[3])
        veh_desc_btn[3] = guiCreateButton(0.05, 0.80, 0.30, 0.10, "Spawn/Unspawn", true, veh_wnd_veh[3])
        veh_spawn_inf[3] = guiCreateLabel(0.48, 0.15, 0.50, 0.10, "Pojazd zespawnowany (ID: 0)", true, veh_wnd_veh[3])
        veh_desc_btn_find[3] = guiCreateButton(0.65, 0.80, 0.30, 0.10, "Namierz", true, veh_wnd_veh[3])

        guiLabelSetHorizontalAlign (veh_desc_lab[3], "left", true)
        addEventHandler("onClientGUIClick", veh_desc_btn[3], spawnVehicleFromList, false)
        addEventHandler("onClientGUIClick", veh_desc_btn_find[3], findMyVehicle, false)

        -- zakładka wozu czwartego
        veh_wnd_veh[4] = guiCreateTab("Pojazd 4", veh_wnd_tab_veh)
        veh_desc_img[4] = guiCreateStaticImage( 0.05, 0.07, 0.40, 0.27, "images/vehicles/558.png", true, veh_wnd_veh[4] )
        veh_desc_lab[4] = guiCreateLabel(0.05, 0.37, 0.90, 0.27, "Jakiś tam opis wozu się tutaj zrobi.", true, veh_wnd_veh[4])
        veh_desc_btn[4] = guiCreateButton(0.05, 0.80, 0.30, 0.10, "Spawn/Unspawn", true, veh_wnd_veh[4])
        veh_spawn_inf[4] = guiCreateLabel(0.48, 0.15, 0.50, 0.10, "Pojazd zespawnowany (ID: 0)", true, veh_wnd_veh[4])
        veh_desc_btn_find[4] = guiCreateButton(0.65, 0.80, 0.30, 0.10, "Namierz", true, veh_wnd_veh[4])

        guiLabelSetHorizontalAlign (veh_desc_lab[4], "left", true)
        addEventHandler("onClientGUIClick", veh_desc_btn[4], spawnVehicleFromList, false)
        addEventHandler("onClientGUIClick", veh_desc_btn_find[4], findMyVehicle, false)

        -- zakładka wozu piątego
        veh_wnd_veh[5] = guiCreateTab("Pojazd 5", veh_wnd_tab_veh)
        veh_desc_img[5] = guiCreateStaticImage( 0.05, 0.07, 0.40, 0.27, "images/vehicles/558.png", true, veh_wnd_veh[5] )
        veh_desc_lab[5] = guiCreateLabel(0.05, 0.37, 0.90, 0.27, "Jakiś tam opis wozu się tutaj zrobi.", true, veh_wnd_veh[5])
        veh_desc_btn[5] = guiCreateButton(0.05, 0.80, 0.30, 0.10, "Spawn/Unspawn", true, veh_wnd_veh[5])
        veh_spawn_inf[5] = guiCreateLabel(0.48, 0.15, 0.50, 0.10, "Pojazd zespawnowany (ID: 0)", true, veh_wnd_veh[5])
        veh_desc_btn_find[5] = guiCreateButton(0.65, 0.80, 0.30, 0.10, "Namierz", true, veh_wnd_veh[5])

        guiLabelSetHorizontalAlign (veh_desc_lab[5], "left", true)
        addEventHandler("onClientGUIClick", veh_desc_btn[5], spawnVehicleFromList, false)
        addEventHandler("onClientGUIClick", veh_desc_btn_find[5], findMyVehicle, false)

        veh_btn_close = guiCreateButton(0.29, 0.87, 0.44, 0.09, "Zamknij", true, veh_wnd)
        addEventHandler("onClientGUIClick", veh_btn_close, hidePlayerVehiclesClient, false)
        guiSetVisible(veh_wnd, false)
    end
)

--[[
    V-Info
]]--

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        wnd_veh_info = guiCreateWindow(0.36, 0.28, 0.28, 0.39, "Informacje o pojeździe", true)
        guiWindowSetSizable(wnd_veh_info, false)

        grid_veh_inf = guiCreateGridList(0.05, 0.08, 0.89, 0.65, true, wnd_veh_info)
        guiGridListAddColumn(grid_veh_inf, "Typ", 0.5)
        guiGridListAddColumn(grid_veh_inf, "Wartość", 0.5)
        for i = 1, 10 do
            guiGridListAddRow(grid_veh_inf)
        end
        guiGridListSetItemText(grid_veh_inf, 0, 1, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 0, 2, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 1, 1, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 1, 2, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 2, 1, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 2, 2, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 3, 1, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 3, 2, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 4, 1, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 4, 2, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 5, 1, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 5, 2, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 6, 1, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 6, 2, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 7, 1, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 7, 2, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 8, 1, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 8, 2, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 9, 1, "-", false, false)
        guiGridListSetItemText(grid_veh_inf, 9, 2, "-", false, false)
        guiSetAlpha(grid_veh_inf, 0.80)
        btn_veh_inf_close = guiCreateButton(0.31, 0.78, 0.38, 0.16, "Zamknij", true, wnd_veh_info)    
        guiSetVisible(wnd_veh_info, false)

        -- sortowanie
        guiGridListSetSortingEnabled ( grid_veh_inf, false )

        -- close btn
        addEventHandler("onClientGUIClick", btn_veh_inf_close, function() guiSetVisible(wnd_veh_info, false) showCursor(false) guiSetInputEnabled(false) end, false)
    end
)

function showVehicleInfoView(theVehicle, infoarray)
    -- UID
    guiGridListSetItemText(grid_veh_inf, 0, 1, "UID pojazdu", false, false)
    guiGridListSetItemText(grid_veh_inf, 0, 2, getElementData(theVehicle, "vehicle.uid"), false, false)
    -- ID
    guiGridListSetItemText(grid_veh_inf, 1, 1, "ID pojazdu", false, false)
    guiGridListSetItemText(grid_veh_inf, 1, 2, getElementData(theVehicle, "id"), false, false)
    -- HP
    guiGridListSetItemText(grid_veh_inf, 2, 1, "HP pojazdu", false, false)
    guiGridListSetItemText(grid_veh_inf, 2, 2, math.floor(tonumber(getElementHealth(theVehicle))), false, false)
    -- Model
    guiGridListSetItemText(grid_veh_inf, 3, 1, "Model pojazdu", false, false)
    guiGridListSetItemText(grid_veh_inf, 3, 2, getElementModel(theVehicle), false, false)
    -- Nazwa pojazdu
    guiGridListSetItemText(grid_veh_inf, 4, 1, "Nazwa pojazdu", false, false)
    guiGridListSetItemText(grid_veh_inf, 4, 2, infoarray[1], false, false)
    -- Typ właściciela
    guiGridListSetItemText(grid_veh_inf, 5, 1, "Typ właściciela", false, false)
    if tonumber(getElementData(theVehicle, "vehicle.ownertype")) == 1 then
        guiGridListSetItemText(grid_veh_inf, 5, 2, "Gracz", false, false)
    elseif tonumber(getElementData(theVehicle, "vehicle.ownertype")) == 0 then
        guiGridListSetItemText(grid_veh_inf, 5, 2, "Brak", false, false)
    else
        guiGridListSetItemText(grid_veh_inf, 5, 2, "Grupa", false, false)
    end
    -- UID właścicela
    guiGridListSetItemText(grid_veh_inf, 6, 1, "UID właścicela", false, false)
    guiGridListSetItemText(grid_veh_inf, 6, 2, getElementData(theVehicle, "vehicle.owner"), false, false)
    -- Paliwo
    guiGridListSetItemText(grid_veh_inf, 7, 1, "Paliwo", false, false)
    guiGridListSetItemText(grid_veh_inf, 7, 2, round(getElementData(theVehicle, "vehicle.fuel")).."/"..GetVehicleMaxFuel(getElementModel(theVehicle)), false, false)
    -- Kolor
    guiGridListSetItemText(grid_veh_inf, 8, 1, "Kolor", false, false)
    guiGridListSetItemText(grid_veh_inf, 8, 2, getElementData(theVehicle, "vehicle.col1").." / "..getElementData(theVehicle, "vehicle.col2"), false, false)
    -- Przebieg
    guiGridListSetItemText(grid_veh_inf, 9, 1, "Przebieg", false, false)
    guiGridListSetItemText(grid_veh_inf, 9, 2, round(getElementData(theVehicle, "vehicle.mileage")).." km", false, false)

    guiSetVisible(wnd_veh_info, true)
    guiSetInputEnabled(true)
    showCursor(true)
end
addEvent( "showVehicleInfoView", true )
addEventHandler( "showVehicleInfoView", getLocalPlayer(), showVehicleInfoView )