local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

function selectingPlayerSpawn(thePlayer, theCmd)
	local query = dbQuery(handler, "SELECT * FROM lsrp_doors WHERE door_ownertype = 1 AND door_owner = ".. tonumber(getElementData(thePlayer, "player.uid")))
	local result = dbPoll(query, -1)

	local spawns = {}
	if result then
		for k = 0, table.getn(result) do 
			if result[k] then
				spawns[k] = {}
				spawns[k][1] = result[k]["door_uid"]
				spawns[k][2] = result[k]["door_name"]
			end
		end
	end
	if query then dbFree(query) end
	triggerClientEvent(thePlayer, "onPlayerSelectSpawn", thePlayer, spawns)
end
addCommandHandler("spawn", selectingPlayerSpawn)

function updatePlayerSpawn(thePlayer, spawnID)
	-- JAKIEŚ INFO NA KONIEC
	if spawnID == 0 then 
		-- spawn ogólny
		local query = dbQuery(handler, "UPDATE lsrp_characters SET char_house = 0, char_spawnplace = 0 WHERE char_uid = "..tonumber(getElementData(thePlayer, "player.uid")))
		dbFree(query)
	else
		-- spawn w domu
		local query = dbQuery(handler, "UPDATE lsrp_characters SET char_house = ".. tonumber(spawnID) ..", char_spawnplace = 1 WHERE char_uid = "..tonumber(getElementData(thePlayer, "player.uid")))
		dbFree(query)
	end

	exports.lsrp:showPopup(thePlayer, "Pomyślnie edytowano miejsce spawnu!", 5)
end
addEvent("onPlayerUpdateSpawnServer", true)
addEventHandler("onPlayerUpdateSpawnServer", getRootElement(), updatePlayerSpawn)