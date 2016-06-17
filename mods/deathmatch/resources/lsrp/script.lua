-- Główny plik tego gówna
local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
setCloudsEnabled ( true )
setFPSLimit(60)

-- oznacz zbugowanych jako OFFLINE
local onlines = dbQuery(handler, "UPDATE lsrp_characters SET char_online = 0")
dbFree(onlines)

-- wyłączenie tego domyślnego /me
function disableMTAme(message, mtype)

	if getElementData(source, "player.logged") == false then
		cancelEvent()
	end

	if mtype == 1 then
		-- source
		if string.len(message) <= 0 then
			outputChatBox("#CCCCCCUżycie: /me [Akcja]", source, 255, 255, 255, true)
		end

		local posX, posY, posZ = getElementPosition( source )
		local chatSphere = createColSphere( posX, posY, posZ, 10 )
		local nearbyPlayers = getElementsWithinColShape( chatSphere, "player" )

		local output = "#C2A2DA** " .. playerRealName(source) .. " " .. message
		outputDebugString(getPlayerName(source)..": /me "..message)
		for index, nearbyPlayer in ipairs( nearbyPlayers ) do
        	outputChatBox( output, nearbyPlayer, 255, 255, 255, true)
    	end

    	destroyElement(chatSphere) -- optymalizacja
		cancelEvent()
	elseif mtype == 0 then

		if(tonumber(getElementData(source, "player.bw")) > 0) then
			exports.lsrp:showPopup(source, "Nie możesz się odzywać będąc nieprzytomnym.", 5 )
			cancelEvent()
			return
		end

		local first_letter = message:sub(1,1)
		if (first_letter == ".") or (first_letter == "!") or (first_letter == "@") then
			cancelEvent()
			return
		end

		local posX, posY, posZ = getElementPosition( source )
		local chatSphere = createColSphere( posX, posY, posZ, 10 )
		local nearbyPlayers = getElementsWithinColShape( chatSphere, "player" )

		local output = playerRealName(source).." mówi: "..firstToUpper(message)
		outputDebugString(output)
		for index, nearbyPlayer in ipairs(nearbyPlayers) do
			if getElementDimension(source) == getElementDimension(nearbyPlayer) then
				local ox, oy, oz = getElementPosition(nearbyPlayer)
				local distance = getDistanceBetweenPoints2D(posX, posY, ox, oy)
				if distance < 2 then
					outputChatBox( "#FFFFFF"..output, nearbyPlayer, 255, 255, 255, true)
				elseif distance < 4 then
					outputChatBox( "#EEEEEE"..output, nearbyPlayer, 255, 255, 255, true)
				elseif distance < 6 then
					outputChatBox( "#DDDDDD"..output, nearbyPlayer, 255, 255, 255, true)
				elseif distance < 8 then
					outputChatBox( "#CCCCCC"..output, nearbyPlayer, 255, 255, 255, true)
				else
					outputChatBox( "#BBBBBB"..output, nearbyPlayer, 255, 255, 255, true)
				end
			end
		end

		setPedAnimation ( source, "PED", "IDLE_CHAT", 60 * string.len(message), true, false, true, false)
		destroyElement(chatSphere) -- optymalizacja
		cancelEvent()
	end
end
addEventHandler("onPlayerChat", getRootElement(), disableMTAme)

-- test pozycja
function getPosition(thePlayer, command)
	local x, y, z = getElementPosition(thePlayer)
	outputChatBox("X: ".. x ..", Y: ".. y .. ", Z: "..z)
end
addCommandHandler("pos", getPosition)

-- test weapon
function createWeaponForPlayer(thePlayer, command, weaponModel)
	giveWeapon(thePlayer, weaponModel, 500)
	setPedStat(thePlayer, 69, 999)
	setPedStat(thePlayer, 70, 999)
	setPedStat(thePlayer, 71, 999)
	setPedStat(thePlayer, 72, 999)
	setPedStat(thePlayer, 73, 999)
	setPedStat(thePlayer, 74, 999)
	setPedStat(thePlayer, 75, 999)
	setPedStat(thePlayer, 76, 999)
	setPedStat(thePlayer, 77, 999)
	setPedStat(thePlayer, 78, 999)
	setPedStat(thePlayer, 79, 999)
end
addCommandHandler("weapon", createWeaponForPlayer)

-- czas rzeczywisty
function syncTime()
    local realTime = getRealTime()
    local hour = realTime.hour
    local minute = realTime.minute
    setMinuteDuration ( 60000 )
    setTime( hour , minute )
end
setTimer ( syncTime, 500, 1 )
setTimer ( syncTime, 3000000, 0 ) 

-- import
function isVehicleOccupied(theVehicle)
	local players = getElementsByType ( "player" )
	for it, player in ipairs(players) do
		if(getPedOccupiedVehicle(player) == theVehicle) then
			return true
		end
	end

	return false
end

--[[ IMPORTY ]] --
function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

-- pobranie elementu gracza, który prowadzi pojazd
function getVehicleDriver(theVehicle)
	local players = getElementsByType ( "player" )
	for it, player in ipairs(players) do
		if(getPedOccupiedVehicle(player) == theVehicle) then
			if getPedOccupiedVehicleSeat(player) == 0 then
				return player
			end
		end
	end
	return false
end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end


-- AC
function playerSpawnFunc ( posX, posY, posZ, spawnRotation, theTeam, theSkin, theInterior, theDimension )
	if getElementData(source, "player.logged") == false then
		kickPlayer(source)
	end
end
addEventHandler ( "onPlayerSpawn", getRootElement(), playerSpawnFunc )