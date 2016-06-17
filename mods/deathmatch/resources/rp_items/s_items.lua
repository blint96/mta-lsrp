local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
addEventHandler ( "onResourceStart", resourceRoot, function() outputDebugString("[startup] Załadowano system przedmiotów") loadCorpsesOnStart() end )

-- ładowanie ciałek na starcie serwera
function loadCorpsesOnStart()
	local query = dbQuery(handler, "SELECT * FROM lsrp_items WHERE item_type = '".. ITEM_CORPSE .."' AND item_place = 0")
	local result = dbPoll(query, -1)

	if result then
		for k = 1, table.getn(result) do 
			local obj = createObject(1574, result[k]["item_posx"], result[k]["item_posy"], result[k]["item_posz"])
			if obj then
				setElementData(obj, "object.itemuid", tonumber(result[k]["item_uid"]))
				setElementDimension(obj, tonumber(result[k]["item_world"]))
			end
		end
	end

	if query then dbFree(query) end
end

-- Pokaż itemy
function showPlayerItemsCommand(thePlayer, command, exParam)
	
	if exParam == "podnies" or exParam == "szukaj" then
		if not isPedInVehicle(thePlayer) then
			-- ziemia
			listPlayerNearItemsOnFoot(thePlayer)
		else
			-- auta
		end
		return
	elseif exParam == nil or exParam == "lista" then
		local query = dbQuery(handler, "SELECT * FROM lsrp_items WHERE item_place = 1 AND item_owner = "..getElementData(thePlayer, "player.uid"))
		local result = dbPoll ( query, -1 )

		if result then
			if result[1] then
				itemarray = {}
				local index = 0
				local item_num = table.getn(result)

				for i = 1, item_num do 
					itemarray[index] = {}
					itemarray[index][1] = result[i]["item_uid"]
					itemarray[index][2] = result[i]["item_name"]
					itemarray[index][3] = result[i]["item_weight"]
					itemarray[index][4] = result[i]["item_type"]
					itemarray[index][5] = result[i]["item_used"]
					itemarray[index][6] = result[i]["item_value1"]
					itemarray[index][7] = result[i]["item_value2"]
					index = index + 1
				end

				triggerClientEvent (thePlayer, "fillItemsGrid", thePlayer, itemarray)
				return
			else
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie posiadasz przedmiotów przy sobie.", 5 )
			end
		end
	end

	--triggerClientEvent (thePlayer, "fillItemsGrid", thePlayer, itemarray)
	call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie posiadasz przedmiotów przy sobie.", 5 )
end
addCommandHandler("p", showPlayerItemsCommand)
addEvent("showPlayerItemsForPlayer", true)
addEventHandler("showPlayerItemsForPlayer", getRootElement(), showPlayerItemsCommand)

-- Funkcja zwracająca tablicę przedmiotów gracza
function getPlayerItemsArray(thePlayer)
	local query = dbQuery(handler, "SELECT * FROM lsrp_items WHERE item_place = 1 AND item_owner = "..getElementData(thePlayer, "player.uid"))
	local result = dbPoll ( query, -1 )

	if result then
		itemarray = {}
		local index = 0
		local item_num = table.getn(result)

		for i = 1, item_num do 
			itemarray[index] = {}
			itemarray[index][1] = result[i]["item_uid"]
			itemarray[index][2] = result[i]["item_name"]
			itemarray[index][3] = result[i]["item_weight"]
			itemarray[index][4] = result[i]["item_type"]
			itemarray[index][5] = result[i]["item_used"]
			itemarray[index][6] = result[i]["item_value1"]
			itemarray[index][7] = result[i]["item_value2"]
			index = index + 1
		end

		if query then dbFree(query) end
		return itemarray
	end
	if query then dbFree(query) end
	return false
end

function createItem(thePlayer, itemType, itemVal1, itemVal2, itemName)
	local query = dbQuery(handler, "INSERT INTO lsrp_items VALUES(NULL, '".. itemName .."', "..tonumber(itemVal1)..", "..tonumber(itemVal2)..", "..tonumber(itemType)..", 0.0, 0.0, 0.0, 1, "..tonumber(getElementData(thePlayer, "player.uid"))..", 0, 0, 0, 1.0, '')")
	if query then dbFree(query) end
end

--[[
----------------------------------
--	Zmiana użycia przedmiotu
----------------------------------
]]--
function setItemUse(item_uid, used)
	if used == true then
		local query = dbQuery(handler, "UPDATE lsrp_items SET item_used = 1 WHERE item_uid = "..tonumber(item_uid))
		if query then dbFree(query) end
	else
		local query = dbQuery(handler, "UPDATE lsrp_items SET item_used = 0 WHERE item_uid = "..tonumber(item_uid))
		if query then dbFree(query) end
	end
end

function getItemUse(item_uid)
	local query = dbQuery(handler, "SELECT item_used FROM lsrp_items WHERE item_uid = "..tonumber(item_uid))
	local result = dbPoll(query, -1)

	local used = result[1]["item_used"]
	if query then dbFree(query) end
	return used
end

--[[
----------------------------------
-- Przedmioty w pobliżu, podnoszenie etc.
----------------------------------
]]--
function playerPickupItem(thePlayer, itemUid)
	local query = dbQuery(handler, "UPDATE lsrp_items SET item_place = 1, item_owner = '"..tonumber(getElementData(thePlayer, "player.uid")).."' WHERE item_uid = '".. tonumber(itemUid) .."'")
	if query then dbFree(query) end

	exports.lsrp:imitationMe(thePlayer, "podnosi jakiś przedmiot." )
	setPedAnimation(thePlayer, "BOMBER", "BOM_Plant", -1, false, false, true, false)

	-- sprawdzanie obiektów
	local objects = getElementsByType("object")
	for k, object in ipairs(objects) do 
		if tonumber(getElementData(object, "object.itemuid")) == tonumber(itemUid) then 
			destroyElement(object)
			break
		end
	end
end
addEvent("onPlayerPickupItem", true)
addEventHandler("onPlayerPickupItem", getRootElement(), playerPickupItem)

function listPlayerNearItemsOnFoot(thePlayer)
	local pX, pY, pZ = getElementPosition(thePlayer)
	local world = getElementDimension(thePlayer)

	local itemArray = {}
	local query = dbQuery(handler, "SELECT `item_uid`, `item_name`, `item_weight` FROM `lsrp_items` WHERE item_posx < '"..tonumber(pX + 2).."' AND item_posx > '"..tonumber(pX - 2 ).."' AND item_posy < '"..tonumber(pY + 2).."' AND item_posy > '"..tonumber(pY -2).."' AND item_posz < '"..tonumber(pZ + 2).."' AND item_posz > '"..tonumber(pZ - 2).."' AND item_place = 0 AND item_world = '"..world.."'")
	local result = dbPoll(query, -1)

	if result then
		local index = 0
		local item_num = table.getn(result)

		for i = 1, item_num do 
			itemArray[index] = {}
			itemArray[index][1] = result[i]["item_uid"]
			itemArray[index][2] = result[i]["item_name"]
			itemArray[index][3] = result[i]["item_weight"]
			index = index + 1
		end
	end

	if table.getn(result) > 0 then
		-- C-Side
		triggerClientEvent (thePlayer, "fillNearItemsGrid", thePlayer, itemArray)
	else
		exports.lsrp:showPopup(thePlayer, "W pobliżu nie ma żadnych przedmiotów.", 5)
	end

	-- Czyścimy
	if query then dbFree(query) end
end

function listPlayerNearItemsInVehicle(thePlayer)

end

--[[
----------------------------------
--	Funkcje do broni
----------------------------------
]]--
function getWeaponType(weap_model)
	if (weap_model == 22 or weap_model == 23 or weap_model == 24) then return WEAPONSLOT_TYPE_HANDGUN end -- handgun
	if (weap_model == 0 or weap_model == 1) then return WEAPONSLOT_TYPE_UNARMED end
	if (weap_model == 2 or weap_model == 3 or weap_model == 4 or weap_model == 5 or weap_model == 6 or weap_model == 7 or weap_model == 8 or weap_model == 9) then return WEAPONSLOT_TYPE_MELEE end
	if (weap_model == 25 or weap_model == 26 or weap_model == 27) then return WEAPONSLOT_TYPE_SHOTGUN end
	if (weap_model == 28 or weap_model == 29 or weap_model == 32) then return WEAPONSLOT_TYPE_SMG end
	if (weap_model == 30 or weap_model == 31) then return WEAPONSLOT_TYPE_RIFLE end
