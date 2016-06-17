local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
addEventHandler ( "onResourceStart", resourceRoot, function() outputDebugString("[startup] Załadowano system obiektów") end )

-- Branch: KYLO
-- Zmiana działania obiektów, są trzymane po stronie serwera i wysyłane klientowi w ramach streamera
objects = {}

-- dodawanie obiektów do bazy
function addObject(model, x, y, z, world, interior)
	local object = createObject ( model, x, y, z )
	if not object then return false end

	local query = dbQuery(handler, "INSERT INTO lsrp_objects (object_model, object_posx, object_posy, object_posz, object_rotx, object_roty, object_rotz, object_world, object_interior, object_group, object_gaterotx, object_gateroty, object_gaterotz, object_owner) VALUES ("..model..", "..x..", "..y..", "..z..", 0.0, 0.0, 0.0, "..world..", "..interior..", '', 0.0, 0.0, 0.0, 0)")
	local _, _, insert_id = dbPoll(query, -1)

	setElementData(object, "object.uid", insert_id)
	setElementDimension(object, world)
	setElementDimension(object, world)
	setElementInterior(object, interior)

	if query then dbFree(query) end
	return insert_id
end

-- usuwanie obiektu z bazy
function removeObject(object)
	local object_uid = getElementData(object, "object.uid")
	local query = dbQuery(handler, "DELETE FROM lsrp_objects WHERE object_uid = "..object_uid)
	if query then dbFree(query) end

	destroyElement(object)
	return true
end
addEvent("RemoveObject", true)
addEventHandler("RemoveObject", getRootElement(), removeObject)

-- wczytywanie wszystkich obiektów na starcie
function LoadObjects()
	local debug = exports.lsrp:getDebugStatus( )
	local query = nil
	if debug == true then
		outputDebugString("[debug] Wczytuje tylko obiekty z VW 0.")
		query = dbQuery(handler, "SELECT * FROM lsrp_objects WHERE object_world = 0")
	else 
		query = dbQuery(handler, "SELECT * FROM lsrp_objects")
	end

	local load = 0
	--local query = dbQuery(handler, "SELECT * FROM lsrp_objects")
	local result = dbPoll(query, -1)

	local ile = 0	-- usuwanie błędnych obiektów
	if result then
		for k = 0, table.getn(result) do
			if result[k] then
				objects[load] = {}
				objects[load]["uid"] = tonumber(result[k]["object_uid"])
				objects[load]["vw"] = tonumber(result[k]["object_world"])
				objects[load]["model"] = tonumber(result[k]["object_model"])
				objects[load]["posx"] = tonumber(result[k]["object_posx"])
				objects[load]["posy"] = tonumber(result[k]["object_posy"])
				objects[load]["posz"] = tonumber(result[k]["object_posz"])
				objects[load]["rotx"] = tonumber(result[k]["object_rotx"])
				objects[load]["roty"] = tonumber(result[k]["object_roty"])
				objects[load]["rotz"] = tonumber(result[k]["object_rotz"])
				--local created = createObject ( tonumber(result[k]["object_model"]), tonumber(result[k]["object_posx"]), tonumber(result[k]["object_posy"]), tonumber(result[k]["object_posz"]), tonumber(result[k]["object_rotx"]), tonumber(result[k]["object_roty"]), tonumber(result[k]["object_rotz"]) )



				-- usuwanie błędnych obiektów
				--[[if not created then
					local destroy_q = dbQuery(handler, "DELETE FROM lsrp_objects WHERE object_uid = "..tonumber(result[k]["object_uid"]))
					if destroy_q then dbFree(destroy_q) end
					ile = ile + 1
				end]]--

				if created then
					setElementData(created, "object.uid", tonumber(result[k]["object_uid"]))
					setElementDimension(created, result[k]["object_world"])
					addObjectTextureInfo(created) -- zadziałczy?
				end

				load = load + 1
			end
		end
	end

	outputDebugString("[load] Usunieto "..ile.." obiektów!")
	outputDebugString("[load] Wczytano "..table.getn(objects).." obiektów!")
	if query then dbFree(query) end
end
addEventHandler ( "onResourceStart", resourceRoot, LoadObjects )

-- zapis obiektu i sync (jakiś błąd jest podczas pierwszej edycji obiektu (?))
function SaveObject(object_uid, x, y, z, rx, ry, rz)
	local object = getObjectByUID(object_uid)
	setElementPosition(object, x, y, z)
	setElementRotation(object, rx, ry, rz)

	local query = dbQuery(handler, "UPDATE lsrp_objects SET object_posx = "..x..", object_posy = "..y..", object_posz = "..z..", object_rotx = "..rx..", object_roty = "..ry..", object_rotz = "..rz.." WHERE object_uid = "..object_uid)
	dbFree(query)
end
addEvent("SaveObject", true)
addEventHandler ( "SaveObject", getRootElement(), SaveObject )

function getObjectByUID(uid)
	local objects = getElementsByType ( "object" )
	for i, object in ipairs(objects) do
		if tonumber(getElementData(object, "object.uid")) == uid then
			return object
		end
	end

	return false
end