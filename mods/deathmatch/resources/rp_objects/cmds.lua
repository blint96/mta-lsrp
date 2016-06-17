local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

-- stawianie obiektu
function playerCreatedObject(thePlayer, command, objectId)
	-- jakieś sprawdzanie drzwi potem etc
	local world = getElementDimension(thePlayer)
	local admin = exports.lsrp:getPlayerAdmin( thePlayer )

	if world == 0 then
		if admin ~= 1 then
			exports.lsrp:showPopup(thePlayer, "Nie możesz tutaj edytować obiektów!", 5 )
			return
		end
	end

	if objectId == nil then
		outputChatBox("#CCCCCCUżycie: /oc [ID Obiektu]", thePlayer, 255, 255, 255, true)
		return
	end


	if world ~= 0 then
		if admin == 0 then
			-- jest na innym niż 0 i nie jest adminem
			local doors = getElementsByType("pickup")
			local player_door = nil

			for i, door in ipairs(doors) do
				if tonumber(getElementData(door, "door.exitvw")) == world then
					player_door = door
					break
				end
			end

			if player_door == nil then
				exports.lsrp:showPopup(thePlayer, "Musisz znajdować się w jakimś budynku by użyć tej komendy!", 5 )
				return
			end

			if tonumber(getElementData(player_door, "door.ownertype")) == 1 then
				-- drzwi należą do gracza
				if tonumber(getElementData(player_door, "door.owner")) ~= tonumber(getElementData(thePlayer, "player.uid")) then
					exports.lsrp:showPopup(thePlayer, "Te drzwi nie należą do Ciebie!", 5 )
					return
				end
			elseif tonumber(getElementData(player_door, "door.ownertype")) == 5 then
				-- sprawdzenie grupy SIM00n
			else
				exports.lsrp:showPopup(thePlayer, "Te drzwi nie należą do Ciebie!", 5 )
				return
			end
		end
	end

	local model = tonumber(objectId)
	local x, y, z = getElementPosition(thePlayer)
	x = x + 2
	
	addObject(model, x, y, z, getElementDimension(thePlayer), getElementInterior(thePlayer))
end
addCommandHandler("oc", playerCreatedObject)

-- osel
function playerSelectObject(thePlayer, command, model)
	local is_edit = getElementData(thePlayer, "player.objedit")
	if is_edit ~= -1 then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Edytujesz już jakiś obiekt!", 5 )
		return
	end

	local world = getElementDimension(thePlayer)
	local admin = tonumber(exports.lsrp:getPlayerAdmin( thePlayer ))

	if world == 0 then
		if admin ~= 1 then
			exports.lsrp:showPopup(thePlayer, "Nie możesz tutaj edytować obiektów!", 5 )
			return
		end
	end

	-- Nie jest adminem, ale jest w jakiś drzwiach, więc sprawdź czy może edytować
	if world ~= 0 then
		if admin == 0 then
			local player_door = nil
			local doors = getElementsByType("pickup")
			for i, door in pairs(doors) do
				if (tonumber(getElementData(door, "door.exitvw")) == world) then
					player_door = door
					break
				end
			end

			if player_door == nil then
				exports.lsrp:showPopup(thePlayer, "Musisz znajdować się w jakimś budynku by użyć tej komendy!", 5 )
				return
			end

			if tonumber(getElementData(player_door, "door.ownertype")) == 1 then
				-- drzwi należą do gracza
				if tonumber(getElementData(player_door, "door.owner")) ~= tonumber(getElementData(thePlayer, "player.uid")) then
					exports.lsrp:showPopup(thePlayer, "Te drzwi nie należą do Ciebie!", 5 )
					return
				end
			elseif tonumber(getElementData(player_door, "door.ownertype")) == 5 then
				-- sprawdzenie grupy SIM00n
			else
				exports.lsrp:showPopup(thePlayer, "Te drzwi nie należą do Ciebie!", 5 )
				return
			end
		end
	end

	-- oselowanie po modelu
	if model ~= nil then
		local x, y, z = getElementPosition(thePlayer)
		local sphere = createColSphere( x, y, z, 25 )
		local objects = getElementsWithinColShape( sphere, "object" )

		local current = nil
		local distance = 0
		for index, object in ipairs(objects) do 
			if getElementModel(object) == tonumber(model) then
				if getElementDimension(thePlayer) == getElementDimension(object) then
					local ox, oy, oz = getElementPosition(object)
					local dis = getDistanceBetweenPoints2D(x, y, ox, oy)
					if dis < distance or distance == 0 then
						current = object
						distance = getDistanceBetweenPoints2D(x, y, ox, oy)
					end
				end
			end
		end

		destroyElement(sphere) -- optymalizacja

		if current == nil then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie znaleziono takiego obiektu w pobliżu!", 5 )
			return
		end

		setElementData(thePlayer, "player.objedit", getElementData(current, "object.uid"))
		triggerClientEvent (thePlayer, "setPlayerToEditObject", thePlayer, current)
		return
	end

	setElementData(thePlayer, "player.objedit", 0)
	triggerClientEvent(thePlayer, "setPlayerToSelectObject", thePlayer)

	-- info
	outputChatBox("#CCCCCCAby anulować wybieranie obiektu wciśnij #990000LALT!", thePlayer, 255, 255, 255, true)
