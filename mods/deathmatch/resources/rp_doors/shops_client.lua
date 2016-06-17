-- HANDLER KUPOWANIA JAK SKIN = 0 TO NIE DAJ RADY

-- Troche zmiennych
local temp_arr = nil
local order_step = 0 -- na jednym GUI to rozwiążemy
local orderGroupArray = nil

local clothes = false
local dummy = nil
local selected = 1

-- Tablica na ubranka
local clothes = {}
clothes[1] = {2, 100, "Ubranie dziwaka"}
clothes[2] = {7, 200, "Dres"}
clothes[3] = {1, 300, "Przetarte ubrania"}
clothes[4] = {298, 35, "Warszawski cwaniaczek"}
clothes[5] = {9, 150, "Brązowy garnitur"}
clothes[6] = {10, 70, "Babciny 1"}
clothes[7] = {11, 160, "Kelnerka 1"}
clothes[8] = {12, 180, "Czarna sukienka"}
clothes[9] = {13, 85, "Fioletowa koszulka"}
clothes[10] = {14, 90, "Koszula w kwiaty"}
clothes[11] = {15, 75, "Koszula w kratkę"}
clothes[12] = {16, 120, "Kamizelka odblaskowa"}
clothes[13] = {17, 210, "Ciemny garnitur"}
clothes[14] = {18, 140, "Szorty"}
clothes[15] = {19, 50, "Czerwone dresy"}
clothes[16] = {20, 60, "Dresy ortalionowe"}
clothes[17] = {21, 70, "Koszula w paski"}
clothes[18] = {22, 65, "Pomarańczowe dresy"}
clothes[19] = {23, 90, "Beżowe spodenki"}
clothes[20] = {24, 110, "Kurtka LS"}
clothes[21] = {25, 125, "Bejsbolówka"}
clothes[22] = {26, 135, "Komplet podróżniczy"}
clothes[23] = {27, 50, "Komplet budowniczy"}
clothes[24] = {28, 60, "Czarna podkoszulka"}
clothes[25] = {29, 90, "Bluza z kapturem"}
clothes[26] = {30, 60, "Szara podkoszulka"}
clothes[27] = {31, 80, "Komplet Rodeo damski"}
clothes[28] = {32, 40, "Zniszczona koszula"}
clothes[29] = {33, 50, "Bagienny komplet"}
clothes[30] = {34, 80, "Komplet Rodeo męski"}
clothes[31] = {35, 150, "Różowa koszula"}
clothes[32] = {36, 140, "Niebieskie spodenki"}
clothes[33] = {37, 140, "Jasno-niebieska koszula"}
clothes[34] = {38, 70, "Beżowo-biała koszulka"}
clothes[35] = {39, 85, "Brązowy żakiet"}
clothes[36] = {40, 210, "Jasno-czerwona sukienka"}
clothes[37] = {41, 120, "Aqua komplet"}
clothes[38] = {43, 115, "Fioletowa koszula"}
clothes[39] = {44, 95, "Niebieska koszula w kratkę"}
clothes[40] = {45, 120, "Zielone bermudy"}
clothes[41] = {46, 140, "Biała koszula"}
clothes[42] = {47, 75, "Jasno-brązowa koszula"}
clothes[43] = {48, 65, "Koszulka w paski"}
clothes[44] = {49, 140, "Komplet mistrza sztuk walki"}
clothes[45] = {50, 80, "Szary kombinezon"}
clothes[46] = {51, 140, "Komplet sportowy żółty"}
clothes[47] = {52, 140, "Komplet sportowy pasiak"}
clothes[48] = {53, 70, "Koszula w kropki"}
clothes[49] = {54, 85, "Różowa spódnica"}
clothes[50] = {55, 180, "Sukienka w paski"}
clothes[51] = {56, 110, "Koszulka na ramiączkach"}
clothes[52] = {57, 250, "Ciemny garnitur"}
clothes[53] = {58, 50, "Przetarte jeansy"}
clothes[54] = {59, 130, "Elegancka koszula"}
clothes[55] = {60, 100, "Jasno-brązowa koszulka"}
clothes[56] = {61, 300, "Strój pilota"}
clothes[57] = {62, 90, "Pidżama"}
clothes[58] = {63, 100, "Bikini"}
clothes[59] = {64, 110, "Minispódniczka"}
clothes[60] = {66, 140, "Niebiesko-biała bejsbolówka"}
clothes[61] = {67, 80, "Szara bluza"}
clothes[62] = {68, 190, "Czarna sutanna"}
clothes[63] = {69, 95, "Komplet jeanoswy"}
clothes[64] = {70, 250, "Kitel lekarski"}
clothes[65] = {71, 250, "Mundur PD1"}
clothes[66] = {72, 100, "Jeansy dzwony"}
clothes[67] = {73, 100, "Spodnie moro"}
clothes[68] = {75, 70, "Strój jednoczęściowy"}
clothes[69] = {76, 210, "Niebieski żakiet"}
clothes[70] = {77, 15, "Podarta spódnica"}
clothes[71] = {78, 10, "Porwane ubrania"}
clothes[72] = {79, 8, "Podarta kamizelka"}
clothes[73] = {80, 150, "Czerwony strój bokserski"}
clothes[74] = {81, 150, "Niebieski strój bokserski"}
clothes[75] = {82, 250, "Gwiazda Rocka 1"}
clothes[76] = {83, 250, "Gwiazda Rocka 2"}
clothes[77] = {84, 250, "Gwiazda Rocka 3"}
clothes[78] = {85, 100, "Sztuczne futro"}
clothes[79] = {87, 140, "Bikini"}
clothes[80] = {88, 150, "Jasna spódnica"}
clothes[81] = {89, 90, "Niebieska suknia"}
clothes[82] = {90, 160, "Czarna minispódniczka"}
clothes[83] = {91, 230, "Biała sukienka"}
clothes[84] = {92, 160, "Bikini z chustą"}
clothes[85] = {93, 140, "Czarne jeansy"}
clothes[86] = {94, 160, "Kremowa koszula"}
clothes[87] = {95, 65, "Wyblakła koszula"}
clothes[88] = {96, 140, "Komplet sportowy czarny"}
clothes[89] = {97, 120, "Czerwone bermudy"}
clothes[90] = {98, 150, "Koszula z kołnierzykiem"}
clothes[91] = {99, 140, "Komplet sporowy z kaskiem"}
clothes[92] = {100, 135, "Kamizelka skórzana"}
clothes[93] = {101, 110, "Zielona koszula"}
clothes[94] = {102, 80, "Fioletowe szorty"}
clothes[95] = {103, 80, "Fioletowa chusta"}
clothes[96] = {104, 75, "Fioletowy TankTop"}
clothes[97] = {105, 68, "Zielona bluza"}
clothes[98] = {106, 65, "Zielona koszula w kratkę"}
clothes[99] = {107, 80, "Zielony podkoszulek"}
clothes[100] = {108, 60, "Czarne dresy"}
clothes[101] = {109, 60, "Biały podkoszulek"}
clothes[102] = {110, 70, "Spodenki jeansowe"}
clothes[103] = {111, 210, "Czarny garnitur ze swetrem"}
clothes[104] = {112, 110, "Brązowa kurtka"}
clothes[105] = {113, 290, "Szary garnitur"}
clothes[106] = {114, 60, "Koszulka z kołnierzykiem"}
clothes[107] = {115, 90, "Luźne dresy"}
clothes[108] = {116, 80, "Biały TankTop"}
clothes[109] = {117, 160, "Czarna koszula"}
clothes[110] = {118, 160, "Czarna koszula"}
clothes[111] = {120, 275, "Szarawy garnitur"}
clothes[112] = {121, 110, "Koszulka ARMY"}
clothes[113] = {122, 140, "Beżowe luźne spodnie"}
clothes[114] = {123, 120, "Koszula z kwiatami"}
clothes[115] = {124, 110, "Obcisła koszulka"}
clothes[116] = {125, 130, "Skórzana kurtka"}
clothes[117] = {126, 150, "Ciemno-niebieska koszula"}
clothes[118] = {127, 220, "Brązowe futro"}
clothes[119] = {128, 90, "Podwinięte jeansy"}
clothes[120] = {129, 75, "Długa spódnica"}
clothes[121] = {130, 80, "Spódnica XXL"}
clothes[122] = {131, 110, "Slim jeansy"}
clothes[123] = {132, 50, "Stara koszula"}
clothes[124] = {133, 50, "Ubrodzone jeansy"}
clothes[125] = {134, 20, "Zniszczone ubrania"}
clothes[126] = {135, 15, "Rozpięta brudna koszula"}
clothes[127] = {136, 18, "Fioletowe porawne spodnie"}
clothes[128] = {137, 25, "Porwane jeansy"}
clothes[129] = {138, 160, "Białe bikini"}
clothes[130] = {139, 160, "Żółte bikini"}
clothes[131] = {140, 160, "Czerwone bikini"}
clothes[132] = {141, 240, "Żakiet w paski"}
clothes[133] = {142, 110, "Pomarańczowo-niebieska koszulka"}
clothes[134] = {143, 140, "Jasno-niebieska koszula"}
clothes[135] = {144, 135, "Czarno-czerwona koszulka"}
clothes[136] = {145, 140, "Stringi"}
clothes[137] = {146, 150, "Czarne szorty"}
clothes[138] = {147, 220, "Jasno-ciemny garnitur"}
clothes[139] = {148, 240, "Grynszpanowy żakiet"}
clothes[140] = {150, 220, "Atramentowy żakiet"}
clothes[141] = {151, 95, "Jeansowa spódnica"}
clothes[142] = {152, 100, "Czerwona minispódniczka"}
clothes[143] = {153, 210, "Garnitur z kaskiem"}
clothes[144] = {154, 150, "Kobaltowe szorty"}
clothes[145] = {155, 170, "Żółto-czerwona koszulka"}
clothes[146] = {156, 160, "Błękitna koszula"}
clothes[147] = {157, 90, "Jeanoswe szelki"}
clothes[148] = {158, 95, "Jeansowe szelki"}
clothes[149] = {159, 70, "Szelki"}
clothes[150] = {160, 35, "Zniszczona koszula"}

