local vehicle = nil

function createRepairLabelForPlayer(theVehicle)
	vehicle = theVehicle
	addEventHandler("onClientRender", getRootElement(), vehicleRepairLabel)
end
addEvent("createRepairLabelForPlayer", true)
addEventHandler("createRepairLabelForPlayer", getRootElement(), createRepairLabelForPlayer)

function destroyRepairLabelForPlayer(theVehicle)
	removeEventHandler ( "onClientRender", getRootElement(), vehicleRepairLabel )
end
addEvent("destroyRepairLabelForPlayer", true)
addEventHandler("destroyRepairLabelForPlayer", getRootElement(), destroyRepairLabelForPlayer)

function vehicleRepairLabel()
	-- zaraz sie bardziej pobawimy
	if vehicle ~= nil then
		local index = tonumber(getElementData(vehicle, "id"))
		local text = "** Stan naprawy (".. math.floor(tonumber(getElementData(vehicle, "vehicle.repairpercent"))) .."%) **"
		local vx, vy, vz = getElementPosition(vehicle)
		local px, py, pz = getElementPosition(getLocalPlayer())

		local distance = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)
		if distance < 10.0 then 
			local screenX, screenY = getScreenFromWorldPosition ( vx, vy, vz + 1.0 )
            if not screenY then return end

            dxDrawText ( text, screenX, screenY, screenX, screenYW, tocolor(255,51,0,255), 1, "clear", "center", "bottom", false, false, false, true )
		end
	end
end
addEvent("vehicleRepairLabel", true)
addEventHandler("vehicleRepairLabel", getRootElement(), vehicleRepairLabel)