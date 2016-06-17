-- MySQL
local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

--[[ komendy adminów ]] --
function adminVehicleControl(thePlayer, command, action, var1, var2, var3)
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	if (padmin ~= 1) then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Brak uprawnień do użycia tej komendy.", 5 )
		return
	end

	if (action == nil) then
		outputChatBox("#CCCCCCUżycie: /av [ usun | stworz | goto | przypisz | gethere | fix | silnik | zaparkuj | hp | kolor1 | kolor2 | flip | respawn ]", thePlayer, 255, 255, 255, true)
		return
	end

	-- silnik do zrobienia
	if (action == "silnik") then
		if var1 == nil then
			outputChatBox("#CCCCCCUżycie: /av silnik [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))
		if not vehicle then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Taki pojazd nie jest zespawnowany.", 5 )
			return
		end

		changeVehicleEngineState(vehicle)
	end

	-- Model
	if (action == "model") then
		if var1 == nil or var2 == nil then
			outputChatBox("#CCCCCCUżycie: /av model [ID pojazdu] [Nowy model]", thePlayer, 255, 255, 255, true)
			return
		end
	end

	-- Unspawn
	if (action == "unspawn") then
		if var1 == nil then
			outputChatBox("#CCCCCCUżycie: /av unspawn [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return
		end

		local vehicle_id = tonumber(var1)	
		if not getVehicleByID(vehicle_id) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Taki pojazd nie jest zespawnowany.", 5 )
			return
		end

		UnspawnVehicle(vehicle_id)
	end

	-- Spawn
	if (action == "spawn") then
		if var1 == nil then
			outputChatBox("#CCCCCCUżycie: /av spawn [UID pojazdu]", thePlayer, 255, 255, 255, true)
			return
		end

		local spawn_uid = tonumber(var1)
		local element = nil

		local vehicles = getElementsByType("vehicle")
		for k, v in ipairs(vehicles) do
			if tonumber(getElementData(v, "vehicle.uid")) == spawn_uid then
				element = v 
				break
			end
		end

		if not element then
			LoadVehicle(spawn_uid)
		else
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Taki pojazd jest już zespawnowany. (ID: ".. gotVehicleID(element) ..")", 5 )
			return
		end
	end

	-- przypisywanie
	if (action == "przypisz") then
		if(var1 == nil) or (var2 == nil) or (var3 == nil) then
			outputChatBox("#CCCCCCUżycie: /av przypisz [ID pojazdu] [gracz | grupa] [ID wlaściciela]", thePlayer, 255, 255, 255, true)
			return
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))

		-- pod gracza
		if (var2 == "gracz") then
			local player_id = tonumber(var3)
			local player_element = call ( getResourceFromName ( "lsrp" ), "getPlayerByID", player_id )

			local player_uid = getElementData(player_element, "player.uid")
			setElementData(vehicle, "vehicle.owner", player_uid)
			setElementData(vehicle, "vehicle.ownertype", 1)

			local query = dbQuery(handler, "UPDATE lsrp_cars SET car_owner = "..tonumber(player_uid)..", car_ownertype = 1 WHERE car_uid = "..getElementData(vehicle, "vehicle.uid"))
			if query then dbFree(query) end

			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Przypisałeś pojazd pod "..var2..", UID nowego właściciela: "..player_uid..".", 5 )
		end

		if (var2 == "grupa") then
			local group_uid = tonumber(var3)
			setElementData(vehicle, "vehicle.owner", group_uid)
			setElementData(vehicle, "vehicle.ownertype", 2)

			local query = dbQuery(handler, "UPDATE lsrp_cars SET car_owner = "..group_uid..", car_ownertype = 2 WHERE car_uid = "..getElementData(vehicle, "vehicle.uid"))
			if query then dbFree(query) end

			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Przypisałeś pojazd pod "..var2..", UID nowego właściciela: "..group_uid..".", 5 )
		end
	end

	-- paliwo
	if (action == "paliwo") then
		if (var1 == nil) or (var2 == nil) then
			outputChatBox("#CCCCCCUżycie: /av paliwo [ID pojazdu] [Litry]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))
		setElementData(vehicle, "vehicle.fuel", tonumber(var2))
	end

	-- info
	if (action =="info") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av info [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))
		local infoarray = {}
		infoarray[1] = vehicleNames[getElementModel(vehicle) - 400][2]
		triggerClientEvent(thePlayer, "showVehicleInfoView", thePlayer, vehicle, infoarray)
	end

	-- zaparkuj
	if (action =="zaparkuj") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av respawn [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))
		if ParkVehicle(vehicle) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Pojazd został pomyślnie zaparkowany.", 5 )
		else
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Wystąpił błąd podczas parkowania pojazdu, być może jest zajęte miejsce parkingowe.", 5 )
		end
	end

	-- respawn
	if (action == "respawn" or action == "res") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av respawn [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))
		local uid = getElementData(vehicle, "vehicle.uid")

		UnspawnVehicle(tonumber(var1))
		LoadVehicle(uid)
	end

	-- flip
	if (action == "flip") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av flip [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))
		local rx, ry, rz = getElementRotation(vehicle)
		setElementRotation(vehicle, rx + 180, ry, rz)

		local x, y, z = getElementPosition(vehicle)
		setElementPosition(vehicle, x, y, z + 3)
	end

	-- kolor2
	if (action == "kolor2") then
		-- wybierałkę się tutaj zrobi
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av kolor2 [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local colorPicker = call ( getResourceFromName ( "rp_colorpicker" ), "openPicker", thePlayer,  1, "#FFFFFF", "Kolor dla pojazdu" )
		local vehicle = getVehicleByID(tonumber(var1))
		setElementData(thePlayer, "player.vehedit", vehicle)
		setElementData(thePlayer, "player.coledit", 2)
		exports.rp_logs:log_VehicleLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") zmienił kolor pojazdu "..getElementData(vehicle, "vehicle.name").." (UID: ".. getElementData(vehicle, "vehicle.uid") ..")")
	end

	-- kolor1
	if (action == "kolor1") then
		-- wybierałkę się tutaj zrobi
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av kolor1 [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local colorPicker = call ( getResourceFromName ( "rp_colorpicker" ), "openPicker", thePlayer,  1, "#FFFFFF", "Kolor dla pojazdu" )
		local vehicle = getVehicleByID(tonumber(var1))
		setElementData(thePlayer, "player.vehedit", vehicle)
		setElementData(thePlayer, "player.coledit", 1)
		exports.rp_logs:log_VehicleLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") zmienił kolor pojazdu "..getElementData(vehicle, "vehicle.name").." (UID: ".. getElementData(vehicle, "vehicle.uid") ..")")
	end

	-- ustawianie hpsów
	if (action == "hp") then
		if(var1 == nil) or (var2 == nil) then
			outputChatBox("#CCCCCCUżycie: /av hp [ID pojazdu] [HP]", thePlayer, 255, 255, 255, true)
			return
		end

		local vehicle_id = tonumber(var1)
		if not getVehicleByID(vehicle_id) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local hp = tonumber(var2)
		setElementHealth(getVehicleByID(vehicle_id), hp)
		exports.rp_logs:log_VehicleLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") ustawił pojazdowi "..getElementData(getVehicleByID(vehicle_id), "vehicle.name").." (UID: ".. getElementData(getVehicleByID(vehicle_id), "vehicle.uid") ..") HP na: " .. hp)
	end

	-- całkowita naprawa
	if (action == "fix") then
		if(var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av fix [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return
		end

		local vehicle_id = tonumber(var1)
		if not getVehicleByID(vehicle_id) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		fixVehicle ( getVehicleByID(vehicle_id) )
		exports.rp_logs:log_VehicleLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") naprawił całkowicie pojazd "..getElementData(getVehicleByID(vehicle_id), "vehicle.name").." (UID: ".. getElementData(getVehicleByID(vehicle_id), "vehicle.uid") ..")")
	end

	-- gethere
	if (action == "gethere") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av gethere [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return
		end

		local vehicle_id = tonumber(var1)
		if not getVehicleByID(vehicle_id) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(vehicle_id)
		local x, y, z = getElementPosition(thePlayer)

		setElementPosition(vehicle, x + 2.0, y, z)
		setElementDimension(vehicle, getElementDimension(thePlayer))
	end

	-- goto
	if (action == "goto") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av goto [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return
		end

		local vehicle_id = tonumber(var1)
		if not getVehicleByID(vehicle_id) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle_el = getVehicleByID(vehicle_id)

		-- jest zespawnowany etc
		setElementDimension ( thePlayer, getElementDimension(vehicle_el) ) 
		warpPedIntoVehicle(thePlayer, vehicle_el)
	end

	-- stworz
	if (action == "stworz") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av stworz [Model pojazdu]", thePlayer, 255, 255, 255, true)
			return
		end

		local model = tonumber(var1)
		local x, y, z = getElementPosition(thePlayer)

		local created = false
		for i=0, table.getn(vehicleNames) do
			if vehicleNames[i][1] == model then
				created = true
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Stworzyłeś pojazd ".. vehicleNames[i][2] .."!", 5 )

				local insert_id = CreateCar(model, x, y, z)
				exports.rp_logs:log_VehicleLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") stworzył pojazd "..vehicleNames[i][2].." (UID: ".. insert_id ..")")
			end
		end

		if created == false then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Taki pojazd nie istnieje!", 5 )
			return
		end
	end

	-- usuń
	if (action == "usun") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av usun [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return
		end

		local vehicle_id = tonumber(var1)
		local vehicle = getVehicleByID(vehicle_id)

		if vehicle == false then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Taki pojazd nie jest teraz zespawnowany!", 5 )
			return
		end

		exports.rp_logs:log_VehicleLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") usunął pojazd "..getElementData(vehicle, "vehicle.name").." (UID: ".. getElementData(vehicle, "vehicle.uid") ..")")
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Usunąłeś ten pojazd.", 5 )
		DeleteCar(vehicle_id)
	end
end
addCommandHandler("av", adminVehicleControl)

-------------------------------------------------------------
-- SUPPORT
-- SV
-------------------------------------------------------------
function supportVehicleControl(thePlayer, command, action, var1, var2, var3)
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	if (padmin > -1) then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Brak uprawnień do użycia tej komendy.", 5 )
		return
	end

	if (action == nil) then
		outputChatBox("#CCCCCCUżycie: /sv [ unspawn | goto | gethere | fix | silnik | zaparkuj | hp | kolor1 | kolor2 | flip | respawn ]", thePlayer, 255, 255, 255, true)
		return
	end

	-- silnik do zrobienia
	if (action == "silnik") then
		if var1 == nil then
			outputChatBox("#CCCCCCUżycie: /av silnik [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))
		if not vehicle then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Taki pojazd nie jest zespawnowany.", 5 )
			return
		end

		changeVehicleEngineState(vehicle)
	end

	-- Unspawn
	if (action == "unspawn") then
		if var1 == nil then
			outputChatBox("#CCCCCCUżycie: /av unspawn [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return
		end

		local vehicle_id = tonumber(var1)	
		if not getVehicleByID(vehicle_id) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Taki pojazd nie jest zespawnowany.", 5 )
			return
		end

		UnspawnVehicle(vehicle_id)
	end

	-- Spawn
	if (action == "spawn") then
		if var1 == nil then
			outputChatBox("#CCCCCCUżycie: /av spawn [UID pojazdu]", thePlayer, 255, 255, 255, true)
			return
		end

		local spawn_uid = tonumber(var1)
		local element = nil

		local vehicles = getElementsByType("vehicle")
		for k, v in ipairs(vehicles) do
			if tonumber(getElementData(v, "vehicle.uid")) == spawn_uid then
				element = v 
				break
			end
		end

		if not element then
			LoadVehicle(spawn_uid)
		else
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Taki pojazd jest już zespawnowany. (ID: ".. gotVehicleID(element) ..")", 5 )
			return
		end
	end

	-- paliwo
	if (action == "paliwo") then
		if (var1 == nil) or (var2 == nil) then
			outputChatBox("#CCCCCCUżycie: /av paliwo [ID pojazdu] [Litry]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))
		setElementData(vehicle, "vehicle.fuel", tonumber(var2))
	end

	-- info
	if (action =="info") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av info [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))
		local infoarray = {}
		infoarray[1] = vehicleNames[getElementModel(vehicle) - 400][2]
		triggerClientEvent(thePlayer, "showVehicleInfoView", thePlayer, vehicle, infoarray)
	end

	-- zaparkuj
	if (action =="zaparkuj") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av respawn [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))
		if ParkVehicle(vehicle) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Pojazd został pomyślnie zaparkowany.", 5 )
		else
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Wystąpił błąd podczas parkowania pojazdu, być może jest zajęte miejsce parkingowe.", 5 )
		end
	end

	-- respawn
	if (action == "respawn" or action == "res") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av respawn [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))
		local uid = getElementData(vehicle, "vehicle.uid")

		UnspawnVehicle(tonumber(var1))
		LoadVehicle(uid)
	end

	-- flip
	if (action == "flip") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av flip [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(tonumber(var1))
		local rx, ry, rz = getElementRotation(vehicle)
		setElementRotation(vehicle, rx + 180, ry, rz)

		local x, y, z = getElementPosition(vehicle)
		setElementPosition(vehicle, x, y, z + 3)
	end

	-- kolor2
	if (action == "kolor2") then
		-- wybierałkę się tutaj zrobi
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av kolor2 [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local colorPicker = call ( getResourceFromName ( "rp_colorpicker" ), "openPicker", thePlayer,  1, "#FFFFFF", "Kolor dla pojazdu" )
		local vehicle = getVehicleByID(tonumber(var1))
		setElementData(thePlayer, "player.vehedit", vehicle)
		setElementData(thePlayer, "player.coledit", 2)
		exports.rp_logs:log_VehicleLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") zmienił kolor pojazdu "..getElementData(vehicle, "vehicle.name").." (UID: ".. getElementData(vehicle, "vehicle.uid") ..")")
	end

	-- kolor1
	if (action == "kolor1") then
		-- wybierałkę się tutaj zrobi
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av kolor1 [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return 
		end

		if not getVehicleByID(tonumber(var1)) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local colorPicker = call ( getResourceFromName ( "rp_colorpicker" ), "openPicker", thePlayer,  1, "#FFFFFF", "Kolor dla pojazdu" )
		local vehicle = getVehicleByID(tonumber(var1))
		setElementData(thePlayer, "player.vehedit", vehicle)
		setElementData(thePlayer, "player.coledit", 1)
		exports.rp_logs:log_VehicleLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") zmienił kolor pojazdu "..getElementData(vehicle, "vehicle.name").." (UID: ".. getElementData(vehicle, "vehicle.uid") ..")")
	end

	-- ustawianie hpsów
	if (action == "hp") then
		if(var1 == nil) or (var2 == nil) then
			outputChatBox("#CCCCCCUżycie: /av hp [ID pojazdu] [HP]", thePlayer, 255, 255, 255, true)
			return
		end

		local vehicle_id = tonumber(var1)
		if not getVehicleByID(vehicle_id) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local hp = tonumber(var2)
		setElementHealth(getVehicleByID(vehicle_id), hp)
		exports.rp_logs:log_VehicleLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") ustawił pojazdowi "..getElementData(getVehicleByID(vehicle_id), "vehicle.name").." (UID: ".. getElementData(getVehicleByID(vehicle_id), "vehicle.uid") ..") HP na: " .. hp)
	end

	-- całkowita naprawa
	if (action == "fix") then
		if(var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av fix [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return
		end

		local vehicle_id = tonumber(var1)
		if not getVehicleByID(vehicle_id) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		fixVehicle ( getVehicleByID(vehicle_id) )
		exports.rp_logs:log_VehicleLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") naprawił całkowicie pojazd "..getElementData(getVehicleByID(vehicle_id), "vehicle.name").." (UID: ".. getElementData(getVehicleByID(vehicle_id), "vehicle.uid") ..")")
	end

	-- gethere
	if (action == "gethere") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av gethere [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return
		end

		local vehicle_id = tonumber(var1)
		if not getVehicleByID(vehicle_id) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle = getVehicleByID(vehicle_id)
		local x, y, z = getElementPosition(thePlayer)

		setElementPosition(vehicle, x + 2.0, y, z)
		setElementDimension(vehicle, getElementDimension(thePlayer))
	end

	-- goto
	if (action == "goto") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /av goto [ID pojazdu]", thePlayer, 255, 255, 255, true)
			return
		end

		local vehicle_id = tonumber(var1)
		if not getVehicleByID(vehicle_id) then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie jest aktualnie zespawnowany.", 5 )
			return 
		end

		local vehicle_el = getVehicleByID(vehicle_id)

		-- jest zespawnowany etc
		setElementDimension ( thePlayer, getElementDimension(vehicle_el) ) 
		warpPedIntoVehicle(thePlayer, vehicle_el)
	end
end
addCommandHandler("sv", supportVehicleControl)

--[[ komendy ogólne  ]] --
function changeVehicleHoodStatus(thePlayer, theCmd)
	local car = getNearbyPlayerCar(thePlayer, 5)
	if not car then 
		exports.lsrp:showPopup(thePlayer, "Musisz stać przy jakimś pojeździe by użyć tej komendy.", 5)
		return
	end

	if car then 
		if (tonumber(getElementData(car, "vehicle.ownertype")) == 1) then
			-- gracz
			if(tonumber(getElementData(car, "vehicle.owner")) == tonumber(getElementData(thePlayer, "player.uid"))) then 
				local status = getVehicleDoorOpenRatio ( car, 0 )
				if status > 0 then 
					setVehicleDoorOpenRatio ( car, 0, 0, 2500 )
				else
					setVehicleDoorOpenRatio ( car, 0, 1, 2500 )
				end
			else
				exports.lsrp:showPopup(thePlayer, "Ten pojazd nie należy do Ciebie.", 5)
				return
			end
		elseif (tonumber(getElementData(car, "vehicle.ownertype")) == 0) then
			local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
			if padmin ~= 0 then 
				local status = getVehicleDoorOpenRatio ( car, 0 )
				if status > 0 then 
					setVehicleDoorOpenRatio ( car, 0, 0, 2500 )
				else
					setVehicleDoorOpenRatio ( car, 0, 1, 2500 )
				end
			end
		else
			-- dla grup sprawdzenie
		end
	end
end
addCommandHandler("maska", changeVehicleHoodStatus)

function changeVehicleTrunkStatus(thePlayer, theCmd)
	local car = getNearbyPlayerCar(thePlayer, 5)
	if not car then 
		exports.lsrp:showPopup(thePlayer, "Musisz stać przy jakimś pojeździe by użyć tej komendy.", 5)
		return
	end

	if car then 
		if (tonumber(getElementData(car, "vehicle.ownertype")) == 1) then
			-- gracz
			if(tonumber(getElementData(car, "vehicle.owner")) == tonumber(getElementData(thePlayer, "player.uid"))) then 
				local status = getVehicleDoorOpenRatio ( car, 1 )
				if status > 0 then 
					setVehicleDoorOpenRatio ( car, 1, 0, 2500 )
				else
					setVehicleDoorOpenRatio ( car, 1, 1, 2500 )
				end
			else
				exports.lsrp:showPopup(thePlayer, "Ten pojazd nie należy do Ciebie.", 5)
				return
			end
		elseif (tonumber(getElementData(car, "vehicle.ownertype")) == 0) then
			-- dla niczyich
			local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
			if padmin ~= 0  then 
				local status = getVehicleDoorOpenRatio ( car, 1 )
				if status > 0 then 
					setVehicleDoorOpenRatio ( car, 1, 0, 2500 )
				else
					setVehicleDoorOpenRatio ( car, 1, 1, 2500 )
				end
			end
		else
			-- dla grup
		end
	end
end
addCommandHandler("bagaznik", changeVehicleTrunkStatus)

function changeVehicleEngineStateCommand(thePlayer, command)
	local vehicle = getPedOccupiedVehicle(thePlayer)

	-- jeśli admin to każda
	local skip = false
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	if padmin > 0 then skip = true end

	if vehicle ~= false then
		local seat = getPedOccupiedVehicleSeat ( thePlayer )

		if getElementHealth(vehicle) <= 350 then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Silnik w tym pojeździe jest kompletnie zniszczony, udaj się do mechanika.", 5 )
			return
		end

		if getElementData(vehicle, "vehicle.fuel") <= 0 then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Skończyło się paliwo, zatankuj pojazd na stacji.", 5 )
			return
		end

		if skip then
			changeVehicleEngineState(vehicle)
			return
		end

		if (seat == 0) then
			if (tonumber(getElementData(vehicle, "vehicle.ownertype")) == 1) then
				if(tonumber(getElementData(vehicle, "vehicle.owner")) == tonumber(getElementData(thePlayer, "player.uid"))) then
					changeVehicleEngineState(vehicle)
				else
					call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie masz kluczyków do tego pojazdu.", 5 )
				end
			else
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie masz kluczyków do tego pojazdu.", 5 )
			end
		else 
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Aby użyć tej komendy musisz być kierowcą pojazdu.", 5 )
		end
	else
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Aby użyć tej komendy musisz być w jakimś pojeździe.", 5 )
	end
end
addCommandHandler("silnik", changeVehicleEngineStateCommand)

-- tankowanie fury
function applyPlayerGas(thePlayer, command, amount)
	if amount == nil then
		outputChatBox("#CCCCCCUżycie: /tankuj [Ilość litrów]", thePlayer, 255, 255, 255, true)
		return
	end

	local gas_amount = tonumber(amount)
	local car = getNearbyPlayerCar(thePlayer, 3)
	if not car then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "W pobliżu nie ma żadnego pojazdu!", 5 )
		return
	end
	local current_gas = getElementData(car, "vehicle.fuel")

	-- buggerino!
	if gas_amount <= 0 then
		outputChatBox("#CCCCCCUżycie: /tankuj [Ilość litrów (+)]", thePlayer, 255, 255, 255, true)
		return
	end

	local station = getPlayerNearbyGasStation(thePlayer)
	if not station then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "W pobliżu nie ma żadnego dystrybutora!", 5 )
		return
	end

	if isPedInVehicle(thePlayer) then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Wyjdź z auta jeśli chcesz tankować paliwo.", 5 )
		return
	end

	local pay = math.floor(gas_amount * gasStation[station][5])
	if tonumber(getElementData(thePlayer, "player.cash")) < pay then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie masz wystarczająco pieniędzy!", 5 )
		return
	end

	if current_gas + gas_amount > GetVehicleMaxFuel(getElementModel(car)) then
		exports.lsrp:showPopup(thePlayer, "Nie zmieści się tyle paliwa do baku.", 5 )
		return
	end

	if not car then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "W pobliżu nie ma żadnego pojazdu!", 5 )
		return
	end

	local set_money = getElementData(thePlayer, "player.cash") - pay
	setElementData(thePlayer, "player.cash", set_money)
	setPlayerMoney(thePlayer, set_money)
	setElementData(car, "vehicle.fuel", getElementData(car, "vehicle.fuel") + gas_amount)
	outputChatBox("#669999Pomyślnie zatankowałeś ".. gas_amount .." litrów za #669966$"..pay.."#669999!", thePlayer, 255, 255, 255, true)
end
addCommandHandler("tankuj", applyPlayerGas)

-- test kolory
function getRotation(thePlayer, command)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	local vehicle_id = gotVehicleID(vehicle)

	local rx, ry, rz = getElementRotation(vehicle)
	outputChatBox("K: "..rx.." "..ry.." "..rz, thePlayer)
end
addCommandHandler("rotacja", getRotation)

-- przejazd
function passingFunction(thePlayer, command)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	local x, y, z = getElementPosition(thePlayer)
	if not vehicle then 
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Musisz być w pojeździe by użyć tej komendy.", 5 )
		return
	end

	local doors = getElementsByType("pickup")
	for i, door in ipairs(doors) do 
		if tonumber(getElementData(door, "door.entervw")) == getElementDimension(thePlayer) then
			local distance = getDistanceBetweenPoints3D(x, y, z, tonumber(getElementData(door, "door.enterx")), tonumber(getElementData(door, "door.entery")), tonumber(getElementData(door,"door.enterz" )))
			if distance < 3 then
				if getElementData(door, "door.exitx") == 0 and getElementData(door, "door.exity") == 0 and getElementData(door, "door.exitz") == 0 then
					exports.lsrp:showDoorInfo(thePlayer, "Drzwi są w trakcie remontu, nie można przejść.", 7, "gamemode_dialogs/lock.png", door )
					return
				end

				if tonumber(getElementData(door, "door.lock")) == 1 then
					local admin = exports.lsrp:getPlayerAdmin( thePlayer )
					if admin ~= 1 then
						exports.lsrp:showPopup(thePlayer, "Te drzwi są zamknięte.", 5 )
						return
					end
				end

				-- przejazd
				local rx, ry, rz = getElementRotation(vehicle)
				setElementRotation(vehicle, rx, ry, tonumber(getElementData(door, "door.exita")))
				setElementInterior(vehicle, tonumber(getElementData(door, "door.exitint")))
				setElementDimension(vehicle, tonumber(getElementData(door, "door.exitvw")))
				setElementPosition(vehicle, tonumber(getElementData(door, "door.exitx")), tonumber(getElementData(door, "door.exity")), tonumber(getElementData(door, "door.exitz")))
			end
		end

		if tonumber(getElementData(door, "door.exitvw")) == getElementDimension(thePlayer) then
			local distance = getDistanceBetweenPoints3D(x, y, z, tonumber(getElementData(door, "door.exitx")), tonumber(getElementData(door, "door.exity")), tonumber(getElementData(door, "door.exitz")))
		
			if distance < 3 then 
				if getElementData(door, "door.exitx") == 0 and getElementData(door, "door.exity") == 0 and getElementData(door, "door.exitz") == 0 then
					exports.lsrp:showDoorInfo(thePlayer, "Drzwi są w trakcie remontu, nie można przejść.", 7, "gamemode_dialogs/lock.png", door )
					return
				end

				if tonumber(getElementData(door, "door.lock")) == 1 then
					local admin = exports.lsrp:getPlayerAdmin( thePlayer )
					if admin ~= 1 then
						exports.lsrp:showPopup(thePlayer, "Te drzwi są zamknięte.", 5 )
						return
					end
				end

				-- przejazd
				-- przejazd
				local rx, ry, rz = getElementRotation(vehicle)
				setElementRotation(vehicle, rx, ry, tonumber(getElementData(door, "door.entera")))
				setElementInterior(vehicle, tonumber(getElementData(door, "door.enterint")))
				setElementDimension(vehicle, tonumber(getElementData(door, "door.entervw")))
				setElementPosition(vehicle, tonumber(getElementData(door, "door.enterx")), tonumber(getElementData(door, "door.entery")), tonumber(getElementData(door, "door.enterz")))
			end
		end
	end
end
addCommandHandler("przejazd", passingFunction)