local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
addEventHandler ( "onResourceStart", resourceRoot, function() outputDebugString("[startup] Załadowano system animacji") end )

function stringtobool(jp2gmd)
	if jp2gmd == "1" then
		return true
	else
		return false
	end
end

function stopPlayerAnimation(thePlayer)
	setPedAnimation(thePlayer, "BSKTBALL","BBALL_idle_O", 1)
end
addEvent("stopPlayerAnimation", true)
addEventHandler("stopPlayerAnimation", getRootElement(), stopPlayerAnimation)

function applyAnimationIfChat( message, messageType )
	if getElementData(source, "player.logged") == true then
		if (messageType == 0) then
			for i = 1, #message do
				if i == 1 then
				    local c = message:sub(i,i)
				    if c == "." then
				    	local query = dbQuery(handler, "SELECT * FROM lsrp_anim WHERE anim_command = '"..message.."'") -- sql injection potem wywalic
				    	local result = dbPoll(query, -1)
				    	if result then
				    		if result[1] then
				    			-- time 1 jeśli ma być loopowana
				    			local loop = false
				    			local save = false
				    			local freeze = false
				    			if tonumber(result[1]["anim_loop"]) > 0 then loop = true else loop = false end
				    			if tonumber(result[1]["anim_position"]) > 0 then save = true else save = false end
				    			if tonumber(result[1]["anim_freeze"]) > 0 then freeze = true else freeze = false end
				    			setPedAnimation ( source, result[1]["anim_lib"], result[1]["anim_name"], tonumber(result[1]["anim_speed"]), loop, save, true, freeze)
				    		end
				    	end
				    	if query then dbFree(query) end
				    	cancelEvent()
				    end
				    break
				end
			end
		end
	end
end
addEventHandler( "onPlayerChat", getRootElement(), applyAnimationIfChat )