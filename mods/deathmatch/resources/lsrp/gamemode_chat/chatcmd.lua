-- /re
function wrCommand(thePlayer, commandName, ...)
	if getElementData(thePlayer, "player.lastw") == false then
		exports.lsrp:showPopup(thePlayer, "Nie pisałeś do nikogo w ostatnim czasie.", 5 )
		return
	end

	local msg_to_send = table.concat({...}, " ")
	local select_id = tonumber(getElementData(thePlayer, "player.lastw"))

	if (msg_to_send == nil) then
		outputChatBox("#CCCCCCUżycie: /wr [Wiadomość]", thePlayer, 255, 255, 255, true)
		return
	end

	local gainer = getPlayerByID(select_id)
	if not gainer then
		exports.lsrp:showPopup(thePlayer, "Taki gracz nie jest podłączony do serwera.", 5 )
		return
	end

	if (getElementData(gainer, "player.logged") == false) then
		exports.lsrp:showPopup(thePlayer, "Ten gracz się jeszcze nie zalogował.", 5 )
		return
	end

	if (gainer == thePlayer) then
		exports.lsrp:showPopup(thePlayer, "Nie możesz napisać sam do siebie.", 5 )
		return 
	end

	-- Kolorki do czatu
	setElementData(thePlayer, "player.lastw", select_id)
	local color = tonumber(getElementData(thePlayer, "player.color"))
	local message = "#FF9900(( "..rank_col[color]..getElementData(thePlayer, "player.gname").."#FF9900 ["..getPlayerID(thePlayer).."]: "..msg_to_send.." ))"
	outputChatBox(message, gainer, 255, 255, 255, true)

	color = tonumber(getElementData(gainer, "player.color"))
	message = "#FFCC33(( » "..rank_col[color]..getElementData(gainer, "player.gname").."#FFCC33 ["..getPlayerID(gainer).."]: "..msg_to_send.." ))"
	outputChatBox(message, thePlayer, 255, 255, 255, true)
end
addCommandHandler("wr", wrCommand)

-- /i
function iCommand(player, commandName, ...)
	if getPlayerAdmin(player) < 1 then
		showPopup(player, "Brak uprawnień do użycia tej komendy.", 7)
		return 
	end

	local ac_array = {...}
	local ac_text = table.concat(ac_array, " ")

	if #ac_array <= 0 then
		outputChatBox("#CCCCCCUżycie: /ac [Wiadomość]", player, 255, 255, 255, true)
		return
	end

	local adminColor = tonumber(getElementData(player, "player.color"))
	local out_message = "#FFFFFF(( "..rank_col[adminColor]..getElementData(player, "player.gname").."#FFFFFF: "..ac_text.." ))"

	for index, p in ipairs(getElementsByType("player")) do
		outputChatBox( out_message, p, 255, 255, 255, true)
	end
end
addCommandHandler("i", iCommand)

-- /stats
function statsCommand(thePlayer, commandName, theTarget)
	if theTarget == nil then
		-- pokaż stats thePlayer
		triggerClientEvent(thePlayer, "showPlayerStats", thePlayer, thePlayer)
	else
		if tonumber(getElementData(thePlayer, "player.admin")) ~= 0 then
			-- pokaż stats theTarget
			if not isElement(getPlayerByID(tonumber(theTarget))) then
				triggerClientEvent(thePlayer, "showPlayerStats", thePlayer, thePlayer)
				return
			end

			if getElementData(getPlayerByID(tonumber(theTarget)), "player.logged") ~= true then
				triggerClientEvent(thePlayer, "showPlayerStats", thePlayer, thePlayer)
				return
			end

			triggerClientEvent(thePlayer, "showPlayerStats", thePlayer, getPlayerByID(tonumber(theTarget)))
		else
			-- pokaż stats thePlayer
			triggerClientEvent(thePlayer, "showPlayerStats", thePlayer, thePlayer)
		end
	end
end
addCommandHandler("stats", statsCommand)