-- Kupowane
local buy_name = nil
local buy_price = nil
local buy_count = nil
local buy_uid = nil


--
-- Część na ubrania
--

-- Init GUI
addEventHandler("onClientResourceStart", resourceRoot, function()
	local screenx, screeny = guiGetScreenSize()

	----------------------------------------------------------
	-- GUI
	-- SKLEPOWE
	----------------------------------------------------------
	cloth_arrow_left = guiCreateStaticImage(screenx * 0.285, screeny * 0.70, screeny * 0.15, screeny * 0.15, "icons/a_left.png", false)
	addEventHandler("onClientGUIClick", cloth_arrow_left, function() stepCloth("prev") end, false)
	cloth_arrow_right = guiCreateStaticImage ( screenx * 0.625, screeny * 0.70, screeny * 0.15, screeny * 0.15, "icons/a_right.png", false )
	addEventHandler("onClientGUIClick", cloth_arrow_right, function() stepCloth("next") end, false)
	cloth_btn_buy = guiCreateStaticImage ( screenx * 0.41, screeny * 0.72, screeny * 0.12, screeny * 0.12, "icons/cash.png", false )
	addEventHandler("onClientGUIClick", cloth_btn_buy, function() buyCloth() end, false)
	cloth_btn_cancel = guiCreateStaticImage ( screenx * 0.52, screeny* 0.72, screeny * 0.12, screeny * 0.12, "icons/cancel.png", false )
	addEventHandler("onClientGUIClick", cloth_btn_cancel, function() stopPlayerDummy() end, false)
	setShoppingGui(false)


	----------------------------------------------------------
	-- GUI
	-- ZAMAWIANIE
	----------------------------------------------------------
    wnd_order = guiCreateWindow(0.32, 0.24, 0.35, 0.52, "Zamów produkty", true)
    guiWindowSetSizable(wnd_order, false)
    grid_order = guiCreateGridList(0.03, 0.07, 0.94, 0.76, true, wnd_order)
    guiGridListSetSortingEnabled(grid_order, false)
    guiGridListAddColumn(grid_order, "Nr", 0.2)
    guiGridListAddColumn(grid_order, "Kategoria", 0.8)
    guiGridListAddRow(grid_order)
    guiGridListSetItemText(grid_order, 0, 1, "1", false, false)
    guiGridListSetItemText(grid_order, 0, 2, "Żarcie", false, false)
    btn_order_sel = guiCreateButton(0.09, 0.87, 0.33, 0.08, "Wybierz", true, wnd_order)
    addEventHandler("onClientGUIClick", btn_order_sel, function() finishStep() end, false)
    guiSetProperty(btn_order_sel, "NormalTextColour", "FFAAAAAA")
    btn_order_cancel = guiCreateButton(0.58, 0.87, 0.33, 0.08, "Anuluj", true, wnd_order)
    addEventHandler("onClientGUIClick", btn_order_cancel, function() guiSetVisible(wnd_order, false) showCursor(false) guiSetInputEnabled(false) end, false)
    guiSetProperty(btn_order_cancel, "NormalTextColour", "FFAAAAAA")   
    guiSetVisible(wnd_order, false) 


    ----------------------------------------------------------
	-- GUI
	-- ILOŚĆ
	----------------------------------------------------------
    wnd_order_count = guiCreateWindow(0.30, 0.38, 0.40, 0.23, "Finalizacja zamówienia", true)
    guiWindowSetSizable(wnd_order_count, false)
    btn_count_accept = guiCreateButton(0.13, 0.61, 0.29, 0.21, "Gotowe", true, wnd_order_count)
    addEventHandler("onClientGUIClick", btn_count_accept, function() checkoutPlayerOrder() end, false)
    guiSetProperty(btn_count_accept, "NormalTextColour", "FFAAAAAA")
    btn_count_cancel = guiCreateButton(0.57, 0.61, 0.30, 0.22, "Anuluj", true, wnd_order_count)
    addEventHandler("onClientGUIClick", btn_count_cancel, function() guiSetVisible(wnd_order_count, false) showCursor(false) guiSetInputEnabled(false) end, false)
    guiSetProperty(btn_count_cancel, "NormalTextColour", "FFAAAAAA")
    ipt_order_count = guiCreateEdit(0.13, 0.33, 0.74, 0.21, "999", true, wnd_order_count)
    guiEditSetMaxLength(ipt_order_count, 4)
    lab_order_count = guiCreateLabel(0.13, 0.18, 0.73, 0.09, "Ile sztuk produktu chcesz kupić?", true, wnd_order_count)    
    guiSetVisible(wnd_order_count, false)


    ----------------------------------------------------------
	-- GUI
	-- Koszt
	----------------------------------------------------------
    wnd_cost = guiCreateWindow(0.30, 0.38, 0.40, 0.23, "Finalizacja zamówienia", true)
    guiWindowSetSizable(wnd_cost, false)
    btn_cost_accept = guiCreateButton(0.13, 0.61, 0.29, 0.21, "Gotowe", true, wnd_cost)
    addEventHandler("onClientGUIClick", btn_cost_accept, function() setProductCost() end, false)
    guiSetProperty(btn_cost_accept, "NormalTextColour", "FFAAAAAA")
    btn_cost_cancel = guiCreateButton(0.57, 0.61, 0.30, 0.22, "Anuluj", true, wnd_cost)
    addEventHandler("onClientGUIClick", btn_cost_cancel, function() guiSetVisible(wnd_cost, false) showCursor(false) guiSetInputEnabled(false) end, false)
    guiSetProperty(btn_cost_cancel, "NormalTextColour", "FFAAAAAA")
    ipt_order_cost = guiCreateEdit(0.13, 0.33, 0.74, 0.21, "999", true, wnd_cost)
    guiEditSetMaxLength(ipt_order_cost, 4)
    lab_order_cost = guiCreateLabel(0.13, 0.18, 0.73, 0.09, "Ile ma kosztować każda sztuka tego produktu?", true, wnd_cost)    
    guiSetVisible(wnd_cost, false)

    ----------------------------------------------------------
	-- GUI
	-- Finalizacja, ile kosztuje i czy akcept?
	----------------------------------------------------------
	wnd_final = guiCreateWindow(0.30, 0.38, 0.40, 0.23, "Finalizacja zamówienia", true)
   	guiWindowSetSizable(wnd_final, false)
    btn_final_accept = guiCreateButton(0.13, 0.61, 0.29, 0.21, "Kup", true, wnd_final)
    addEventHandler("onClientGUIClick", btn_final_accept, function() finalPlayerOrder() end, false)
    guiSetProperty(btn_final_accept, "NormalTextColour", "FFAAAAAA")
    btn_final_cancel = guiCreateButton(0.57, 0.61, 0.30, 0.22, "Anuluj", true, wnd_final)
    addEventHandler("onClientGUIClick", btn_final_cancel, function() guiSetVisible(wnd_final, false) showCursor(false) guiSetInputEnabled(false) end, false)
    guiSetProperty(btn_final_cancel, "NormalTextColour", "FFAAAAAA")
    lab_final = guiCreateLabel(0.13, 0.18, 0.73, 0.09, "Czy jesteś pewien, że chcesz kupić DE x1000?", true, wnd_final)
    lab_final_price = guiCreateLabel(0.13, 0.33, 0.74, 0.12, "Całkowity koszt: $1500", true, wnd_final)
    guiSetVisible(wnd_final, false)   

end)