end
addCommandHandler("osel", playerSelectObject)

-- omat
function playerChangeObjectTexture(thePlayer, theCmd, theTextname, theTexID)
	if theTextname == nil or theTexID == nil then 
		outputChatBox("#CCCCCCUżycie: /omat [Nazwa tekstury] [ID Tekstury]", thePlayer, 255, 255, 255, true)
		return
	end

	local is_edit = tonumber(getElementData(thePlayer, "player.objedit"))
	if is_edit == -1 then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie edytujesz żadnego obiektu!", 5 )
		return
	end

	local texture_id = tonumber(theTexID)
	local texture_name = theTextname

	-- query
	local object = getObjectByUID(is_edit)
	local query = dbQuery(handler, "SELECT * FROM lsrp_materials WHERE mat_objectuid = "..is_edit)
	local result = dbPoll(query, -1)
	if query then dbFree(query) end
	local is_new = true
	if result and result[1] then is_new = false end

	-- query 2
	if not is_new then 
		local query = dbQuery(handler, "UPDATE lsrp_materials SET mat_texturename = '".. texture_name .."', mat_textureuid = "..texture_id.." WHERE mat_objectuid = ".. is_edit .." ")
		if query then dbFree(query) end
	else
		local query = dbQuery(handler, "INSERT INTO lsrp_materials VALUES(NULL, ".. is_edit ..", '" .. texture_name .."', ".. texture_id ..")")
		if query then dbFree(query) end
	end

	-- Dodaj na nowo teksturę
	-- Zaraz trzeba loopa przez wszystkich w pobliżu zrobić żeby na nowo teksturkę pobrać
	addObjectTextureInfo(object)
	renderObjectTexture(object, thePlayer)
end
addCommandHandler("omat", playerChangeObjectTexture)

-- Debug no
function objectDebugCommand(thePlayer, theCmd)
	local x, y, z = getElementPosition(thePlayer)
	local sphere = createColSphere ( x, y, z, 300.0 )

	local objects = getElementsWithinColShape ( sphere, "object" )
	local count = 0
	for k, v in ipairs(objects) do 
		if getElementDimension(thePlayer) == getElementDimension(v) then
			count = count + 1;
		end
	end
	destroyElement(sphere)

	outputChatBox("streamowanych obiektow: " .. count, thePlayer)
end
addCommandHandler("odeb", objectDebugCommand)