end

function insertWeaponToData(thePlayer, weaponUid, weaponType, weaponAmmo)
	if getElementData(thePlayer, "player.pweapon") == nil then
		-- jak nie ma to dodaj
		local new_array = {} new_array[1] = weaponUid new_array[2] = weaponType new_array[3] = weaponAmmo
		setElementData(thePlayer, "player.pweapon", new_array)
		return true
	elseif getElementData(thePlayer, "player.sweapon") == nil then
		-- jak nie ma to dodaj
		local new_array = {} new_array[1] = weaponUid new_array[2] = weaponType new_array[3] = weaponAmmo
		setElementData(thePlayer, "player.sweapon", new_array)
		return true
	end
	return false
end

-- usuwanie z tabeli
function deleteWeaponFromData(thePlayer, weaponUid)
	if getElementData(thePlayer, "player.pweapon") ~= nil then
		local weapon = getElementData(thePlayer, "player.pweapon")
		if tonumber(weapon[1]) == tonumber(weaponUid) then
			setElementData(thePlayer, "player.pweapon", nil)
		end
	end

	if getElementData(thePlayer, "player.sweapon") ~= nil then
		local weapon = getElementData(thePlayer, "player.sweapon")
		if tonumber(weapon[1]) == tonumber(weaponUid) then
			setElementData(thePlayer, "player.sweapon", nil)
		end
	end
	return false
end

-- Sprawdzenie czy nie ma takiej borni już w eq
function isPlayerAllowToPickWeapon(thePlayer, weaponType)
	local is_allow = true
	if getElementData(thePlayer, "player.pweapon") ~= nil then
		-- jak ma to sprawdź jaką
		local array = getElementData(thePlayer, "player.pweapon")
		if array[2] == weaponType then
			is_allow = false
		end
	end

	if getElementData(thePlayer, "player.sweapon") ~= nil then
		-- jak ma to sprawdź jaką
		local array = getElementData(thePlayer, "player.sweapon")
		if array[2] == weaponType then
			is_allow = false
		end
	end
	return is_allow
end

-- usuwanie obiektu jak odużywa broń
function deleteAttachWhenHideWeapon(thePlayer, weapon_id)
	local objects = getElementsByType ( "object" )
	for i, object in ipairs(objects) do
		if getElementModel(object) == tonumber(weaponsOb[tonumber(weapon_id)]) then
			if (tonumber(getElementData(object, "object.stickto")) == tonumber(getElementData(thePlayer, "player.uid"))) then
				exports.boneattach:detachElementFromBone(object)
				destroyElement(object)
			end
		end
	end
end

-- zapis broni jak wyjdzie z użytą lub zginie z użytą
function savePlayerWeaponsWhenUsed(thePlayer)
	if getElementData(thePlayer, "player.pweapon") ~= nil then
		-- jak ma to sprawdź jaką
		local array = getElementData(thePlayer, "player.pweapon")
		if array[2] then
			local leftAmmo = getPedTotalAmmo(thePlayer, getWeaponType(array[2]))
			takeWeapon(thePlayer, tonumber(array[2]))

			setItemUse(array[1], false)
			deleteWeaponFromData(thePlayer, array[1]) -- test

			local query = dbQuery(handler, "UPDATE lsrp_items SET item_value2 = "..tonumber(leftAmmo).." WHERE item_uid = "..tonumber(array[1]))
			if query then dbFree(query) end
		end
	end

	if getElementData(thePlayer, "player.sweapon") ~= nil then
		-- jak ma to sprawdź jaką
		local array = getElementData(thePlayer, "player.sweapon")
		if array[2] then
			local leftAmmo = getPedTotalAmmo(thePlayer, getWeaponType(array[2]))
			takeWeapon(thePlayer, tonumber(array[2]))

			setItemUse(array[1], false)
			deleteWeaponFromData(thePlayer, array[1]) -- test

			local query = dbQuery(handler, "UPDATE lsrp_items SET item_value2 = "..tonumber(leftAmmo).." WHERE item_uid = "..tonumber(array[1]))
			if query then dbFree(query) end
		end
	end
