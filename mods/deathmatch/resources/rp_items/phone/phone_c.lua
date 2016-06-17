--------------------------------------------------------------------------------------
-- Trzeba dodać sprawdzanie czy ma w użyciu telefon a jak nie to zablokować binda "P"
--------------------------------------------------------------------------------------

-- Trochę configu
local STATE_HOME = 0
local STATE_SMS = 1
local STATE_CALL = 2
local STATE_SETT = 3
local STATE_WRITE_SMS = 4
local STATE_CONTACTS = 5
local STATE_CONTACTS_LIST = 6
local STATE_CONTACTS_SEL = 7
local STATE_SETTINGS_VIEW = 8

local is_player_use_phone = false
local is_player_use_inputs = false
local player_state = STATE_HOME
local selected_num = 0

addEventHandler("onClientResourceStart", resourceRoot,
    function()
    	-- Init phone
    	phone = guiCreateStaticImage ( 0.80, 0.40, 0.15, 0.55, "phone/phone.png", true, nil )
        internet = guiCreateStaticImage ( 0.82, 0.53, 0.045, 0.08, "phone/internet.png", true, nil )
        call = guiCreateStaticImage ( 0.8855, 0.53, 0.045, 0.08, "phone/call.png", true, nil )
        settings = guiCreateStaticImage ( 0.82, 0.64, 0.045, 0.08, "phone/settings.png", true, nil )
        sms = guiCreateStaticImage ( 0.8855, 0.64, 0.045, 0.08, "phone/sms.png", true, nil )
        closeBtn = guiCreateStaticImage ( 0.855, 0.86, 0.045, 0.08, "phone/sms.png", true, nil )
        guiSetAlpha(closeBtn, 0.0)

        -- Grid do SMSów
        phone_sms_grid = guiCreateGridList(0.81, 0.51, 0.13, 0.34, true)
        guiGridListAddColumn(phone_sms_grid, "Wybierz opcję", 0.9)
        for i = 1, 3 do
            guiGridListAddRow(phone_sms_grid)
        end
        guiGridListSetItemText(phone_sms_grid, 0, 1, "Napisz SMS", false, false)
        guiGridListSetItemText(phone_sms_grid, 1, 1, "Lista SMS", false, false)
        guiGridListSetItemText(phone_sms_grid, 2, 1, "Wróć", false, false)
        addEventHandler ( "onClientGUIClick", phone_sms_grid, menuClick )
        guiSetAlpha(phone_sms_grid, 0.80)   
        guiSetVisible(phone_sms_grid, false)

        -- Grid do menu kontaktów
        php_contact_grid = guiCreateGridList(0.81, 0.51, 0.13, 0.34, true)
        guiGridListAddColumn(php_contact_grid, "Kontakt", 0.9)
        for i = 1, 3 do
            guiGridListAddRow(php_contact_grid)
        end
        guiGridListSetItemText(php_contact_grid, 0, 1, "Lista kontaktów", false, false)
        guiGridListSetItemText(php_contact_grid, 1, 1, "Dodaj nowy", false, false)
        guiGridListSetItemText(php_contact_grid, 2, 1, "Wróć", false, false)
        addEventHandler ( "onClientGUIClick", php_contact_grid, menuClick )
        guiGridListSetSortingEnabled(php_contact_grid, false)
        guiSetAlpha(php_contact_grid, 0.80)   
        guiSetVisible(php_contact_grid, false)

        -- Grid listy kontaktów
        phone_contact_list = guiCreateGridList(0.81, 0.51, 0.13, 0.34, true)
        addEventHandler ( "onClientGUIClick", phone_contact_list, menuClick )
        guiGridListAddColumn(phone_contact_list, "Kontakt", 0.9)
        guiSetAlpha(phone_contact_list, 0.80)   
        guiGridListSetSortingEnabled(phone_contact_list, false)

        -- Grid konkretnego kontaktu
        phone_contact_select = guiCreateGridList(0.81, 0.51, 0.13, 0.34, true)
        addEventHandler ( "onClientGUIClick", phone_contact_select, menuClick )
        phone_contact_select_name = guiGridListAddColumn(phone_contact_select, "Kontakt", 0.9)
        guiSetAlpha(phone_contact_select, 0.80)   
        guiGridListSetSortingEnabled(phone_contact_select, false)
        for i = 1, 4 do
            guiGridListAddRow(phone_contact_select)
        end
        guiGridListSetItemText(phone_contact_select, 0, 1, "Zadzwoń", false, false)
        guiGridListSetItemText(phone_contact_select, 1, 1, "Napisz SMS", false, false)
        guiGridListSetItemText(phone_contact_select, 2, 1, "Usuń", false, false)
        guiGridListSetItemText(phone_contact_select, 3, 1, "Powrót", false, false)

        -- Grid ustawień
        phone_sett_grid = guiCreateGridList(0.81, 0.51, 0.13, 0.34, true)
        addEventHandler ( "onClientGUIClick", phone_sett_grid, menuClick )
        guiGridListAddColumn(phone_sett_grid, "Informacje o telefonie", 0.9)
        guiSetAlpha(phone_sett_grid, 0.80)   
        guiGridListSetSortingEnabled(phone_sett_grid, false)
        for i = 1, 3 do
            guiGridListAddRow(phone_sett_grid)
        end
        guiGridListSetItemText(phone_sett_grid, 0, 1, "Powrót", false, false)
        guiGridListSetItemText(phone_sett_grid, 1, 1, "Twój numer: ", false, false)


        -- Tworzenie nowego kontaktu
        wnd_create_contact = guiCreateWindow(0.35, 0.40, 0.31, 0.29, "Tworzenie nowego kontaktu", true)
        guiWindowSetSizable(wnd_create_contact, false)
        btn_con_add_succ = guiCreateButton(0.08, 0.73, 0.30, 0.16, "Gotowe", true, wnd_create_contact)
        guiSetProperty(btn_con_add_succ, "NormalTextColour", "FFAAAAAA")
        btn_con_add_deny = guiCreateButton(0.62, 0.72, 0.30, 0.17, "Anuluj", true, wnd_create_contact)
        guiSetProperty(btn_con_add_deny, "NormalTextColour", "FFAAAAAA")
        edit_con_add_num = guiCreateEdit(0.32, 0.40, 0.63, 0.16, "", true, wnd_create_contact)
        edit_con_add_name = guiCreateEdit(0.32, 0.16, 0.63, 0.16, "", true, wnd_create_contact)
        lab_con_add_first = guiCreateLabel(0.04, 0.16, 0.26, 0.16, "Nazwa kontaktu", true, wnd_create_contact)
        lab_con_add_sec = guiCreateLabel(0.04, 0.40, 0.27, 0.19, "Numer kontaktu", true, wnd_create_contact)
        guiSetVisible(wnd_create_contact, false)
        addEventHandler("onClientGUIClick", btn_con_add_deny, function() guiSetVisible(wnd_create_contact, false) end)
        addEventHandler("onClientGUIClick", btn_con_add_succ, menuClick)

        -- Wysyłajka SMSów
        wnd_send_sms = guiCreateWindow(0.32, 0.56, 0.36, 0.20, "Nowy SMS", true)
        guiWindowSetSizable(wnd_send_sms, false)
        txt_sms = guiCreateEdit(0.09, 0.25, 0.82, 0.35, "", true, wnd_send_sms)
        btn_sms_send = guiCreateButton(0.12, 0.70, 0.32, 0.23, "Wyślij", true, wnd_send_sms)
        guiSetProperty(btn_sms_send, "NormalTextColour", "FFAAAAAA")
        btn_sms_close = guiCreateButton(0.57, 0.70, 0.32, 0.23, "Zamknij", true, wnd_send_sms)
        addEventHandler ( "onClientGUIClick", btn_sms_close, function() guiSetVisible(wnd_send_sms, false) guiSetInputEnabled(false) end, false )
        addEventHandler( "onClientGUIClick", btn_sms_send, function() playerSendSMS() end, false )
        guiSetProperty(btn_sms_close, "NormalTextColour", "FFAAAAAA")  
        guiSetVisible(wnd_send_sms, false)

        -- Eventy kliknieć
        addEventHandler ( "onClientGUIClick", internet, function() outputChatBox("(( Funkcja nieaktywna. ))") end, false )
        addEventHandler ( "onClientGUIClick", call, function() changePlayerScreen(STATE_CONTACTS) end, false )
        addEventHandler ( "onClientGUIClick", sms, function() changePlayerScreen(STATE_SMS) end, false )
        addEventHandler ( "onClientGUIClick", settings, function() changePlayerScreen(STATE_SETTINGS_VIEW) end, false )
        addEventHandler ( "onClientGUIClick", closeBtn, function() togglePhoneInputs() end, false )
        guiSetEnabled(phone, false)

        -- Na koniec domyślnie chowaj telefon
        is_player_use_phone = true
        togglePlayerPhone()

        -- Bind do telefonu
        bindKey("p", "up", togglePhoneInputs)
        guiSetVisible(phone, false)
    end 
)

