--[[ 
	1. bindujemy "[" od Engine dla włączania silnika
	2. bindujemy "]" od świateł, nie od żadnego słowa ale po prostu jest blisko klawisza "E"
]]--

function setVehicleBinds ( )
	-- source
	bindKey ( source, "[", "down", changeVehicleEngineStateByBind )
	bindKey ( source, "]", "down", changeVehicleLightsStateByBind )
end
addEventHandler ( "onPlayerJoin", getRootElement(), setVehicleBinds )

-- [[ Funkcje pod bindy ]] --

-- start silnika
function changeVehicleEngineStateByBind(thePlayer)
	if not isPedInVehicle(thePlayer) then return end
	local vehicle = getPedOccupiedVehicle(thePlayer)

	local skip = false
	local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
	if padmin > 0 then skip = true end

	if vehicle ~= false then
		local seat = getPedOccupiedVehicleSeat ( thePlayer )

		if getElementHealth(vehicle) <= 350 then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Silnik w tym pojeździe jest kompletnie zniszczony, udaj się do mechanika.", 5 )
			return
		end

		if getElementData(vehicle, "vehicle.fuel") <= 0 then
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Skończyło się paliwo, zatankuj pojazd na stacji.", 5 )
			return
		end

		if skip then
			changeVehicleEngineState(vehicle)
			return
		end

		if (seat == 0) then
			if (tonumber(getElementData(vehicle, "vehicle.ownertype")) == 1) then
				if(tonumber(getElementData(vehicle, "vehicle.owner")) == tonumber(getElementData(thePlayer, "player.uid"))) then
					changeVehicleEngineState(vehicle)
				else
					call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie masz kluczyków do tego pojazdu.", 5 )
				end
			else
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie masz kluczyków do tego pojazdu.", 5 )
			end
		else 
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Aby użyć tej komendy musisz być kierowcą pojazdu.", 5 )
		end
	else
		call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Aby użyć tej komendy musisz być w jakimś pojeździe.", 5 )
	end
end

-- włączanie świateł
function changeVehicleLightsStateByBind(thePlayer)
	if not isPedInVehicle(thePlayer) then return end
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if theVehicle == false then return end -- jeśli nie ma pojazdu to niech przerwie funkcje w tym miejscu

	changeVehicleStateLights(theVehicle)
end