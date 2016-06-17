-- bw
function setBW(thePlayer, theCommand, theAction, theTarget, theMin)
	if getPlayerAdmin(thePlayer) == ADMIN_LEVEL_NONE then
		showPopup(thePlayer, "Brak uprawnień do użycia tej komendy.", 7)
		return
	end

	if theAction == nil then 
		outputChatBox("#CCCCCCUżycie: /bw [zdejmij | naloz] [ID Gracza] [Czas]", thePlayer, 255, 255, 255, true)
	end

	-- /bw zdejmij
	if theAction == "zdejmij" then
		if theTarget == nil then
			outputChatBox("#CCCCCCUżycie: /bw zdejmij [ID Gracza]", thePlayer, 255, 255, 255, true)
			return
		end

		-- Sprawdź czy jest taki gracz
		local target = getPlayerByID(tonumber(theTarget))
		if not target then
			showPopup(thePlayer, "Nie ma takiego gracza.", 7)
			return
		end

		-- Jeśli niezalogowany
		if (getElementData(target, "player.logged") == false) then
			exports.lsrp:showPopup(thePlayer, "Ten gracz się jeszcze nie zalogował.", 5 )
			return
		end

		local bw_time = tonumber(getElementData(target, "player.bw"))
		if bw_time <= 0 then
			exports.lsrp:showPopup(thePlayer, "Ten gracz nie ma BW.", 5 )
			return
		end

		setElementData(target, "player.bw", 1)
		exports.lsrp:showPopup(thePlayer, "Ściągnąłeś BW graczowi.", 5 )
		exports.lsrp:showPopup(target, "Administrator ściągnął Ci BW!", 5 )

		return
	end

	-- /bw naloz
	if theAction == "naloz" then
		if theTarget == nil or theMin == nil then
			outputChatBox("#CCCCCCUżycie: /bw naloz [ID Gracza] [Czas w minutach]", thePlayer, 255, 255, 255, true)
			return
		end

		-- Sprawdź czy jest taki gracz
		local target = getPlayerByID(tonumber(theTarget))
		if not target then
			showPopup(thePlayer, "Nie ma takiego gracza.", 7)
			return
		end

		-- Jeśli niezalogowany
		if (getElementData(target, "player.logged") == false) then
			exports.lsrp:showPopup(thePlayer, "Ten gracz się jeszcze nie zalogował.", 5 )
			return
		end

		setElementHealth(target, 0)
		setElementData(target, "player.bw", tonumber(theMin) * 60)
		exports.lsrp:showPopup(thePlayer, "Nadałeś BW graczowi.", 5 )

		return
	end
end
addCommandHandler("bw", setBW)

-- res
function resPlayer(thePlayer, theCommand, theTarget)
	if getPlayerAdmin(thePlayer) == ADMIN_LEVEL_NONE then
		showPopup(thePlayer, "Brak uprawnień do użycia tej komendy.", 7)
		return
	end

	if theTarget == nil then 
		outputChatBox("#CCCCCCUżycie: /res [ID Gracza]", thePlayer, 255, 255, 255, true)
		return
	end

	local target = getPlayerByID(tonumber(theTarget))
	if not target then 
		showPopup(thePlayer, "Nie ma takiego gracza.", 7)
		return
	end

	setCameraTarget(target, target)
	setElementDimension(target, 0)
	setElementPosition(target, spawnX, spawnY, spawnZ)
	setElementInterior(target, 0)
end
addCommandHandler("res", resPlayer)

-- tp
function playerSelfTeleport(thePlayer, theCommand, theX, theY, theZ, theInterior, theWorld)
	if getPlayerAdmin(thePlayer) == ADMIN_LEVEL_NONE then
		showPopup(thePlayer, "Brak uprawnień do użycia tej komendy.", 7)
		return
	end

	if theX == nil or theY == nil or theZ == nil then 
		outputChatBox("#CCCCCCUżycie: /tp [Pozycja X] [Pozycja Y] [Pozycja Z] [Interior] [World]", thePlayer, 255, 255, 255, true)
		return 
	end

	setElementPosition(thePlayer, tonumber(theX), tonumber(theY), tonumber(theZ))
	setElementDimension(thePlayer, tonumber(theWorld))
	setElementInterior(thePlayer, tonumber(theInterior))