--[[
---------------------------------------------------
-- Wyświetlanie telefonu
---------------------------------------------------
]]--
function togglePlayerPhone()
	if is_player_use_phone == true then
		guiSetVisible(phone, false)
		guiSetVisible(internet, false)
		guiSetVisible(call, false)
		guiSetVisible(settings, false)
		guiSetVisible(sms, false)
		guiSetVisible(closeBtn, false)
		guiSetVisible(phone_sms_grid, false)
		guiSetVisible(php_contact_grid, false)
		guiSetVisible(phone_contact_list, false)
		guiSetVisible(phone_contact_select, false)
		guiSetVisible(phone_sett_grid, false)
		is_player_use_phone = false
	else
		guiSetVisible(phone, true)
		guiSetVisible(internet, true)
		guiSetVisible(call, true)
		guiSetVisible(settings, true)
		guiSetVisible(sms, true)
		guiSetVisible(closeBtn, true)
		is_player_use_phone = true
	end
end

--[[
---------------------------------------------------
-- Nawigowanie telefonem
---------------------------------------------------
]]--
function togglePhoneInputs()
	guiSetInputEnabled(false)
	if tonumber(getElementData(localPlayer, "player.phonenumber")) > 0 then
		-- Jakieś gówno
		if isAnyGUIVisible() then
			return
		end

		if is_player_use_inputs == true then
			-- przestań używać
			is_player_use_inputs = false
			togglePlayerPhone()
			showCursor(false)
		else
			-- zacznij używać
			is_player_use_inputs = true
			player_state = STATE_HOME
			togglePlayerPhone()
			showCursor(true)
		end
	end
