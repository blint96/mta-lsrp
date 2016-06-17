local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

function togglePhoneForPlayer(thePlayer)
	triggerClientEvent (thePlayer, "onPhoneToggle", thePlayer)
end

function insertContactToPhone(thePlayer, conNumer, conDesc)
	local query = dbQuery(handler, "INSERT INTO lsrp_phone_contacts VALUES("..tonumber(getElementData(thePlayer, "player.phonenumber"))..", '"..conDesc.."', "..conNumer..")")
	dbFree(query)
end
addEvent("onInsertContact", true)
addEventHandler("onInsertContact", getRootElement(), insertContactToPhone)

function listPlayerContacts(thePlayer)
	local number = tonumber(getElementData(thePlayer, "player.phonenumber"))
	local query = dbQuery(handler, "SELECT * FROM lsrp_phone_contacts WHERE phone_id = "..number)

	-- Trzeba dodać alarmowe i wracanie
	conarray = {}
	conarray[0] = {}
	conarray[0][1] = "Wróć"
	conarray[0][2] = 0

	conarray[1] = {}
	conarray[1][1] = "(911) Numer alarmowy"
	conarray[1][2] = 911

	conarray[2] = {}
	conarray[2][1] = "(777) Taxi"
	conarray[2][2] = 777

	conarray[3] = {}
	conarray[3][1] = "   "
	conarray[3][2] = 0

	local result = dbPoll(query, -1)
	if result then
		if result[1] then
			local index = 4
			local con_num = table.getn(result)

			for i = 1, con_num do 
				conarray[index] = {}
				conarray[index][1] = result[i]["phone_desc"]
				conarray[index][2] = result[i]["phone_numb"]
				index = index + 1
			end
		end
	else 
		conarray = {} -- buggerino
	end

	triggerClientEvent (thePlayer, "onFillContacts", thePlayer, conarray)
	if query then dbFree(query) end
end
addEvent("onListPlayerContacts", true)
addEventHandler("onListPlayerContacts", getRootElement(), listPlayerContacts)

--[[
---------------------------------------
-- Funkcja na dzwonienie
---------------------------------------
]]--

function makeCallFunc(thePlayer, theNumber)

	if theNumber == 911 then 
		exports.lsrp:showPopup(thePlayer, "debug lspd", 5 )
		return
	end

	if theNumber == 777 then 
		exports.lsrp:showPopup(thePlayer, "debug taxi", 5 )
		return
	end

	-------------------------------------------------------------
 	-- HURTOWNIA - /tel 333
 	-------------------------------------------------------------
	if theNumber == 333 then 
		local world = getElementDimension(thePlayer)
		if world == 0 then 
			exports.lsrp:showPopup(thePlayer, "Musisz znajdować się w budynku by użyć tej komendy!", 5)
			return
		end

		local door = exports.rp_doors:getPlayerDoor(thePlayer)
		if not door then 
			exports.lsrp:showPopup(thePlayer, "Musisz znajdować się w budynku by użyć tej komendy!", 5)
			return
		end

		local allowed = false
		local is_admin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
		if is_admin > 0 then allowed = true end

		if not allowed then 
			-- sprawdź czy właściciel firmy, returnuj jeśli nie
			local group_id = exports.rp_groups:GetGroupID(getElementData(door, "door.owner"))
			if group_id then 
				local perm = exports.rp_groups:IsPlayerHasPermTo(thePlayer, group_id, 128)
				if not perm then 
					allowed = false
					exports.lsrp:showPopup(thePlayer, "Nie jesteś właścicielem budynku!", 5)
					return
				end
			else
				allowed = false
				exports.lsrp:showPopup(thePlayer, "Nie jesteś właścicielem budynku!", 5)
				return
			end
		else
			-- pokaż zamawiajkę
			exports.rp_doors:showPlayerOrderMenu(thePlayer)
		end

		-- pokaż zamawiajkę
		exports.rp_doors:showPlayerOrderMenu(thePlayer)
		return
	end

	local phone_owner = isPhoneAvailable(tonumber(theNumber))
	if not phone_owner then 
		exports.lsrp:showPopup(thePlayer, "Numer jest poza zasięgiem sieci...", 5 )
		return
	end

	if isNumberBusy(tonumber(theNumber)) then 
		exports.lsrp:showPopup(thePlayer, "Ten numer jest zajęty!", 5 )
		return
	end

	if tonumber(theNumber) == tonumber(getElementData(thePlayer, "player.phonenumber")) then 
		exports.lsrp:showPopup(thePlayer, "Nie możesz dzwonić sam do siebie!", 5 )
		return
	end

	if phone_owner then 
		local new_call_id = getFreeCallID()
		calls[new_call_id]["call_enable"] = true
		calls[new_call_id]["call_make"] = tonumber(getElementData(thePlayer, "player.phonenumber"))
		calls[new_call_id]["call_towho"] = number
		calls[new_call_id]["call_response"] = false

		outputChatBox("» Wykonuję połączenie do "..owner..", poczekaj aż podniesie słuchawkę.", thePlayer, 204, 204, 0, false)
		outputChatBox("» Połączenie przychodzące od "..getNumberLabel(phone_owner, tonumber(getElementData(thePlayer, "player.phonenumber"))).." wpisz /odbierz by zacząć rozmowę.", phone_owner, 204, 204, 0, false)
	end
