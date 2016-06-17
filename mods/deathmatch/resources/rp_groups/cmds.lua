local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
mainplayertable = {}

-- Nie wiem co ja tutaj porobiłem
-- Już mi się we łbie chyba poprzestawiało
-- Od tempa i w ogóle, nie ważne - grunt, że działa
local dutyArray = {}
local dutyType = {}
local dutyId = {}
local dutyGroupUid = {}
local dutyStart = {}

local DUTY_TYPE_GROUP = 5
local DUTY_TYPE_ADMIN = 1
 
----------------------------
-- DUTY
----------------------------
function getPlayerDutyInfo(thePlayer)
	local playerid = tonumber(getElementData(thePlayer, "id"))
	return dutyArray[playerid], dutyType[playerid], dutyId[playerid], dutyGroupUid[playerid], dutyStart[playerid]
end

function isPlayerOnAdminDuty(thePlayer)
	local is = false
	local playerid = tonumber(getElementData(thePlayer, "id"))
	if dutyArray[playerid] == true and dutyType[playerid] == DUTY_TYPE_ADMIN then
		if (getElementData(thePlayer, "player.logged") == false) then
			return false
		else
			return true
		end
	else
		return false
	end
end

-- Funkcja do zapisu jak timeouty, crashe ETC!
function savePlayerDuty(thePlayer)
	local playerid = tonumber(getElementData(thePlayer, "id"))
	if dutyArray[playerid] == true then 
		local id = dutyId[playerid]
		if id > 0 then 
			local query = dbQuery(handler, "UPDATE lsrp_duties SET duty_end = "..tonumber(exports.rp_punish:getTimestamp()).." WHERE duty_uid = "..dutyId[playerid])
			dbFree(query)
		end
	end

	-- podlicz ile minutek
	local start_duty = dutyStart[playerid]
	local stop_duty = tonumber(exports.rp_punish:getTimestamp())
	local duty_minutes = 0
	if start_duty then
		-- poprawa błędu w konsoli
		duty_minutes = math.floor((stop_duty - start_duty) / 60)
	end

	-- Daj info na koniec
	local gname = groupsarray[GetGroupID(dutyGroupUid[playerid])]["name"]
	outputChatBox("#CCCCCC» Zakończyłeś służbę w grupie ".. gname .." - łącznie nabiłeś " .. duty_minutes .." minut!", thePlayer, 255, 255, 255, true)

	-- sprawdź czy payday się należy, lsrp_char_groups -> group_lastpayment
	local endline = stop_duty - 86400
	local total_time = 0
	local query = dbQuery(handler, "SELECT * FROM lsrp_duties WHERE duty_type = ".. DUTY_TYPE_GROUP .." AND duty_owner = ".. getElementData(thePlayer, "player.uid") .." AND duty_typeuid = ".. dutyGroupUid[playerid] .." AND duty_end != 0 AND duty_start > " .. endline)
	local result = dbPoll ( query, -1 )
	if result then 
		local res_num = table.getn(result)
		for i = 1, res_num do 
			total_time = total_time + (tonumber(result[i]["duty_end"]) - tonumber(result[i]["duty_start"]))
		end
	end
	if query then dbFree(query) end

	-- Rozdaj PAYDAY
	if math.floor(total_time / 60) >= _PAYDAY_LIMIT then 
		local query = dbQuery(handler, "SELECT * FROM lsrp_char_groups WHERE char_uid = ".. tonumber(getElementData(thePlayer, "player.uid")) .. " AND group_uid = ".. dutyGroupUid[playerid])
		local result = dbPoll (query, -1)
		local salary, last, job = 0, 0, 0
		if result then 
			salary = result[1]["group_payment"]
			last = result[1]["group_lastpayment"]
			job = tonumber(result[1]["uid"])
		end
		if query then dbFree(query) end

		if last < endline then
			-- Żeby nie pobierał kilka razy jednego dnia
			local query = dbQuery(handler, "UPDATE lsrp_char_groups SET group_lastpayment = ".. stop_duty .." WHERE uid = "..job)
			dbFree(query)

			-- Wypłać kasę
			if groupsarray[GetGroupID(dutyGroupUid[playerid])]["cash"] < salary then 
				outputChatBox("#FF9900» Firma w której pracujesz nie wypłaciła należnego #669966$".. salary .."!", thePlayer, 255, 255, 255, true)
				salary = 0
			else 
				groupsarray[GetGroupID(dutyGroupUid[playerid])]["cash"] = groupsarray[GetGroupID(dutyGroupUid[playerid])]["cash"] - salary
			end

			local payout = _MIN_DOTATION + salary
			outputChatBox("#FF9900» Otrzymałeś wypłatę w wysokości #669966$".. payout .."!", thePlayer, 255, 255, 255, true)

			-- nadaj kasę
	    	local before_pocket = tonumber(getElementData(thePlayer, "player.cash"))
	    	setPlayerMoney(thePlayer, before_pocket + payout)
	    	setElementData(thePlayer, "player.cash", before_pocket + payout)
		end
	end
	
	-- Czyszczonko!
	dutyArray[playerid] = false
	dutyType[playerid] = 0
