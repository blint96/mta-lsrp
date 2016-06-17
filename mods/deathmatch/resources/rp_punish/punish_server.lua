-- Pozyjca AJ
local aj_x = 1175.21875
local aj_y = -1182.0654296875
local aj_z = 32.02

-- Typy kar
PSH_TYPE_BAN = 1
PSH_TYPE_KICK = 2
PSH_TYPE_JAIL = 3
PSH_TYPE_WARN = 4

local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
addEventHandler ( "onResourceStart", resourceRoot, function() outputDebugString("[startup] Załadowano system kar") end )

--[[
-------------------------------------------
--	Funkcje pomocnicze
-------------------------------------------
]]--
function showPunishForAll(theAdmin, theOwner, theReason, thePunish)
	local admin = exports.lsrp:playerRealName( theAdmin )
	local owner = exports.lsrp:playerRealName( theOwner )
	triggerClientEvent ( getElementsByType("player"), "showPunishForPlayer", getRootElement(), admin, owner, theReason, thePunish )
	setTimer ( function()
		triggerClientEvent ( getElementsByType("player"), "hidePunishForPlayer", getRootElement() )
	end, 10000, 1 )
end

function isLeapYear(year)
    if year then year = math.floor(year)
    else year = getRealTime().year + 1900 end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

function getTimestamp(year, month, day, hour, minute, second)
    -- initiate variables
    local monthseconds = { 2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400 }
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second
 
    -- calculate timestamp
    for i=1970, year-1 do timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000) end
    for i=1, month-1 do timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i]) end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second
 
    timestamp = timestamp - 3600 --GMT+1 compensation
    if datetime.isdst then timestamp = timestamp - 3600 end
 
    return timestamp
end

--[[
-------------------------------------------
--	Funkcje kar
-------------------------------------------
]]--
function addPlayerBan(thePlayer, theReason, theDays, theGiver) -- theGiver - kto nadał
	local serial = getPlayerSerial(thePlayer)
	local ip = getPlayerIP(thePlayer)

	local punish_date = getTimestamp()
	local giver_uid = getElementData(theGiver, "player.uid")
	local owner_uid = getElementData(thePlayer, "player.uid")
	local period = 0

	if tonumber(theDays) > 0 then
		period = getTimestamp() + theDays * 86400
		showPunishForAll(theGiver, thePlayer, theReason, "Ban ["..theDays.." dni]")
	else
		showPunishForAll(theGiver, thePlayer, theReason, "Ban [perm]")
	end

	-- logi kar
	showPunishForAll(theGiver, thePlayer, theReason, "Ban")

	local query = dbQuery(handler, "INSERT INTO lsrp_punish VALUES(NULL, "..PSH_TYPE_BAN..", "..owner_uid..", "..giver_uid..", '"..theReason.."', "..period..", "..punish_date..", '"..serial.."', '"..ip.."')")
	if query then dbFree(query) end

	kickPlayer ( thePlayer, theReason )
	return true
end

function addPlayerKick(thePlayer, theReason, theGiver)
	local serial = getPlayerSerial(thePlayer)
	local ip = getPlayerIP(thePlayer)

	local punish_date = getTimestamp()
	local giver_uid = getElementData(theGiver, "player.uid")
	local owner_uid = getElementData(thePlayer, "player.uid")

	-- logi kar
	showPunishForAll(theGiver, thePlayer, theReason, "Kick")

	local query = dbQuery(handler, "INSERT INTO lsrp_punish VALUES(NULL, "..PSH_TYPE_KICK..", "..owner_uid..", "..giver_uid..", '"..theReason.."', 0, "..punish_date..", '"..serial.."', '"..ip.."')")
	if query then dbFree(query) end

	kickPlayer ( thePlayer, theReason )
	return true
end

function addPlayerJail(thePlayer, theReason, thePeriod, theGiver)
	local serial = getPlayerSerial(thePlayer)
	local ip = getPlayerIP(thePlayer)

	local punish_date = getTimestamp()
	local giver_uid = getElementData(theGiver, "player.uid")
	local owner_uid = getElementData(thePlayer, "player.uid")
	local period = getTimestamp() + thePeriod * 60

	local query = dbQuery(handler, "INSERT INTO lsrp_punish VALUES(NULL, "..PSH_TYPE_JAIL..", "..owner_uid..", "..giver_uid..", '"..theReason.."', "..period..", "..punish_date..", '"..serial.."', '"..ip.."')")
	if query then dbFree(query) end

	-- logi kar
	showPunishForAll(theGiver, thePlayer, theReason, "Adminjail ".."[".. thePeriod .." min]")

	-- Miejsce na textdraw
	setElementData(thePlayer, "player.aj", thePeriod * 60) -- dodać potem przy wyjściu zapisywanie stanu
	setElementDimension(thePlayer, 1000 + tonumber(exports.lsrp:getPlayerID(thePlayer)))
	setElementPosition(thePlayer, aj_x, aj_y, aj_z)
	return true
end

-- Po zalogowaniu sprawdź czy w AJ nie powinien siedzieć a później do timera dodać spadanie co sekunde jego ajta
function checkJail(thePlayer)
	if tonumber(getElementData(thePlayer, "player.aj")) > 0 then
		setElementPosition(thePlayer, aj_x, aj_y, aj_z)
	end
end

function checkBans(thePlayer)
	local banned = false
	local serial = getPlayerSerial(thePlayer)
	local ip = getPlayerIP(thePlayer)
	local time = getTimestamp()

	local query = dbQuery(handler, "SELECT * FROM lsrp_punish WHERE (punish_type = "..PSH_TYPE_BAN.." AND punish_ip = '".. ip .."') OR (punish_type = "..PSH_TYPE_BAN.." AND punish_serial = '"..serial.."') ORDER BY punish_id DESC ")
	local result = dbPoll(query, -1)

	if result then
		if result[1] then
			local punish_end = tonumber(result[1]["punish_end"])
			if punish_end <= 0 or punish_end > getTimestamp() then
				outputDebugString(result[1]["punish_id"])
				banned = true
			end
		end
	end

	return banned
end