end

-- funkcja do zmiany ekranu telefonu
function changePlayerScreen(state)
	guiSetVisible(internet, false)
	guiSetVisible(call, false)
	guiSetVisible(settings, false)
	guiSetVisible(sms, false)
	guiSetVisible(phone_sms_grid, false)
	guiSetVisible(php_contact_grid, false)
	guiSetVisible(phone_contact_list, false)
	guiSetVisible(phone_contact_select, false)
	guiSetVisible(phone_sett_grid, false)

	-- nowy state
	player_state = state

	if state == STATE_SETTINGS_VIEW then 
		guiSetVisible(phone_sett_grid, true)
		guiGridListSetItemText(phone_sett_grid, 1, 1, "Twój numer: "..getElementData(localPlayer, "player.phonenumber"), false, false)
	end

	if state == STATE_HOME then
		guiSetVisible(internet, true)
		guiSetVisible(call, true)
		guiSetVisible(settings, true)
		guiSetVisible(sms, true)
	end

	if state == STATE_CONTACTS_LIST then
		guiSetVisible(phone_contact_list, true)
	end

	if state == STATE_SMS then
		guiSetVisible(phone_sms_grid, true)
	end

	if state == STATE_CONTACTS then
		guiSetVisible(php_contact_grid, true)
	end

	-- Wybrany konkretny kontakt
	if state == STATE_CONTACTS_SEL then 
		guiSetVisible(phone_contact_select, true)
	end
end