-- /w - whisper
function wCommand(thePlayer, commandName, toWho, ...)
	local msg_to_send = table.concat({...}, " ")
	local select_id = tonumber(toWho)

	if (toWho == nil or msg_to_send == nil) then
		outputChatBox("#CCCCCCUżycie: /w [ID Gracza] [Wiadomość]", thePlayer, 255, 255, 255, true)
		return
	end

	local gainer = getPlayerByID(select_id)
	if not gainer then
		exports.lsrp:showPopup(thePlayer, "Taki gracz nie jest podłączony do serwera.", 5 )
		return
	end

	if (getElementData(gainer, "player.logged") == false) then
		exports.lsrp:showPopup(thePlayer, "Ten gracz się jeszcze nie zalogował.", 5 )
		return
	end

	if (gainer == thePlayer) then
		exports.lsrp:showPopup(thePlayer, "Nie możesz napisać sam do siebie.", 5 )
		return 
	end

	-- Kolorki do czatu
	setElementData(thePlayer, "player.lastw", select_id)
	local color = tonumber(getElementData(thePlayer, "player.color"))
	local message = "#FF9900(( "..rank_col[color]..getElementData(thePlayer, "player.gname").."#FF9900 ["..getPlayerID(thePlayer).."]: "..msg_to_send.." ))"
	outputChatBox(message, gainer, 255, 255, 255, true)

	color = tonumber(getElementData(gainer, "player.color"))
	message = "#FFCC33(( » "..rank_col[color]..getElementData(gainer, "player.gname").."#FFCC33 ["..getPlayerID(gainer).."]: "..msg_to_send.." ))"
	outputChatBox(message, thePlayer, 255, 255, 255, true)
end
addCommandHandler("w", wCommand)

-- /ac
function acCommand(player, commandName, ...)
	if getPlayerAdmin(player) == ADMIN_LEVEL_NONE then
		showPopup(player, "Brak uprawnień do użycia tej komendy.", 7)
		return 
	end

	local ac_array = {...}
	local ac_text = table.concat(ac_array, " ")

	if #ac_array <= 0 then
		outputChatBox("#CCCCCCUżycie: /ac [Wiadomość]", player, 255, 255, 255, true)
		return
	end

	local adminColor = tonumber(getElementData(player, "player.color"))
	local out_message = "#CCCC99(( #990000[AC] "..rank_col[adminColor]..getElementData(player, "player.gname").."#CCCC99: "..ac_text.." ))"

	for index, p in ipairs(getElementsByType("player")) do
		if tonumber(getElementData(p, "player.admin")) == 1 then
			outputChatBox( out_message, p, 255, 255, 255, true)
		end
	end
end
addCommandHandler("ac", acCommand)

-- /gc
function gcCommand(player, commandName, ...)
	if getPlayerAdmin(player) == ADMIN_LEVEL_NONE then
		showPopup(player, "Brak uprawnień do użycia tej komendy.", 7)
		return 
	end

	local do_array = {...}
	local do_text = table.concat(do_array, " ")

	if #do_array <= 0 then
		outputChatBox("#CCCCCCUżycie: /gc [Wiadomość]", player, 255, 255, 255, true)
		return
	end

	local adminColor = tonumber(getElementData(player, "player.color"))
	local out_message = "#00CCFF(( #3399CC[GC] "..rank_col[adminColor]..getElementData(player, "player.gname").."#00CCFF: "..do_text.." ))"

	for index, p in ipairs( getElementsByType("player") ) do
		if tonumber(getElementData(p, "player.admin")) ~= 0 then
        	outputChatBox( out_message, p, 255, 255, 255, true)
        end
    end
end
addCommandHandler ( "gc", gcCommand )