end
addCommandHandler("tp", playerSelfTeleport)

-- alpha
function setPlayerAlpha(thePlayer, commandName, theTarget, alphaLevel)
	if getPlayerAdmin(thePlayer) == ADMIN_LEVEL_NONE then
		showPopup(thePlayer, "Brak uprawnień do użycia tej komendy.", 7)
		return
	end

	if theTarget == nil or alphaLevel == nil then
		outputChatBox("#CCCCCCUżycie: /setalpha [ID Gracza] [0-255]", thePlayer, 255, 255, 255, true)
		return
	end

	local level = tonumber(alphaLevel)
	local target = getPlayerByID(tonumber(theTarget))
	setElementAlpha(target, level)
end
addCommandHandler("setalpha", setPlayerAlpha)

-- setvw
function setPlayerWorld(thePlayer, commandName, target_id, set_world)
	if getPlayerAdmin(thePlayer) == ADMIN_LEVEL_NONE then
		showPopup(thePlayer, "Brak uprawnień do użycia tej komendy.", 7)
		return
	end

	if target_id == nil or set_world == nil then
		outputChatBox("#CCCCCCUżycie: /setvw [ID Gracza] [ID Świata]", thePlayer, 255, 255, 255, true)
		return
	end

	local target = getPlayerByID(tonumber(target_id))
	if not target then
		showPopup(thePlayer, "Wskazany przez Ciebie gracz nie jest podłączony do serwera.", 5)
		return
	end

	setElementDimension(target, tonumber(set_world))
end
addCommandHandler("setvw", setPlayerWorld)

-- specowanie
function specPlayer(thePlayer, commandName, target_id)
	if getPlayerAdmin(thePlayer) == ADMIN_LEVEL_NONE then
		showPopup(thePlayer, "Brak uprawnień do użycia tej komendy.", 7)
		return
	end

	if target_id == nil then
		setCameraTarget(thePlayer)
		--setElementFrozen (thePlayer, false)
		setElementAlpha(thePlayer, 255)
		detachElements(thePlayer, getPlayerByID(tonumber(target_id)))
	else
		setElementDimension(thePlayer, getElementDimension(getPlayerByID(tonumber(target_id))))
		setCameraTarget(thePlayer, getPlayerByID(tonumber(target_id)))
		--setElementFrozen (thePlayer, true)
		setElementAlpha(thePlayer, 0)
		attachElements ( thePlayer, getPlayerByID(tonumber(target_id)), 0.0, 0.0, 5.0 )
	end
end
addCommandHandler("spec", specPlayer)

-- teleportowanie
function teleportToMe(thePlayer, command, who)
	if getPlayerAdmin(thePlayer) ~= ADMIN_LEVEL_NONE then
		local target = getPlayerByID(tonumber(who))

		if who == nil then
			outputChatBox("#CCCCCCUżycie: /gethere [ID Gracza]", thePlayer, 255, 255, 255, true)
			return
		end

		if target == false then
			showPopup(thePlayer, "Wskazany przez Ciebie gracz nie jest podłączony do serwera, nie można się do niego przeteleportować.", 5)
			return
		end

		local x, y, z = getElementPosition(thePlayer)
		x = x + 2
		setElementPosition(target, x, y, z)
		setElementDimension(target, getElementDimension(thePlayer))
		setElementInterior(target, getElementInterior(thePlayer))
	else
		-- msg ze nie ma upr
		showPopup(thePlayer, "Brak uprawnień do użycia tej komendy.", 7)
		return
	end
end
addCommandHandler("gethere", teleportToMe)