-- GUI func
function setShoppingGui(state)
	guiSetVisible(cloth_arrow_right, state)
	guiSetVisible(cloth_arrow_left, state)
	guiSetVisible(cloth_btn_cancel, state)
	guiSetVisible(cloth_btn_buy, state)
end

function buyCloth()
	local p_money = tonumber(getElementData(localPlayer, "player.cash"))
	local cost = tonumber(clothes[selected][2])
	if cost > p_money then 
		outputChatBox("Błąd: Nie masz wystarczająco pieniędzy.")
		return
	end

	stopPlayerDummy()
	setPlayerMoney(p_money - cost)
	setElementData(localPlayer, "player.cash", (p_money - cost))
	triggerServerEvent("onPlayerClothBuy", getRootElement(), getLocalPlayer(), tonumber(clothes[selected][1]), clothes[selected][3])
end

function stepCloth(nav)
	if nav == "prev" then 
		if (selected - 1) < 1 then
			selected = 1
		else
			selected = selected - 1
		end
	else
		if (selected + 1) > table.getn(clothes) then
			selected = 1
		else
			selected = selected + 1
		end
	end

	setElementModel(dummy, clothes[selected][1])
end

-- Spawnowanie manekina, freezowanie gracza i w ogóle początek kupowania ciuchów
function spawnPlayerDummy()
	local static_x, static_y, static_z = getElementPosition(localPlayer)
	local x, y, z = getElementPosition(localPlayer)
	local a, b, r = getElementRotation(localPlayer)

	x = x - math.sin ( math.rad(r) ) * 4
    y = y + math.cos ( math.rad(r) ) * 4

	if dummy == nil then
		dummy = createPed ( 0, x, y, z )

		-- Poprawka z kamerą
		local cam = getCamera()
		detachElements( cam )
		setElementPosition( cam, 0,0,0 )
		setCameraTarget(localPlayer)

		setElementInterior(dummy, getElementInterior(localPlayer))
		setElementDimension(dummy, getElementDimension(localPlayer))
		setElementRotation(dummy, 0, 0, r + 180)
		addEventHandler("onClientRender",getRootElement(), drawDummyText)
		setElementFrozen(localPlayer, true)
		setCameraMatrix ( static_x, static_y, static_z, x, y, z )
		selected = 1

		setShoppingGui(true)
		showCursor(true)
		guiSetInputEnabled(true)
	end