-- /do
function doCommand(player, commandName, ...)
	local do_array = {...}
	local do_text = table.concat(do_array, " ")

	if #do_array <= 0 then
		outputChatBox("#CCCCCCUżycie: /do [Sytuacja]", player, 255, 255, 255, true)
		return
	end

	local message = "#9999CC** " .. do_text .. " (( " .. playerRealName(player) .. " ))"
	local posX, posY, posZ = getElementPosition( player )
	local chatSphere = createColSphere( posX, posY, posZ, 10 )
	local nearbyPlayers = getElementsWithinColShape( chatSphere, "player" )

	for index, nearbyPlayer in ipairs( nearbyPlayers ) do
        outputChatBox( message, nearbyPlayer, 255, 255, 255, true)
    end

    destroyElement(chatSphere) -- optymalizacja
end
addCommandHandler ( "do", doCommand )

-- /b
function bCommand(player, commandName, ...)
	local b_array = {...}
	local b_text = table.concat(b_array, " ")

	if #b_array <= 0 then
		outputChatBox("#CCCCCCUżycie: /b [Wiadomość]", player, 255, 255, 255, true)
		return
	end

	-- pozycja piszącego
	local x, y, z = getElementPosition(player)

	--message = "#666666(( #FFFFFF".. rank_col[getElementData(player, "player.color")] ..getElementData(player, "player.gname").." #666666[".. getElementData(player, "id") .."]: " ..b_text.." ))"
	local posX, posY, posZ = getElementPosition( player )
	local chatSphere = createColSphere( posX, posY, posZ, 10 )
	local nearbyPlayers = getElementsWithinColShape( chatSphere, "player" )

	local message = nil

	for index, nearbyPlayer in ipairs( nearbyPlayers ) do
		local ox, oy, oz = getElementPosition(nearbyPlayer)
		local distance = getDistanceBetweenPoints2D(x, y, ox, oy)
		if distance < 2 then
			message = "#BBBBBB(( #FFFFFF".. rank_col[getElementData(player, "player.color")] ..getElementData(player, "player.gname").." #BBBBBB[".. getElementData(player, "id") .."]: " ..b_text.." ))"
		elseif distance < 4 then
			message = "#AAAAAA(( #FFFFFF".. rank_col[getElementData(player, "player.color")] ..getElementData(player, "player.gname").." #AAAAAA[".. getElementData(player, "id") .."]: " ..b_text.." ))"
		elseif distance < 6 then
			message = "#999999(( #FFFFFF".. rank_col[getElementData(player, "player.color")] ..getElementData(player, "player.gname").." #999999[".. getElementData(player, "id") .."]: " ..b_text.." ))"
		elseif distance < 8 then
			message = "#888888(( #FFFFFF".. rank_col[getElementData(player, "player.color")] ..getElementData(player, "player.gname").." #888888[".. getElementData(player, "id") .."]: " ..b_text.." ))"
		else
			message = "#666666(( #FFFFFF".. rank_col[getElementData(player, "player.color")] ..getElementData(player, "player.gname").." #666666[".. getElementData(player, "id") .."]: " ..b_text.." ))"
		end
        outputChatBox( message, nearbyPlayer, 255, 255, 255, true)
    end

    destroyElement(chatSphere) -- optymalizacja
end
addCommandHandler ( "b", bCommand )

-- /szept /s
function sCommand(player, commandName, ...)
	local b_array = {...}
	local b_text = table.concat(b_array, " ")

	-- Jeśli BW to niech nie gada
	if(tonumber(getElementData(player, "player.bw")) > 0) then
		exports.lsrp:showPopup(player, "Nie możesz się odzywać będąc nieprzytomnym.", 5 )
		return
	end

	if #b_array <= 0 then
		outputChatBox("#CCCCCCUżycie: /s [Wiadomość] - szeptanie", player, 255, 255, 255, true)
		return
	end

	-- pozycja piszącego
	local x, y, z = getElementPosition(player)

	local output = playerRealName(player).." szepcze: "..firstToUpper(b_text)
	local posX, posY, posZ = getElementPosition( player )
	local chatSphere = createColSphere( posX, posY, posZ, 4 )
	local nearbyPlayers = getElementsWithinColShape( chatSphere, "player" )

	for index, nearbyPlayer in ipairs( nearbyPlayers ) do
		local ox, oy, oz = getElementPosition(nearbyPlayer)
		local distance = getDistanceBetweenPoints2D(x, y, ox, oy)
		if distance < 1 then
			outputChatBox( "#FFFFFF"..output, nearbyPlayer, 255, 255, 255, true)
		elseif distance < 2 then
			outputChatBox( "#EEEEEE"..output, nearbyPlayer, 255, 255, 255, true)
		elseif distance < 3 then
			outputChatBox( "#CCCCCC"..output, nearbyPlayer, 255, 255, 255, true)
		else
			outputChatBox( "#BBBBBB"..output, nearbyPlayer, 255, 255, 255, true)
		end
        --outputChatBox( message, nearbyPlayer, 255, 255, 255, true)
    end

    destroyElement(chatSphere) -- optymalizacja