end

function dutyCommand(thePlayer, theCmd, theFunction, theId)
	local playerid = tonumber(getElementData(thePlayer, "id"))
	if theFunction == nil then
		if dutyArray[playerid] == true then
			savePlayerDuty(thePlayer)
			return
		end

		outputChatBox("#CCCCCCUżycie: /duty [ grupa | admin ]", thePlayer, 255, 255, 255, true)
		return
	end

	-- DUTY W GRUPACH
	if theFunction == "grupa" then
		if dutyArray[playerid] == true then
			savePlayerDuty(thePlayer)
			return
		end

		if theId == nil then 
			outputChatBox("#CCCCCCUżycie: /duty grupa [Slot]", thePlayer, 255, 255, 255, true)
			return
		end

		-- Potem zapis jaki UID grupy, sprawdzanie slotów
		-- Sprawdzenie typu grupy, czy może na dworzu ETC
		local slot = tonumber(theId)
		if(playergroups[playerid][tonumber(slot)]["group_id"] == 0) then
			exports.lsrp:showPopup(thePlayer, "Wystapił błąd, podano niepoprawny slot grupy.", 5 )
			return
		end

		local group_id = playergroups[playerid][tonumber(slot)]["group_id"]
		local group_type = groupsarray[group_id]["type"]

		-- Sprawdź czy grupa ma flagę na wbijanie poza biznesem
		local skip = false
		if groupSettings[group_type][2] == true then 
			skip = true
		end

		-- Nie ma flagi, sprawdź czy jest w biznesie
		if not skip then 
			local door = exports.rp_doors:getPlayerDoor(thePlayer)
			if not door then 
				exports.lsrp:showPopup(thePlayer, "Musisz znajdować się w budynku biznesu by wpisać tą komendę!", 5 )
				return
			end

			if (tonumber(getElementData(door, "door.ownertype")) ~= 5) then 
				exports.lsrp:showPopup(thePlayer, "Musisz znajdować się w budynku biznesu by wpisać tą komendę!", 5 )
				return
			end

			local owner = tonumber(getElementData(door, "door.owner"))
			if tonumber(groupsarray[group_id]["uid"]) ~= owner then
				exports.lsrp:showPopup(thePlayer, "Musisz znajdować się w budynku biznesu by wpisać tą komendę!", 5 )
				return
			end
		end

		-- Zmienne do duty
		dutyGroupUid[playerid] = groupsarray[group_id]["uid"]
		dutyType[playerid] = DUTY_TYPE_GROUP
		dutyArray[playerid] = true

		local query = dbQuery(handler, "INSERT INTO lsrp_duties VALUES (NULL, "..DUTY_TYPE_GROUP..", "..tonumber(dutyGroupUid[playerid])..", "..tonumber(getElementData(thePlayer, "player.uid"))..", "..tonumber(exports.rp_punish:getTimestamp())..", 0)")
		local _, _, insert_id = dbPoll(query, -1)
		if query then dbFree(query) end
		dutyId[playerid] = insert_id

		local gname = groupsarray[GetGroupID(dutyGroupUid[playerid])]["name"]
		outputChatBox("#CCCCCC» Rozpocząłeś służbę w grupie ".. gname .."!", thePlayer, 255, 255, 255, true)
		dutyStart[playerid] = tonumber(exports.rp_punish:getTimestamp())
	end

	-- DUTY ADMINÓW
	if theFunction == "admin" then
		if dutyArray[playerid] == true then 
			-- SQL SAVE
			local query = dbQuery(handler, "UPDATE lsrp_duties SET duty_end = "..tonumber(exports.rp_punish:getTimestamp()).." WHERE duty_uid = "..dutyId[playerid])
			dbFree(query)

			setElementData(thePlayer, "player.displayname", getElementData(thePlayer, "player.originalname"))
			dutyArray[playerid] = false
			dutyType[playerid] = 0

			exports.lsrp:showPopup(thePlayer, "Zszedłeś z duty administratora!", 5)
			return
		end

		local gname = getElementData(thePlayer, "player.gname")
		setElementData(thePlayer, "player.displayname", gname)
		dutyType[playerid] = DUTY_TYPE_ADMIN
		dutyArray[playerid] = true

		local query = dbQuery(handler, "INSERT INTO lsrp_duties VALUES (NULL, "..DUTY_TYPE_ADMIN..", 0, "..tonumber(getElementData(thePlayer, "player.uid"))..", "..tonumber(exports.rp_punish:getTimestamp())..", 0)")
		local _, _, insert_id = dbPoll(query, -1)
		if query then dbFree(query) end
		dutyId[playerid] = insert_id

		exports.lsrp:showPopup(thePlayer, "Wszedłeś na duty administratora!", 5)
		return
	end