end

-- Koniec kupowania
function stopPlayerDummy()
	removeEventHandler("onClientRender", getRootElement(), drawDummyText)
	destroyElement(dummy)
	setElementFrozen(localPlayer, false)
	setCameraTarget ( localPlayer )
	dummy = nil

	setShoppingGui(false)
	showCursor(false)
	guiSetInputEnabled(false)
end

function drawDummyText()
	if dummy ~= nil then
		local px, py, pz = getElementPosition(localPlayer)
		local x, y, z = getPedBonePosition( dummy, 8 )
		local is_coll = processLineOfSight(px, py, pz, x, y, z, true, false, false, true, false, false)

		if is_coll == false then 
			local distance = getDistanceBetweenPoints3D ( px, py, pz, x, y, z )
			if distance < 15.0 then 
				local sX, sY = getScreenFromWorldPosition( x, y, z + 0.25 );

				if sX then
					dxDrawText("#006600$"..clothes[selected][2], sX, sY, sX, sY, tocolor(5,150,200,255), 2.0, "pricedown", "center", "bottom", false, false, false, true )
				end
			else
				stopPlayerDummy()
			end
		end
	end
end

-- Pokazywanie asortymentu
function showPlayerBuyMenu( theArray)
	if theArray then
		temp_arr = theArray
		guiGridListClear(grid_shopping)
		local item_num = table.getn(theArray)
		for i = 0, item_num do 
			guiGridListAddRow(grid_shopping)
		end

		for i = 0, item_num do
			guiGridListSetItemText(grid_shopping, i, 1, theArray[i]["product_name"], false, false)
			guiGridListSetItemText(grid_shopping, i, 2, theArray[i]["product_count"], false, false)
			guiGridListSetItemText(grid_shopping, i, 3, "$"..theArray[i]["product_price"], false, false)
		end

		guiSetVisible(wnd_shopping, true)
		guiSetInputEnabled(true)
		showCursor(true)
	end
