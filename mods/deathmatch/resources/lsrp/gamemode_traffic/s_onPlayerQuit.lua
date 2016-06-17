-- Funkcja na wychodzenie z serwera
function quitPlayer ( quitType )

	-- info o wyjściu
	if getElementData(source, "player.logged") == true then
		local x, y, z = getElementPosition(source)
		local message = ""
		if quitType == "Quit" then
			message = "(( "..playerRealName(source).." - wyjście ))"
		elseif quitType == "Kicked" then
			message = "(( "..playerRealName(source).." - kick ))"
		elseif quitType == "Banned" then
			message = "(( "..playerRealName(source).." - ban ))"
		elseif quitType == "Timed out" then
			message = "(( "..playerRealName(source).." - timeout ))"
		else
			message = "(( "..playerRealName(source).." - nieznany ))"
		end
		local infoSphere = createColSphere( x, y, z, 35 )
		local nearbyPlayers = getElementsWithinColShape( infoSphere, "player" )
		for index, nearbyPlayer in ipairs( nearbyPlayers ) do
			if getElementDimension(nearbyPlayer) == getElementDimension(source) then
				outputChatBox("#CCCCCC"..message, nearbyPlayer, 255, 255, 255, true)
			end
		end
		destroyElement(infoSphere) -- optymalizacja

		-- Usuwanie obiektów przycezpialnych jeśli jakieś były
		local objects = getAttachedElements ( source )
		for i, object in ipairs(objects) do
			destroyElement(object)
		end
	end
	
	-- Oznacz jako rozłączonego
	if getElementData(source, "player.logged") == true then
		exports.rp_items:savePlayerWeaponsWhenUsed(source) -- odużyj bronie jak miał użyte

		if getElementData(source, "player.uid") ~= nil then
			local query = dbQuery(handler, "UPDATE lsrp_characters SET char_online = 0, char_cash = '"..tonumber(getElementData(source, "player.cash")).."', char_bankcash = '"..tonumber(getElementData(source, "player.bankcash")).."', char_aj = "..tonumber(getElementData(source, "player.aj"))..", char_hours = "..tonumber(getElementData(source, "player.hours"))..", char_minutes = ".. tonumber(getElementData(source, "player.minutes")) ..", char_skin = "..tonumber(getElementData(source, "player.skin"))..", char_health = "..tonumber(getElementHealth(source))..", char_bw = "..tonumber(getElementData(source, "player.bw")) ..", char_shooting = "..tonumber( getElementData(source, "player.shooting") ).." WHERE char_uid = "..getElementData(source, "player.uid"))
			dbFree(query)
		end

		-- Jeśli ma BW to dodaj zapis
		if tonumber(getElementData(source, "player.bw")) > 0 then
			local bw_x, bw_y, bw_z = getElementPosition(source)
			local world = getElementDimension(source)
			local int = getElementInterior(source)
			local query = dbQuery(handler, "UPDATE lsrp_characters SET char_posx = "..bw_x..", char_posy = "..bw_y..", char_posz = "..bw_z..", char_vw = "..world..", char_int = "..int..", char_bw = ".. tonumber(getElementData(source, "player.bw")) .." WHERE char_uid = "..tonumber(getElementData(source, "player.uid")) )
			if query then dbFree(query) end
		end

		-- Odznacz bronie, wcześniej zapis można dodać
		local query = dbQuery(handler, "UPDATE lsrp_items SET item_used = 0 WHERE item_type = 6 AND item_owner = "..tonumber(getElementData(source, "player.uid")))
		if query then dbFree(query) end
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )