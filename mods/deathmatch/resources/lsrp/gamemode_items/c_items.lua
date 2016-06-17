-- załaduj gui
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        eq_wnd_main = guiCreateWindow(240, 207, 529, 380, "Ekwipunek", false)
        guiWindowSetSizable(eq_wnd_main, false)

        eq_btn_close = guiCreateButton(219, 325, 105, 33, "Zamknij", false, eq_wnd_main)
        eq_scrollpane_main = guiCreateScrollPane(24, 35, 481, 280, false, eq_wnd_main)

        eq_gridlist_main = guiCreateGridList(16, 16, 455, 254, false, eq_scrollpane_main)
        guiGridListAddColumn(eq_gridlist_main, "UID", 0.3)
        guiGridListAddColumn(eq_gridlist_main, "Nazwa", 0.3)
        guiGridListAddColumn(eq_gridlist_main, "Waga", 0.3)
        for i = 1, 100 do
            guiGridListAddRow(eq_gridlist_main)
        end
        guiGridListSetItemText(eq_gridlist_main, 0, 1, "#69", false, false)
        guiGridListSetItemText(eq_gridlist_main, 0, 2, "Pistolet", false, false)
        guiGridListSetItemText(eq_gridlist_main, 0, 3, "10.0", false, false)

        guiSetVisible(eq_wnd_main, false)   
        addEventHandler("onClientGUIClick", eq_btn_close, hidePlayerEquipment, false)
        addEventHandler("onClientGUIClick", eq_gridlist_main, itemClick, false)
    end
)

-- wykrywanie klikniętego grida itemów
function itemClick ( button, state, sx, sy, x, y, z, elem, gui )
        -- if state is down ( not to trigger the function twice on mouse button up/down), clicked gui and the element is our player list
        if source == eq_gridlist_main then
            local itemUID = guiGridListGetItemText ( eq_gridlist_main, guiGridListGetSelectedItem ( eq_gridlist_main ), 1 )
            itemUID = itemUID:gsub("%#", "")
            outputChatBox ("Kliknięty item to: " .. itemUID )     -- output it to chat box
        end

        if ( ( state == "down" ) and ( gui == true ) and ( source == eq_gridlist_main ) ) then
                -- get the player name from the selected row, first column 
                local playerName = guiGridListGetItemText ( eq_gridlist_main, guiGridListGetSelectedItem ( eq_gridlist_main ), 1 )
                outputChatBox ( playerName )     -- output it to chat box
        end
end

function showPlayerEquipment()
    -- gdzieś tutaj zapełnianie dodać z MySQLa
    for i = 1, 100 do
        guiGridListSetItemText(eq_gridlist_main, i, 1, "", false, false)
        guiGridListSetItemText(eq_gridlist_main, i, 2, "", false, false)
        guiGridListSetItemText(eq_gridlist_main, i, 3, "", false, false)
    end
    triggerServerEvent("getPlayerItems", getRootElement(), getElementData(getLocalPlayer(), "player.uid"))

    -- pokaż okno
    guiSetVisible(eq_wnd_main, true)
    showCursor(true)
    guiSetInputEnabled(true)
end
function hidePlayerEquipment()
    guiSetVisible(eq_wnd_main, false)
    showCursor(false)
    guiSetInputEnabled(false)
end
addCommandHandler ( "p", showPlayerEquipment )

-- dodawanie itemów do grida
function fillItemsGrid(items)
    local index = 0
    for i = 0, #items do
        guiGridListSetItemText(eq_gridlist_main, index, 1, "#"..items[i][0], false, false)
        guiGridListSetItemText(eq_gridlist_main, index, 2, items[i][1], false, false)
        guiGridListSetItemText(eq_gridlist_main, index, 3, items[i][2], false, false)
        --outputChatBox(items[i], 255, 255, 255, true);
        index = index + 1
    end
    -- outputChatBox(table.concat( items, ", ", 0, #items ), 255, 255, 255, true);
end
addEvent( "fillItemsGrid", true )
addEventHandler( "fillItemsGrid", localPlayer, fillItemsGrid )