end

-- kupowajka
function finishPlayerShopping()
	-- pobieranie select grid ID, sprawdzanie czy ma wystarczająco kasiory etc.
	local index = guiGridListGetSelectedItem ( grid_shopping )
	local p_money = tonumber(getElementData(localPlayer, "player.cash"))
	local cost = temp_arr[index]["product_price"]

	if temp_arr[index]["product_price"] > p_money then
		outputChatBox("Błąd: Nie masz wystarczająco pieniędzy.", 200, 200, 200)
		return
	end

	if temp_arr[index]["product_count"] <= 0 then 
		outputChatBox("Błąd: Ten produkt już się skończył.", 200, 200, 200)
		return
	end

	-- pobierz kaskę
	setElementData(localPlayer, "player.cash", (p_money - cost))
	setPlayerMoney(p_money - cost)

	-- dodaj itema i odejmij jeden z p_count
	if temp_arr[index]["product_count"] > 1 then
		triggerServerEvent("onPlayerCreateItemRequest", getRootElement(), getLocalPlayer(), temp_arr[index]["product_name"], temp_arr[index]["product_type"], temp_arr[index]["product_value1"], temp_arr[index]["product_value2"], temp_arr[index]["product_uid"], false)
	else
		triggerServerEvent("onPlayerCreateItemRequest", getRootElement(), getLocalPlayer(), temp_arr[index]["product_name"], temp_arr[index]["product_type"], temp_arr[index]["product_value1"], temp_arr[index]["product_value2"], temp_arr[index]["product_uid"], true)
	end

	temp_arr[index]["product_count"] = temp_arr[index]["product_count"] - 1
