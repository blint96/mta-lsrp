local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

function updateVehicleColor(id, hex, r, g, b)
	-- zmiana koloru auta
	if id == 1 then
		local veh = getElementData(source, "player.vehedit")
		if veh ~= nil then
			if getElementData(source, "player.coledit") == 1 then
				local col1 = r..","..g..","..b
				local query = dbQuery(handler, "UPDATE lsrp_cars SET car_color1 = '"..col1.."' WHERE car_uid = "..tonumber(getElementData(veh, "vehicle.uid")))
				dbFree(query)

				-- trzeba col2 dobrać
				local col2 = getElementData(veh, "vehicle.col2")
				local col2_ar = {}
				col2_ar[0], col2_ar[1], col2_ar[2] = col2:match("(%d+),(%d+),(%d+)")

				setElementData(veh, "vehicle.col1", col1)
				setVehicleColor(veh, r, g, b, col2_ar[0], col2_ar[1], col2_ar[2])
			else
				local col2 = r..","..g..","..b
				local query = dbQuery(handler, "UPDATE lsrp_cars SET car_color2 = '"..col2.."' WHERE car_uid = "..tonumber(getElementData(veh, "vehicle.uid")))
				dbFree(query)

				-- trzeba col1 dobrać
				local col1 = getElementData(veh, "vehicle.col1")
				local col1_ar = {}
				col1_ar[0], col1_ar[1], col1_ar[2] = col1:match("(%d+),(%d+),(%d+)")

				setElementData(veh, "vehicle.col2", col2)
				setVehicleColor(veh, col1_ar[0], col1_ar[1], col1_ar[2], r, g, b)
			end
		end
	end
end
addEvent("onPickerColorUpdate", true)
addEventHandler("onPickerColorUpdate", getRootElement(), updateVehicleColor)

function updateVehicleColorClose(id, hex, r, g, b)
	setElementData(source, "player.vehedit", nil)
	setElementData(source, "player.coledit", nil)
end
addEvent("onPickerColorClose", true)
addEventHandler("onPickerColorClose", getRootElement(), updateVehicleColorClose)