-- /brama
function gateStatusCommand(thePlayer, theCmd)
	local vw, int, adminlvl = getElementDimension(thePlayer), getElementInterior(thePlayer), tonumber(getElementData(thePlayer, "player.admin"))
	if adminlvl ~= 1 then 
		if vw ~= 0 then 
			local door = exports.rp_doors:getPlayerDoor(thePlayer)
			if not door then 
				exports.lsrp:showPopup(thePlayer, "Brak uprawnień do użycia tej komendy!", 5)
				return
			end

			local o_type = tonumber(getElementData(door, "door.ownertype"))
			if o_type == 0 then 
				return
			end

			if o_type == 1 then 
				if tonumber(getElementData(door, "door.owner")) ~= tonumber(getElementData(thePlayer, "player.uid")) then 
					return
				end
			end

			if o_type == 5 then 
				-- sprawdź czy permy do bram w grupie ma
				-- return
			end
		end
	end

	local object_uid, object_id, distance = 0, 0, 0
	distance = 6
	local opened = 0

	local pX, pY, pZ = getElementPosition(thePlayer)
	local query = "SELECT `object_uid`, `object_posx`, `object_posy`, `object_posz`, `object_rotx`, `object_roty`, `object_rotz`, `object_gatex`, `object_gatey`, `object_gatez`, `object_gaterotx`, `object_gateroty`, `object_gaterotz`, `object_owner` FROM `lsrp_objects` WHERE ((object_posx < '".. pX .."' + '".. distance .."' AND object_posx > '"..pX.."' - '"..distance.."' AND object_posy < '"..pY.."' + '"..distance.."' AND object_posy > '"..pY.."' - '"..distance.."' AND object_posz < '"..pZ.."' + '"..distance.."' AND object_posz > '"..pZ.."' - '"..distance.."') OR (object_gatex < '"..pX.."' + '"..distance.."' AND object_gatex > '"..pX.."' - '"..distance.."' AND object_gatey < '"..pY.."' + '"..distance.."' AND object_gatey > '"..pY.."' - '"..distance.."' AND object_gatez < '"..pZ.."' + '"..distance.."' AND object_gatez > '"..pZ.."' - '"..distance.."')) AND object_world = '"..vw.."' AND object_interior = '"..int.."' AND object_gate = '1' LIMIT 5"
	outputConsole(query)

	local sql = dbQuery(handler, query)
	local result = dbPoll(sql, -1)
	if result and result[1] then 
		local res_num = table.getn(result) 
		for i = 1, res_num do 
			local object = getObjectByUID(tonumber(result[i]["object_uid"]))
			local flag = false
			if not object then break end
			local oX, oY, oZ = getElementPosition(object)

			local closeX, closeY, closeZ = tonumber(result[i]["object_posx"]), tonumber(result[i]["object_posy"]), tonumber(result[i]["object_posz"])
			local openX, openY, openZ = tonumber(result[i]["object_gatex"]), tonumber(result[i]["object_gatey"]), tonumber(result[i]["object_gatez"])

			-- Sprawdzenie flag
			if vw == 0 then
				local group_id = exports.rp_groups:GetGroupID(tonumber(result[i]["object_owner"]))
				if not exports.rp_groups:IsPlayerInGroup(thePlayer, group_id) then 
					if adminlvl < 1 then 
						flag = false
					end
				else
					if exports.rp_groups:IsPlayerHasPermTo(thePlayer, group_id, 16) then 
						flag = true
					end
				end
			else
				flag = true
			end

			if adminlvl > 0 then 
				flag = true
			end

			if flag then 
				if oX == closeX and oY == closeY and oZ == closeZ then 
					-- otwórz
					moveObject(object, 2500, openX, openY, openZ, tonumber(result[i]["object_gaterotx"]), tonumber(result[i]["object_gateroty"]), tonumber(result[i]["object_gaterotz"]))
				else
					-- zamknij
					moveObject(object, 2500, closeX, closeY, closeZ, tonumber(result[i]["object_rotx"]), tonumber(result[i]["object_roty"]), tonumber(result[i]["object_rotz"]))
				end
			end

			opened = opened + 1
		end
	end

	if sql then dbFree(sql) end
end
addCommandHandler("brama", gateStatusCommand)