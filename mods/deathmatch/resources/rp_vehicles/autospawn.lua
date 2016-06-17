--[[
	Spawnowanie pojazdów i unspawnowanie jak gośc wyjdzie
]]--

function setVehicleToUnspawnHandler()
	-- source - gracz
	setTimer(setVehicleToUnspawn, 25000, 1, tonumber(getElementData(source, "player.uid")))
end

function setVehicleToUnspawn(player_uid)
	-- sprawdź czy czasem nie wrócił do gry już
	for i, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "player.uid") == tonumber(player_uid) then
			-- przerywamy
			return
		end
	end

	for i, vehicle in ipairs(getElementsByType("vehicle")) do
		if tonumber(getElementData(vehicle, "vehicle.ownertype")) == 1 and tonumber(getElementData(vehicle, "vehicle.owner")) == tonumber(player_uid) then
			UnspawnVehicle(gotVehicleID(vehicle))
		end
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), setVehicleToUnspawnHandler )