end
addEvent("onPlayerStartCall", true)
addEventHandler("onPlayerStartCall", getRootElement(), makeCallFunc)

function selectConctactFunc(thePlayer, theSelect)
	local query = dbQuery(handler, "SELECT * FROM lsrp_phone_contacts WHERE phone_id = "..tonumber(getElementData(thePlayer, "player.phonenumber")))
	local result = dbPoll(query, -1)

	-- POWRÓT
	if tonumber(theSelect) == 0 then 
		triggerClientEvent (thePlayer, "onChangePhoneScreen", thePlayer, 0) -- STATE_HOME
		return
	end

	-- ALARMOWE
	if tonumber(theSelect) == 1 then 
		outputChatBox("» Brak zasięgu, nie zadzwonisz na 911", thePlayer)
		return
	end

	-- TAXI
	if tonumber(theSelect) == 2 then 
		outputChatBox("» Brak zasięgu, nie zadzwonisz na 777", thePlayer)
		return
	end

	-- KRECHA, NIC
	if tonumber(theSelect) == 3 then 
		return
	end

	-- Poprawka indexów
	local regular_phones = tonumber(theSelect - 4)

	if result then
		if result[tonumber(regular_phones)+1] then
			number = tonumber(result[tonumber(regular_phones)+1]["phone_numb"])
			owner = result[tonumber(regular_phones)+1]["phone_desc"]
		end
	end

	--local phone_owner = isPhoneAvailable(number)
	if query then dbFree(query) end

	-- Zmiana działania menu
	triggerClientEvent (thePlayer, "onPlayerSetSelectedNumber", thePlayer, number)

	--[[ if not isPhoneAvailable(number) then 
		exports.lsrp:showPopup(thePlayer, "Numer jest poza zasięgiem sieci...", 5 )
		return
	end

	if number == tonumber(getElementData(thePlayer, "player.phonenumber")) then 
		exports.lsrp:showPopup(thePlayer, "Nie możesz zadzwonić sam do siebie!", 5 )
		return
	end

	if isNumberBusy(number) then 
		exports.lsrp:showPopup(thePlayer, "Ten numer jest zajęty!", 5 )
		return
	end

	if phone_owner then 
		local new_call_id = getFreeCallID()
		calls[new_call_id]["call_enable"] = true
		calls[new_call_id]["call_make"] = tonumber(getElementData(thePlayer, "player.phonenumber"))
		calls[new_call_id]["call_towho"] = number
		calls[new_call_id]["call_response"] = false

		outputChatBox("> Wykonuję połączenie do "..owner..", poczekaj aż podniesie słuchawkę.", thePlayer, 204, 204, 0, false)
		outputChatBox("> Połączenie przychodzące od "..getNumberLabel(phone_owner, tonumber(getElementData(thePlayer, "player.phonenumber"))).." wpisz /odbierz by zacząć rozmowę.", phone_owner, 204, 204, 0, false)
		return
	end ]]--
end
addEvent("onPlayerSelectNumber", true)
addEventHandler("onPlayerSelectNumber", getRootElement(), selectConctactFunc)

--[[
---------------------------------------
-- Pętelka przez graczy, sprawdamy czy można zadzwonić pod jakiś nr
-- RETURN: false or player element
---------------------------------------
]]--
function isPhoneAvailable(theNumber)
	local players = getElementsByType("player")
	local available = false
	for key, player in ipairs(players) do
		if tonumber(getElementData(player, "player.phonenumber")) == tonumber(theNumber) then 
			available = player
		end
	end

	return available
end

--
--	RETURN: raw number or contact name
--
function getNumberLabel(thePlayer, theNumber)
	local label = theNumber
	local query = dbQuery(handler, "SELECT * FROM lsrp_phone_contacts WHERE phone_id = "..tonumber(getElementData(thePlayer, "player.phonenumber")).." AND phone_numb = "..tonumber(theNumber).."")
	local result = dbPoll(query, -1)

	if result then 
		if result[1] then 
			label = result[1]["phone_desc"]
		end
	end
	return label
end

--
-- Handler wysyłania SMSów
--
function onPlayerSendSMS(thePlayer, theNumber, theMessage)
	local theTarget = getPlayerByNumber(tonumber(theNumber))

	if not theTarget then 
		exports.lsrp:showPopup(thePlayer, "Numer poza zasięgiem sieci.", 5)
		return
	end

	if theMessage == nil or string.len(theMessage) <= 0 then 
		exports.lsrp:showPopup(thePlayer, "Nie można wysłać pustej wiadomości.", 5)
		return 
	end

	outputChatBox("#FFFF66[SMS] "..getNumberLabel(thePlayer, tonumber(theNumber)).." » "..theMessage, thePlayer, 255, 255, 255, true)
	outputChatBox("#FFFF66[SMS] "..getNumberLabel(theTarget, getElementData(thePlayer, "player.phonenumber")).." « "..theMessage, theTarget, 255, 255, 255, true)

	exports.lsrp:imitationMe(thePlayer, "wysyła SMS-a.")
	exports.lsrp:imitationMe(theTarget, "otrzymuje SMS-a.")
end
addEvent("onPlayerSendSMS", true)
addEventHandler("onPlayerSendSMS", getRootElement(), onPlayerSendSMS)