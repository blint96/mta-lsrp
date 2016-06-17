local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

 player_r = {} -- red color
 player_g = {} -- green color
 player_b = {} -- blue color
 player_c = {} -- 1 lub 2

function updateVehicleColorOffer(id, hex, r, g, b)
	-- zmiana koloru auta
	if id == 2 then
		player_r[source] = r 
		player_g[source] = g 
		player_b[source] = b
	end
end
addEvent("onPickerColorUpdate", true)
addEventHandler("onPickerColorUpdate", getRootElement(), updateVehicleColorOffer)

function updateVehicleColorCloseOffer(id, hex, r, g, b)
	if id == 2 then
		player_r[source] = r 
		player_g[source] = g 
		player_b[source] = b
		startPlayerPainting(extra[source], source)
	end
end
addEvent("onPickerColorClose", true)
addEventHandler("onPickerColorClose", getRootElement(), updateVehicleColorCloseOffer)

function startPlayerPainting(thePlayer, theClient)
	-- The Player maluje a theClient siedzi w aucie
	local vehicle = getPedOccupiedVehicle(theClient)
	--outputChatBox("auto: " .. getElementData(vehicle, "vehicle.name"))
	--outputChatBox("kolory: "..player_r[theClient]..", ".. player_g[theClient]..", ".. player_b[theClient])

	-- w tym miejscu trzeba zacząć malowanie i na koniec pobranie tego @up zeby nalozyc kolor na woz
	-- zapomnialem kodząc o player_c <- to do zrobienia na potem
end