local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

function adminDoorControl(thePlayer, command, action, var1, var2, var3, ...)
	-- sprawdź admina
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	if (padmin ~= 1) then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Brak uprawnień do użycia tej komendy.", 5 )
		return
	end

	-- nie ma akcji
	if (action == nil) then
		outputChatBox("#CCCCCCUżycie: /ad [ stworz | wejscie | wyjscie | entervw | exitvw | usun | nazwa | przypisz | goto ]", thePlayer, 255, 255, 255, true)
		return
	end

	-- interior
	-- Dodać tutaj wybierałkę interiorów od R*

	if (action == "info") then
		if var1 == nil then
			outputChatBox("#CCCCCCUżycie: /ad info [ID Drzwi]", thePlayer, 255, 255, 255, true)
			return
		end

		local door_id = tonumber(var1)
		local door = getDoorByID(door_id)
		if not door then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Takie drzwi nie istnieją.", 5 )
			return
		end

		triggerClientEvent(thePlayer, "showDoorInfoView", thePlayer, door)
	end

	-- goto
	if (action == "goto") then
		if var1 == nil then
			outputChatBox("#CCCCCCUżycie: /ad goto [ID Drzwi]", thePlayer, 255, 255, 255, true)
			return
		end

		local door_id = tonumber(var1)
		local door = getDoorByID(door_id)
		if not door then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Takie drzwi nie istnieją.", 5 )
			return
		end

		local x, y, z = getElementPosition(door)
		setElementDimension(thePlayer, getElementDimension(door))
		setElementInterior(thePlayer, getElementInterior(door))
		setElementPosition(thePlayer, x, y, z)
	end

	-- pickup
	if (action == "pickup") then
		if var1 == nil or var2 == nil then
			outputChatBox("#CCCCCCUżycie: /ad pickup [ID Drzwi] [ID Pickupa]", thePlayer, 255, 255, 255, true)
			return
		end

		local door_id = tonumber(var1)
		local door = getDoorByID(door_id)
		if not door then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Takie drzwi nie istnieją.", 5 )
			return
		end

		local pickup = tonumber(var2)

		local query = dbQuery(handler, "UPDATE lsrp_doors SET door_pickup = "..pickup.." WHERE door_uid = "..getElementData(door, "door.uid"))
		dbFree(query)

		-- Informacja
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Pomyślnie edytowano drzwi!", 5 )

		ReloadDoor(door_id)
		return
	end

	-- entervw
	if (action == "entervw") then
		if (var1 == nil or var2 == nil) then
			outputChatBox("#CCCCCCUżycie: /ad entervw [ID Drzwi] [Świat]", thePlayer, 255, 255, 255, true)
			return
		end

		local door_id = tonumber(var1)
		local door = getDoorByID(door_id)
		if not door then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Takie drzwi nie istnieją.", 5 )
			return
		end

		local entervw = tonumber(var2)

		if entervw < 0 then
			outputChatBox("#CCCCCCUżycie: /ad entervw [ID Drzwi] [Świat] - tylko światy dodatnie", thePlayer, 255, 255, 255, true)
			return
		end

		-- Informacja
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Pomyślnie edytowano drzwi!", 5 )

		exports.rp_logs:log_AdminLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") zmienił world wyjściowy drzwi "..getElementData(door, "door.name").." (UID: ".. getElementData(door, "door.uid") ..")")
		local query = dbQuery(handler, "UPDATE lsrp_doors SET door_entervw = "..entervw.." WHERE door_uid = "..getElementData(door, "door.uid"))
		if query then dbFree(query) end
		setElementData(door, "door.entervw", tonumber(var2))
		setElementDimension(door, entervw)
	end

	-- wejście
	if (action == "wejscie") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /ad wejscie [ID Drzwi]", thePlayer, 255, 255, 255, true)
			return
		end

		local door_id = tonumber(var1)
		local door = getDoorByID(door_id)
		if not door then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Takie drzwi nie istnieją.", 5 )
			return
		end

		local x, y, z = getElementPosition(thePlayer)
		local _, _, a = getElementRotation(thePlayer)
		local query = dbQuery(handler, "UPDATE lsrp_doors SET door_enterx = "..x..", door_entery = "..y..", door_enterz = "..z..", door_entera = "..a.." WHERE door_uid = "..getElementData(door, "door.uid"))
		dbFree(query)

		setElementData(door, "door.enterx", x)
		setElementData(door, "door.entery", y)
		setElementData(door, "door.enterz", z)
		setElementData(door, "door.entera", a)

		-- Informacja
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Pomyślnie edytowano drzwi!", 5 )

		setElementPosition(door, x, y, z)
		exports.rp_logs:log_AdminLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") zmienił wyjście drzwi "..getElementData(door, "door.name").." (UID: ".. getElementData(door, "door.uid") ..")")
	end

	-- przypisywanie
	if (action == "przypisz") then
		if (var1 == nil or var2 == nil or var3 == nil) then
			-- trzeba im przypomnieć, że UID a nie ID
			outputChatBox("#CCCCCCUżycie: /ad przypisz [ID Drzwi] grupa/gracz [UID Właściciela]", thePlayer, 255, 255, 255, true)
			return
		end

		local door_id = tonumber(var1)
		local door = getDoorByID(door_id)

		if not door then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Takie drzwi nie istnieją.", 5 )
			return
		end

		local new_owner = tonumber(var3)
		if var2 == "grupa" then
			-- przypisywanie pod grupe
			local query = dbQuery(handler, "UPDATE lsrp_doors SET door_owner = "..new_owner..", door_ownertype = 5 WHERE door_uid = "..getElementData(door, "door.uid"))
			if query then dbFree(query) end

			setElementData(door, "door.owner", new_owner)
			setElementData(door, "door.ownertype", 5)

			exports.rp_logs:log_AdminLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") przypisał drzwi "..getElementData(door, "door.name").." (UID: ".. getElementData(door, "door.uid") ..") pod grupe (UID: "..new_owner..")")
		elseif var2 == "gracz" then
			-- przypisywanie pod gracza
			local player = exports.lsrp:getPlayerByID(new_owner);
			if player == false then
				outputChatBox("#CCCCCCUżycie: /ad przypisz [ID Drzwi] gracz [ID Właściciela]", thePlayer, 255, 255, 255, true)
				return
			end

			local query = dbQuery(handler, "UPDATE lsrp_doors SET door_owner = "..tonumber(getElementData(player, "player.uid"))..", door_ownertype = 1 WHERE door_uid = "..getElementData(door, "door.uid"))
			if query then dbFree(query) end

			setElementData(door, "door.owner", tonumber(getElementData(player, "player.uid")))
			setElementData(door, "door.ownertype", 1)

			exports.rp_logs:log_AdminLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") przypisał drzwi "..getElementData(door, "door.name").." (UID: ".. getElementData(door, "door.uid") ..") pod gracza (UID: "..tonumber(getElementData(player, "player.uid"))..")")
		else
			-- nic, bo nie bedzie takiej sytuacji
		end

		-- Informacja
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Pomyślnie edytowano drzwi!", 5 )
	end

	-- nazwa

	-- tworzenie drzwi
	if (action == "stworz") then
		local x, y, z = getElementPosition(thePlayer)
		local rx, ry, rz = getElementRotation(thePlayer)

		local door_name = tostring(table.concat({var1, var2, var3, ...}, " "))
		if door_name == nil then
			outputChatBox("#CCCCCCUżycie: /ad stworz [Nazwa drzwi]", thePlayer, 255, 255, 255, true)
			return
		end

		-- Informacja
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Pomyślnie stworzono drzwi!", 5 )

		local door = CreateDoor(door_name, x, y, z, rz, getElementInterior(thePlayer), getElementDimension(thePlayer))
		exports.rp_logs:log_AdminLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") stworzył drzwi "..door_name.." (UID: ".. getElementData(door, "door.uid") ..")")
		return 
	end

	-- wyjscie
	if (action == "wyjscie") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /ad wyjscie [ID Drzwi]", thePlayer, 255, 255, 255, true)
			return
		end

		local door_id = tonumber(var1)
		local door = getDoorByID(door_id)
		if not door then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Takie drzwi nie istnieją.", 5 )
			return
		end

		local x, y, z = getElementPosition(thePlayer)
		local _, _, a = getElementRotation(thePlayer)
		local query = dbQuery(handler, "UPDATE lsrp_doors SET door_exitx = "..x..", door_exity = "..y..", door_exitz = "..z..", door_exita = "..a..", door_exitint = ".. getElementInterior(thePlayer) .." WHERE door_uid = "..getElementData(door, "door.uid"))
		dbFree(query)

		-- Informacja
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Pomyślnie edytowano drzwi!", 5 )

		setElementData(door, "door.exitx", x)
		setElementData(door, "door.exity", y)
		setElementData(door, "door.exitz", z)
		setElementData(door, "door.exita", a)
		setElementData(door, "door.exitint", getElementInterior(thePlayer))

		exports.rp_logs:log_AdminLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") zmienił wyjście drzwi "..getElementData(door, "door.name").." (UID: ".. getElementData(door, "door.uid") ..")")
	end

	-- exitvw
	if (action == "exitvw") then
		if (var1 == nil or var2 == nil) then
			outputChatBox("#CCCCCCUżycie: /ad exitvw [ID Drzwi] [Świat]", thePlayer, 255, 255, 255, true)
			return
		end

		local door_id = tonumber(var1)
		local door = getDoorByID(door_id)
		if not door then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Takie drzwi nie istnieją.", 5 )
			return
		end

		local exitvw = tonumber(var2)

		if exitvw < 0 then
			outputChatBox("#CCCCCCUżycie: /ad exitvw [ID Drzwi] [Świat] - tylko światy dodatnie", thePlayer, 255, 255, 255, true)
			return
		end

		-- Informacja
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Pomyślnie edytowano drzwi!", 5 )

		exports.rp_logs:log_AdminLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") zmienił world wyjściowy drzwi "..getElementData(door, "door.name").." (UID: ".. getElementData(door, "door.uid") ..")")
		local query = dbQuery(handler, "UPDATE lsrp_doors SET door_exitvw = "..exitvw.." WHERE door_uid = "..getElementData(door, "door.uid"))
		if query then dbFree(query) end
		setElementData(door, "door.exitvw", tonumber(var2))
	end

	-- usuwanie drzwi
	if (action == "usun") then
		if (var1 == nil) then
			outputChatBox("#CCCCCCUżycie: /ad usun [ID Drzwi]", thePlayer, 255, 255, 255, true)
			return
		end

		local door_id = tonumber(var1)
		if door_id <= 0 then
			outputChatBox("#CCCCCCUżycie: /ad usun [ID Drzwi]", thePlayer, 255, 255, 255, true)
			return
		end

		local door = getDoorByID(door_id)
		if not door then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie ma takich drzwi.", 5 )
			return
		end

		exports.rp_logs:log_AdminLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") usunął drzwi "..getElementData(door, "door.name").." (UID: ".. getElementData(door, "door.uid") ..")")
		DeleteDoor(door_id)
		return
	end
