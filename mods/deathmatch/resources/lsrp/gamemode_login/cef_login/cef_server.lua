local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

function getUserCharacters(thePlayer, userId)
	local query = dbQuery(handler, "SELECT * FROM lsrp_characters WHERE char_gid = '"..tonumber(userId).."'")
	local result = dbPoll(query, -1)
	if result and result[1] then 
		charsarray = {}
		local index = 0
		local char_num = table.getn(result)

		for i = 1, char_num do 
			charsarray[index] = {}
			charsarray[index]["char_uid"] = result[i]["char_uid"]
			charsarray[index]["char_name"] = result[i]["char_name"]
			index = index + 1
		end

		--outputChatBox("showPlayerCharactersList, num of chars: "..char_num)
		triggerClientEvent (thePlayer, "showPlayerCharactersList", thePlayer, charsarray)
	else
		showPopup(thePlayer, "Nie masz postaci!", 3)
		return
	end
end

--[[ LOGOWANIE NA KONTO GLOBALNE ]]--
function cef_submitServerLogin(thePlayer, login, password)
	if not login or not password then 
		showPopup(source, "Uzupełnij wszystkie pola!", 3)
		return
	end

	if string.len(password) > 1 then
		local query = dbQuery(handler, "SELECT * FROM lsrp_members WHERE user_login = '".. login .."' AND user_passhash = MD5(CONCAT(MD5(user_salt), MD5('"..password.."')))")
		local result = dbPoll ( query, -1 )
		if result and result[1] then
			local member_id = tonumber(result[1]["user_id"])

			-- Active
			if tonumber(result[1]["user_active"]) <= 0 then
				kickPlayer(thePlayer, "Twoje konto nie jest aktywne.")
				return
			end

			-- Beta
			if tonumber(result[1]["user_beta_access"]) <= 0 then 
				kickPlayer(thePlayer, "Nie masz dostępu do beta.")
				return
			end

			-- POBIERANIE USER_XXXXX
			setElementData(thePlayer, "player.admin", result[1]["user_admin"])
			setElementData(thePlayer, "player.gname", result[1]["user_login"])
			setElementData(thePlayer, "player.color", result[1]["user_color"])
			setElementData(thePlayer, "player.showtags", tonumber(result[1]["user_showtags"]))
			setElementData(thePlayer, "player.shaders", tonumber(result[1]["user_shaders"]))
			setElementData(thePlayer, "player.gamescore", tonumber(result[1]["user_gamepoints"]))

			getUserCharacters(thePlayer, member_id)
		else
			showPopup(thePlayer, "Wprowadzono błędny login lub hasło!", 3)
			return
		end

		if query then dbFree(query) end
	else
		showPopup(thePlayer, "Podane hasło ma nieprawidłową długość!", 3)
		return
	end
end
addEvent("cefCheckLogin",true)
addEventHandler("cefCheckLogin", root, cef_submitServerLogin)

