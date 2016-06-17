local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
addEventHandler ( "onResourceStart", resourceRoot, function() outputDebugString("[startup] Załadowano system ofert") end )

local send_offer = {}
local gain_offer = {}
extra = {}
-- POTEM ZRÓB WYJĄTEK DLA TEGO SAMEGO CO WYSYŁA BO BUGGERINO
-- POTEM ZRÓB WYJĄTEK DLA TEGO SAMEGO CO WYSYŁA BO BUGGERINO
-- POTEM ZRÓB WYJĄTEK DLA TEGO SAMEGO CO WYSYŁA BO BUGGERINO
-- POTEM ZRÓB WYJĄTEK DLA TEGO SAMEGO CO WYSYŁA BO BUGGERINO

function offers_standardResponses(thePlayer, target_id)
	local target = exports.lsrp:getPlayerByID(tonumber(target_id))
	if not target then 
		exports.lsrp:showPopup(thePlayer, "Taki gracz nie jest podłączony do serwera.", 5 )
		return false
	end

	if (getElementData(target, "player.logged") == false) then
		exports.lsrp:showPopup(thePlayer, "Ten gracz nie zalogował się jeszcze do gry.", 5 )
		return false
	end

	-- sam sobie nie bedzie mogl wysylac
	if target == thePlayer then 
		exports.lsrp:showPopup(thePlayer, "Nie możesz wysyłać oferty sam sobie.", 5)
		return
	end

	local ox, oy, oz = getElementPosition(thePlayer)
	local rx, ry, rz = getElementPosition(target)
	local distance = getDistanceBetweenPoints3D ( ox, oy, oz, rx, ry, rz )
	if getElementDimension(target) ~= getElementDimension(thePlayer) then
		exports.lsrp:showPopup(thePlayer, "Taki gracz jest poza Twoim zasięgiem!", 5 )
		return false
	end

	if distance > 5.0 then
		exports.lsrp:showPopup(thePlayer, "Taki gracz jest poza Twoim zasięgiem!", 5 )
		return false
	end

	return true
end

