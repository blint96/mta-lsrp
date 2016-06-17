function getPlayerDoor()
    local world = getElementDimension(localPlayer)
    if world == 0 then 
        return false
    else
        local doors = getElementsByType("pickup")
        for _, door in ipairs(doors) do 
            if(tonumber(getElementData(door, "door.exitvw")) == world) then
                return door
            end
        end

        return false
    end
end

function playerEnterDoor()
	if getKeyState( "lalt" ) == true then 
		-- wchodzenie/wychodzenie z drzwi
		local world = getElementDimension(getLocalPlayer())
		local doors = getElementsByType("pickup")
		local x, y, z = getElementPosition(getLocalPlayer())

        -- buggerino
        if isPedInVehicle(localPlayer) then
            return
        end

		for i, door in ipairs(doors) do 
			-- wejście
			if tonumber(getElementData(door, "door.entervw")) == getElementDimension(getLocalPlayer()) then
				local distance = getDistanceBetweenPoints3D(x, y, z, tonumber(getElementData(door, "door.enterx")), tonumber(getElementData(door, "door.entery")), tonumber(getElementData(door,"door.enterz" )))
				if distance < 3 then
					triggerServerEvent("setPlayerToEnterDoors", getRootElement(), getLocalPlayer(), door)
					break
				end
			end

			-- wyjście
			if tonumber(getElementData(door, "door.exitvw")) == getElementDimension(getLocalPlayer()) then
				local distance = getDistanceBetweenPoints3D(x, y, z, tonumber(getElementData(door, "door.exitx")), tonumber(getElementData(door, "door.exity")), tonumber(getElementData(door, "door.exitz")))
				if distance < 3 then
					triggerServerEvent("setPlayerToExitDoors", getRootElement(), getLocalPlayer(), door)
					break
				end
			end
		end
	end
end 
addEventHandler("onClientResourceStart", resourceRoot, function() bindKey ( "space", "down", playerEnterDoor ) end)

--[[
	Info drzwi
]]--

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        ------------------------------------------------------
        -- GUI Sklepów
        ------------------------------------------------------
        wnd_shopping = guiCreateWindow(0.29, 0.25, 0.42, 0.51, "Asortyment w sklepie", true)
        guiWindowSetSizable(wnd_shopping, false)
        grid_shopping = guiCreateGridList(0.02, 0.07, 0.97, 0.73, true, wnd_shopping)
        guiGridListAddColumn(grid_shopping, "Nazwa produktu", 0.3)
        guiGridListAddColumn(grid_shopping, "Ilość", 0.3)
        guiGridListAddColumn(grid_shopping, "Cena", 0.3)
        guiGridListAddRow(grid_shopping)
        guiGridListSetItemText(grid_shopping, 0, 1, "Kremówka", false, false)
        guiGridListSetItemText(grid_shopping, 0, 2, "2137", false, false)
        guiGridListSetItemText(grid_shopping, 0, 3, "$23", false, false)
        btn_shopping_buy = guiCreateButton(0.16, 0.83, 0.26, 0.11, "Kup", true, wnd_shopping)
        guiSetProperty(btn_shopping_buy, "NormalTextColour", "FFAAAAAA")
        btn_shopping_close = guiCreateButton(0.60, 0.83, 0.26, 0.11, "Zamknij", true, wnd_shopping)
        guiSetProperty(btn_shopping_close, "NormalTextColour", "FFAAAAAA") 
        guiSetVisible(wnd_shopping, false)
        guiGridListSetSortingEnabled ( grid_shopping, false )
        addEventHandler("onClientGUIClick", btn_shopping_close, function() guiSetVisible(wnd_shopping, false) showCursor(false) guiSetInputEnabled(false) end, false)
        addEventHandler("onClientGUIClick", btn_shopping_buy, function() finishPlayerShopping() end, false)

        ------------------------------------------------------
        -- GUI Informacji o drzwiach
        ------------------------------------------------------
        wnd_door_info = guiCreateWindow(0.36, 0.28, 0.28, 0.39, "Informacje o drzwiach", true)
        guiWindowSetSizable(wnd_door_info, false)

        grid_door_inf = guiCreateGridList(0.05, 0.08, 0.89, 0.65, true, wnd_door_info)
        guiGridListAddColumn(grid_door_inf, "Typ", 0.5)
        guiGridListAddColumn(grid_door_inf, "Wartość", 0.5)
        for i = 1, 8 do
            guiGridListAddRow(grid_door_inf)
        end
        guiGridListSetItemText(grid_door_inf, 0, 1, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 0, 2, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 1, 1, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 1, 2, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 2, 1, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 2, 2, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 3, 1, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 3, 2, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 4, 1, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 4, 2, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 5, 1, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 5, 2, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 6, 1, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 6, 2, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 7, 1, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 7, 2, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 8, 1, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 8, 2, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 9, 1, "-", false, false)
        guiGridListSetItemText(grid_door_inf, 9, 2, "-", false, false)
        guiSetAlpha(grid_door_inf, 0.80)
        btn_door_inf_close = guiCreateButton(0.31, 0.78, 0.38, 0.16, "Zamknij", true, wnd_door_info)    
        guiSetVisible(wnd_door_info, false)
        guiGridListSetSortingEnabled ( grid_door_inf, false )
        addEventHandler("onClientGUIClick", btn_door_inf_close, function() guiSetVisible(wnd_door_info, false) showCursor(false) guiSetInputEnabled(false) end, false)
    end
)

