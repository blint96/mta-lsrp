-- Standardowo
local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

-- Ma uprawnienia do oferowania, jest gość któremu oferuje i jest
-- w tych drzwiach, SQL pobiera produkty w tych drzwiach i pokazuje je
-- na GUI a na koniec pyta o cenę produktu, koleś albo akceptuje
-- albo też nie
function onPlayerStartSendingProduct(thePlayer, theTarget, theDoors)
	local query = dbQuery(handler, "SELECT * FROM lsrp_products WHERE product_dooruid = "..tonumber(getElementData(theDoors, "door.uid")))
	local result = dbPoll(query, -1)
	if result then 
		if result[1] then 
			local productsArray = {}
			local index = 0
			local p_num = table.getn(result)

			for i = 1, p_num do 
				productsArray[index] = {}
				productsArray[index]["uid"] = result[i]["product_uid"]
				productsArray[index]["name"] = result[i]["product_name"]
				productsArray[index]["type"] = result[i]["product_type"]
				productsArray[index]["v1"] = result[i]["product_value1"]
				productsArray[index]["v2"] = result[i]["product_value2"]
				productsArray[index]["price"] = result[i]["product_price"]
				productsArray[index]["count"] = result[i]["product_number"]
				index = index + 1
			end

			triggerClientEvent (thePlayer, "onClientStartSelectingProducts", thePlayer, theTarget, productsArray)
		else
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Brak produktów w tych drzwiach.", 5 )
		end
	end
end

-- Wybrał już nowy produkt, mamy jego UID w parametrze productUID
-- sprawdzamy czy jeszcze jest w magazynie, jeśli tak to wyślij ofertę 
-- do gościa i zakończ wybieranie produktu
function onPlayerSelectProduct(thePlayer, theTarget, productUID)
	local query = dbQuery(handler, "SELECT * FROM lsrp_products WHERE product_uid = ".. tonumber(productUID) )
	local result = dbPoll(query, -1)
	if result and result[1] then 
		local count = tonumber(result[1]["product_number"])
		local price = tonumber(result[1]["product_price"])
		local name = result[1]["product_name"]
		if count > 1 then
			onOfferSend(thePlayer, theTarget, OFFER_TYPE_PRODUCT, name, productUID, price)
		else
			onOfferSend(thePlayer, theTarget, OFFER_TYPE_PRODUCT, name, productUID, price)
		end
		extra[thePlayer] = count -- to w chuj ważne
	end
end
addEvent("onPlayerSelectProduct", true)
addEventHandler("onPlayerSelectProduct", getRootElement(), onPlayerSelectProduct)