end

-- Wypełnianie tabelki itemkami
function showOrders(array, type)
	
	-- POKAŻ KATEGORIE
	if type == 1 then
		orderGroupArray = array
	    guiGridListClear(grid_order)
	    order_step = 1

	    for i = 0, table.getn(array) do
	        guiGridListAddRow(grid_order)
	    end

	    for i=0, table.getn(array) do
	        guiGridListSetItemText(grid_order, i, 1, array[i]["cat_uid"], false, false) --uid
	        guiGridListSetItemText(grid_order, i, 2, array[i]["cat_name"], false, false) --nazwa
	    end
	end

	-- POKAŻ PRODUKTY
	if type == 2 then 
		order_step = 2
		orderGroupArray = array
		guiGridListClear(grid_order)

		for i = 0, table.getn(array) do 
			guiGridListAddRow(grid_order)
		end

		for i=0, table.getn(array) do
	        guiGridListSetItemText(grid_order, i, 1, array[i]["order_uid"], false, false) --uid
	        guiGridListSetItemText(grid_order, i, 2, array[i]["order_name"], false, false) --nazwa
	    end
	end

	guiSetVisible(wnd_order, true)
	showCursor(true)
	guiSetInputEnabled(true)
end
addEvent("showOrders", true)
addEventHandler("showOrders", localPlayer, showOrders)