function showDoorInfoView(theDoor)
    -- UID
    guiGridListSetItemText(grid_door_inf, 0, 1, "UID drzwi", false, false)
    guiGridListSetItemText(grid_door_inf, 0, 2, getElementData(theDoor, "door.uid"), false, false)
    -- ID
    guiGridListSetItemText(grid_door_inf, 1, 1, "ID drzwi", false, false)
    guiGridListSetItemText(grid_door_inf, 1, 2, getElementData(theDoor, "id"), false, false)
    -- Pickup
    guiGridListSetItemText(grid_door_inf, 2, 1, "ID Pickupa", false, false)
    guiGridListSetItemText(grid_door_inf, 2, 2, getElementModel(theDoor), false, false)
    -- Zamek
    guiGridListSetItemText(grid_door_inf, 3, 1, "Zamek", false, false)
    if tonumber(getElementData(theDoor, "door.lock")) == 1 then
    	guiGridListSetItemText(grid_door_inf, 3, 2, "zamknięty", false, false)
    else
    	guiGridListSetItemText(grid_door_inf, 3, 2, "otwarty", false, false)
    end
    -- Nazwa drzwi
    guiGridListSetItemText(grid_door_inf, 4, 1, "Nazwa drzwi", false, false)
    guiGridListSetItemText(grid_door_inf, 4, 2, getElementData(theDoor, "door.name"), false, false)
    -- Typ właściciela
    guiGridListSetItemText(grid_door_inf, 5, 1, "Typ właściciela", false, false)
    if tonumber(getElementData(theDoor, "door.ownertype")) == 1 then
        guiGridListSetItemText(grid_door_inf, 5, 2, "Gracz", false, false)
    elseif tonumber(getElementData(theDoor, "vehicle.ownertype")) == 0 then
        guiGridListSetItemText(grid_door_inf, 5, 2, "Brak", false, false)
    else
        guiGridListSetItemText(grid_door_inf, 5, 2, "Grupa", false, false)
    end
    -- UID właściciela
    guiGridListSetItemText(grid_door_inf, 6, 1, "UID właściciela", false, false)
    guiGridListSetItemText(grid_door_inf, 6, 2, getElementData(theDoor, "door.owner"), false, false)
    -- Nazwa grupy / Nick gracza
    --guiGridListSetItemText(grid_door_inf, 7, 1, "UID właściciela", false, false)
    --guiGridListSetItemText(grid_door_inf, 7, 2, getElementData(theDoor, "door.owner"), false, false)

    guiSetVisible(wnd_door_info, true)
    guiSetInputEnabled(true)
    showCursor(true)
end
addEvent( "showDoorInfoView", true )
addEventHandler( "showDoorInfoView", getLocalPlayer(), showDoorInfoView )