-- teleportowanie
function teleportToPlayer(thePlayer, command, toWho)
	if getPlayerAdmin(thePlayer) ~= ADMIN_LEVEL_NONE then
		local target = getPlayerByID(tonumber(toWho))

		if toWho == nil then
			outputChatBox("#CCCCCCUżycie: /goto [ID Gracza]", thePlayer, 255, 255, 255, true)
			return
		end

		if target == false then
			showPopup(thePlayer, "Wskazany przez Ciebie gracz nie jest podłączony do serwera, nie można się do niego przeteleportować.", 5)
			return
		end

		local x, y, z = getElementPosition(target)
		x = x + 2
		setElementPosition(thePlayer, x, y, z)
		setElementDimension(thePlayer, getElementDimension(target))
		setElementInterior(thePlayer, getElementInterior(target))
	else
		-- msg ze nie ma upr
		showPopup(thePlayer, "Brak uprawnień do użycia tej komendy.", 7)
		return
	end
end
addCommandHandler("goto", teleportToPlayer)

-- zmiana koloru
function changePlayerColor(thePlayer, command)
	if getPlayerAdmin(thePlayer) ~= ADMIN_LEVEL_ADM then
		showPopup(thePlayer, "Brak uprawnień do użycia tej komendy.", 7)
		return
	end

	local color = tonumber(getElementData(thePlayer, "player.color"))
	if color > 4 then
		setElementData(thePlayer, "player.color", 0)
	else
		color = color + 1
		setElementData(thePlayer, "player.color", color)
	end

	showPopup(thePlayer, "Zmieniłeś kolor swojej rangi. (Nowy kolor: ".. rank[color] ..")", 7)
end
addCommandHandler("kolor", changePlayerColor)

-- ustawianie skina
function setPlayerNewSkin(thePlayer, command, toWho, skinId)
	if getPlayerAdmin(thePlayer) ~= ADMIN_LEVEL_NONE then
		setElementModel(getPlayerByID(tonumber(toWho)), tonumber(skinId))
		setElementData(getPlayerByID(tonumber(toWho)), "player.skin", tonumber(skinId))
	else
		showPopup(thePlayer, "Brak uprawnień do użycia tej komendy.", 7)
		return
	end 
end
addCommandHandler("setskin", setPlayerNewSkin)

-- Ustawianie HP
function setPlayerNewHealth(thePlayer, command, toWho, amount)
	if getPlayerAdmin(thePlayer) ~= ADMIN_LEVEL_NONE then
		local target = getPlayerByID(tonumber(toWho))

		if toWho ~= nil and amount ~= nil then
			-- wpisane, nadaj HP

			if target == false then
				showPopup(thePlayer, "Ten gracz nie jest podłączony do serwera.", 5)
				return
			end

			local amount = tonumber(amount)
			setElementHealth(target, amount)
			outputChatBox("#CCCCCCUstawiono graczowi #0099FF"..playerRealName(target).."#CCCCCC punkty zdrowia na: #0099FF"..amount, thePlayer, 255, 255, 255, true)
		else
			outputChatBox("#CCCCCCUżycie: /sethp [ID Gracza] [Ilość HP]", thePlayer, 255, 255, 255, true)
			return
		end
	else 
		showPopup(thePlayer, "Brak uprawnień do użycia tej komendy.", 7)
		return
	end
end
addCommandHandler("sethp", setPlayerNewHealth)

function getMyData ( thePlayer, command )
	if getElementData(thePlayer, "player.admin") ~= 1 then
		return
	end

    local data = getAllElementData ( thePlayer )     -- get all the element data of the player who entered the command
    for k, v in pairs ( data ) do                    -- loop through the table that was returned
        outputConsole ( k .. ": " .. tostring ( v ) )             -- print the name (k) and value (v) of each element data, we need to make the value a string, since it can be of any data type
    end
end
addCommandHandler ( "data", getMyData )