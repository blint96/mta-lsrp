local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

-- redefinicje
function lsrp_createPickup(x, y, z, pickup)
	local door = createPickup(x, y, z, 3, pickup, 10000)
	if door then
		assignDoorID(door)
	end
	return door
end

function lsrp_destroyPickup(element)
	-- jakieś czyszczenie dodać
	freeDoorID(element)
	destroyElement(element)
end

-- pickup handler
function onPlayerPickup ( thePlayer )

	if getElementData(source, "door.exitx") == 0 and getElementData(source, "door.exity") == 0 and getElementData(source, "door.exitz") == 0 then
		exports.lsrp:showDoorInfo(thePlayer, "Drzwi są w trakcie remontu, nie można przejść.", 7, "gamemode_dialogs/lock.png", source )
		return
	end

   	if getElementData(source, "door.lock") == 1 then
   		-- zamknięte
   		exports.lsrp:showDoorInfo(thePlayer, "Drzwi zamknięte, nie możesz teraz przez nie przejść - jeżeli jesteś właścicielem to możesz je otworzyć.", 7, "gamemode_dialogs/lock.png", source )
   	else
   		-- otwarte
   		exports.lsrp:showDoorInfo(thePlayer, "Drzwi otwarte.\nWciśnij ALT+Spacja aby wejść do środka.", 7, "gamemode_dialogs/enter.png", source )
   	end
end

-- Usuwanie drzwi
function DeleteDoor(door_id)
	-- usuń same drzwi
	local query = dbQuery(handler, "DELETE FROM lsrp_doors WHERE door_uid = "..getElementData(getDoorByID(door_id), "door.uid"))
	if query then dbFree(query) end

	-- usuń obiekty w tych drzwiach
	local query = dbQuery(handler, "DELETE FROM lsrp_objects WHERE object_world = "..getElementData(getDoorByID(door_id), "door.uid"))
	if query then dbFree(query) end

	local objects = getElementsByType("object")
	for k, object in ipairs(objects) do
		if getElementDimension(object) == tonumber(getElementData(getDoorByID(door_id), "door.exitvw")) then
			if getElementDimension(object) ~= 0 then
				destroyElement(object)
			end
		end
	end

	lsrp_destroyPickup(getDoorByID(door_id))
	return true
end

-- Tworzenie drzwi
function CreateDoor(name, x, y, z, angle, interior, vw)
	local query = dbQuery(handler, "INSERT INTO lsrp_doors (door_name, door_enterx, door_entery, door_enterz, door_entera, door_enterint, door_entervw, door_exitx, door_exity, door_exitz, door_exita, door_exitint, door_exitvw, door_audiourl, door_image) VALUES ('"..name.."', "..x..", "..y..", "..z..", "..angle..", "..interior..", "..vw..", 0.0, 0.0, 0.0, 0.0, 0, 0, '', '')")
	local _, _, insert_id = dbPoll(query, -1)

	local door = LoadDoor(insert_id)
	if query then dbFree(query) end
	return door
end

function ReloadDoor(door_id)
	local uid = getElementData(getDoorByID(door_id), "door.uid")
	lsrp_destroyPickup(getDoorByID(door_id))
	LoadDoor(uid)
	return true
end

function LoadDoor(uid)
	local query = dbQuery(handler, "SELECT * FROM lsrp_doors WHERE door_uid = "..uid)
	local result = dbPoll(query, -1)

	if result then
		if result[1] then
			local created = lsrp_createPickup(tonumber(result[1]["door_enterx"]), tonumber(result[1]["door_entery"]), tonumber(result[1]["door_enterz"]), tonumber(result[1]["door_pickup"]))
			if created then
				setElementData(created, "door.uid", tonumber(result[1]["door_uid"]))
				setElementData(created, "door.owner", tonumber(result[1]["door_owner"]))
				setElementData(created, "door.name", result[1]["door_name"])
				setElementData(created, "door.ownertype", tonumber(result[1]["door_ownertype"]))
				setElementData(created, "door.enterx", tonumber(result[1]["door_enterx"]))
				setElementData(created, "door.entery", tonumber(result[1]["door_entery"]))
				setElementData(created, "door.enterz", tonumber(result[1]["door_enterz"]))
				setElementData(created, "door.entera", tonumber(result[1]["door_entera"]))
				setElementData(created, "door.entervw", tonumber(result[1]["door_entervw"]))
				setElementData(created, "door.enterint", tonumber(result[1]["door_enterint"]))
				setElementData(created, "door.exitx", tonumber(result[1]["door_exitx"]))
				setElementData(created, "door.exity", tonumber(result[1]["door_exity"]))
				setElementData(created, "door.exitz", tonumber(result[1]["door_exitz"]))
				setElementData(created, "door.exita", tonumber(result[1]["door_exita"]))
				setElementData(created, "door.exitvw", tonumber(result[1]["door_exitvw"]))
				setElementData(created, "door.exitint", tonumber(result[1]["door_exitint"]))
				setElementData(created, "door.lock", tonumber(result[1]["door_lock"]))

				setElementDimension(created, tonumber(result[1]["door_entervw"]))
				setElementInterior(created, tonumber(result[1]["door_enterint"]))

				addEventHandler ( "onPickupHit", created, onPlayerPickup )
				return created
			end
		else
			return false
		end
	else
		return false
	end
	if query then dbFree(query) end
