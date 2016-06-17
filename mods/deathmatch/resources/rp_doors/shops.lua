local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
-- c_doors.lua -> wnd_shopping

------------------------------------------------------
-- Handlery komend, komendy
------------------------------------------------------
function cjClothesCommand(thePlayer, theCmd )
	if tonumber(getElementData(thePlayer, "player.admin")) == 0 then
		exports.lsrp:showPopup(thePlayer, "Brak uprawnień do użycia tej komendy.", 7)
		return
	end

	if getElementModel(thePlayer) ~= 0 then 
		exports.lsrp:showPopup(thePlayer, "Musisz być w skinie CJa.", 7)
		return
	end

	addPedClothes ( thePlayer, "hoodyAblack", "hoodyA", 0 )
	addPedClothes ( thePlayer, "baldgoatee", "head", 1 )
	addPedClothes ( thePlayer, "worktrgrey", "worktr", 2 )
	addPedClothes ( thePlayer, "timbergrey", "bask1", 3 )
	addPedClothes ( thePlayer, "glasses04dark", "glasses04", 15 )
	addPedClothes ( thePlayer, "dogtag", "neck", 13 )
	setPlayerStat( thePlayer, 23, 999)
	setPedWalkingStyle ( thePlayer, 121 )
end
addCommandHandler("cj", cjClothesCommand)

function playerClothesCommand(thePlayer, theCommand)
	-- sprawdzanie dodaj potem czy w sklepie jest lol
	local world = getElementDimension(thePlayer)
	if world ~= 0 then 
		local pDoor = getPlayerDoor(thePlayer)
		if pDoor ~= false then 
			if tonumber(getElementData(pDoor, "door.ownertype")) == 5 then 
				local group_uid = tonumber(getElementData(pDoor, "door.owner"))
				local group_type = tonumber(exports.rp_groups:GetGroupType(group_uid))

				if group_type == 11 then
					triggerClientEvent(thePlayer, "onPlayerStartClothesSelect", thePlayer)
					return
				else
					exports.lsrp:showPopup(thePlayer, "Nie jesteś w sklepie z ciuchami.", 5)
					return
				end
			else
				exports.lsrp:showPopup(thePlayer, "Nie jesteś w sklepie z ciuchami.", 5)
				return
			end
		else
			exports.lsrp:showPopup(thePlayer, "Aby użyć tej komendy musisz znajdować się w budynku.", 5)
			return
		end
	else
		exports.lsrp:showPopup(thePlayer, "Aby użyć tej komendy musisz znajdować się w budynku.", 5)
		return
	end
end

function playerBuyCommand(thePlayer, theCommand)
	local world = getElementDimension(thePlayer)
	if world ~= 0 then 
		local pDoor = getPlayerDoor(thePlayer)
		if pDoor ~= false then 
			local query = dbQuery(handler, "SELECT * FROM lsrp_products WHERE product_dooruid = '".. getElementData(pDoor, "door.uid") .."'")
			local result = dbPoll(query, -1)

			if result then 
				local result_num = table.getn(result)
				local index = 0
				if result_num > 0 then
					local theArray = {}
					for i = 1, result_num do 
						theArray[index] = {}
						theArray[index]["product_uid"] = result[i]["product_uid"]
						theArray[index]["product_name"] = result[i]["product_name"]
						theArray[index]["product_count"] = result[i]["product_number"]
						theArray[index]["product_price"] = result[i]["product_price"]
						theArray[index]["product_type"] = result[i]["product_type"]
						theArray[index]["product_value1"] = result[i]["product_value1"]
						theArray[index]["product_value2"] = result[i]["product_value2"]
						index = index + 1
					end
					triggerClientEvent(thePlayer, "onPlayerStartShopping", thePlayer, theArray)
				else
					exports.lsrp:showPopup(thePlayer, "Brak produktów w magazynie.", 5)
				end
			else
				exports.lsrp:showPopup(thePlayer, "Brak produktów w magazynie.", 5)
			end

			if query then dbFree(query) end
			return
		else
			-- Nie jest w drzwiach
			exports.lsrp:showPopup(thePlayer, "Aby użyć tej komendy musisz znajdować się w budynku.", 5)
			return
		end
	else
		-- póki co info
		-- potem jakieś budki etc.
		exports.lsrp:showPopup(thePlayer, "Aby użyć tej komendy musisz znajdować się w budynku.", 5)
		return
	end
end

------------------------------------------------------
-- Jakieś pierdółkowe f-cje
------------------------------------------------------
function createServerCloth(thePlayer, theModel, theName)
	exports.rp_items:createItem(thePlayer, 5, tonumber(theModel), 0, theName)
end

