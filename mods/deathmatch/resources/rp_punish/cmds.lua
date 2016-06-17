-- exports.lsrp:showPopup(thePlayer, "Dotacja musi zawierać się w kwocie $0 - $1500.", 5 )
local spawnX, spawnY, spawnZ = 1566.17, -1310.42, 17.15

--[[
----------------------------------------------
--	BAN
----------------------------------------------
]]--
function adminRunBan(thePlayer, commandName, theTarget, thePeriod, ...)
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	if (padmin == 0) then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Brak uprawnień do użycia tej komendy.", 5 )
		return
	end

	local theReason = tostring(table.concat({...}, " "))
	if (theTarget == nil or thePeriod == nil or theReason == nil) then
		outputChatBox("#CCCCCCUżycie: /ban [ID Gracza] [Czas w dniach] [Powód].", thePlayer, 255, 255, 255, true)
		return
	end

	local target = exports.lsrp:getPlayerByID(tonumber(theTarget))
	if not target then
		exports.lsrp:showPopup(thePlayer, "Taki gracz nie jest podłączony do serwera.", 5 )
		return 
	end

	if (getElementData(target, "player.logged") == false) then
		exports.lsrp:showPopup(thePlayer, "Ten gracz nie zalogował się jeszcze do gry.", 5 )
		return
	end

	outputChatBox("#CCCCCCInformacja: Pomyślnie zbanowałeś gracza.", thePlayer, 255, 255, 255, true)
	exports.rp_logs:log_AdminLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") zbanował gracza "..getPlayerName(target).." (UID: ".. getElementData(target, "player.uid") ..")")
	-- miejsce na textdraw
	addPlayerBan(target, theReason, tonumber(thePeriod), thePlayer)
end
addCommandHandler("ban", adminRunBan)


--[[
----------------------------------------------
--	KICK
----------------------------------------------
]]--
function adminRunKick(thePlayer, commandName, theTarget, ...)
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	if (padmin == 0) then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Brak uprawnień do użycia tej komendy.", 5 )
		return
	end

	local theReason = tostring(table.concat({...}, " "))
	if theTarget == nil or theReason == nil then
		outputChatBox("#CCCCCCUżycie: /kick [ID gracza] [Powód]", thePlayer, 255, 255, 255, true)
		return
	end

	local target = exports.lsrp:getPlayerByID(tonumber(theTarget))
	if not target then
		exports.lsrp:showPopup(thePlayer, "Taki gracz nie jest podłączony do serwera.", 5 )
		return
	end

	if (getElementData(target, "player.logged") == false) then
		exports.lsrp:showPopup(thePlayer, "Ten gracz nie zalogował się jeszcze do gry.", 5 )
		return
	end

	exports.rp_logs:log_AdminLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") skickował gracza "..getPlayerName(target).." (UID: ".. getElementData(target, "player.uid") ..")")
	-- miejsce na textdraw
	addPlayerKick(target, theReason, thePlayer)
end
addCommandHandler("kick", adminRunKick)

--[[
----------------------------------------------
--	AdminJail
----------------------------------------------
]]--
function adminRunJail(thePlayer, commandName, theTarget, thePeriod, ...)
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	if (padmin == 0) then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Brak uprawnień do użycia tej komendy.", 5 )
		return
	end

	local theReason = tostring(table.concat({...}, " "))
	if (theTarget == nil or thePeriod == nil or theReason == nil) then
		outputChatBox("#CCCCCCUżycie: /aj [ID Gracza] [Czas w minutach] [Powód].", thePlayer, 255, 255, 255, true)
		return
	end

	local target = exports.lsrp:getPlayerByID(tonumber(theTarget))
	if not target then
		exports.lsrp:showPopup(thePlayer, "Taki gracz nie jest podłączony do serwera.", 5 )
		return 
	end

	if (getElementData(target, "player.logged") == false) then
		exports.lsrp:showPopup(thePlayer, "Ten gracz nie zalogował się jeszcze do gry.", 5 )
		return
	end

	exports.rp_logs:log_AdminLog("[admin] Administrator ".. getPlayerName(thePlayer) .. " (UID: ".. getElementData(thePlayer, "player.uid") ..") nadał AJ graczowi "..getPlayerName(target).." (UID: ".. getElementData(target, "player.uid") ..")")
	-- miejsce na textdraw
	addPlayerJail(target, theReason, tonumber(thePeriod), thePlayer)
end
addCommandHandler("aj", adminRunJail)

function adminReleaseJail(thePlayer, commandName, theTarget)
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	if (padmin == 0) then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Brak uprawnień do użycia tej komendy.", 5 )
		return
	end

	if theTarget == nil then
		outputChatBox("#CCCCCCUżycie: /unaj [ID Gracza].", thePlayer, 255, 255, 255, true)
		return
	end

	local target = exports.lsrp:getPlayerByID(tonumber(theTarget))
	if not target then
		exports.lsrp:showPopup(thePlayer, "Taki gracz nie jest podłączony do serwera.", 5 )
		return
	end

	setElementData(target, "player.aj", 0)
	setElementPosition(target, spawnX, spawnY, spawnZ)
	setElementDimension(target, 0)
end
addCommandHandler("unaj", adminReleaseJail)

--[[
----------------------------------------------
--	Slap
----------------------------------------------
]]--
function adminRunSlap(thePlayer, theCommand, theTarget)
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	if (padmin == 0) then
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Brak uprawnień do użycia tej komendy.", 5 )
		return
	end

	if theTarget == nil then
		outputChatBox("#CCCCCCUżycie: /slap [ID Gracza].", thePlayer, 255, 255, 255, true)
		return
	end

	local target = exports.lsrp:getPlayerByID(tonumber(theTarget))
	if not target then
		exports.lsrp:showPopup(thePlayer, "Taki gracz nie jest podłączony do serwera.", 5 )
		return
	end

	local t_x, t_y, t_z = getElementPosition(target)
	setElementPosition(target, t_x, t_y, t_z + 6.0)
	exports.lsrp:showPopup(target, "Slap!", 5 )
end
addCommandHandler("slap", adminRunSlap)