end

-- wczytywanie wszystkich drzwi na starcie
function LoadDoors()
	local load = 0
	local query = dbQuery(handler, "SELECT * FROM lsrp_doors")
	local result = dbPoll(query, -1)

	if result then
		for k = 0, table.getn(result) do
			if result[k] then
				load = load + 1
				--local created = createPickup ( tonumber(result[k]["door_enterx"]), tonumber(result[k]["door_entery"]), tonumber(result[k]["door_enterz"]), 3, tonumber(result[k]["door_pickup"]), 10000 )
				local created = lsrp_createPickup(tonumber(result[k]["door_enterx"]), tonumber(result[k]["door_entery"]), tonumber(result[k]["door_enterz"]), tonumber(result[k]["door_pickup"]))

				if created then
					-- data
					setElementData(created, "door.uid", tonumber(result[k]["door_uid"]))
					setElementData(created, "door.owner", tonumber(result[k]["door_owner"]))
					setElementData(created, "door.name", result[k]["door_name"])
					setElementData(created, "door.ownertype", tonumber(result[k]["door_ownertype"]))
					setElementData(created, "door.enterx", tonumber(result[k]["door_enterx"]))
					setElementData(created, "door.entery", tonumber(result[k]["door_entery"]))
					setElementData(created, "door.enterz", tonumber(result[k]["door_enterz"]))
					setElementData(created, "door.entera", tonumber(result[k]["door_entera"]))
					setElementData(created, "door.entervw", tonumber(result[k]["door_entervw"]))
					setElementData(created, "door.enterint", tonumber(result[k]["door_enterint"]))
					setElementData(created, "door.exitx", tonumber(result[k]["door_exitx"]))
					setElementData(created, "door.exity", tonumber(result[k]["door_exity"]))
					setElementData(created, "door.exitz", tonumber(result[k]["door_exitz"]))
					setElementData(created, "door.exita", tonumber(result[k]["door_exita"]))
					setElementData(created, "door.exitvw", tonumber(result[k]["door_exitvw"]))
					setElementData(created, "door.exitint", tonumber(result[k]["door_exitint"]))
					setElementData(created, "door.lock", tonumber(result[k]["door_lock"]))

					setElementDimension(created, tonumber(result[k]["door_entervw"]))
					setElementInterior(created, tonumber(result[k]["door_enterint"]))

					-- callback
					addEventHandler ( "onPickupHit", created, onPlayerPickup )
				end
			end
		end
	end

	outputDebugString("[load] Wczytano "..load.." drzwi!")
	if query then dbFree(query) end
end
addEventHandler ( "onResourceStart", resourceRoot, LoadDoors )
addEventHandler ( "onResourceStart", resourceRoot, function() outputDebugString("[startup] Załadowano system drzwi") end )

function getPlayerDoor(thePlayer)
	local world = getElementDimension(thePlayer)
	if world == 0 then 
		return false
	else
		local doors = getElementsByType("pickup")
		for _, door in ipairs(doors) do 
			if(tonumber(getElementData(door, "door.exitvw")) == world) then
				return door
			end
		end

		return false
	end
end

function getDoorElementByUID(door_uid)
	local element = nil
	local doors = getElementsByType("pickup")
	for _, door in ipairs(doors) do 
		if(tonumber(getElementData(door, "door.uid")) == door_uid) then
			element = door
			break
		end
	end
	return element