--[[ WYBÓR POSTACI ]]--
function onPlayerSelectCharacterByUid(thePlayer, char_uid)
	if thePlayer then

		-- nowe mysql
		local query = dbQuery(handler, "SELECT * FROM lsrp_characters WHERE char_uid = "..tonumber(char_uid))
		local result = dbPoll ( query, -1 )

		if result[1] and type(result) == 'table' then
			outputDebugString("[login] Gracz "..result[1]['char_name'].." (UID: "..result[1]['char_uid']..") zalogował się do gry")
		else 
			--outputChatBox("#990000Wpisałeś błędne hasło!", client, 255, 255, 255, true);
			--triggerClientEvent(client, "setPlayerToLogin", client)
			return
		end

		-- tutaj sprawdzanie hasła i zapis wszystkiego i tak dalej
		setElementData(thePlayer, "player.displayname", result[1]['char_name'])
		setElementData(thePlayer, "player.originalname", result[1]['char_name'])

		-- zespawnuj gracza
		--[[setElementData(client, "player.logged", true)
		spawnPlayer(client, spawnX, spawnY, spawnZ)
		fadeCamera(client, true)
		setCameraTarget(client, client)]]--
		-- Start: New spawning --
		-- Some strange error when fresh connect.
		setElementData(thePlayer, "player.logged", true)
		if tonumber(result[1]["char_spawnplace"]) == 1 then 
			-- znajdź drzwi o uid
			local uid = tonumber(result[1]["char_house"])
			local door = exports.rp_doors:getDoorElementByUID(uid)
			if not door then 
				spawnPlayer(thePlayer, spawnX, spawnY, spawnZ)
			else
				spawnPlayer(thePlayer, tonumber(getElementData(door, "door.exitx")), tonumber(getElementData(door, "door.exity")), tonumber(getElementData(door, "door.exitz")))
				setElementDimension(thePlayer, tonumber(getElementData(door, "door.exitvw")))
				setElementInterior(thePlayer, tonumber(getElementData(door, "door.exitint")))
			end
		else
			spawnPlayer(thePlayer, spawnX, spawnY, spawnZ)
		end

		--fadeCamera(client, true)
		--setCameraTarget(client, client)
		-- END: New spawning --

		-- przypisz wartości
		setElementModel(thePlayer, result[1]["char_skin"])
		setPlayerMoney(thePlayer, result[1]["char_cash"])
		setElementData(thePlayer, "player.cash", result[1]["char_cash"])
		setElementData(thePlayer, "player.bankcash", result[1]["char_bankcash"])
		setElementData(thePlayer, "player.uid", result[1]["char_uid"])
		setElementData(thePlayer, "player.gid", result[1]["char_gid"])
		setElementData(thePlayer, "player.skin", result[1]["char_skin"])
		setElementData(thePlayer, "player.afk", 0)
		--setElementData(client, "player.admin", result[1]["user_admin"])
		setElementData(thePlayer, "player.dl", 0)
		setElementData(thePlayer, "player.gtx", false)
		setElementData(thePlayer, "player.vehedit", nil)
		setElementData(thePlayer, "player.coledit", nil)
		--setElementData(client, "player.gname", result[1]["user_name"])
		--setElementData(client, "player.color", result[1]["user_color"])
		setElementData(thePlayer, "player.objedit", -1)
		--setElementData(client, "player.gamescore", tonumber(result[1]["user_gamepoints"]))
		setElementData(thePlayer, "player.logged", true)
		setElementData(thePlayer, "player.aj", result[1]["char_aj"])
		setElementData(thePlayer, "player.hours", result[1]["char_hours"])
		setElementData(thePlayer, "player.minutes", result[1]["char_minutes"])
		setElementData(thePlayer, "player.weapons", nil)
		setElementData(thePlayer, "player.bw", tonumber(result[1]["char_bw"]))
		setElementData(thePlayer, "player.lastw", false)
		setElementData(thePlayer, "player.shooting", tonumber(result[1]["char_shooting"]))
		setElementData(thePlayer, "player.phonenumber", tonumber(0))
		--setElementData(client, "player.showtags", tonumber(result[1]["user_showtags"]))
		--setElementData(client, "player.shaders", tonumber(result[1]["user_shaders"]))

		-- Miejsce na bronie
		setElementData(thePlayer, "player.pweapon", nil)
		setElementData(thePlayer, "player.sweapon", nil)

		local admin = tonumber(getElementData(thePlayer, "player.admin"))
		if admin ~= 0 then
			-- admin
			if admin > 0 then
				outputChatBox("#FF574F> Posiadasz uprawnienia administratora!", thePlayer, 255, 255, 255, true)
			else
				outputChatBox("#3399CC> Posiadasz uprawnienia supportera!", thePlayer, 255, 255, 255, true)
			end
		else 
			-- nie admin
			-- kickPlayer(client, "Work in progress...")
			-- return
		end 

		-- styl chodu dla faceta
		if result[1]["char_sex"] == 1 then
			setPedWalkingStyle(thePlayer, 118)
		end

		-- styl chodu dla baby
		if result[1]["char_sex"] == 2 then
			setPedWalkingStyle(thePlayer, 129)
		end

		-- opis
		setElementData(thePlayer, "player.describe", nil)

		-- Dodaj event
		triggerEvent ( "onPlayerLoginSQL", thePlayer)

		-- wyczyść pamięć
		if query then dbFree(query) end

		-- tepnij do AJa po reconnecie
		exports.rp_punish:checkJail(thePlayer)

		-- ustaw numer telefonu
		exports.rp_items:setPlayerPhoneNumberOnJoin(thePlayer)

		setPlayerNametagShowing(thePlayer, false)
		outputChatBox("#336699Witaj #FFFFFF".. getElementData(thePlayer, "player.gname") .."#336699! Zalogowałeś się do #FFFFFFLos Santos Role Play#336699, miłej gry!", thePlayer, 255, 255, 255, true)

		-- sprawdź czy ma BW
		setPlayerAfterLogBW(thePlayer, tonumber(result[1]["char_posx"]), tonumber(result[1]["char_posy"]), tonumber(result[1]["char_posz"]), tonumber(result[1]["char_int"]), tonumber(result[1]["char_vw"]))

		-- dodaj, że postać zalogowana
		local query = dbQuery(handler, "UPDATE lsrp_characters SET char_online = 1 WHERE char_uid = ".. getElementData(thePlayer, "player.uid") ..";")
		dbFree(query)

		-- HUD
		setPlayerHudComponentVisible( thePlayer, "radar", false )
		setPlayerHudComponentVisible( thePlayer, "ammo", false )
		setPlayerHudComponentVisible( thePlayer, "health", false )
		setPlayerHudComponentVisible( thePlayer, "clock", false )
		setPlayerHudComponentVisible( thePlayer, "money", false )
		setPlayerHudComponentVisible( thePlayer, "armour", false )
		setPlayerHudComponentVisible( thePlayer, "weapon", false )

		-- Hotfix
		setPlayerName(thePlayer, result[1]['char_name'])

		-- Nowe logowanie
		if getElementDimension(thePlayer) == 0 then
			triggerClientEvent(thePlayer, "closePlayerLoginForm", thePlayer, false)
		else
			setCameraTarget(thePlayer, thePlayer)
			triggerClientEvent(thePlayer, "closePlayerLoginForm", thePlayer, true)
		end
	end
end
addEvent("onPlayerSelectCharacterByUid", true)
addEventHandler("onPlayerSelectCharacterByUid", getRootElement(), onPlayerSelectCharacterByUid)