end
addCommandHandler("ad", adminDoorControl)

function userDoorControl(thePlayer, command, action, var1)
	if action == nil then
		outputChatBox("#CCCCCCUżycie: /drzwi [zamknij | info | sprzedaj | opcje]", thePlayer, 255, 255, 255, true)
		return
	end
 
	if action == "info" then
		local world = getElementDimension(thePlayer)
		if world == 0 then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Musisz znajdować się w budynku by użyć tej komendy.", 5 )
			return
		end

		local door = getDoorByWorld(world)
		if door == false then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Musisz znajdować się w budynku by użyć tej komendy.", 5 )
			return 
		end

		local owner_type = tonumber(getElementData(door, "door.ownertype"))
		local owner = tonumber(getElementData(door, "door.owner"))
		if owner_type == 1 then
			if owner ~= tonumber(getElementData(thePlayer, "player.uid")) then
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten budynek nie należy do Ciebie.", 5 )
				return
			end

			-- pokaż info
			triggerClientEvent(thePlayer, "showDoorInfoView", thePlayer, door)
		elseif owner_type == 5 then
			--[[
				D INFO DLA GRUP
				D INFO DLA GRUP
				D INFO DLA GRUP
				D INFO DLA GRUP
			]] --
			local group_uid = tonumber(getElementData(door, "door.owner"))
			local group_id = exports.rp_groups:GetGroupID(group_uid)

			if (exports.rp_groups:IsPlayerInGroup(thePlayer, group_id)) then 
				triggerClientEvent(thePlayer, "showDoorInfoView", thePlayer, door)
			else
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten budynek nie należy do Ciebie.", 5 )
			end
		else
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten budynek nie należy do Ciebie.", 5 )
		end
	end

	if action == "zamknij" then
		-- wiadomo
		local world = getElementDimension(thePlayer)
		local doors = getElementsByType("pickup")
		local x, y, z = getElementPosition(thePlayer)

		local toggled = false
		local find = false

		for i, door in ipairs(doors) do 
			-- wejście
			if tonumber(getElementData(door, "door.entervw")) == getElementDimension(thePlayer) then
				local distance = getDistanceBetweenPoints2D(x, y, tonumber(getElementData(door, "door.enterx")), tonumber(getElementData(door, "door.entery")))
				if distance < 3 then
					-- właściciel gracz
					find = true
					if tonumber(getElementData(door, "door.owner")) == tonumber(getElementData(thePlayer, "player.uid")) then
						if tonumber(getElementData(door, "door.ownertype")) == 1 then
							toggled = true
							if tonumber(getElementData(door, "door.lock")) == 1 then
								setElementData(door, "door.lock", 0)
								outputChatBox("Drzwi zostały otwarte.", thePlayer)
							else
								setElementData(door, "door.lock", 1)
								outputChatBox("Drzwi zostały zamknięte.", thePlayer)
							end

							local query = dbQuery(handler, "UPDATE lsrp_doors SET door_lock = "..tonumber(getElementData(door, "door.lock")).." WHERE door_uid = "..tonumber(getElementData(door, "door.uid")))
							if query then dbFree(query) end
						end
					end

					-- właściciel grupa
					-- 1. sprawdź do jakiej grupy i czy w ogóle do grupy należy
					-- 2. sprawdź jaki to ID grupy
					-- 3. sprawdź czy gracz jest w tej grupie
					-- 4. sprawdź czy ma permy do otwierania drzwi
					if tonumber(getElementData(door, "door.ownertype")) == 5 then
						local group_uid = tonumber(getElementData(door, "door.owner"))
						local group_id = exports.rp_groups:GetGroupID(group_uid)
						if (exports.rp_groups:IsPlayerInGroup(thePlayer, group_id)) then 
							if ( exports.rp_groups:IsPlayerHasPermTo(thePlayer, group_id, 32) ) then
								toggled = true
								if tonumber(getElementData(door, "door.lock")) == 1 then
									setElementData(door, "door.lock", 0)
									outputChatBox("Drzwi zostały otwarte.", thePlayer)
								else
									setElementData(door, "door.lock", 1)
									outputChatBox("Drzwi zostały zamknięte.", thePlayer)
								end
							else
								call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie posiadasz kluczy do tych drzwi.", 5 )
							end
						else
							call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie posiadasz kluczy do tych drzwi.", 5 )
						end
					end

					break
				end
			end

			-- wyjście
			if tonumber(getElementData(door, "door.exitvw")) == getElementDimension(thePlayer) then
				local distance = getDistanceBetweenPoints2D(x, y, tonumber(getElementData(door, "door.exitx")), tonumber(getElementData(door, "door.exity")))
				if distance < 3 then
					find = true

					-- właściciel gracz
					if tonumber(getElementData(door, "door.owner")) == tonumber(getElementData(thePlayer, "player.uid")) then
						if tonumber(getElementData(door, "door.ownertype")) == 1 then
							toggled = true
							if tonumber(getElementData(door, "door.lock")) == 1 then
								setElementData(door, "door.lock", 0)
								outputChatBox("Drzwi zostały otwarte.", thePlayer)
							else
								setElementData(door, "door.lock", 1)
								outputChatBox("Drzwi zostały zamknięte.", thePlayer)
							end

							local query = dbQuery(handler, "UPDATE lsrp_doors SET door_lock = "..tonumber(getElementData(door, "door.lock")).." WHERE door_uid = "..tonumber(getElementData(door, "door.uid")))
							if query then dbFree(query) end
						end
					end

					--właściciel grupa

					break
				end
			end
		end

		if toggled == false and find == false then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "W pobliżu nie ma żadnych drzwi.", 5 )
		end

		if find == true and toggled == false then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie posiadasz kluczy do tego budynku.", 5 )
		end
	end
end
addCommandHandler("drzwi", userDoorControl)

function getPlayerWorldCommand(thePlayer, command)
	local world = getElementDimension(thePlayer)
	outputChatBox("#CCCCCCTwój świat: "..world, thePlayer, 255, 255, 255, true)
end
addCommandHandler("getvw", getPlayerWorldCommand)