end

function applyPlayerWeaponSkill(thePlayer)
	local stat = ((1000 * tonumber(getElementData(thePlayer, "player.shooting"))) / 100)
	setPedStat(thePlayer, 69, stat)
	setPedStat(thePlayer, 70, stat)
	setPedStat(thePlayer, 71, stat)
	setPedStat(thePlayer, 72, stat)
	setPedStat(thePlayer, 73, stat)
	setPedStat(thePlayer, 74, stat)
	setPedStat(thePlayer, 75, stat)
	setPedStat(thePlayer, 76, stat)
	setPedStat(thePlayer, 77, stat)
	setPedStat(thePlayer, 78, stat)
	setPedStat(thePlayer, 79, stat)
end
addEvent("OnPlayerSkillUp", true)
addEventHandler("OnPlayerSkillUp", getRootElement(), applyPlayerWeaponSkill)

--[[
----------------------------------
--	Funkcje do telefonów
----------------------------------
]]--
function isPlayerAllowToTogglePhone(thePlayer)
	local phone_num = 0
	local query = dbQuery(handler, "SELECT * FROM lsrp_items WHERE item_place = 1 AND item_owner = "..getElementData(thePlayer, "player.uid"))
	local result = dbPoll ( query, -1 )
	if result then
		local item_num = tonumber(table.getn(result))
		for i = 1, item_num do 
			if result[i]["item_type"] == 8 then
				if tonumber(result[i]["item_used"]) > 0 then
					phone_num = phone_num + 1
				end
			end
		end
	end

	if phone_num > 0 then
		return false
	else
		return true
	end
end

function setPlayerPhoneNumberOnJoin(thePlayer)
	local query = dbQuery(handler, "SELECT * FROM lsrp_items WHERE item_place = 1 AND item_type = 8 AND item_owner = "..getElementData(thePlayer, "player.uid"))
	local result = dbPoll ( query, -1 )
	if result then
		local item_num = tonumber(table.getn(result))
		for i = 1, item_num do 
			if tonumber(result[i]["item_used"]) > 0 then
				setElementData(thePlayer, "player.phonenumber", tonumber(result[i]["item_value1"]))
				return true
			end
		end
	end

	setElementData(thePlayer, "player.phonenumber", 0)
	return false
end

--[[
|-------------------------------------------------
|	Używanie itemków, onItemUse
| 	1. Jeśli przedmiot jest jednorazowy to dodaj triggerClientEvent(thePlayer, "hideItemUseForm", thePlayer)
|	2. Jeśli przedmiot ma zmieniać status użycia to użyj triggerClientEvent(thePlayer, "changeUseStatus", thePlayer, false/true)
|-------------------------------------------------
]]--

