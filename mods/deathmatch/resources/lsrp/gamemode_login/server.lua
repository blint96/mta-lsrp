spawnX, spawnY, spawnZ = 1566.17, -1310.42, 17.15
handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

-- funkcja na respawn gracza
function respawnPlayer(player)
	spawnPlayer(player, spawnX, spawnY, spawnZ)
	setCameraTarget(player, player)
	setElementModel(player, getElementData(player, "player.skin"))
end

-- test
function onPlayerLoginSQL()
	-- source?
	--outputChatBox("zalogowal sie jakis gnuj "..getPlayerName(source))
end
addEvent ( "onPlayerLoginSQL", true )
addEventHandler ( "onPlayerLoginSQL", getRootElement(), onPlayerLoginSQL )

function submitServerLogin(password)
	if string.len(password) > 0 then

		-- nowe mysql
		local query = dbQuery(handler, "SELECT * FROM lsrp_members LEFT JOIN lsrp_characters ON user_id = char_gid WHERE char_name ='".. getPlayerName(client) .."' AND user_passhash = MD5(CONCAT(MD5(user_salt), MD5('"..password.."')))")
		local result = dbPoll ( query, -1 )

		if result[1] and type(result) == 'table' then
			outputDebugString("[login] Gracz "..result[1]['char_name'].." (UID: "..result[1]['char_uid']..") zalogował się do gry")
		else 
			outputChatBox("#990000Wpisałeś błędne hasło!", client, 255, 255, 255, true);
			triggerClientEvent(client, "setPlayerToLogin", client)
			return
		end

		-- tutaj sprawdzanie hasła i zapis wszystkiego i tak dalej
		setElementData(client, "player.displayname", getPlayerName(client))
		setElementData(client, "player.originalname", getPlayerName(client))

		-- zespawnuj gracza
		--[[setElementData(client, "player.logged", true)
		spawnPlayer(client, spawnX, spawnY, spawnZ)
		fadeCamera(client, true)
		setCameraTarget(client, client)]]--
		-- Start: New spawning --
		-- Some strange error when fresh connect.
		setElementData(client, "player.logged", true)
		if tonumber(result[1]["char_spawnplace"]) == 1 then 
			-- znajdź drzwi o uid
			local uid = tonumber(result[1]["char_house"])
			local door = exports.rp_doors:getDoorElementByUID(uid)
			if not door then 
				spawnPlayer(client, spawnX, spawnY, spawnZ)
			else
				spawnPlayer(client, tonumber(getElementData(door, "door.exitx")), tonumber(getElementData(door, "door.exity")), tonumber(getElementData(door, "door.exitz")))
				setElementDimension(client, tonumber(getElementData(door, "door.exitvw")))
				setElementInterior(client, tonumber(getElementData(door, "door.exitint")))
			end
		else
			spawnPlayer(client, spawnX, spawnY, spawnZ)
		end

		--fadeCamera(client, true)
		--setCameraTarget(client, client)
		-- END: New spawning --

		-- przypisz wartości
		setElementModel(client, result[1]["char_skin"])
		setPlayerMoney(client, result[1]["char_cash"])
		setElementData(client, "player.cash", result[1]["char_cash"])
		setElementData(client, "player.bankcash", result[1]["char_bankcash"])
		setElementData(client, "player.uid", result[1]["char_uid"])
		setElementData(client, "player.gid", result[1]["char_gid"])
		setElementData(client, "player.skin", result[1]["char_skin"])
		setElementData(client, "player.afk", 0)
		setElementData(client, "player.admin", result[1]["user_admin"])
		setElementData(client, "player.dl", 0)
		setElementData(client, "player.gtx", false)
		setElementData(source, "player.vehedit", nil)
		setElementData(source, "player.coledit", nil)
		setElementData(client, "player.gname", result[1]["user_name"])
		setElementData(client, "player.color", result[1]["user_color"])
		setElementData(client, "player.objedit", -1)
		setElementData(client, "player.gamescore", tonumber(result[1]["user_gamepoints"]))
		setElementData(client, "player.logged", true)
		setElementData(client, "player.aj", result[1]["char_aj"])
		setElementData(client, "player.hours", result[1]["char_hours"])
		setElementData(client, "player.minutes", result[1]["char_minutes"])
		setElementData(client, "player.weapons", nil)
		setElementData(client, "player.bw", tonumber(result[1]["char_bw"]))
		setElementData(client, "player.lastw", false)
		setElementData(client, "player.shooting", tonumber(result[1]["char_shooting"]))
		setElementData(client, "player.phonenumber", tonumber(0))
		setElementData(client, "player.showtags", tonumber(result[1]["user_showtags"]))
		setElementData(client, "player.shaders", tonumber(result[1]["user_shaders"]))

		-- Miejsce na bronie
		setElementData(client, "player.pweapon", nil)
		setElementData(client, "player.sweapon", nil)

		local admin = tonumber(result[1]["user_admin"])
		if admin ~= 0 then
			-- admin
			if admin > 0 then
				outputChatBox("#FF574F> Posiadasz uprawnienia administratora!", client, 255, 255, 255, true)
			else
				outputChatBox("#3399CC> Posiadasz uprawnienia supportera!", client, 255, 255, 255, true)
			end
		else 
			-- nie admin
			-- kickPlayer(client, "Work in progress...")
			-- return
		end 

		-- Active
		if tonumber(result[1]["user_active"]) <= 0 then
			kickPlayer(client, "Twoje konto nie jest aktywne.")
			return
		end

		-- Beta
		if tonumber(result[1]["user_beta_access"] <= 0) then 
			kickPlayer(client, "Nie masz dostępu do beta.")
			return
		end

		-- styl chodu dla faceta
		if result[1]["char_sex"] == 1 then
			setPedWalkingStyle(client, 118)
		end

		-- styl chodu dla baby
		if result[1]["char_sex"] == 2 then
			setPedWalkingStyle(client, 129)
		end

		-- opis
		setElementData(client, "player.describe", nil)

		-- Dodaj event
		triggerEvent ( "onPlayerLoginSQL", client)

		-- wyczyść pamięć
		if query then dbFree(query) end

		-- tepnij do AJa po reconnecie
		exports.rp_punish:checkJail(client)

		-- ustaw numer telefonu
		exports.rp_items:setPlayerPhoneNumberOnJoin(client)

		setPlayerNametagShowing(client, false)
		outputChatBox("#336699Witaj #FFFFFF".. result[1]["user_name"] .."#336699! Zalogowałeś się do #FFFFFFLos Santos Role Play#336699, miłej gry!", client, 255, 255, 255, true)

		-- sprawdź czy ma BW
		setPlayerAfterLogBW(client, tonumber(result[1]["char_posx"]), tonumber(result[1]["char_posy"]), tonumber(result[1]["char_posz"]), tonumber(result[1]["char_int"]), tonumber(result[1]["char_vw"]))

		-- dodaj, że postać zalogowana
		local query = dbQuery(handler, "UPDATE lsrp_characters SET char_online = 1 WHERE char_uid = ".. getElementData(client, "player.uid") ..";")
		dbFree(query)

		-- HUD
		setPlayerHudComponentVisible( client, "radar", false )
		setPlayerHudComponentVisible( client, "ammo", false )
		setPlayerHudComponentVisible( client, "health", false )
		setPlayerHudComponentVisible( client, "clock", false )
		setPlayerHudComponentVisible( client, "money", false )
		setPlayerHudComponentVisible( client, "armour", false )
		setPlayerHudComponentVisible( client, "weapon", false )

		-- Nowe logowanie
		if getElementDimension(client) == 0 then
			triggerClientEvent(client, "closePlayerLoginForm", client, false)
		else
			setCameraTarget(client, client)
			triggerClientEvent(client, "closePlayerLoginForm", client, true)
		end
	end
end
addEvent("submitServerLogin",true)
addEventHandler("submitServerLogin", root, submitServerLogin)