end

--[[
	Wchodzenie do drzwi
]]--
function setPlayerToEnterDoors(thePlayer, theDoors)

	if getElementData(theDoors, "door.exitx") == 0 and getElementData(theDoors, "door.exity") == 0 and getElementData(theDoors, "door.exitz") == 0 then
		exports.lsrp:showDoorInfo(thePlayer, "Drzwi są w trakcie remontu, nie można przejść.", 7, "gamemode_dialogs/lock.png", theDoors )
		return
	end

	if tonumber(getElementData(theDoors, "door.lock")) == 1 then
		local admin = exports.lsrp:getPlayerAdmin( thePlayer )
		if admin ~= 1 then
			exports.lsrp:showPopup(thePlayer, "Te drzwi są zamknięte.", 5 )
			return
		end
	end

	-- Informacje o kupnie
	if tonumber(getElementData(theDoors, "door.ownertype")) == 5 then 
		local group_uid = tonumber(getElementData(theDoors, "door.owner"))
		local group_type = tonumber(exports.rp_groups:GetGroupType(group_uid))
		if group_type == 11 then
			outputChatBox("» #FF6600Informacja: użyj komendy #FFFFFF/ubranie #FF6600by kupić nowe ubranie.", thePlayer, 255, 255, 255, true)
		end

		if group_type == 2 then 
			outputChatBox("» #FF6600Informacja: użyj komendy #FFFFFF/kup #FF6600by kupić jakieś przedmioty.", thePlayer, 255, 255, 255, true)
		end
	end

	-- rotcja przy wejściu
	local rx, ry, rz = getElementRotation(thePlayer)
	setElementRotation(thePlayer, rx, ry, tonumber(getElementData(theDoors, "door.exita")))
	setCameraTarget(thePlayer)
	setTimer(setCameraTarget, 250, 1, thePlayer)

	setElementInterior(thePlayer, tonumber(getElementData(theDoors, "door.exitint")))
	setElementDimension(thePlayer, tonumber(getElementData(theDoors, "door.exitvw")))
	setElementPosition(thePlayer, tonumber(getElementData(theDoors, "door.exitx")), tonumber(getElementData(theDoors, "door.exity")), tonumber(getElementData(theDoors, "door.exitz")))
end
addEvent("setPlayerToEnterDoors", true)
addEventHandler("setPlayerToEnterDoors", getRootElement(), setPlayerToEnterDoors)

function setPlayerToExitDoors(thePlayer, theDoors)

	if tonumber(getElementData(theDoors, "door.lock")) == 1 then
		local admin = exports.lsrp:getPlayerAdmin( thePlayer )
		if admin ~= 1 then
			exports.lsrp:showPopup(thePlayer, "Te drzwi są zamknięte.", 5 )
			return
		end
	end

	-- rotcja przy wyjściu
	local rx, ry, rz = getElementRotation(thePlayer)
	setElementRotation(thePlayer, rx, ry, tonumber(getElementData(theDoors, "door.entera")))
	setCameraTarget(thePlayer)
	setTimer(setCameraTarget, 250, 1, thePlayer)

	-- Sprawdź czy jest na duty i anuluj jeśli wychodzi z budynku
	local is_duty, duty_type, duty_id, duty_group_uid, duty_start = exports.rp_groups:getPlayerDutyInfo(thePlayer)
	if (is_duty) and (duty_type ~= 1) then 
		local group_type = exports.rp_groups:GetGroupType(duty_group_uid) 
		local groupSettTable = exports.rp_groups:getGroupSettings()
		if groupSettTable[group_type][2] == false then 
			exports.rp_groups:savePlayerDuty(thePlayer)
		end
	end

	setElementInterior(thePlayer, tonumber(getElementData(theDoors, "door.enterint")))
	setElementDimension(thePlayer, tonumber(getElementData(theDoors, "door.entervw")))
	setElementPosition(thePlayer, tonumber(getElementData(theDoors, "door.enterx")), tonumber(getElementData(theDoors, "door.entery")), tonumber(getElementData(theDoors, "door.enterz")))
end
addEvent("setPlayerToExitDoors", true)
addEventHandler("setPlayerToExitDoors", getRootElement(), setPlayerToExitDoors)
