function onVehicleTakeDamage(loss)
	-- source to pojazd
	if not isVehicleOccupied(source) then
		-- nie ma ludzi w środku
	else
		-- są
	end
end
addEventHandler("onVehicleDamage", getRootElement(), onVehicleTakeDamage)