end
addCommandHandler ( "s", sCommand )

-- /krzyk /k
function kCommand(player, commandName, ...)
	local b_array = {...}
	local b_text = table.concat(b_array, " ")

	-- Jeśli BW to niech nie gada
	if(tonumber(getElementData(player, "player.bw")) > 0) then
		exports.lsrp:showPopup(player, "Nie możesz się odzywać będąc nieprzytomnym.", 5 )
		return
	end

	if #b_array <= 0 then
		outputChatBox("#CCCCCCUżycie: /k [Wiadomość] - krzyk", player, 255, 255, 255, true)
		return
	end

	-- pozycja piszącego
	local x, y, z = getElementPosition(player)

	local output = playerRealName(player).." krzyczy: "..firstToUpper(b_text).."!"
	local posX, posY, posZ = getElementPosition( player )
	local chatSphere = createColSphere( posX, posY, posZ, 25 )
	local nearbyPlayers = getElementsWithinColShape( chatSphere, "player" )

	for index, nearbyPlayer in ipairs( nearbyPlayers ) do
		local ox, oy, oz = getElementPosition(nearbyPlayer)
		local distance = getDistanceBetweenPoints2D(x, y, ox, oy)
		if distance < 5 then
			outputChatBox( "#FFFFFF"..output, nearbyPlayer, 255, 255, 255, true)
		elseif distance < 10 then
			outputChatBox( "#EEEEEE"..output, nearbyPlayer, 255, 255, 255, true)
		elseif distance < 15 then
			outputChatBox( "#CCCCCC"..output, nearbyPlayer, 255, 255, 255, true)
		else
			outputChatBox( "#BBBBBB"..output, nearbyPlayer, 255, 255, 255, true)
		end
        --outputChatBox( message, nearbyPlayer, 255, 255, 255, true)
    end

    destroyElement(chatSphere) -- optymalizacja
end
addCommandHandler ( "k", kCommand )


-- /l lokalny
function lCommand(player, commandName, ...)
	local b_array = {...}
	local b_text = table.concat(b_array, " ")

	-- Jeśli BW to niech nie gada
	if(tonumber(getElementData(player, "player.bw")) > 0) then
		exports.lsrp:showPopup(player, "Nie możesz się odzywać będąc nieprzytomnym.", 5 )
		return
	end

	if #b_array <= 0 then
		outputChatBox("#CCCCCCUżycie: /l [Wiadomość] - czat lokalny", player, 255, 255, 255, true)
		return
	end

	-- pozycja piszącego
	local x, y, z = getElementPosition(player)

	local output = playerRealName(player).." mówi: "..firstToUpper(b_text)
	local posX, posY, posZ = getElementPosition( player )
	local chatSphere = createColSphere( posX, posY, posZ, 25 )
	local nearbyPlayers = getElementsWithinColShape( chatSphere, "player" )

	for index, nearbyPlayer in ipairs( nearbyPlayers ) do
		local ox, oy, oz = getElementPosition(nearbyPlayer)
		local distance = getDistanceBetweenPoints2D(x, y, ox, oy)
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
        --outputChatBox( message, nearbyPlayer, 255, 255, 255, true)
    end

    destroyElement(chatSphere) -- optymalizacja
end
addCommandHandler ( "l", lCommand )