end
addCommandHandler("duty", dutyCommand)
addEventHandler ( "onPlayerLoginSQL", getRootElement(), function() local playerid = tonumber(getElementData(source, "id")) dutyArray[playerid] = false dutyType[playerid] = 0 dutyId[playerid] = 0 end )
addEventHandler ( "onPlayerQuit", getRootElement(), function() savePlayerDuty(source) end )
----------------------------
-- KONIC DUTY
----------------------------

function adminGroupControl(thePlayer, command, action, var1, var2, var3, ...)
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	if (padmin ~= 1) then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Brak uprawnień do użycia tej komendy.", 5 )
		return
	end

	if (action == nil) then
		outputChatBox("#CCCCCCUżycie: /ag [ dotacja | stworz | przeladuj | lider | lista | nazwa | usun | info | typ ]", thePlayer, 255, 255, 255, true)
		outputChatBox("#CCCCCCUżycie: /ag [ value1 | value2 | value3 ]", thePlayer, 255, 255, 255, true)
		return
	end

	-- dotacja
	if (action == "dotacja") then
		if (var1 == nil or var2 == nil) then
			outputChatBox("#CCCCCCUżycie: /ag dotacja [UID] [Kwota].", thePlayer, 255, 255, 255, true)
			return
		end

		var2 = tonumber(var2)
		if (var2 < 0 or var2 > 1500) then
			exports.lsrp:showPopup(thePlayer, "Dotacja musi zawierać się w kwocie $0 - $1500.", 5 )
			return
		end

		local group_id = tonumber(var1)
		group_id = GetGroupID(uid)
		if not group_id then
			exports.lsrp:showPopup(thePlayer, "Podałeś niepoprawne UID groupy.", 5 )
			return
		end

		groupsarray[group_id]["dotation"] = var2
		SaveGroup(group_id)
		exports.lsrp:showPopup(thePlayer, "Dotacja grupy " .. groupsarray[group_id]["name"] .. " została zmieniona na $" .. var2 .. ".", 5 )
		return
	end

	if (action == "stworz") then
		if(var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /ag stworz [Nazwa]", thePlayer, 255, 255, 255, true)
			return
		end

		local name = tostring(table.concat({var1, var2, var3, ...}, " "))
		if(name == nil) then
			outputChatBox("#CCCCCCUżycie: /ag stworz [Nazwa]", thePlayer, 255, 255, 255, true)
			return
		end
		
		local insert_id = CreateGroup(name)
		if insert_id then
			exports.lsrp:showPopup(thePlayer, "Grupa " .. name .. " została stworzona. UID: " .. insert_id, 5 )
		else
			exports.lsrp:showPopup(thePlayer, "Wystąpił błąd podczas tworzenia grupy.", 5 )
		end

		return
	end

	if (action == "przeladuj") then
		if(var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /ag przeladuj [UID]", thePlayer, 255, 255, 255, true)
			return
		end

		var1 = tonumber(var1)
		local group_id = GetGroupID(var1)

		if(group_id == -1) then
			outputChatBox("#FF0000Podano niepoprawne uid grupy.", thePlayer, 255, 255, 255, true)
			return
		end

		if LoadGroup(var1) then
			outputChatBox("#00FF00Grupa została poprawnie przeładowana.", thePlayer, 255, 255, 255, true)
		else
			outputChatBox("#FF0000Wystąpił błąd w ładowaniu grupy.", thePlayer, 255, 255, 255, true)
		end
		return
	end

	if (action == "lider") then
		if(var1 == nil or var2 == nil) then
			outputChatBox("#CCCCCCUżycie: /ag lider [UID grupy] [ID gracza]", thePlayer, 255, 255, 255, true)
			return
		end

		var1 = tonumber(var1)
		local group_id = GetGroupID(var1)

		local player_id = tonumber(var2)
		local player_element = call ( getResourceFromName ( "lsrp" ), "getPlayerByID", player_id )

		if (not player_element) then
			outputChatBox("#FF0000Podałeś niepoprawne ID gracza.", thePlayer, 255, 255, 255, true)
			return
		end

		if(group_id == -1) then
			outputChatBox("#FF0000Podano niepoprawne UID grupy.", thePlayer, 255, 255, 255, true)
			return
		end

		if(IsPlayerInGroup(player_element, group_id)) then
			outputChatBox("#FF0000Ten gracz już jest w tej grupie.", thePlayer, 255, 255, 255, true)
			return
		end

		local slot = GetFreeGroupSlotForPlayer(player_element)
		if(slot) then
			playergroups[player_id][slot]["group_id"]			= group_id
			playergroups[player_id][slot]["group_perm"]			= 127
			playergroups[player_id][slot]["group_name"]			= groupsarray[group_id]["name"]
			playergroups[player_id][slot]["group_uid"]			= tonumber(groupsarray[group_id]["uid"])
			local query = dbQuery(handler, "INSERT INTO lsrp_char_groups (`char_uid`, `group_uid`, `group_perm`) VALUES ('"..tonumber(getElementData(player_element, "player.uid")).."', '"..var1.."', '127')")
			dbPoll(query, -1)
			exports.lsrp:showPopup(player_element, "Zostałeś mianowany liderem grupy " ..groupsarray[group_id]["name"].. " przez administratora " ..exports.lsrp:playerRealName(thePlayer).. ".", 5 )
			exports.lsrp:showPopup(thePlayer, "Gracz " ..exports.lsrp:playerRealName(player_element).. " został liderem grupy " ..groupsarray[group_id]["name"].. ".", 5 )
		else
			exports.lsrp:showPopup(thePlayer, "Wystąpił błąd. Ten gracz ma już 5 grup.", 5 )
		end

		return
	end

	if (action == "lista") then
		triggerClientEvent (thePlayer, "updateClientList", thePlayer, groupsarray)
		triggerClientEvent (thePlayer, "showGroupList", thePlayer)
		return
	end

	if (action == "nazwa") then
		local name = table.concat({var2, var3, ...}, " ")
		if(var1 == nil or var2 == nil or name == nil) then
			outputChatBox("#CCCCCCUżycie: /ag nazwa [UID grupy] [Nowa nazwa]", thePlayer, 255, 255, 255, true)
			return
		end

		local group_id = GetGroupID(tonumber(var1))
		groupsarray[group_id]["name"] = name
		if SaveGroup(group_id) then
			exports.lsrp:showPopup(thePlayer, "Nazwa została poprawnie zmieniona na " .. name .. ". UID: " .. var1, 5 )
		else
			exports.lsrp:showPopup(thePlayer, "Wystąpił błąd podczas zmiany nazwy.", 5 )
		end

		return
	end

	if (action == "usun") then
		if(var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /ag usun [UID grupy]", thePlayer, 255, 255, 255, true)
			return
		end

		local group_id = GetGroupID(tonumber(var1))

		if DeleteGroup(group_id) then
			exports.lsrp:showPopup(thePlayer, "Grupa została poprawnie usunięta.", 5 )
		else
			exports.lsrp:showPopup(thePlayer, "Wystąpił błąd podczas usuwania grupy.", 5 )
		end

		return
	end

	if (action == "typ") then
		if(var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /ag usun [UID grupy]", thePlayer, 255, 255, 255, true)
			return
		end

		local group_id = GetGroupID(tonumber(var1))

		if(group_id == -1) then
			outputChatBox("#FF0000Podano niepoprawne uid grupy.", thePlayer, 255, 255, 255, true)
			return
		end

		--mainplayertable[tonumber(getElementData( thePlayer, "id" ))] = group_id
		triggerClientEvent (thePlayer, "showGroupTypeView", thePlayer, group_id)
		return
	end

	if (action == "info") then
		if(var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /ag info [UID]", thePlayer, 255, 255, 255, true)
			return
		end

		local group_id = GetGroupID(tonumber(var1))

		if(group_id == -1) then
			outputChatBox("#FF0000Podano niepoprawne uid grupy.", thePlayer, 255, 255, 255, true)
			return
		end

		triggerClientEvent (thePlayer, "updateClientList", thePlayer, groupsarray)
		triggerClientEvent (thePlayer, "showGroupInfoView", thePlayer, group_id)
		return 
	end

	if (action == "value") then
		if(var1 == nil or var2 == nil or var3 == nil) then
			outputChatBox("#CCCCCCUżycie: /ag value [UID] [1-3] [Nowa wartość]", thePlayer, 255, 255, 255, true)
			return
		end

		local group_id = GetGroupID(tonumber(var1))
		if group_id == -1 then
			outputChatBox("#CCCCCCNiepoprawne UID grupy.", thePlayer, 255, 255, 255, true)
			outputChatBox("#CCCCCCUżycie: /ag value [UID] [1-3] [Nowa wartość]", thePlayer, 255, 255, 255, true)
			return
		end

		local gindex = ""
		if(var2 == "1") then
			gindex = "value1"
		elseif(var2 == "2") then
			gindex = "value2"
		elseif(var2 == "3") then
			gindex = "value3"
		else
			outputChatBox("#CCCCCCUżycie: /ag value [UID] [1-3] [Nowa wartość]", thePlayer, 255, 255, 255, true)
			return
		end

		groupsarray[group_id][gindex] = tonumber(var3)
		
		if SaveGroup(group_id) then
			exports.lsrp:showPopup(thePlayer, "Wartość została poprawnie zmieniona.", 5 )
		else
			exports.lsrp:showPopup(thePlayer, "Wystapił błąd podczas edycji grupy.", 5 )
		end
		return
	end

end
addCommandHandler("ag", adminGroupControl)

function userGroupManagement(thePlayer, command, slot, action, var1, var2, var3, ...)
	-- Co każde wykonanie dla pewności przesyłamy x2
	triggerClientEvent (thePlayer, "updateClientList", thePlayer, groupsarray)
	triggerClientEvent (thePlayer, "updateClientSidePlayerGroups", thePlayer, playergroups)

	if (slot == nil or tonumber(slot) <= 0 or tonumber(slot) > 5) then
		outputChatBox("#CCCCCCUżycie: /g [slot (1-5)] [ zapros | wypros | info | pojazdy | respawn | online ]", thePlayer, 255, 255, 255, true)
		outputChatBox("#CCCCCCUżycie: /g [slot (1-5)] [ wyplac | wplac | czat | wczytaj | ogloszenia | opusc ]", thePlayer, 255, 255, 255, true)
		triggerClientEvent( thePlayer, "showGroups", thePlayer )
		return
	end

	local playerid = tonumber(getElementData(thePlayer, "id"))
	if(playergroups[playerid][tonumber(slot)]["group_id"] == 0) then
		exports.lsrp:showPopup(thePlayer, "Wystapił błąd, podano niepoprawny slot grupy.", 5 )
		return
	end

	-- opuszczanie
	if(action == "opusc") then 
		if(slot == nil) then 
			outputChatBox("#CCCCCCUżycie: /g [slot (1-5)] opusc", thePlayer, 255, 255, 255, true)
		end

		local group_id = playergroups[playerid][tonumber(slot)]["group_id"]
		local target_id = tonumber(getElementData(thePlayer, "id"))
		local target_element = call ( getResourceFromName ( "lsrp" ), "getPlayerByID", target_id )

		-- SQL
		local query = dbQuery(handler, "DELETE FROM lsrp_char_groups WHERE char_uid = '"..tonumber(getElementData(target_element, "player.uid")).."' AND group_uid = '"..groupsarray[group_id]["uid"].."'")
		dbPoll(query, -1)

		-- Czyścioszek
		local target_slot = GetPlayerGroupSlot(target_element, group_id)
		playergroups[target_id][target_slot]["group_id"]			= 0
		playergroups[target_id][target_slot]["group_skin"]			= 0
		playergroups[target_id][target_slot]["group_rank"]			= 0
		playergroups[target_id][target_slot]["group_payment"]		= 0
		playergroups[target_id][target_slot]["group_perm"]			= 0

		exports.lsrp:showPopup(thePlayer, "Opuściłeś tą grupę!", 5 )
	end

	if(action == "zapros") then
		if(var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /g [slot (1-5)] zapros [ID gracza]", thePlayer, 255, 255, 255, true)
			return
		end

		local group_id = playergroups[playerid][tonumber(slot)]["group_id"]

		if not IsPlayerHasPermTo(thePlayer, group_id, GROUP_PERM_LEADER) then 
			exports.lsrp:showPopup(thePlayer, "Brak uprawnień do tej czynności!", 5 )
			return
		end
		
		local target_id = tonumber(var1)
		local target_element = call ( getResourceFromName ( "lsrp" ), "getPlayerByID", target_id )
		if (not target_element) then
			outputChatBox("#FF0000Podałeś niepoprawne ID gracza.", thePlayer, 255, 255, 255, true)
			return
		end

		if(playerid == target_id) then
			outputChatBox("#FF0000Nie możesz zaprosić samego siebie.", thePlayer, 255, 255, 255, true)
			return
		end

		if(IsPlayerInGroup(target_element, group_id)) then
			outputChatBox("#FF0000Ten gracz już jest w tej grupie.", thePlayer, 255, 255, 255, true)
			return
		end

		local slot = GetFreeGroupSlotForPlayer(target_element)
		if(not slot) then
			outputChatBox("#FF0000Ten gracz nie ma wolnych slotów grupy.", thePlayer, 255, 255, 255, true)
			return
		end

		playergroups[target_id][slot]["group_id"]			= group_id
		local query = dbQuery(handler, "INSERT INTO lsrp_char_groups (`char_uid`, `group_uid`, `group_perm`) VALUES ('"..tonumber(getElementData(target_element, "player.uid")).."', '"..groupsarray[group_id]["uid"].."', '0')")
		dbPoll(query, -1)
		exports.lsrp:showPopup(thePlayer, "Gracz "..exports.lsrp:playerRealName(target_element).." został pomyślnie zaproszony do grupy "..groupsarray[group_id]["name"]..".", 5 )
		exports.lsrp:showPopup(target_element, "Zostałeś zaproszony do grupy "..groupsarray[group_id]["name"].." przez "..exports.lsrp:playerRealName(thePlayer)..".", 5 )

	elseif(action == "wypros") then
		if(var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /g [slot (1-5)] wypros [ID gracza]", thePlayer, 255, 255, 255, true)
			return
		end

		local group_id = playergroups[playerid][tonumber(slot)]["group_id"]

		if not IsPlayerHasPermTo(thePlayer, group_id, GROUP_PERM_LEADER) then 
			exports.lsrp:showPopup(thePlayer, "Brak uprawnień do tej czynności!", 5 )
			return
		end
		
		local target_id = tonumber(var1)
		local target_element = call ( getResourceFromName ( "lsrp" ), "getPlayerByID", target_id )
		if (not target_element) then
			outputChatBox("#FF0000Podałeś niepoprawne ID gracza.", thePlayer, 255, 255, 255, true)
			return
		end

		if(playerid == target_id) then
			outputChatBox("#FF0000Nie możesz wyprosić samego siebie.", thePlayer, 255, 255, 255, true)
			return
		end

		if(not IsPlayerInGroup(target_element, group_id)) then
			outputChatBox("#FF0000Ten gracz nie jest w tej grupie.", thePlayer, 255, 255, 255, true)
			return
		end
		local query = dbQuery(handler, "DELETE FROM lsrp_char_groups WHERE char_uid = '"..tonumber(getElementData(target_element, "player.uid")).."' AND group_uid = '"..groupsarray[group_id]["uid"].."'")
		dbPoll(query, -1)

		exports.lsrp:showPopup(thePlayer, "Gracz "..exports.lsrp:playerRealName(target_element).." został wyproszony z grupy "..groupsarray[group_id]["name"]..".", 5 )
		exports.lsrp:showPopup(target_element, "Zostałeś wyproszony z grupy "..groupsarray[group_id]["name"].." przez "..exports.lsrp:playerRealName(thePlayer)..".", 5 )
		
		local target_slot = GetPlayerGroupSlot(target_element, group_id)
		playergroups[target_id][target_slot]["group_id"]			= 0
		playergroups[target_id][target_slot]["group_skin"]			= 0
		playergroups[target_id][target_slot]["group_rank"]			= 0
		playergroups[target_id][target_slot]["group_payment"]		= 0
		playergroups[target_id][target_slot]["group_perm"]			= 0

	elseif(action == "info") then
		local group_id = playergroups[playerid][tonumber(slot)]["group_id"]
		--[[ -- tutaj musi się wyświetlić zjebane GUI dla group_id
		-- outputChatBox(groupsarray[tonumber(group_id)]["name"])
		triggerClientEvent (thePlayer, "showGroupInfoViewPlayer", thePlayer, tonumber(slot))]]--
		if group_id == nil or group_id <= 0 then 
			return
		end

		triggerClientEvent (thePlayer, "updateClientList", thePlayer, groupsarray)
		triggerClientEvent (thePlayer, "showGroupInfoView", thePlayer, group_id)
	elseif(action == "pojazdy") then

	elseif(action == "respawn") then
		local group_id = playergroups[playerid][tonumber(slot)]["group_id"]

		if not IsPlayerHasPermTo(thePlayer, group_id, GROUP_PERM_LEADER) then 
			exports.lsrp:showPopup(thePlayer, "Brak uprawnień do tej czynności!", 5 )
			return
		end

		RespawnGroupVehicles(group_id)
		exports.lsrp:showPopup(thePlayer, "Pomyślnie wykonałeś respawn pojazdów w grupie "..groupsarray[group_id]["name"]..".", 5 )

	elseif(action == "online") then
		-- ONLINE
		local playerid = tonumber(getElementData(thePlayer, "id"))
		local group_uid = playergroups[playerid][tonumber(slot)]["group_uid"]

		local players = getElementsByType("player")
		local online_list = nil
		for k, player in pairs(players) do 
			local loop_id = tonumber(getElementData(player, "id"))
			local form_name = exports.lsrp:playerRealName(player).." (ID: ".. loop_id ..")"
			--if dutyArray[loop_id] == true then 
			if IsPlayerInGroup(player, GetGroupID(group_uid)) then 
				if (dutyArray[loop_id] == true) and (dutyGroupUid[loop_id] == group_uid) then 
					if not online_list then 
						online_list = "#006600"..form_name
					else
						online_list = online_list .. ", #006600" .. form_name
					end
				else
					if not online_list then 
						online_list = "#FFFFFF"..form_name
					else
						online_list = online_list .. ", #FFFFFF" .. form_name
					end
				end
			end
		end

		if not online_list then 
			exports.lsrp:showPopup(thePlayer, "Brak graczy na służbie!", 5)
			return
		end

		outputChatBox("#009999» Online ".. playergroups[playerid][tonumber(slot)]["group_name"] ..": #FFFFFF"..online_list , thePlayer, 255, 255, 255, true)
	elseif(action == "wyplac") then
		--outputChatBox("wyplac")

	elseif(action == "wplac") then
		--outputChatBox("wplac")

	elseif(action == "czat") then
		--outputChatBox("czat")

	elseif(action == "wczytaj") then
		--outputChatBox("wczytaj")

	elseif(action == "ogloszenia") then
		--outputChatBox("ogloszenia")

	else
		outputChatBox("#CCCCCCUżycie: /g [slot (1-5)] [ zapros | wypros | info | pojazdy | respawn | online ]", thePlayer, 255, 255, 255, true)
		outputChatBox("#CCCCCCUżycie: /g [slot (1-5)] [ wyplac | wplac | czat | wczytaj | ogloszenia ]", thePlayer, 255, 255, 255, true)
	end
	return
end
addCommandHandler("g", userGroupManagement)

--
-- DEBUG: sprawdzenie grup
--
function adminShowDebugGroups(thePlayer, theCmd)
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	local playerid = tonumber(getElementData(thePlayer, "id"))
	if (padmin ~= 1) then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Brak uprawnień do użycia tej komendy.", 5 )
		return
	end

	local slot = 1
	for i = 1, _G_MAX_GROUP_SLOTS do
		if playergroups[playerid][tonumber(slot)]["group_id"] ~= 0 then
			outputConsole(slot.."#: "..playergroups[playerid][slot]["group_id"])
			outputConsole(slot.."#: "..playergroups[playerid][slot]["group_rank"])
			outputConsole(slot.."#: "..playergroups[playerid][slot]["group_perm"])
			outputConsole(slot.."#: UID TEJ GRUPY: "..groupsarray[playergroups[playerid][slot]["group_id"]]["uid"])
			slot = slot + 1
		end
	end
end
addCommandHandler("dg", adminShowDebugGroups)