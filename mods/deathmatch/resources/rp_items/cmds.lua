local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

function adminItemControl(thePlayer, command, action, var1, var2, var3, ...)
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	if (padmin ~= 1) then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Brak uprawnień do użycia tej komendy.", 5 )
		return
	end

	if (action == nil) then
		outputChatBox("#CCCCCCUżycie: /ap [ stworz | usun | typ | info | value1 | value 2]", thePlayer, 255, 255, 255, true)
		return
	end

	if (action == "info") then
		local item_uid = tonumber(var1)
		if item_uid == nil then
			outputChatBox("#CCCCCCUżycie: /ap info [UID przedmiotu]", thePlayer, 255, 255, 255, true)
			return
		end

		local query = dbQuery(handler, "SELECT * FROM lsrp_items WHERE item_uid = "..item_uid)
		local result = dbPoll(query, -1)
		if result then
			if result[1] then
				outputChatBox("#CCCCCC> Przedmiot "..result[1]["item_name"].." (UID: "..item_uid..")", thePlayer, 255, 255, 255, true)
				outputChatBox("#CCCCCC> Wartość 1-sza: "..result[1]["item_value1"], thePlayer, 255, 255, 255, true)
				outputChatBox("#CCCCCC> Wartość 2-ga: "..result[1]["item_value2"], thePlayer, 255, 255, 255, true)
				outputChatBox("#CCCCCC> Właściciel: "..result[1]["item_owner"], thePlayer, 255, 255, 255, true)
			else
				outputChatBox("#CCCCCCBłąd: nie znaleziono takiego przedmiotu", thePlayer, 255, 255, 255, true)
			end
		else
			outputChatBox("#CCCCCCBłąd: nie znaleziono takiego przedmiotu", thePlayer, 255, 255, 255, true)
		end

		if query then dbFree(query) end
	end

	if (action == "usun") then
		local item_uid = tonumber(var1)
		if item_uid == nil then
			outputChatBox("#CCCCCCUżycie: /ap usun [UID przedmiotu]", thePlayer, 255, 255, 255, true)
			return
		end

		outputChatBox("#CCCCCCPrzedmiot usunięty!", thePlayer, 255, 255, 255, true)
		local query = dbQuery(handler, "DELETE FROM lsrp_items WHERE item_uid = "..item_uid)
		if query then dbFree(query) end
	end

	if (action == "stworz") then
		local itype = tonumber(var1)
		local val1 = tonumber(var2)
		local val2 = tonumber(var3)

		if itype == 8 then
			-- jeśli telefon to random numer jakiś
			val1 = math.random(100000, 999999)
		end

		local name = tostring(table.concat({...}, " "))
		if (itype == nil or val1 == nil or val2 == nil or name == nil) then
			outputChatBox("#CCCCCCUżycie: /ap stworz [Typ przedmiotu] [Wartość 1] [Wartość 2] [Nazwa przedmiotu]", thePlayer, 255, 255, 255, true)
			return
		end

		local uid = getElementData(thePlayer, "player.uid")
		local query = dbQuery(handler, "INSERT INTO lsrp_items VALUES(NULL, '".. name .."', "..val1..", "..val2..", "..itype..", 0.0, 0.0, 0.0, 1, "..uid..", 0, 0, 0, 1.0, '')")
		local _, _, insert_id = dbPoll(query, -1)
		if query then dbFree(query) end

		exports.rp_logs:log_ItemLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") stworzył przedmiot "..name.." (UID: ".. insert_id ..")")
		outputDebugString("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") stworzył przedmiot "..name.." (UID: ".. insert_id ..")")
	end
end
addCommandHandler("ap", adminItemControl)