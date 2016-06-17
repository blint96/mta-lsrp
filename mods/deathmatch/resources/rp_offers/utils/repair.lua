--[[ Co się ma dokładnie dziać podczas całego procesu naprawy pojazdu ]] --
MAX_REPAIR_STEPS = 150

function startCarRepair(thePlayer, theClient, theVehicle)
	local index = tonumber(getElementData(theVehicle, "id"))
	local timer = setTimer ( loopCarRepair, 1000, MAX_REPAIR_STEPS, thePlayer, theClient, theVehicle )
	vehicleRepairs[index] = {}
	vehicleRepairs[index]["step"] = 0
	vehicleRepairs[index]["timer"] = timer
	vehicleRepairs[index]["mechanic"] = thePlayer
	vehicleRepairs[index]["client"] = theClient
	setElementData(theVehicle, "vehicle.repairpercent", 0)

	-- dodaj do klienta
	triggerClientEvent(thePlayer, "createRepairLabelForPlayer", thePlayer, theVehicle)
	triggerClientEvent(theClient, "createRepairLabelForPlayer", theClient, theVehicle)

	outputChatBox("#CCCCCCInformacja: Naprawa pojazdu rozpoczęła się, odgrywaj akcję do czasu zakończenia naprawy!", thePlayer, 255, 255, 255, true)
end

function loopCarRepair(thePlayer, theClient, theVehicle)
	local index = tonumber(getElementData(theVehicle, "id"))
	
	-- jakby za daleko był
	local px, py, pz = getElementPosition(thePlayer)
	local cx, cy, cz = getElementPosition(theVehicle)
	local distance = getDistanceBetweenPoints3D(px, py, pz, cx, cy, cz)

	-- Log fix
	if(not isElement(thePlayer) or not isElement(theClient)) then
		killTimer(vehicleRepairs[index]["timer"])
	end

	if distance < 5.0 then 
		vehicleRepairs[index]["step"] = vehicleRepairs[index]["step"] + 1
		vehicleRepairs[index]["percent"] = tonumber(100 * vehicleRepairs[index]["step"] / MAX_REPAIR_STEPS)
		setElementData(theVehicle, "vehicle.repairpercent", vehicleRepairs[index]["percent"])

		local step = vehicleRepairs[index]["step"]
		if step == MAX_REPAIR_STEPS then 
			killTimer(vehicleRepairs[index]["timer"])
			vehicleRepairs[index]["step"] = 0
			setElementData(theVehicle, "vehicle.repairpercent", nil)
			outputChatBox("#CCCCCCInformacja: Naprawa pojazdu dobiegła końca!", thePlayer, 255, 255, 255, true)
			outputChatBox("#CCCCCCInformacja: Naprawa pojazdu dobiegła końca!", theClient, 255, 255, 255, true)
			fixVehicle ( theVehicle )

			-- pousuwaj im z clienta
			triggerClientEvent(thePlayer, "destroyRepairLabelForPlayer", thePlayer, theVehicle)
			vehicleRepairs[index]["client"] = nil
			vehicleRepairs[index]["mechanic"] = nil
			triggerClientEvent(theClient, "destroyRepairLabelForPlayer", theClient, theVehicle)
		end
	end
end

function isUserRepairCar(theUser)
	for key, value in pairs(vehicleRepairs) do 
		if vehicleRepairs[key] then 
			if vehicleRepairs[key]["mechanic"] == theUser then 
				return true
			end

			if vehicleRepairs[key]["client"] == theUser then 
				return true
			end
		end
	end
	return false
end