-- Zmienna globalna, przyda sie
local theClient = nil

-- Init okna z produktami
addEventHandler("onClientResourceStart", resourceRoot,
    function()
        wnd_products = guiCreateWindow(0.34, 0.28, 0.32, 0.56, "Wybierz produkt", true)
        guiWindowSetSizable(wnd_products, false)

        grid_product = guiCreateGridList(0.04, 0.07, 0.91, 0.80, true, wnd_products)
        guiGridListAddColumn(grid_product, "UID", 0.2)
        guiGridListAddColumn(grid_product, "Nazwa produktu", 0.6)
        guiGridListAddColumn(grid_product, "Ilość", 0.2)
        for i = 1, 2 do
            guiGridListAddRow(grid_product)
        end
        guiGridListSetItemText(grid_product, 0, 1, "-", false, false)
        guiGridListSetItemText(grid_product, 0, 2, "-", false, false)
        guiGridListSetItemText(grid_product, 1, 1, "-", false, false)
        guiGridListSetItemText(grid_product, 1, 2, "-", false, false)
        btn_product_close = guiCreateButton(0.04, 0.89, 0.91, 0.09, "Zamknij to okno", true, wnd_products)
        addEventHandler("onClientGUIClick", btn_product_close, function() guiSetVisible(wnd_products, false) showCursor(false) guiSetInputEnabled(false) end, false)
        addEventHandler("onClientGUIClick", grid_product, productClick, false)
        guiSetProperty(btn_product_close, "NormalTextColour", "FFAAAAAA")    
        guiSetVisible(wnd_products, false)
    end
)

function showPlayerProducts(client, products)
    -- zapełnij GUI
    theClient = client

    -- wyczyść, dodaj nowe pola
    guiGridListClear(grid_product)
    for i = 0, table.getn(products) do
        guiGridListAddRow(grid_product)
    end

    for i=0, table.getn(products) do
        guiGridListSetItemText(grid_product, i, 1, products[i]["uid"], false, false) --uid
        guiGridListSetItemText(grid_product, i, 2, products[i]["name"], false, false) --uid
        guiGridListSetItemText(grid_product, i, 3, "x"..products[i]["count"], false, false) --uid
    end

    -- pokaż GUI
    guiSetVisible(wnd_products, true) showCursor(true) guiSetInputEnabled(true)
end
addEvent("onClientStartSelectingProducts", true)
addEventHandler("onClientStartSelectingProducts", getRootElement(), showPlayerProducts)

-- Wykrywanie kliknięcia na produkt
function productClick ( button, state, sx, sy, x, y, z, elem, gui )
    if (source == grid_product) and (button == "left") and (state == "up") then
        -- SQL
        local productUID = guiGridListGetItemText ( grid_product, guiGridListGetSelectedItem ( grid_product ), 1 )
        triggerServerEvent( "onPlayerSelectProduct", getRootElement(), localPlayer, theClient, productUID )

        -- Pozamykać trzeba
        guiSetVisible(wnd_products, false)
        showCursor(false)
        guiSetInputEnabled(false)
    end
end