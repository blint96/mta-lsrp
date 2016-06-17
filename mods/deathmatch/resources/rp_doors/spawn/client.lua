addEventHandler("onClientResourceStart", resourceRoot,
    function()
        wnd_set_spawn = guiCreateWindow(0.30, 0.19, 0.39, 0.52, "Wybierz miejsce spawnu", true)
        guiWindowSetSizable(wnd_set_spawn, false)

        grid_set_spawn = guiCreateGridList(0.03, 0.08, 0.94, 0.77, true, wnd_set_spawn)
        guiGridListAddColumn(grid_set_spawn, "UID", 0.2)
        guiGridListAddColumn(grid_set_spawn, "Nazwa drzwi", 0.8)
        guiGridListAddRow(grid_set_spawn)
        guiGridListSetItemText(grid_set_spawn, 0, 1, "-", false, false)
        guiGridListSetItemText(grid_set_spawn, 0, 2, "-", false, false)
        btn_set_spawn = guiCreateButton(0.35, 0.87, 0.30, 0.10, "Zamknij", true, wnd_set_spawn)
        guiSetProperty(btn_set_spawn, "NormalTextColour", "FFAAAAAA")  
        guiGridListSetSortingEnabled ( grid_set_spawn, false )
        guiSetVisible(wnd_set_spawn, false)  
        addEventHandler("onClientGUIClick", btn_set_spawn, function() guiSetVisible(wnd_set_spawn, false) showCursor(false) guiSetInputEnabled(false) end, false)
        addEventHandler("onClientGUIClick", grid_set_spawn, selectPlayerSpawn, false)
    end
)

function selectPlayerSpawn(button, state, sx, sy, x, y, z, elem, gui)
    if (source == grid_set_spawn) and (button == "left") and (state == "up") then
        local selected = guiGridListGetItemText ( grid_set_spawn, guiGridListGetSelectedItem ( grid_set_spawn ), 1 )
        local uid = tonumber(selected)

        if not uid then 
            triggerServerEvent( "onPlayerUpdateSpawnServer", getRootElement(), getLocalPlayer(), 0 )
        else
            triggerServerEvent( "onPlayerUpdateSpawnServer", getRootElement(), getLocalPlayer(), uid )
        end
        guiSetVisible(wnd_set_spawn, false) showCursor(false) guiSetInputEnabled(false)
    end
end

function showPlayerSpawnGUI(spawn_areas)
    guiGridListClear(grid_set_spawn)
    for i = 0, table.getn(spawn_areas) + 1 do
        guiGridListAddRow(grid_set_spawn)
    end 

    -- Spawn w mieście
    guiGridListSetItemText(grid_set_spawn, 0, 1, "NL", false, false)
    guiGridListSetItemText(grid_set_spawn, 0, 2, "Spawn ogólny", false, false)

    -- Spawn w domach
    for i = 1, table.getn(spawn_areas) do 
        guiGridListSetItemText(grid_set_spawn, i, 1, spawn_areas[i][1], false, false) --uid
        guiGridListSetItemText(grid_set_spawn, i, 2, spawn_areas[i][2], false, false) --uid
    end

    guiSetVisible(wnd_set_spawn, true)
    showCursor(true)
    guiSetInputEnabled(true)
end
addEvent("onPlayerSelectSpawn", true)
addEventHandler("onPlayerSelectSpawn", getRootElement(), showPlayerSpawnGUI)