function createItemFromClientRequest(thePlayer, itemName, itemType, itemValue1, itemValue2, productID, delete)
	if itemType == 8 then 
		itemValue1 = math.random(100000, 999999)
	end

	if delete == true then 
		local query = dbQuery(handler, "DELETE FROM lsrp_products WHERE product_uid = '".. productID .."'")
		if query then dbFree(query) end
	else
		local query = dbQuery(handler, "UPDATE lsrp_products SET product_number = product_number - 1 WHERE product_uid = '".. productID .."'")
		if query then dbFree(query) end
	end

	exports.rp_items:createItem(thePlayer, itemType, itemValue1, itemValue2, itemName)
end

function showPlayerOrderMenu(thePlayer)
	local resArray = nil
	local query = dbQuery(handler, "SELECT * FROM lsrp_orders_cat")
	local result = dbPoll(query, -1)
	if result then 
		if result[1] then
			resArray = {}
			local index = 0
			local len = table.getn(result)

			for i = 1, len do
				resArray[index] = {}
				resArray[index]["cat_uid"] = result[i]["cat_uid"]
				resArray[index]["cat_name"] = result[i]["cat_name"]
				index = index + 1
			end

			triggerClientEvent (thePlayer, "showOrders", thePlayer, resArray, 1)
		end
	end
	if query then dbFree(query) end
end

function showPlayerAvailableProducts(thePlayer, cat_id)
	local pDoor = getPlayerDoor(thePlayer)
	if pDoor ~= false then 
		local ownertype = tonumber(getElementData(pDoor, "door.ownertype"))
		local owner = tonumber(getElementData(pDoor, "door.owner"))
		local group_type = tonumber(exports.rp_groups:GetGroupType(owner))

		local query = dbQuery(handler, "SELECT * FROM `lsrp_orders` WHERE order_ownertype = 5 AND order_owner = "..group_type.." AND order_type = "..tonumber(cat_id).." OR order_ownertype = 0 AND order_owner = "..owner.." AND order_type = "..tonumber(cat_id))
		local result = dbPoll(query, -1)

		if result then 
			if result[1] then 
				resArray = {}
				local index = 0
				local len = table.getn(result)

				for i = 1, len do 
					resArray[index] = {}
					-- do wyświetlenia
					resArray[index]["order_uid"] = result[i]["order_uid"]
					resArray[index]["order_name"] = result[i]["order_name"]

					-- reszta
					resArray[index]["order_price"] = result[i]["order_price"]
					index = index + 1
				end

				triggerClientEvent (thePlayer, "showOrders", thePlayer, resArray, 2)
			else
				exports.lsrp:showPopup(thePlayer, "Brak dostępnych produktów.", 5)
				return
			end
		else
			exports.lsrp:showPopup(thePlayer, "Brak dostępnych produktów.", 5)
			return
		end
	end
	return false
end

-- Koniec kupwoania, zabierz kasę etc.
function onPlayerFinishOrder(thePlayer, beforeCash, orderID, order_num, productPrice)
	setPlayerMoney(thePlayer, beforeCash)
	setElementData(thePlayer, "player.cash", beforeCash)

	-- pobierz info, dodaj do lsrp_packages
	local query = dbQuery(handler, "SELECT * FROM lsrp_orders WHERE order_uid = "..orderID)
	local result = dbPoll(query, -1)

	local door_uid = tonumber(getElementData(getPlayerDoor(thePlayer), "door.uid"))
	
	-- PRODUKCYJNY
	--local insert = dbQuery(handler, "INSERT INTO lsrp_packages VALUES (NULL, "..door_uid..", '".. result[1]["order_name"] .."', '".. result[1]["order_itemtype"] .."', '".. result[1]["order_itemvalue1"] .."', '".. result[1]["order_itemvalue2"] .."', '".. order_num .."', 1, 0)")
	--dbFree(insert)

	-- BETA
	local insert = dbQuery(handler, "INSERT INTO lsrp_products VALUES (NULL, '".. result[1]["order_name"] .."', '".. result[1]["order_itemtype"] .."', '".. result[1]["order_itemvalue1"] .."', '".. result[1]["order_itemvalue2"] .."', '".. productPrice .."', '"..order_num.."', '"..door_uid.."')") 
	dbFree(insert)

	if query then dbFree(query) end
	exports.lsrp:showPopup(thePlayer, "Zlecenie zostało zaakceptowane!", 5)
end


------------------------------------------------------
-- Eventy
------------------------------------------------------
addEvent("onPlayerShowAvaiableProducts", true)
addEventHandler("onPlayerShowAvaiableProducts", getRootElement(), showPlayerAvailableProducts)

addEvent("onPlayerFinishOrder", true)
addEventHandler("onPlayerFinishOrder", getRootElement(), onPlayerFinishOrder)

addEvent("onPlayerClothBuy", true)
addEventHandler("onPlayerClothBuy", getRootElement(), createServerCloth)

addEvent("onPlayerCreateItemRequest", true)
addEventHandler("onPlayerCreateItemRequest", getRootElement(), createItemFromClientRequest)

addCommandHandler("ubranie", playerClothesCommand)
addCommandHandler("kup", playerBuyCommand)