-- KOMENDA
function offerCmd(thePlayer, theCmd, theType, theTarget, thePrice)
	if theType == nil then
		outputChatBox("#CCCCCCUżycie: /oferuj [pojazd | lakierowanie | produkt | przywitanie | naprawe]", thePlayer, 255, 255, 255, true)
		return
	end

	-- lakierowanie OFFER_TYPE_PAINTw
	if theType == "lakierowanie" then 
		if theTarget == nil or thePrice == nil then
			outputChatBox("#CCCCCCUżycie: /oferuj lakierowanie [ID Gracza] [Cena]", thePlayer, 255, 255, 255, true)
			return
		end

		-- Standardowe sprawdzenia
		if not offers_standardResponses(thePlayer, tonumber(theTarget)) then return end
		local target = exports.lsrp:getPlayerByID(tonumber(theTarget))

		-- Reszta
		local price = tonumber(thePrice)
		local is_onduty, duty_type, duty_id, duty_groupuid, duty_start = exports.rp_groups:getPlayerDutyInfo(thePlayer)
		if not is_onduty then 
			exports.lsrp:showPopup(thePlayer, "Musisz być na służbie by zaoferować naprawę.", 5 )
			return
		end

		local group_id = exports.rp_groups:GetGroupID(duty_groupuid)
		local group_type = exports.rp_groups:GetGroupType(duty_groupuid)
		if group_type ~= 6 then  -- nie jest mechazordem
			exports.lsrp:showPopup(thePlayer, "Musisz być na służbie warsztatu by zaoferować naprawę.", 5 )
			return
		end

		if price < 0 then
			exports.lsrp:showPopup(thePlayer, "Podano nieprawidłową cenę!", 5 )
			return
		end

		local vehicle = getPedOccupiedVehicle(target)
		if not vehicle then 
			exports.lsrp:showPopup(thePlayer, "Gracz któremu oferujesz naprawę nie siedzi w pojeździe.", 5 )
			return
		end

		if not exports.rp_groups:IsPlayerHasPermTo(thePlayer, tonumber(group_id), 4) then 
			exports.lsrp:showPopup(thePlayer, "Nie masz uprawnień do oferowania lakierowania.", 5 )
			return
		end

		onOfferSend(thePlayer, target, OFFER_TYPE_PAINT, "Lakierowanie", vehicle, price)
	end

	-- produkt
	if theType == "produkt" then 
		if theTarget == nil then
			outputChatBox("#CCCCCCUżycie: /oferuj produkt [ID Gracza]", thePlayer, 255, 255, 255, true)
			return
		end

		-- Standardowe sprawdzenia
		if not offers_standardResponses(thePlayer, tonumber(theTarget)) then return end
		local target = exports.lsrp:getPlayerByID(tonumber(theTarget))

		-- Sprawdź duty
		local is_onduty, duty_type, duty_id, duty_groupuid, duty_start = exports.rp_groups:getPlayerDutyInfo(thePlayer)
		if not is_onduty then 
			exports.lsrp:showPopup(thePlayer, "Musisz być na służbie by zaoferować produkt.", 5 )
			return
		end

		local group_id = exports.rp_groups:GetGroupID(duty_groupuid)
		local group_type = exports.rp_groups:GetGroupType(duty_groupuid)

		local door = exports.rp_doors:getPlayerDoor(thePlayer)
		if not door then 
			exports.lsrp:showPopup(thePlayer, "Musisz być w budynku by móc oferować produkt.", 5 )
			return
		end

		if tonumber(getElementData(door, "door.ownertype")) ~= 5 then 
			exports.lsrp:showPopup(thePlayer, "To nie jest budynek z możliwością oferowania produktu.", 5 )
			return
		end

		if tonumber(getElementData(door, "door.owner")) ~= tonumber(duty_groupuid) then
			exports.lsrp:showPopup(thePlayer, "Nie możesz tutaj nic oferować.", 5 )
			return
		end

		if not exports.rp_groups:IsPlayerHasPermTo(thePlayer, tonumber(group_id), 4) then 
			exports.lsrp:showPopup(thePlayer, "Nie masz uprawnień do oferowania produktu.", 5 )
			return
		end

		onPlayerStartSendingProduct(thePlayer, target, door)
	end

	-- /o pojazd IDgracza Cena
	if theType == "pojazd" then
		local vehicle = getPedOccupiedVehicle(thePlayer)
		local price = tonumber(thePrice)

		if theTarget == nil or thePrice == nil then
			outputChatBox("#CCCCCCUżycie: /oferuj pojazd [ID gracza] [Cena]", thePlayer, 255, 255, 255, true)
			return
		end

		-- Standardowe sprawdzenia
		if not offers_standardResponses(thePlayer, tonumber(theTarget)) then return end
		local target = exports.lsrp:getPlayerByID(tonumber(theTarget))

		if price < 0 then
			exports.lsrp:showPopup(thePlayer, "Podano nieprawidłową cenę!", 5 )
			return
		end

		if not vehicle then
			exports.lsrp:showPopup(thePlayer, "Musisz siedzieć w pojeździe by użyć tej komendy.", 5 )
			return
		end

		if tonumber(getElementData(vehicle, "vehicle.ownertype")) ~= 1 then
			exports.lsrp:showPopup(thePlayer, "Pojazd nie należy do Ciebie!", 5 )
			return
		end

		if tonumber(getElementData(vehicle, "vehicle.owner")) ~= tonumber(getElementData(thePlayer, "player.uid")) then
			exports.lsrp:showPopup(thePlayer, "Pojazd nie należy do Ciebie!", 5 )
			return
		end

		onOfferSend(thePlayer, target, OFFER_TYPE_CAR, "Pojazd", vehicle, price)
	end

	if theType == "naprawe" then
		if thePrice == nil or theTarget == nil then 
			outputChatBox("#CCCCCCUżycie: /oferuj naprawe [ID gracza] [Cena]", thePlayer, 255, 255, 255, true)
			return
		end

		-- Standardowe sprawdzenia
		if not offers_standardResponses(thePlayer, tonumber(theTarget)) then return end
		local target = exports.lsrp:getPlayerByID(tonumber(theTarget))

		local price = tonumber(thePrice)
		local is_onduty, duty_type, duty_id, duty_groupuid, duty_start = exports.rp_groups:getPlayerDutyInfo(thePlayer)
		if not is_onduty then 
			exports.lsrp:showPopup(thePlayer, "Musisz być na służbie by zaoferować naprawę.", 5 )
			return
		end

		local group_id = exports.rp_groups:GetGroupID(duty_groupuid)
		local group_type = exports.rp_groups:GetGroupType(duty_groupuid)
		if group_type ~= 6 then  -- nie jest mechazordem
			exports.lsrp:showPopup(thePlayer, "Musisz być na służbie warsztatu by zaoferować naprawę.", 5 )
			return
		end

		if price < 0 then
			exports.lsrp:showPopup(thePlayer, "Podano nieprawidłową cenę!", 5 )
			return
		end

		local vehicle = getPedOccupiedVehicle(target)
		if not vehicle then 
			exports.lsrp:showPopup(thePlayer, "Gracz któremu oferujesz naprawę nie siedzi w pojeździe.", 5 )
			return
		end

		--[[ local px, py, pz = getElementPosition(thePlayer)
		local cx, cy, cz = getElementPosition(target)
		local distance = getDistanceBetweenPoints3D(px, py, pz, cx, cy, cz)
		if distance > 5.0 then 
			exports.lsrp:showPopup(thePlayer, "Odległość od tego gracza jest zbyt duża.", 5 )
			return
		end

		if getElementDimension(target) ~= getElementDimension(thePlayer) then 
			exports.lsrp:showPopup(thePlayer, "Odległość od tego gracza jest zbyt duża.", 5 )
			return
		end ]]--

		if isUserRepairCar(thePlayer) then 
			exports.lsrp:showPopup(thePlayer, "Jesteś już w trakcie naprawy jakiegoś pojazdu.", 5 )
			return
		end

		onOfferSend(thePlayer, target, OFFER_TYPE_REPAIR, "Naprawa", vehicle, price)
	end