function onItemUse(thePlayer, itemUid, itemType, itemValue1, itemValue2)

	-- Anty buggerino
	if getItemPlace(itemUid) == 0 then 
		exports.lsrp:showPopup(thePlayer, "Wystąpił błąd z przedmiotem.", 5 )
		return
	end

	-- Typ: 0 -- Nieokreślony
	if itemType == ITEM_NONE then
		exports.lsrp:showPopup(thePlayer, "Nie da się użyć tego przedmiotu.", 5 )
	end

	-- Typ: 1 -- Zegarek
	if itemType == ITEM_WATCH then
		local hour, minutes = getTime()
		local output = hour..":"..minutes

		if minutes < 10 then
			output = hour..":".."0"..minutes
		end
		call ( getResourceFromName ( "lsrp" ), "gameTextForPlayer", thePlayer, output, 4 )
	end

	-- Typ: 2 -- Jedzenie
	if itemType == ITEM_FOOD then
		local health = getElementHealth(thePlayer)
		local before = health + tonumber(itemValue1)

		if health >= 100 then
			outputChatBox( "#9999CC** Czujesz się najedzony.", thePlayer, 255, 255, 255, true)
			return
		end

		if before > 100 then
			setElementHealth(thePlayer, 100)
		else
			setElementHealth(thePlayer, before)
		end

		triggerClientEvent(thePlayer, "hideItemUseForm", thePlayer)
		exports.lsrp:imitationMe(thePlayer, "spożywa posiłek." )
		local query = dbQuery(handler, "DELETE FROM lsrp_items WHERE item_uid = "..itemUid)
		dbFree(query)
	end

	-- Typ: 3 -- Papierosy
	if itemType == ITEM_CIGGY then
		exports.lsrp:showPopup(thePlayer, "Nie da się użyć tego przedmiotu.", 5 )
	end

	-- Typ: 5 -- Ubrania
	if itemType == ITEM_CLOTH then
		setElementData(thePlayer, "player.skin", tonumber(itemValue1))
		setElementModel(thePlayer, tonumber(itemValue1))
	end

	-- Typ: 6 -- Broń
	if itemType == ITEM_WEAPON then
		if getItemUse(itemUid) > 0 then
			-- Zapis można tutaj dodać
			setItemUse(itemUid, false)
			triggerClientEvent(thePlayer, "changeUseStatus", thePlayer, false)
			deleteAttachWhenHideWeapon(thePlayer, tonumber(itemValue1)) -- usuwanie przyczepianego

			local leftAmmo = getPedTotalAmmo(thePlayer, getWeaponType(itemValue1)) -- to nic nie zwraca bo tylko zmienną robimy
			takeWeapon(thePlayer, tonumber(itemValue1))
			deleteWeaponFromData(thePlayer, tonumber(itemUid)) -- test
			local query = dbQuery(handler, "UPDATE lsrp_items SET item_value2 = "..tonumber(leftAmmo).." WHERE item_uid = "..tonumber(itemUid))
			if query then dbFree(query) end
		else
			-- Używanie, uzbrajanie broni
			if (tonumber(itemValue2) <= 0) then
				exports.lsrp:showPopup(thePlayer, "Amunicja w tej broni jest wyczerpana.", 5 )
				return
			end

			if not isPlayerAllowToPickWeapon(thePlayer, itemValue1) then
				exports.lsrp:showPopup(thePlayer, "Masz już jedną taką broń w użyciu.", 5 )
				return
			end

			applyPlayerWeaponSkill(thePlayer)
			insertWeaponToData(thePlayer, itemUid, itemValue1, itemValue2)
			setItemUse(itemUid, true)
			giveWeapon(thePlayer, tonumber(itemValue1), tonumber(itemValue2))
			triggerClientEvent(thePlayer, "changeUseStatus", thePlayer, true)
		end
	end

	-- Typ: 8 -- Telefon
	if itemType == ITEM_PHONE then
		if getItemUse(itemUid) > 0 then
			setItemUse(itemUid, false)
		else
			setItemUse(itemUid, true)
		end

		setPlayerPhoneNumberOnJoin(thePlayer)
	end

	-- Pierdole to MTA, chciałem pomóc, jak zwykle jakieś ich pojebane exporty
	-- servery, clienty i chuj wie co jeszcze nie działają -,-
	-- Wywala błąd jak używam tej zjebanej getNearbyPlayerCar chociaż dodałem
	-- to do exportów w rp_vehicles. Pierdole takie kodzenie -,-
	if itemType == ITEM_CANISTER then
		local gas_amount = tonumber(itemValue1)
		local car = exports.rp_vehicles:getNearbyPlayerCar(thePlayer, 3)
		if not car then
			exports.lsrp:showPopup(thePlayer, "W pobliżu nie ma żadnego pojazdu!", 5 )
			return
		end
		local current_gas = getElementData(car, "vehicle.fuel")

		-- buggerino!
		if gas_amount <= 0 then
			exports.lsrp:showPopup(thePlayer, "Ten kanister jest pusty!!", 5 )
			return
		end

		if isPedInVehicle(thePlayer) then
			exports.lsrp:showPopup(thePlayer, "Wyjdź z auta jeśli chcesz użyć kanistra.", 5 )
			return
		end

		local delta = 0		
		if current_gas + gas_amount <= exports.rp_vehicles:GetVehicleMaxFuel(getElementModel(car)) then
			delta = gas_amount
		else
			delta = exports.rp_vehicles:GetVehicleMaxFuel(getElementModel(car)) - current_gas
		end
		
		setElementData(car, "vehicle.fuel", current_gas + delta)
		itemValue1 = itemValue1 - delta
		local query = dbQuery(handler, "UPDATE lsrp_items SET item_value1 = " .. itemValue1 .. " WHERE item_uid = "..tonumber(itemUid))
		
		outputChatBox("#669999Pomyślnie zatankowałeś ".. delta .." litrów z kanistra#669999!", thePlayer, 255, 255, 255, true)
	end

	-- Typ: 37 -- zwłoki
	if itemType == ITEM_CORPSE then
		exports.lsrp:showPopup(thePlayer, "wip.", 5 )
	end

	------------------------------
	-- To musi być na końcu
	------------------------------
	triggerClientEvent (thePlayer, "fillItemsGrid", thePlayer, getPlayerItemsArray(thePlayer))
