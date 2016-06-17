-- IDy pojazdów
veh_ids = {}

function assignVehID(vehicle)
	for i=1, 2000 do
		if not veh_ids[i] then
			veh_ids[i] = vehicle
			setElementData(vehicle, "id", i, not optimize)
			break
		end
	end
end

function v_startup()
    for k, v in pairs(getElementsByType("vehicle")) do
        local id = getElementData(v, "id")
        if id then veh_ids[id] = v end
    end
end
addEventHandler("onResourceStart", resourceRoot, v_startup)

function gotVehicleID(vehicle)
    for k, v in pairs(veh_ids) do
        if v == vehicle then return k end
    end
end

function freeVehicleID(vehicle)
    local id = getElementData(vehicle, "id")
    if not id then return end
    veh_ids[id] = nil
end

function getVehicleByID(id)
    local vehicle = veh_ids[id]
    return vehicle or false
end

function getVehicleByUID(uid)
    for k, v in pairs(getElementsByType("vehicle")) do
        if tonumber(getElementData(v, "vehicle.uid")) == tonumber(uid) then
            return v
        end
    end
    return false
end