end
addCommandHandler("o", offerCmd)
addCommandHandler("oferuj", offerCmd)

-- Handlery
function onOfferSend(thePlayer, theTarget, theOfferType, theOfferName, theValue, thePrice)
	local sender = thePlayer
	local receiver = theTarget
	local offer_type = theOfferType

	if send_offer[thePlayer] == true then 
		exports.lsrp:showPopup(receiver, "Już jesteś w trakcie oferowania!", 5 )
		return
	end

	if gain_offer[theTarget] == true then
		exports.lsrp:showPopup(receiver, "Ten gracz rozpatruje właśnie jakąś ofertę!", 5 )
		return
	end

	send_offer[thePlayer] = true
	gain_offer[theTarget] = true

	-- Naprawa
	if offer_type == OFFER_TYPE_REPAIR then 
		exports.lsrp:showPopup(receiver, "Oferowano Ci naprawę, rozpatrz propozycję!", 5 )
		outputChatBox("#CCCCCCInformacja: Pomyślnie oferowano naprawę, poczekaj na odpowiedź gracza!", sender, 255, 255, 255, true)
		triggerClientEvent (receiver, "onOfferReceive", receiver, thePlayer, theOfferType, theOfferName, theValue, thePrice)
		return
	end

	-- Pojazd
	if offer_type == OFFER_TYPE_CAR then
		exports.lsrp:showPopup(receiver, "Oferowano Ci pojazd, rozpatrz propozycję!", 5 )
		outputChatBox("#CCCCCCInformacja: Pomyślnie oferowano pojazd, poczekaj na odpowiedź gracza!", sender, 255, 255, 255, true)
		triggerClientEvent (receiver, "onOfferReceive", receiver, thePlayer, theOfferType, theOfferName, theValue, thePrice)
		return
	end

	-- Produkt
	if offer_type == OFFER_TYPE_PRODUCT then 
		exports.lsrp:showPopup(receiver, "Oferowano Ci naprawę, rozpatrz propozycję!", 5 )
		outputChatBox("#CCCCCCInformacja: Pomyślnie oferowano produkt, poczekaj na odpowiedź gracza!", sender, 255, 255, 255, true)
		triggerClientEvent (receiver, "onOfferReceive", receiver, thePlayer, theOfferType, theOfferName, theValue, thePrice)
	end

	-- Lakierowanie
	if offer_type == OFFER_TYPE_PAINT then 
		exports.lsrp:showPopup(receiver, "Oferowano Ci naprawę, rozpatrz propozycję!", 5 )
		outputChatBox("#CCCCCCInformacja: Pomyślnie oferowano lakierowanie, poczekaj na odpowiedź gracza!", sender, 255, 255, 255, true)
		triggerClientEvent (receiver, "onOfferReceive", receiver, thePlayer, theOfferType, theOfferName, theValue, thePrice)
	end
