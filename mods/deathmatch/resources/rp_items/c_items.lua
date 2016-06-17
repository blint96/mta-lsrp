local storage = nil
local used = {}

--[[
    GUI przedmiotów
]]--
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        ----------------------------------------------------------------------------------
        -------------------------   Itemy w ekwipunku gracza    --------------------------
        ----------------------------------------------------------------------------------
        wnd_items = guiCreateWindow(0.29, 0.30, 0.43, 0.45, "Przedmioty przy sobie", true)
        guiWindowSetSizable(wnd_items, false)

        grid_items = guiCreateGridList(0.03, 0.08, 0.95, 0.78, true, wnd_items)
        guiGridListAddColumn(grid_items, "UID przedmiotu", 0.3)
        guiGridListAddColumn(grid_items, "Nazwa przedmiotu", 0.3)
        guiGridListAddColumn(grid_items, "Waga", 0.3)
        for i = 1, 2 do
            guiGridListAddRow(grid_items)
        end
        guiGridListSetItemText(grid_items, 0, 1, "-", false, false)
        guiGridListSetItemText(grid_items, 0, 2, "-", false, false)
        guiGridListSetItemText(grid_items, 0, 3, "-", false, false)
        guiGridListSetItemText(grid_items, 1, 1, "-", false, false)
        guiGridListSetItemText(grid_items, 1, 2, "-", false, false)
        guiGridListSetItemText(grid_items, 1, 3, "-", false, false)
        btn_items_close = guiCreateButton(0.71, 0.88, 0.26, 0.09, "Zamknij", true, wnd_items)
        addEventHandler("onClientGUIClick", btn_items_close, function()
            if guiGetVisible(wnd_item_use) == false then
                guiSetVisible(wnd_items, false) showCursor(false) guiSetInputEnabled(false) 
            else
                guiSetVisible(wnd_items, false)
            end
        end, false)
        addEventHandler("onClientGUIClick", grid_items, itemClick, false)
        guiSetProperty(btn_items_close, "NormalTextColour", "FFAAAAAA")
        guiGridListSetSortingEnabled(grid_items, false)
        guiSetVisible(wnd_items, false)    

        ----------------------------------------------------------------------------------
        ---------------------------   Itemy w pobliżu gracza    --------------------------
        ----------------------------------------------------------------------------------
        wnd_list_item = guiCreateWindow(0.38, 0.30, 0.25, 0.51, "Przedmioty w pobliżu", true)
        guiWindowSetSizable(wnd_list_item, false)

        btn_list_item_close = guiCreateButton(0.32, 0.84, 0.35, 0.10, "Zamknij", true, wnd_list_item)
        addEventHandler("onClientGUIClick", btn_list_item_close, function ()
            guiSetVisible(wnd_list_item, false) showCursor(false) guiSetInputEnabled(false)
        end, false)
        guiSetProperty(btn_list_item_close, "NormalTextColour", "FFAAAAAA")
        grid_list_near_item = guiCreateGridList(0.04, 0.07, 0.92, 0.74, true, wnd_list_item)
        addEventHandler("onClientGUIClick", grid_list_near_item, itemClick, false)
        guiGridListSetSortingEnabled(grid_list_near_item, false)
        guiGridListAddColumn(grid_list_near_item, "UID", 0.3)
        guiGridListAddColumn(grid_list_near_item, "Nazwa przedmiotu", 0.7)
        for i = 1, 3 do
            guiGridListAddRow(grid_list_near_item)
        end
        guiGridListSetItemText(grid_list_near_item, 0, 1, "-", false, false)
        guiGridListSetItemText(grid_list_near_item, 0, 2, "-", false, false)
        guiGridListSetItemText(grid_list_near_item, 1, 1, "-", false, false)
        guiGridListSetItemText(grid_list_near_item, 1, 2, "-", false, false)
        guiGridListSetItemText(grid_list_near_item, 2, 1, "-", false, false)
        guiGridListSetItemText(grid_list_near_item, 2, 2, "-", false, false) 
        guiSetVisible(wnd_list_item, false)


        -- Binda do "I" dodajemy
        bindKey("i", "up", function() triggerServerEvent( "showPlayerItemsForPlayer", getRootElement(), getLocalPlayer(), "" ) end)
    end
)
--[[
    Używanie konkretnego
]]--

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        wnd_item_use = guiCreateWindow(0.74, 0.30, 0.14, 0.45, "Przedmiot", true)
        guiWindowSetSizable(wnd_item_use, false)

        -- używanie itema
        btn_item_use_use = guiCreateButton(0.13, 0.10, 0.73, 0.09, "Użyj", true, wnd_item_use)  
        addEventHandler("onClientGUIClick", btn_item_use_use, function (  )
            triggerServerEvent("onItemUse", getRootElement(), getLocalPlayer(), used[1], used[4], used[6], used[7])
        end, false)

        -- odkładanie itema
        btn_item_use_put = guiCreateButton(0.13, 0.20, 0.73, 0.09, "Odłóż", true, wnd_item_use)
        addEventHandler("onClientGUIClick", btn_item_use_put, function ( ) 
            triggerServerEvent("onItemDrop", getRootElement(), getLocalPlayer(), used[1], used[4], used[6])
        end, false)

        btn_item_use_sell = guiCreateButton(0.13, 0.30, 0.73, 0.09, "Sprzedaj", true, wnd_item_use)
        btn_item_use_info = guiCreateButton(0.13, 0.40, 0.73, 0.09, "Informacje", true, wnd_item_use)
        btn_item_use_safe = guiCreateButton(0.13, 0.50, 0.73, 0.09, "Do schowka", true, wnd_item_use)
        btn_item_use_safe = guiCreateButton(0.13, 0.60, 0.73, 0.09, "Do innego przedmiotu", true, wnd_item_use)

        btn_item_use_close = guiCreateButton(0.13, 0.90, 0.73, 0.09, "Zamknij", true, wnd_item_use)
        addEventHandler("onClientGUIClick", btn_item_use_close, function ( )
            if guiGetVisible(wnd_items) == false then
                guiSetVisible(wnd_item_use, false)
                showCursor(false)
                guiSetInputEnabled(false)
            else
                guiSetVisible(wnd_item_use, false)
            end
        end, false)
        guiSetProperty(btn_item_use_close, "NormalTextColour", "FF106610")
        guiSetVisible(wnd_item_use, false)
    end
)

