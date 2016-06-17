-- w chuj ważna funkcja
function hasbit(x, p)
  return x % (p + p) >= p       
end

local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
groupsarray = {}
playergroups = {}

function Init()	
	groupsarray = {}
	LoadGroups()
end
addEventHandler( "onResourceStart", resourceRoot, Init)
addEventHandler ( "onResourceStart", resourceRoot, function() outputDebugString("[startup] Załadowano system grup") end )
addEventHandler ( "onResourceStop", getResourceRootElement(getThisResource()), function() SaveGroups() end )

function CreateGroup(name)
	local query = dbQuery(handler, "INSERT INTO lsrp_groups (`group_name`) VALUES ('" .. name .. "')")
	local _, _, insert_id = dbPoll(query, -1)
	
	if (insert_id >= 0) then
		if LoadGroup(insert_id) then
			return insert_id
		end
	end
	return false
end

function SaveGroups()
	local group_num = table.getn(groupsarray)
	outputDebugString( "[save] Zapisuję wszystkie grupy (".. group_num ..")" )

	for i = 1, group_num do 
		SaveGroup(i)
	end
end

function LoadGroups()
	outputConsole( "Loading lsrp_groups." )

	local query = dbQuery(handler, "SELECT * FROM lsrp_groups")
	local result = dbPoll ( query, -1 )

	groupsarray = {}
	local index = 0
	
	if result then
		local group_num = table.getn(result)

		for i = 1, group_num do
			groupsarray[index] = {}
			groupsarray[index]["uid"]		= tonumber(result[i]["group_uid"])
			groupsarray[index]["name"]		= result[i]["group_name"]
			groupsarray[index]["cash"]		= tonumber(result[i]["group_cash"])
			groupsarray[index]["type"]		= tonumber(result[i]["group_type"])
			groupsarray[index]["owner"]		= tonumber(result[i]["group_owner"])
			groupsarray[index]["value1"]	= tonumber(result[i]["group_value1"])
			groupsarray[index]["value2"]	= tonumber(result[i]["group_value2"])
			groupsarray[index]["dotation"]	= tonumber(result[i]["group_dotation"])
			groupsarray[index]["color"]		= result[i]["group_color"]
			groupsarray[index]["tag"]		= result[i]["group_tag"]
			groupsarray[index]["activity"]	= result[i]["group_activity"]
			groupsarray[index]["image"]		= result[i]["group_image"]
			groupsarray[index]["lastpay"]	= result[i]["group_lastpay"]
			groupsarray[index]["value3"]	= tonumber(result[i]["group_value3"])
			index = index + 1
		end
	end

	outputConsole( "'-- Finished loading " .. index .. " groups." )
	outputConsole( "'-- Last loaded group: " .. groupsarray[index-1]["name"] .. "(uid: " .. index-1 .. ")." )

	if query then dbFree(query) end
end


function LoadGroup(uid)

	local query = dbQuery(handler, "SELECT * FROM lsrp_groups WHERE group_uid = '" .. uid .. "'")
	local result = dbPoll ( query, -1 )

	if not result then return false end
	result = result[1]

	local group_id = GetGroupID(uid)

	if (group_id ~= -1) then
		outputConsole ( "Reloading an existing group - " .. groupsarray[group_id]["name"] .. "(uid: " .. uid .. ").")
	else
		outputConsole ( "Loading a new group - uid: " .. uid .. ".")
		group_id = findEmptyIndex()
	end

	groupsarray[group_id] = {}
	groupsarray[group_id]["uid"]		= tonumber(result["group_uid"])
	groupsarray[group_id]["name"]		= result["group_name"]
	groupsarray[group_id]["cash"]		= tonumber(result["group_cash"])
	groupsarray[group_id]["type"]		= tonumber(result["group_type"])
	groupsarray[group_id]["owner"]		= tonumber(result["group_owner"])
	groupsarray[group_id]["value1"]		= tonumber(result["group_value1"])
	groupsarray[group_id]["value2"]		= tonumber(result["group_value2"])
	groupsarray[group_id]["dotation"]	= tonumber(result["group_dotation"])
	groupsarray[group_id]["color"]		= result["group_color"]
	groupsarray[group_id]["tag"]		= result["group_tag"]
	groupsarray[group_id]["activity"]	= result["group_activity"]
	groupsarray[group_id]["image"]		= result["group_image"]
	groupsarray[group_id]["lastpay"]	= result["group_lastpay"]
	groupsarray[group_id]["value3"]		= tonumber(result["group_value3"])
	return true
end

