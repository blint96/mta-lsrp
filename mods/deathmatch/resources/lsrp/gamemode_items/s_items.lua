function getPlayerItems(uid)
	-- pobieranie itemów
	local query = mysql_query(handler, "SELECT * FROM lsrp_items WHERE item_owner = ".. uid .." AND item_place = 1")
	outputDebugString("[MySQL] Pobrano itemki!")

	itemarray = {}
	local index = 0

	-- Wracamy do clientside
	for query, row in mysql_rows_assoc(query) do
    	itemarray[index] = {}
    	itemarray[index][0] = row["item_uid"]
    	itemarray[index][1] = row["item_name"]
    	itemarray[index][2] = row["item_weight"]
    	index = index + 1
  	end

  	mysql_free_result(query)
	triggerClientEvent (source, "fillItemsGrid", source, itemarray )
end

addEvent( "getPlayerItems", true )
addEventHandler( "getPlayerItems", getRootElement(), getPlayerItems )