-- ID z tabeli storage
function getIDFromStorageByUID(uid)
    -- 0 czy 1?
    for i = 0, table.getn(storage) do
        if storage[i][1] == tonumber(uid) then
            return i
        end
    end
    return false
end

-- wykrywanie klikniętego grida itemów
function itemClick ( button, state, sx, sy, x, y, z, elem, gui )
    if (source == grid_list_near_item) and (button == "left") and (state == "up") then
        -- SQL
        local itemUID = guiGridListGetItemText ( grid_list_near_item, guiGridListGetSelectedItem ( grid_list_near_item ), 1 )
        triggerServerEvent( "onPlayerPickupItem", getRootElement(), getLocalPlayer(), itemUID )

        -- Pozamykać trzeba
        guiSetVisible(wnd_list_item, false)
        showCursor(false)
        guiSetInputEnabled(false)
    end

    if (source == grid_items) and (button == "left") and (state == "up") then
        local itemUID = guiGridListGetItemText ( grid_items, guiGridListGetSelectedItem ( grid_items ), 1 )
        itemUID = itemUID:gsub("%#", "")
        guiSetVisible(wnd_item_use, true)
        if getIDFromStorageByUID(itemUID) ~= false then
            local storage_id = getIDFromStorageByUID(itemUID)
            guiSetText(wnd_item_use, storage[storage_id][2])

            used[1] = storage[storage_id][1]
            used[2] = storage[storage_id][2]
            used[3] = storage[storage_id][3]
            used[4] = storage[storage_id][4]
            used[5] = storage[storage_id][5]
            used[6] = storage[storage_id][6]
            used[7] = storage[storage_id][7]

            if storage[storage_id][5] == 1 then
                guiSetText(btn_item_use_use, "Przestań używać")
            else
                guiSetText(btn_item_use_use, "Użyj")
            end
        end
    end
end

function changeUseStatus(status) 
    if status == true then
        guiSetText(btn_item_use_use, "Przestań używać")
    else
        guiSetText(btn_item_use_use, "Użyj")
    end
end
addEvent("changeUseStatus", true)
addEventHandler("changeUseStatus", getRootElement(), changeUseStatus)

function hideItemUseForm()
    if guiGetVisible(wnd_items) == false then
        guiSetVisible(wnd_item_use, false)
        showCursor(false)
        guiSetInputEnabled(false)
    else
        guiSetVisible(wnd_item_use, false)
    end
end
addEvent("hideItemUseForm", true)
addEventHandler("hideItemUseForm", getRootElement(), hideItemUseForm)

-- Wypełnianie tabelki itemkami
function fillItemsGrid(array)
    guiGridListClear(grid_items)
    storage = array -- test

    for i = 0, table.getn(array) do
        guiGridListAddRow(grid_items)
    end

    for i=0, table.getn(array) do
        guiGridListSetItemText(grid_items, i, 1, array[i][1], false, false) --uid
        if array[i][5] == 1 then
            guiGridListSetItemText(grid_items, i, 2, array[i][2].." (Używany)", false, false) --nazwa
        else
            guiGridListSetItemText(grid_items, i, 2, array[i][2], false, false) --nazwa
        end
        guiGridListSetItemText(grid_items, i, 3, array[i][3], false, false) --waga
    end

    guiSetVisible(wnd_items, true)
    showCursor(true)
    guiSetInputEnabled(true)
end
addEvent("fillItemsGrid", true)
addEventHandler("fillItemsGrid", localPlayer, fillItemsGrid)

-- wypełnianie tabelki pobliskimi itemami
function fillNearItemsGrid(array)
    guiGridListClear(grid_list_near_item)
    for i = 0, table.getn(array) do
        guiGridListAddRow(grid_list_near_item)
    end 

    for i = 0, table.getn(array) do 
        guiGridListSetItemText(grid_list_near_item, i, 1, array[i][1], false, false) --uid
        guiGridListSetItemText(grid_list_near_item, i, 2, array[i][2], false, false) --uid
    end

    guiSetVisible(wnd_list_item, true)
    showCursor(true)
    guiSetInputEnabled(true)
end
addEvent("fillNearItemsGrid", true)
addEventHandler("fillNearItemsGrid", localPlayer, fillNearItemsGrid)

--[[
----------------------------------------------
-- Update skillu strzelania
----------------------------------------------
]]--

function onClientWeaponFire(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
    if (tonumber ( getElementData(localPlayer, "player.shooting") ) < 100 ) then
        local current = tonumber(getElementData(localPlayer, "player.shooting"))
        local set = current + 0.0015;
        setElementData(localPlayer, "player.shooting", set)

        if (math.floor(set) > math.floor(current)) then
            outputChatBox("> Twój poziom strzelania wzrósł! ("..math.floor(set).."%)", 255, 215, 0)
            triggerServerEvent("OnPlayerSkillUp", getRootElement()) -- popraw skilla
        end
    end
end
addEventHandler ( "onClientPlayerWeaponFire", getLocalPlayer(), onClientWeaponFire )