function SaveGroup(id)
	local name = groupsarray[id]["name"]
	local query = "UPDATE lsrp_groups SET " ..
		"group_name = '"		.. name:gsub("'", "")		.. "', " ..
		"group_cash = '"		.. groupsarray[id]["cash"]		.. "', " ..
		"group_type = '"		.. groupsarray[id]["type"]		.. "', " ..
		"group_owner = '"		.. groupsarray[id]["owner"]		.. "', " ..
		"group_value1 = '"		.. groupsarray[id]["value1"]	.. "', " ..
		"group_value2 = '"		.. groupsarray[id]["value2"]	.. "', " ..
		"group_dotation = '"	.. groupsarray[id]["dotation"]	.. "', " ..
		"group_color = '"		.. groupsarray[id]["color"]		.. "', " ..
		"group_tag = '"			.. groupsarray[id]["tag"]		.. "', " ..
		"group_activity = '"	.. groupsarray[id]["activity"]	.. "', " ..
		"group_image = '"		.. groupsarray[id]["image"]		.. "', " ..
		"group_lastpay = '"		.. groupsarray[id]["lastpay"]	.. "', " ..
		"group_value3 = '"		.. groupsarray[id]["value3"]	.. "' " ..
		"WHERE group_uid = "	.. groupsarray[id]["uid"]	

	local q = dbQuery(handler, query)
	dbFree(q)


end

function DeleteGroup(id)
	local query = "DELETE FROM lsrp_groups WHERE group_uid = '" .. groupsarray[id]["uid"] .. "'"
	if dbQuery(handler, query) then
		groupsarray[i] = {}
		return true
	end

	return false
end

function findEmptyIndex()
	for i = 1, table.getn(groupsarray) do
		if table.getn(groupsarray[i]) == 0 then
			return i
		end
	end
	return table.getn(groupsarray)
end

function GetGroupID(uid)
	uid = tonumber(uid)
	for i = 1, table.getn(groupsarray) do
		if groupsarray[i] then
			if groupsarray[i]["uid"] == uid then
				return i
			end
		end
	end

	return -1
end

function GetGroupType(uid)
	local id = GetGroupID(uid)
	return groupsarray[id]["type"]
end

function GetGroupInfo(thePlayer, group_uid)
	local group_id = GetGroupID(group_uid)
	triggerClientEvent (thePlayer, "showGroupInfoView", thePlayer, group_id, groupsarray)
end
addEvent( "GetGroupInfo", true )
addEventHandler( "GetGroupInfo", root, GetGroupInfo )

function LoadPlayerGroups()
	local query = dbQuery(handler, "SELECT * FROM lsrp_char_groups WHERE char_uid = "..tonumber(getElementData(source, "player.uid")))
	local result = dbPoll ( query, -1 )
	local playerid = tonumber(getElementData(source, "id"))

	playergroups[playerid] = {}
	
	local slot = 1
	for i = 1, _G_MAX_GROUP_SLOTS do
		playergroups[playerid][slot] = {}
		playergroups[playerid][slot]["group_id"]			= 0
		playergroups[playerid][slot]["group_skin"]			= 0
		playergroups[playerid][slot]["group_rank"]			= 0
		playergroups[playerid][slot]["group_payment"]		= 0
		playergroups[playerid][slot]["group_perm"]			= 0
		playergroups[playerid][slot]["group_uid"]			= 0
		playergroups[playerid][slot]["group_name"]			= 0
		slot = slot + 1
	end

	if result then
		local playergroups_num = table.getn(result)
		local slot = 1
		for i = 1, playergroups_num do
			playergroups[playerid][slot]["group_id"]			= GetGroupID(result[i]["group_uid"])
			playergroups[playerid][slot]["group_skin"]			= tonumber(result[i]["group_skin"])
			playergroups[playerid][slot]["group_rank"]			= result[i]["group_title"]
			playergroups[playerid][slot]["group_payment"]		= tonumber(result[i]["group_payment"])
			playergroups[playerid][slot]["group_perm"]			= tonumber(result[i]["group_perm"])
			playergroups[playerid][slot]["group_uid"]			= tonumber(result[i]["group_uid"])
			playergroups[playerid][slot]["group_name"]			= groupsarray[GetGroupID(result[i]["group_uid"])]["name"]
			slot = slot + 1
		end
	end

	if query then dbFree(query) end

end
addEventHandler("onPlayerLoginSQL", getRootElement(), LoadPlayerGroups)

function GetFreeGroupSlotForPlayer(thePlayer)
	local playerid = tonumber(getElementData(thePlayer, "id"))
	for i = 1, _G_MAX_GROUP_SLOTS do
		if(playergroups[playerid][i]["group_id"] == 0) then
			return i
		end
	end

	return false
end

function IsPlayerInGroup(thePlayer, group_id)
	local playerid = tonumber(getElementData(thePlayer, "id"))
	for i = 1, _G_MAX_GROUP_SLOTS do
		if(playergroups[playerid][i]["group_id"] == group_id) then
			return true
		end
	end

	return false
end

------------------------------------------------------
------------------------------------------------------
------------------------------------------------------
-- test blinta

function IsPlayerHasPermTo(thePlayer, group_id, perm)
	local slot = GetPlayerGroupSlot(thePlayer, group_id)
	local playerid = tonumber(getElementData(thePlayer, "id"))
	local p_perm = playergroups[playerid][slot]["group_perm"]

	if (hasbit(p_perm, perm)) then
		return true
	else
		return false
	end