end
addEvent("onItemUse", true)
addEventHandler("onItemUse", getRootElement(), onItemUse)

--[[
|-------------------------------------------------
|	Odkładanie itemów
|-------------------------------------------------
]]--

function getItemPlace(itemUid)
	local query = dbQuery(handler, "SELECT item_place FROM lsrp_items WHERE item_uid = "..tonumber(itemUid))
	local result = dbPoll(query, -1)
	if query then dbFree(query) end

	return tonumber(result[1]["item_place"])
end

function onItemDrop(thePlayer, itemUid, itemType, itemValue1)
	
	-- Anty buggerino
	if getItemPlace(itemUid) == 0 then 
		exports.lsrp:showPopup(thePlayer, "Wystąpił błąd z przedmiotem.", 5 )
		return
	end

	-- Jak oferta to nie może, jak uzyty to nie może
	if (getItemUse(itemUid) > 0 ) then
		exports.lsrp:showPopup(thePlayer, "Nie możesz odłożyć przedmiotu w trakcie gdy go używasz.", 5 )
		return
	end

	if not isPedInVehicle(thePlayer) then
		-- na ziemie
		local posX, posY, posZ = getElementPosition(thePlayer)
		if tonumber(itemType) == ITEM_WEAPON then
			i_obj = createObject(tonumber(weaponsOb[itemValue1]), posX, posY, posZ-1.0, 90, 45, 0) 
		elseif tonumber(itemType) == ITEM_CLOTH then
			i_obj = createObject(2843, posX, posY, posZ-1.0, 0, 0, 0) 
		elseif tonumber(itemType) == ITEM_PHONE then
			i_obj = createObject(330, posX, posY, posZ-1.0, 90, 0, 0) 
		elseif tonumber(itemType) == ITEM_CORPSE then
			i_obj = createObject(1574, posX, posY, posZ-1.0, 0, 0, 0) 
		else
			i_obj = createObject(328, posX, posY, posZ-1.0, 90, 90, 0) -- potem jakieś IDy przedmiotów się porobi
		end
		if i_obj then setElementData(i_obj, "object.itemuid", itemUid) end -- do usuwania jak użyje
		if i_obj then setElementDimension(i_obj, getElementDimension(thePlayer)) end
		if i_obj then setElementInterior(i_obj, getElementInterior(thePlayer)) end

		setPedAnimation(thePlayer, "BOMBER", "BOM_Plant", -1, false, false, true, false)
		exports.lsrp:imitationMe(thePlayer, "odkłada jakiś przedmiot.")

		local query = dbQuery(handler, "UPDATE lsrp_items SET item_world = '"..getElementDimension(thePlayer).."', item_posx = '".. posX .."', item_posy = '".. posY .."', item_posz = '".. (posZ - 1.0) .."', item_place = 0 WHERE item_uid = ".. itemUid .." ")
		if query then dbFree(query) end

		-- Przeładuj widok przedmiotów, schowaj używajke
		triggerClientEvent(thePlayer, "hideItemUseForm", thePlayer)
		triggerClientEvent (thePlayer, "fillItemsGrid", thePlayer, getPlayerItemsArray(thePlayer))
	else
		-- do auta, sprawdź czy wóz do niego należy, do grupy etc.
	end
end
addEvent("onItemDrop", true)
addEventHandler("onItemDrop", getRootElement(), onItemDrop)