function menuClick( button, state, sx, sy )
	guiSetInputEnabled(false)

	-- Ustawienia telefonu
	if source == phone_sett_grid then 
		local option, _ = guiGridListGetSelectedItem ( phone_sett_grid )
		
		-- Powrót
		if option == 0 then 
			changePlayerScreen(STATE_HOME)
		end
	end

	-- konkretny kontakt
	if source == phone_contact_select then 
		local option, _ = guiGridListGetSelectedItem ( phone_contact_select )

		-- CALL
		if option == 0 then 
			local number = selected_num
			triggerServerEvent("onPlayerStartCall", getRootElement(), getLocalPlayer(), tonumber(number))
		end

		-- SMS do gościa
		if option == 1 then 
			guiSetVisible(wnd_send_sms, true)
			guiSetInputEnabled(true)
		end

		-- POWRÓT
		if option == 3 then 
			changePlayerScreen(STATE_CONTACTS_LIST)
		end
	end

	-- wybieranie kontaktu
	if source == phone_contact_list then
		-- indexy lecą od 0, czyli dajemy +1
		local option, _ = guiGridListGetSelectedItem ( phone_contact_list )
		triggerServerEvent("onPlayerSelectNumber", getRootElement(), getLocalPlayer(), option)
	end

	-- walidacja nowego kontaktu
	if source == btn_con_add_succ then
		local number = tonumber(guiGetText(edit_con_add_num))
		local name = guiGetText(edit_con_add_name)

		if (number == nil) or (number > 999999) or (number < 100000) then
			outputChatBox("#CCCCCCBłąd: wprowadzono nieprawidłowy numer!", 255, 255, 255, true)
			return
		end

		if (name == nil) then
			outputChatBox("#CCCCCCBłąd: wprowadzono nieprawidłową nazwę!", 255, 255, 255, true)
			return
		end

		-- Wyczyść
		guiSetText(edit_con_add_num, "")
		guiSetText(edit_con_add_name, "")

		-- Query
		triggerServerEvent("onInsertContact", getRootElement(), getLocalPlayer(), number, name)

		-- Zakończenie
		outputChatBox("#CCCCCC> Dodano nowy kontakt do telefonu.", 255, 255, 255, true)
		guiSetVisible(wnd_create_contact, false)
	end

	-- Wybierałka w menu SMS
	if source == phone_sms_grid then
		local option, _ = guiGridListGetSelectedItem ( phone_sms_grid )
		if option == 2 then
			-- wróć
			changePlayerScreen(STATE_HOME)
		elseif option == 0 then
			-- NAPISZ SMS
		else
			-- LISTA SMS
		end
	end

	-- Wybierałka w menu kontaktów
	if source == php_contact_grid then
		local option, _ = guiGridListGetSelectedItem ( php_contact_grid )
		if option == 2 then
			-- wróć
			changePlayerScreen(STATE_HOME)
		elseif option == 0 then
			-- LISTA KONTAKTÓW
			changePlayerScreen(STATE_CONTACTS_LIST)
			triggerServerEvent("onListPlayerContacts", getRootElement(), getLocalPlayer())
		else
			-- STWÓRZ KONTAKT
			guiSetInputEnabled(true)
			guiSetVisible(wnd_create_contact, true)
		end
	end
end

-- dodawanie kontaktów do listy
function fillContactList(array)
	guiGridListClear(phone_contact_list)
	for i = 0, table.getn(array) do
        guiGridListAddRow(phone_contact_list)
    end

    for i=0, table.getn(array) do
        guiGridListSetItemText(phone_contact_list, i, 1, array[i][1], false, false) --nazwa kontaktu
    end
end

-- Selected phone numb.
function setLocalPlayerSelectedNumber(theNumber)
	selected_num = tonumber(theNumber)
	changePlayerScreen(STATE_CONTACTS_SEL)
end

function playerSendSMS()
	local msg = guiGetText(txt_sms)
	local numb_send = getElementData(localPlayer, "player.phonenumber")
	local numb_get = selected_num

	guiSetText(txt_sms, "") --czyścimy
	triggerServerEvent("onPlayerSendSMS", getRootElement(), getLocalPlayer(), tonumber(numb_get), msg)
end

--[[
---------------------------------------------------
-- Whyimsobad
---------------------------------------------------
]]--
function isAnyGUIVisible() --WHYIMSOBAD
	for k, v in ipairs(getElementsByType("gui-window")) do
		if guiGetVisible(v) then
			return true
		end
	end
	return false
end

--[[
----------------------------------------
-- Estetyka
----------------------------------------
]]--

-- Nowe eventy
addEvent("onChangePhoneScreen", true)
addEvent("onPhoneToggle", true)
addEvent("onFillContacts", true)
addEvent("onPlayerSetSelectedNumber", true)

-- Ich handlery
addEventHandler("onPlayerSetSelectedNumber", localPlayer, setLocalPlayerSelectedNumber)
addEventHandler("onChangePhoneScreen", localPlayer, changePlayerScreen)
addEventHandler("onFillContacts", localPlayer, fillContactList)
addEventHandler("onPhoneToggle", getRootElement(), togglePlayerPhone)