end

------------------------------------------------------
------------------------------------------------------
------------------------------------------------------

function GetPlayerGroupSlot(thePlayer, group_id)
	local playerid = tonumber(getElementData(thePlayer, "id"))
	for i = 1, _G_MAX_GROUP_SLOTS do
		if(playergroups[playerid][i]["group_id"] == group_id) then
			return i
		end
	end

	return false
end

function RespawnGroupVehicles(group_id)
	local vehicles = getElementsByType("vehicle")
	for key, vehicle in ipairs(vehicles) do
		if(getElementData(vehicle, "vehicle.ownertype") == 5 and getElementData(vehicle, "vehicle.owner") == groupsarray[group_id]["uid"]) then
			-- seler: tutaj trzeba dodać czy ktoś w tym aucie jest i wtedy nie respawnować go
			local uid = getElementData(vehicle, "vehicle.uid")
			exports.rp_vehicles:UnspawnVehicle(getElementData(vehicle, "id"))
			exports.rp_vehicles:LoadVehicle(uid)
		end
	end
end

----------------------------------------------------------------
--	CZAT OOC
--	I RADIO GRUPOWE
----------------------------------------------------------------
function groupsChatHandler( message, messageType )
	if getElementData(source, "player.logged") == true then
		if (messageType == 0) then
			for i = 1, #message do
				if i == 1 then
					local playerid = getElementData(source, "id")
				    local c = message:sub(i,i)
				    if c == "!" then
				    	local slot = tonumber(message:sub(2, 2))
				    	if (not slot) or (slot < 1) or (slot > 5) then
				    		exports.lsrp:showPopup(source, "Podano błędny slot!", 3)
				    		return
				    	else
				    		-- RADIO
				    		local group_id = playergroups[playerid][slot]["group_id"]
				    		if groupsarray[group_id]["uid"] > 0 then
				    			local group_type = groupsarray[group_id]["type"]
				    			if groupSettings[group_type][1] == false then 
				    				exports.lsrp:showPopup(source, "Ten typ grupy nie posiada radia!", 4)
				    				return
				    			end

				    			-- Wiadomość na radiu
				    			local players = getElementsByType("player")
				    			for k, player in pairs(players) do 
				    				local looped_id = tonumber(getElementData(player, "id"))
				    				if IsPlayerInGroup(player, group_id) then 
				    					message = message:sub(4)
				    					local g_color = "#"..groupsarray[group_id]["color"]
				    					outputChatBox(g_color.. "** [!".. GetPlayerGroupSlot(player, group_id) .."] #999999[".. groupsarray[group_id]["tag"]  ..  "] ".. g_color ..exports.lsrp:playerRealName(source)..": ".. firstToUpper(message) .." **", player, 255, 255, 255, true)
				    				end
				    			end

				    			-- Wiadomość do pobliskich
				    			exports.lsrp:imitationChat(source, firstToUpper(message), "radio")
				    		else
				    			exports.lsrp:showPopup(source, "Podano błędny slot!", 3)
				    			break
				    		end
				    	end
				    	cancelEvent()
				    end

				    if c == "@" then
				    	local slot = tonumber(message:sub(2, 2))
				    	if (not slot) or (slot < 1) or (slot > 5) then
				    		exports.lsrp:showPopup(source, "Podano błędny slot!", 3)
				    		return
				    	else
				    		-- wyślij wiadomość OOC
				    		local group_id = playergroups[playerid][slot]["group_id"]
				    		if groupsarray[group_id]["uid"] > 0 then
				    			local players = getElementsByType("player")
				    			for k, player in pairs(players) do 
				    				local looped_id = tonumber(getElementData(player, "id"))
				    				if IsPlayerInGroup(player, group_id) then 
				    					message = message:sub(4)
				    					local g_color = "#"..groupsarray[group_id]["color"]
				    					outputChatBox(g_color.. "(( [@".. GetPlayerGroupSlot(player, group_id) .."] #999999[".. groupsarray[group_id]["tag"]  ..  "] ".. g_color ..exports.lsrp:playerRealName(source).." (".. looped_id .."): ".. firstToUpper(message) .." ))", player, 255, 255, 255, true)
				    				end
				    			end
				    		else
				    			exports.lsrp:showPopup(source, "Podano błędny slot!", 3)
				    			break
				    		end
				    	end
				    	cancelEvent()
				    end

				    break
				end
			end
		end
	end
end
addEventHandler( "onPlayerChat", getRootElement(), groupsChatHandler )

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

function onChangeGroupType(newGroupType, groupId)
	groupsarray[tonumber(groupId)]["type"] = tonumber(newGroupType)
	exports.lsrp:showPopup(source, "Pomyślnie zmieniono typ grupy!", 5)
end
addEvent("ChangeGroupType", true)
addEventHandler("ChangeGroupType", getRootElement(), onChangeGroupType)