end

-- Handlery - thePlayer to ten co akceptuje/odrzuca, theTarget to wysyłający
function onPlayerAcceptOffer(thePlayer, theTarget, theType, theValue, thePrice)
	-- Sprawdzenie
	local pmoney = tonumber(getElementData(thePlayer, "player.cash"))
	if tonumber(thePrice) > pmoney then
		exports.lsrp:showPopup(theTarget, "Gracz odrzucił Twoją ofertę!", 5 )
		exports.lsrp:showPopup(thePlayer, "Nie masz tyle pieniędzy!", 5 )
		return
	end

	-- Oferty
	-- /o pojazd
	if theType == OFFER_TYPE_CAR then
		local query = dbQuery(handler, "UPDATE lsrp_cars SET car_owner = "..tonumber(getElementData(thePlayer, "player.uid")).." WHERE car_uid = "..tonumber(getElementData(theValue, "vehicle.uid")))
		if query then dbFree(query) end
		setElementData(theValue, "vehicle.owner", tonumber(getElementData(thePlayer, "player.uid")))
	end

	-- /o naprawe
	if theType == OFFER_TYPE_REPAIR then 
		startCarRepair(thePlayer, theTarget, theValue)
		--fixVehicle ( theValue )
	end

	-- /o produkt
	if theType == OFFER_TYPE_PRODUCT then 
		local product_uid = tonumber(theValue)
		local count = tonumber(extra[theTarget])

		-- pobierz parametry przedmiotu
		local query = dbQuery(handler, "SELECT * FROM lsrp_products WHERE product_uid = "..product_uid)
		local result = dbPoll(query, -1)
		if result and result[1] then 
			exports.rp_items:createItem(thePlayer, tonumber(result[1]["product_type"]), tonumber(result[1]["product_value1"]), tonumber(result[1]["product_value2"]), result[1]["product_name"])
		end

		if count > 1 then 
			-- zmniejsz
			local query = dbQuery(handler, "UPDATE lsrp_products SET product_number = product_number - 1 WHERE product_uid = "..product_uid)
			dbFree(query)
		else
			-- usuń
			local query = dbQuery(handler, "DELETE FROM lsrp_products WHERE product_uid = "..product_uid)
			dbFree(query)
		end
	end

	-- /o lakierowanie
	if theType == OFFER_TYPE_PAINT then 
		local vehicle = theValue
		local client = thePlayer
		local offerer = theTarget
		local price = tonumber(thePrice)

		-- pokaż paletę z kolorami
		local colorPicker = call ( getResourceFromName ( "rp_colorpicker" ), "openPicker", thePlayer,  2, "#FFFFFF", "Kolor dla pojazdu" )
		extra[thePlayer] = offerer
	end

	-- Kaska
	exports.lsrp:showPopup(theTarget, "Gracz akceptował Twoją ofertę!", 5 )
	exports.lsrp:showPopup(thePlayer, "Oferta została zaakceptowana!", 5 )

	send_offer[thePlayer] = false
	gain_offer[theTarget] = false
end
addEvent("onPlayerAcceptOffer", true)
addEventHandler("onPlayerAcceptOffer", getRootElement(), onPlayerAcceptOffer)

function onPlayerRejectOffer(thePlayer, theTarget)
	send_offer[thePlayer] = false
	gain_offer[theTarget] = false

	exports.lsrp:showPopup(theTarget, "Gracz odrzucił Twoją ofertę!", 5 )
end
addEvent("onPlayerRejectOffer", true)
addEventHandler("onPlayerRejectOffer", getRootElement(), onPlayerRejectOffer)