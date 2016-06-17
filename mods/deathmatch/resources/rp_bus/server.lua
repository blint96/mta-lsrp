local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
addEventHandler ( "onResourceStart", resourceRoot, function() outputDebugString("[startup] Załadowano system busów") end )
addEventHandler ( "onResourceStart", resourceRoot, function() LoadBusStops() end )

local busstops = {}

-- KURWA MOZOLNA ROBOTA, WOLE JUZ GRUZ PRZERZUCAĆ NA BUDOWIE
function LoadBusStops()
	local query = dbQuery(handler, "SELECT * FROM lsrp_busstops")
	local result = dbPoll(query, -1)

	if result then 
		for k = 0, table.getn(result) do 
			if result[k] then 
				busstops[k] = {}
				busstops[k]["bus_uid"] = tonumber(result[k]["busstop_uid"])
				busstops[k]["bus_name"] = result[k]["busstop_name"]
				busstops[k]["bus_x"] = result[k]["busstop_posx"]
				busstops[k]["bus_y"] = result[k]["busstop_posy"]
				busstops[k]["bus_z"] = result[k]["busstop_posz"]
			end
		end
	end
end

-- Co by się odświeżało po zalogowaniu
addEventHandler ( "onPlayerLoginSQL", getRootElement(), function() --[[source]] triggerClientEvent (source, "onSyncBus", source, busstops)  end )

-- Do testowania
function syncBusCommand(thePlayer, theCmd)
	triggerClientEvent (thePlayer, "onSyncBus", thePlayer, busstops)
end
addCommandHandler("syncbus", syncBusCommand)

-- Do teleportowania
function setPlayerToBusDrive(thePlayer, theCmd)
	triggerClientEvent (thePlayer, "onEnterBus", thePlayer)
	outputChatBox("» Użyj strzałki w górę by pojechać na wybrany przystanek.", thePlayer)
	outputChatBox("» Użyj strzałki w dół by zrezygnować z trasy.", thePlayer)
	outputChatBox("» Użyj strzałek w lewo i prawo by zmieniać przystanki.", thePlayer)
end
addCommandHandler("bus", setPlayerToBusDrive)