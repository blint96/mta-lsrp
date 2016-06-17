--[[
-------------------------------------------
-- Tablica na calle
-------------------------------------------
]]--
calls = {}
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), 
	function() 
		for i=0, 300 do
			calls[i] = {}
			calls[i]["call_enable"] = false			-- czy wolne
			calls[i]["call_make"] = 0				-- kto dzwoni
			calls[i]["call_towho"] = 0				-- do kogo
			calls[i]["call_response"] = false		-- czy odebrane
		end
	end
)

--
-- RETURN: ID of free CALL or false
--
function getFreeCallID()
	local free_id = false
	for i=0, 300 do
		if calls[i]["call_enable"] == false then
			free_id = i
			break
		end
	end

	return free_id
end

--
-- RETURN: Call ID or false
--
function isNumberBusy(theNumber)
	local call_id = false
	for i=0, 300 do
		if calls[i]["call_make"] == theNumber then
			call_id = i
			break
		end

		if calls[i]["call_towho"] == theNumber then
			call_id = i
			break
		end
	end

	return call_id
end

--
-- RETURN: Player elem or false
--
function getPlayerByNumber(number)
	local players = getElementsByType("player")
	for key, player in ipairs(players) do 
		if tonumber(getElementData(player, "player.phonenumber")) == number then 
			return player
		end
	end
	return false
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

-- /tel
function telCmd(thePlayer, theCmd, theNumber)
	if theNumber == nil then 
		outputChatBox("Użycie: /tel [Numer telefonu]", thePlayer, 200, 200, 200, false)
		return
	end

	local p_number = tonumber(getElementData(thePlayer, "player.phonenumber"))
	local call_id = isNumberBusy(p_number)

	if (p_number < 1) then 
		outputChatBox("» Aby wykonać połączenie musisz mieć telefon w użyciu.", thePlayer, 204, 204, 0, false)
		return
	end

	if (call_id) then 
		outputChatBox("» Prowadzisz już jakąś rozmowę.", thePlayer, 204, 204, 0, false)
		return
	end

	makeCallFunc(thePlayer, tonumber(theNumber))
end
addCommandHandler("tel", telCmd)

-- /t
function phoneSay(thePlayer, theCmd, ...)
	local p_number = tonumber(getElementData(thePlayer, "player.phonenumber"))
	local call_id = isNumberBusy(p_number)

	if call_id then 
		if calls[call_id]["call_response"] == true then 
			local caller = getPlayerByNumber(calls[call_id]["call_make"])
			local called = getPlayerByNumber(calls[call_id]["call_towho"])

			local phoneMsgTable = {...}
			local phoneMsg = table.concat(phoneMsgTable, " ")

			if thePlayer == caller then 
				-- wyślij do calleda
				outputChatBox("Telefon: "..phoneMsg, called, 204, 204, 0, false)
			else
				-- wyślij do callera
				outputChatBox("Telefon: "..phoneMsg, caller, 204, 204, 0, false)
			end

			-- Dodaj do czatu IC
			local output = exports.lsrp:playerRealName(thePlayer).." mówi (telefon): "..firstToUpper(phoneMsg)
			local posX, posY, posZ = getElementPosition( thePlayer )
			local chatSphere = createColSphere( posX, posY, posZ, 25 )
			local nearbyPlayers = getElementsWithinColShape( chatSphere, "player" )

			for index, nearbyPlayer in ipairs( nearbyPlayers ) do
				local ox, oy, oz = getElementPosition(nearbyPlayer)
				local distance = getDistanceBetweenPoints2D(posX, posY, ox, oy)

				if distance < 2 then
					outputChatBox( "#FFFFFF"..output, nearbyPlayer, 255, 255, 255, true)
				elseif distance < 4 then
					outputChatBox( "#EEEEEE"..output, nearbyPlayer, 255, 255, 255, true)
				elseif distance < 6 then
					outputChatBox( "#DDDDDD"..output, nearbyPlayer, 255, 255, 255, true)
				elseif distance < 8 then
					outputChatBox( "#CCCCCC"..output, nearbyPlayer, 255, 255, 255, true)
				else
					outputChatBox( "#BBBBBB"..output, nearbyPlayer, 255, 255, 255, true)
				end
			end

			-- optymalizacja
			destroyElement(chatSphere)
		else 
			outputChatBox("» Nie prowadzisz teraz żadnej rozmowy.", thePlayer, 204, 204, 0, false)
		end
	else 
		outputChatBox("» Nie prowadzisz teraz żadnej rozmowy.", thePlayer, 204, 204, 0, false)
	end
end
addCommandHandler("t", phoneSay)

-- /odbierz /od
function responseCommand(thePlayer, theCmd)
	local p_number = tonumber(getElementData(thePlayer, "player.phonenumber"))
	local call_id = isNumberBusy(p_number)

	if call_id then 

		-- Trochę zmiennych
		local caller = getPlayerByNumber(calls[call_id]["call_make"])
		local called = getPlayerByNumber(calls[call_id]["call_towho"])

		-- Odebrał, zmieniaimy status rozmowy
		calls[call_id]["call_response"] = true

		-- Trochę informacji i mamy atomówki
		outputChatBox("» Ktoś odebrał telefon, używaj komendy /t by mówić do telefonu", caller, 204, 204, 0, false)
		outputChatBox("» Podniosłeś słuchawkę, aby mówić do telefonu użyj komendy /t", called, 204, 204, 0, false)
	end
end
addCommandHandler("od", responseCommand)
addCommandHandler("odbierz", responseCommand)

-- /zakoncz /z
function cancelCommand(thePlayer, theCmd)
	local p_number = tonumber(getElementData(thePlayer, "player.phonenumber"))
	local call_id = isNumberBusy(p_number)

	if call_id then 

		-- Trochę zmiennych
		local caller = getPlayerByNumber(calls[call_id]["call_make"])
		local called = getPlayerByNumber(calls[call_id]["call_towho"])

		-- Czyścimy
		calls[call_id]["call_enable"] = false
		calls[call_id]["call_response"] = false
		calls[call_id]["call_make"] = 0
		calls[call_id]["call_towho"] = 0

		-- Trochę informacji i mamy atomówki
		outputChatBox("» Połączenie zostało przerwane.", caller, 204, 204, 0, false)
		outputChatBox("» Połączenie zostało przerwane.", called, 204, 204, 0, false)
	end
end
addCommandHandler("z", cancelCommand)
addCommandHandler("zakoncz", cancelCommand)

-- SMSiki