function finishStep() 
	if order_step == 1 then
		local option, _ = guiGridListGetSelectedItem ( grid_order )
		local cat_id = orderGroupArray[option]["cat_uid"]
		triggerServerEvent( "onPlayerShowAvaiableProducts", getRootElement(), getLocalPlayer(), cat_id )
	end

	if order_step == 2 then
		local option, _ = guiGridListGetSelectedItem ( grid_order )
		local name = orderGroupArray[option]["order_name"]

		buy_name = name
		buy_price = tonumber(orderGroupArray[option]["order_price"])
		buy_uid = tonumber(orderGroupArray[option]["order_uid"])

		guiSetText(lab_order_count, "Ile sztuk produktu "..buy_name.." chcesz kupić?")
		guiSetVisible(wnd_order, false)
		guiSetVisible(wnd_order_count, true)
		--local message = "Kupujesz "..name..". To kosztuje $"..orderGroupArray[option]["order_price"].." za sztukę"
	end
end

function checkoutPlayerOrder()
	-- sprawdź kasę, sprawdź czy ilość jest OK
	local count = tonumber(guiGetText(ipt_order_count))
	if not count then
		outputChatBox("Błąd: Podano błędną ilość!")
		return
	end

	if count > 9999 or count < 1 then
		outputChatBox("Błąd: Podano błędną ilość!")
		return
	end

	buy_count = count
    guiSetText(lab_final, "Czy jesteś pewien, że chcesz kupić "..buy_name.." x"..buy_count.."?")
    guiSetText(lab_final_price, "Całkowity koszt zamówienia: $"..tonumber(buy_count * tonumber(buy_price)).." ($".. buy_price .."/sztuka)")
	guiSetVisible(wnd_order_count, false)
	--guiSetVisible(wnd_final, true)
	guiSetText(ipt_order_cost, "")
	guiSetVisible(wnd_cost, true)
end

function finalPlayerOrder()
	local cash = tonumber(buy_count * tonumber(buy_price))
	local pcash = tonumber(getElementData(localPlayer, "player.cash"))

	if cash > pcash then
		outputChatBox("Błąd: Nie posiadasz tyle pieniędzy!")
		return
	end

	local beforeCash = pcash - cash
	triggerServerEvent("onPlayerFinishOrder", getRootElement(), getLocalPlayer(), beforeCash, buy_uid, buy_count, productPrice)
	guiSetVisible(wnd_final, false)
	guiSetInputEnabled(false)
	showCursor(false)
end

function setProductCost()
	local cost = tonumber(guiGetText(ipt_order_cost))

	if not cost then
		outputChatBox("Błąd: Podano błędną cenę!")
		return
	end

	if cost > 9999 or cost < 1 then
		outputChatBox("Błąd: Podano błędną cenę!")
		return
	end

	productPrice = cost
	guiSetVisible(wnd_cost, false)
	guiSetVisible(wnd_final, true)
end

--
-- Eventy
--
addEvent("onPlayerStartShopping", true)
addEventHandler("onPlayerStartShopping", localPlayer, showPlayerBuyMenu)

addEvent("onPlayerStartClothesSelect", true)
addEventHandler("onPlayerStartClothesSelect", localPlayer, spawnPlayerDummy)