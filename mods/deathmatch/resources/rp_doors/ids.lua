-- IDy drzwi
door_ids = {}

function assignDoorID(door)
	for i=1, 6000 do
		if not door_ids[i] then
			door_ids[i] = door
			setElementData(door, "id", i, not optimize)
			break
		end
	end
end

function d_startup()
    for k, d in pairs(getElementsByType("pickup")) do
        local id = getElementData(d, "id")
        if id then door_ids[id] = d end
    end
end
addEventHandler("onResourceStart", resourceRoot, d_startup)

function gotDoorID(door)
    for k, d in pairs(door_ids) do
        if d == door then return k end
    end
end

function freeDoorID(door)
    local id = getElementData(door, "id")
    if not id then return end
    door_ids[id] = nil
end

function getDoorByID(id)
    local door = door_ids[id]
    return door or false
end

function getDoorByUID(uid)
    for k, d in pairs(getElementsByType("pickup")) do
        if tonumber(getElementData(d, "door.uid")) == tonumber(uid) then
            return d
        end
    end
    return false
end

function getDoorByWorld(world)
    for k, d in pairs(getElementsByType("pickup")) do
        if tonumber(getElementData(d, "door.exitvw")) == tonumber(world) then
            return d
        end
    end
    return false
end