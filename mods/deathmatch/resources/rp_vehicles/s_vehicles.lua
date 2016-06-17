--[[
	Przy przejściu z SA:MPa na MTA będzie trzeba pamiętać, że MTA ma 3 kolory pojazdów a SAMP tylko 2, 
	no i obrażenia wizualne pojazdu są w sampie wpisane jako x,x,x,x a w MTA to 7 różnych wartości
]]--

local blip = {}
local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
addEventHandler ( "onResourceStart", resourceRoot, function() outputDebugString("[startup] Załadowano system pojazdów") end )

function launchServerVehiclesShowing(thePlayer, command, action, var1)
	
	if(action ~= nil) then
		-- zaparkuj, lista to jest
		-- do zrobienia jeszcze /v sprzedaj
		if(action == "namierz") then
			if (var1 == nil) then
				outputChatBox("#CCCCCCUżycie: /v namierz [ID pojazdu]", thePlayer, 255, 255, 255, true)
				return
			end

			local vehicle = getVehicleByID(tonumber(var1))
			if not vehicle then
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Taki pojazd nie jest zespawnowany.", 5 )
				return
			end

			if tonumber(getElementData(vehicle, "vehicle.owner")) == tonumber(getElementData(thePlayer, "player.uid")) and tonumber(getElementData(vehicle, "vehicle.ownertype")) == 1 then
				-- zrób markera
				local player_id = tonumber(getElementData(thePlayer, "id"))
				local x, y, z = getElementPosition(vehicle)
				blip[player_id] = createBlipAttachedTo ( vehicle, 0, 2, 0, 100, 0, 255, 0, 99999.0, thePlayer )
				addEventHandler ( "onVehicleEnter", getRootElement(), checkBlip )
			else
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Ten pojazd nie należy do Ciebie.", 5 )
				return
			end
		end

		if(action == "zaparkuj") then
			local vehicle = getPedOccupiedVehicle(thePlayer)
			if not vehicle then return end

			-- czy kierowca, czy właściciel i czy wolne miejsce do parkowania
			local seat = getPedOccupiedVehicleSeat(thePlayer)
			if seat ~= 0 then
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie jesteś kierowcą tego pojazdu.", 5 )
				return
			end

			if tonumber(getElementData(vehicle, "vehicle.owner")) == tonumber(getElementData(thePlayer, "player.uid")) and tonumber(getElementData(vehicle, "vehicle.ownertype")) == 1 then
				-- Zaparkuj wózek
				if ParkVehicle(vehicle) then
					call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Pojazd został pomyślnie zaparkowany.", 5 )
				else
					call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Wystąpił błąd podczas parkowania pojazdu, być może jest zajęte miejsce parkingowe.", 5 )
				end
			else
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie jesteś właścicielem tego pojazdu.", 5 )
			end
		end

		if(action == "lista") then
			
		end

		if(action == "info") then
			-- potem
			local vehicle = getPedOccupiedVehicle(thePlayer)
			if not vehicle then
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie jesteś w żadnym pojeździe.", 5 )
				return
			end

			if tonumber(getElementData(vehicle, "vehicle.owner")) == tonumber(getElementData(thePlayer, "player.uid")) and tonumber(getElementData(vehicle, "vehicle.ownertype")) == 1 then
				local infoarray = {}
				infoarray[1] = vehicleNames[getElementModel(vehicle) - 400][2]
				triggerClientEvent(thePlayer, "showVehicleInfoView", thePlayer, vehicle, infoarray)
			else
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie jesteś właścicielem tego pojazdu.", 5 )
				return
			end
		end

		if(action == "zamknij") or (action == "z") then
			local car = getNearbyPlayerCar(thePlayer, 3)
			local is_done = false

			if car ~= nil then
				if tonumber(getElementData(car, "vehicle.ownertype")) == 1 and tonumber(getElementData(car, "vehicle.owner")) == tonumber(getElementData(thePlayer, "player.uid")) then
					setVehicleLocked(car, not isVehicleLocked(car))
					is_done = true
				else
					-- jeśli nie jest właścicielem to sprawdź czy chociaż adminem jest
					local padmin = call ( getResourceFromName ( "lsrp" ), "getPlayerAdmin", thePlayer )
					if (padmin > 0) then
						setVehicleLocked(car, not isVehicleLocked(car))
						is_done = true
					end
				end
			end

			if is_done then
				if isVehicleLocked(car) == true then
					call ( getResourceFromName ( "lsrp" ), "gameTextForPlayer", thePlayer, "zamek zamkniety", 5 )
				else
					call ( getResourceFromName ( "lsrp" ), "gameTextForPlayer", thePlayer, "zamek otwarty", 5 )
				end
			end

			if car == nil then
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie znaleziono żadnego pojazdu w pobliżu.", 5 )
			end
		end
	else 
		-- nie dał żadnego parametru więc po prostu pokazuje się lista pojazdów
		local query = dbQuery(handler, "SELECT * FROM lsrp_cars WHERE car_owner = "..tonumber(getElementData(thePlayer, "player.uid")).." AND car_ownertype = 1")
		local result = dbPoll ( query, -1 )

		if result then
			if result[1]  then
				-- są
				outputChatBox("#CCCCCCUżycie: /v [lista | zamknij | namierz | info | zaparkuj | sprzedaj]", thePlayer, 255, 255, 255, true)
				triggerClientEvent (thePlayer, "showPlayerVehiclesClient", thePlayer )
			else 
				-- nie ma
				call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie posiadasz żadnego pojazdu.", 5 )
				return
			end
		else 
			-- nie ma
			call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, "Nie posiadasz żadnego pojazdu.", 5 )
			return
		end

		-- free mysql
		if query then dbFree(query) end
	end
end
addCommandHandler("v", launchServerVehiclesShowing)

-- namierzanie s-side
function findMyVehicleServer(thePlayer, theVehicleUID)
	local theVehicle = getVehicleByUID(theVehicleUID)
	if not theVehicle then return end

	local player_id = tonumber(getElementData(thePlayer, "id"))
	if blip[player_id] then
		destroyElement(blip[player_id])
		blip[player_id] = nil
		return
	end
	
	local x, y, z = getElementPosition(theVehicle)
	blip[player_id] = createBlipAttachedTo ( theVehicle, 0, 2, 0, 100, 0, 255, 0, 99999.0, thePlayer )
	addEventHandler ( "onVehicleEnter", getRootElement(), checkBlip )
end
addEvent("callFindMyVehicle", true)
addEventHandler("callFindMyVehicle", getRootElement(), findMyVehicleServer)

-- test vehicle
function createVehicleForPlayer(thePlayer, command, vehicleModel)
	local x,y,z = getElementPosition(thePlayer) -- get the position of the player
	x = x + 5 -- add 5 units to the x position
	local createdVehicle = lsrp_CreateVehicle(tonumber(vehicleModel),x,y,z)
	-- check if the return value was ''false''
	if (createdVehicle == false) then
		-- if so, output a message to the chatbox, but only to this player.
		outputChatBox("Failed to create vehicle.",thePlayer)
	end
end
addCommandHandler("createvehicle", createVehicleForPlayer)

-- test handling
function addVehiclePower(thePlayer, command, thePower)
	local power = tonumber(thePower)
	local vehicle = getPedOccupiedVehicle(thePlayer)

	setVehicleHandling(vehicle, "maxVelocity", power)
	setVehicleHandling(vehicle, "engineAcceleration", power)
end
addCommandHandler("handling", addVehiclePower)

-- test destroy
function deleteVehicle(thePlayer, command, vehicleId)
	lsrp_DestroyVehicle(tonumber(vehicleId))
end
addCommandHandler("destroyveh", deleteVehicle )

function getvids(thePlayer, command)
	for i=1, 2000 do 
		if veh_ids[i] then
			outputChatBox(i,thePlayer)
		end
	end
end
addCommandHandler("getvids", getvids)

--[[
		Funkcje
]]--

-- wyświetlanie popupa
function showVehiclePopup(thePlayer, message, time)
	return call ( getResourceFromName ( "lsrp" ), "showPopup", thePlayer, message, tonumber(time) )
end
addEvent( "showVehiclePopup", true )
addEventHandler( "showVehiclePopup", resourceRoot, showVehiclePopup )

-- Funkcja na tworzenie auta, żeby IDy działały - nie używać createVehicle
function lsrp_CreateVehicle(model, x, y, z, rx, ry, rz, numberplate, bDirection, variant1, variant2)
	bDirection = false

	if not rx then rx = 0.0 end
	if not ry then ry = 0.0 end
	if not rz then rz = 0.0 end

	if numberplate == 0 then numberplate = "_" end
	if not variant1 then variant1 = 0 end
	if not variant2 then variant2 = 0 end

	local vehicle = createVehicle(model, x, y, z, rx, ry, rz, numberplate, bDirection, variant1, variant2)
	setElementData(vehicle, "vehicle.enginerun", false)
	setElementData(vehicle, "vehicle.lights", 1)

	if vehicle then
		-- dodaj IDy i tym podobne
		assignVehID(vehicle)
		return vehicle
	else
		return false
	end
end

-- usuwanie pojazdu
function lsrp_DestroyVehicle(vehicleid)
	local element_vehicle = getVehicleByID(tonumber(vehicleid))
	if element_vehicle then
		freeVehicleID( element_vehicle )
		destroyElement ( element_vehicle )
	end
end

-- Ładowanie pojazdu z bazy
function LoadVehicle(uid)
	-- hotfix
	local hotfix = getVehicleByUID(uid)
	if hotfix ~= false then
		outputDebugString("[error] Próbowano wczytać pojazd, który jest już w grze UID(".. uid ..")")
		return
	end

	local query = dbQuery(handler, "SELECT * FROM lsrp_cars WHERE car_uid = "..tonumber(uid))
	local result = dbPoll(query, -1)

	if result then
		if result[1] then
			local x = result[1]["car_posx"]
			local y = result[1]["car_posy"]
			local z = result[1]["car_posz"]
			local angle = result[1]["car_posa"]
			local model = result[1]["car_model"]

			local vehicle = lsrp_CreateVehicle(tonumber(model), tonumber(x), tonumber(y), tonumber(z))
    		setElementRotation(vehicle, 0, 0, 0+tonumber(angle), "default", true) 
    		setVehicleEngineState ( vehicle, false )

    		-- Vehicle data
    		setElementData(vehicle, "vehicle.uid", uid)
    		setElementData(vehicle, "vehicle.model", tonumber(model))
    		setElementData(vehicle, "vehicle.owner", tonumber(result[1]["car_owner"]))
    		setElementData(vehicle, "vehicle.ownertype", tonumber(result[1]["car_ownertype"]))
    		setElementData(vehicle, "vehicle.name", result[1]["car_name"])
    		setElementData(vehicle, "vehicle.doors", false) -- potem do zmiany albo i nie
    		setElementData(vehicle, "vehicle.spawnx", result[1]["car_posx"])
    		setElementData(vehicle, "vehicle.spawny", result[1]["car_posy"])
    		setElementData(vehicle, "vehicle.spawnz", result[1]["car_posz"])
    		setElementData(vehicle, "vehicle.health", result[1]["car_health"])
    		setElementData(vehicle, "vehicle.fuel", result[1]["car_fuel"])
    		setElementData(vehicle, "vehicle.mileage", result[1]["car_mileage"])

    		-- Kolory
    		setElementData(vehicle, "vehicle.col1", result[1]["car_color1"])
    		setElementData(vehicle, "vehicle.col2", result[1]["car_color2"])
    		local color1 = result[1]["car_color1"]
    		local color2 = result[1]["car_color2"]
    		local color1_ar = {}
    		local color2_ar = {}
    		color1_ar[0], color1_ar[1], color1_ar[2] = color1:match("(%d+),(%d+),(%d+)")
    		color2_ar[0], color2_ar[1], color2_ar[2] = color2:match("(%d+),(%d+),(%d+)")
    		setVehicleColor(vehicle, color1_ar[0], color1_ar[1], color1_ar[2], color2_ar[0], color2_ar[1], color2_ar[2])
    		-- setVehicleHeadLightColor ( vehicle, 100, 25, 25)

    		-- ustaw VW
    		setElementDimension(vehicle, tonumber(result[1]["car_world"]))
    		setVehiclePaintjob ( vehicle, tonumber(result[1]["car_paintjob"]) )

    		-- Rejestracja
    		local is_registered = tonumber(result[1]["car_register"])
    		if is_registered > 0 then 
    			setVehiclePlateText( vehicle, "LS " .. uid )
    		else
    			setVehiclePlateText( vehicle, "_" )
    		end

    		-- Obrażenia wozu
    		setElementHealth(vehicle, tonumber(result[1]["car_health"]))
    		local visual = result[1]["car_visual"]
    		local panels = {} -- tablica na maskę etc.
    		local dstate = {} -- tablica na drzwi
    		panels[0], panels[1], panels[2], panels[3], panels[4], panels[5], panels[6], dstate[0], dstate[1], dstate[2], dstate[3], dstate[4], dstate[5] = visual:match("(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+),(%d+)")
    		for i = 0, 6 do
    			setVehiclePanelState(vehicle, i, tonumber(panels[i]))
    		end
    		for i = 0, 5 do
    			setVehicleDoorState(vehicle, i, tonumber(dstate[i]))
    		end

    		exports.rp_logs:log_VehicleLog("[load] Wczytuję pojazd "..result[1]["car_name"].." (UID: "..uid..")")
		else
			return false
		end
	else
		return false
	end

	-- Wyczyść wynik
	if query then dbFree(query) end
end
addEvent( "LoadVehicle", true )
addEventHandler( "LoadVehicle", resourceRoot, LoadVehicle )

-- Wczytywanie wszystkich pojazdów na starcie
function LoadVehicles()
	--[[ FUNKCJA NIEDOKOŃCZONA ]]--
	--[[ FUNKCJA NIEDOKOŃCZONA ]]--
	--[[ 		GRUPY      	   ]]--
	--[[ FUNKCJA NIEDOKOŃCZONA ]]--
	--[[ FUNKCJA NIEDOKOŃCZONA ]]--
	--[[ FUNKCJA NIEDOKOŃCZONA ]]--
	local query = dbQuery(handler, "SELECT * FROM lsrp_cars WHERE car_ownertype != 1")
	local result = dbPoll(query, -1)

	if result then
		for k = 0, table.getn(result) do
			if result[k] then
				LoadVehicle(tonumber(result[tonumber(k)]["car_uid"]))
			end
		end
	end

	if query then dbFree(query) end
end
addEventHandler ( "onResourceStart", resourceRoot, LoadVehicles )

-- najbliższy pojazd od gracza
function getNearbyPlayerCar(thePlayer, radius)
	local x, y, z = getElementPosition(thePlayer)
	local vehRadius = createColSphere( x, y, z, tonumber(radius) )
	local vehicles = getElementsWithinColShape( vehRadius, "vehicle" )

	local last = nil
	local distance = nil
	for k, vehicle in pairs(vehicles) do
		local vx, vy, vz = getElementPosition(vehicle)
		local dist_veh_player = getDistanceBetweenPoints3D(x, y, z, vx, vy, vz)

		if distance == nil or dist_veh_player < distance then
			last = vehicle
			distance = dist_veh_player
		end
	end

	destroyElement(vehRadius) -- optymalizacja
	return last
end

-- światła pojazdu
function changeVehicleStateLights(theVehicle)
	local state = getElementData(theVehicle, "vehicle.lights")
	if state == 1 then
		setElementData(theVehicle, "vehicle.lights", 2)
		setVehicleOverrideLights(theVehicle, 2)
		return
	else
		setElementData(theVehicle, "vehicle.lights", 1)
		setVehicleOverrideLights(theVehicle, 1)
		return
	end
end

-- wł/wył silnika [[ NIE DOKOŃCZONE ]]
function changeVehicleEngineState(theVehicle)
	local state = getVehicleEngineState ( theVehicle )
	setVehicleEngineState ( theVehicle, not state )
	setElementData(theVehicle, "vehicle.enginerun", not state)
end

-- informacje o pojeździe
function showVehicleInfo(thePlayer, theVehicle)

end

-- Tworzenie nowego wozu
function CreateCar(model, x, y, z)
	local query = dbQuery(handler, "INSERT INTO `lsrp_cars` (car_model, car_name, car_posx, car_posy, car_posz, car_posa, car_fuel, car_fueltype) VALUES ('".. tonumber(model) .."', '".. vehicleNames[tonumber(model) - 400][2] .."', '".. x .."', '".. y .."', '".. z .."', '0.0', '50', '0')")
	local _, _, insert_id = dbPoll(query, -1)

	LoadVehicle(tonumber(insert_id))
	if query then dbFree(query) end
	return insert_id
end

-- Usuwanie pojazdu
function DeleteCar(vehicle_id)
	local vehicle = getVehicleByID(vehicle_id)
	local uid = getElementData(vehicle, "vehicle.uid")

	if vehicle ~= false then
		local query = dbQuery(handler, "DELETE FROM lsrp_cars WHERE car_uid = "..tonumber(getElementData(vehicle, "vehicle.uid")))
		if query then dbFree(query) end

		lsrp_DestroyVehicle(vehicle_id)
		return true
	else
		return false
	end
end

-- Unspawn auta
function UnspawnVehicle(vehicle_id)
	local vehicle = getVehicleByID(vehicle_id)
	if vehicle ~= false then
		-- zapisz i tak dalej
		--[[ FUNKCJA NIEDOKOŃCZONA ]]--
		--[[ FUNKCJA NIEDOKOŃCZONA ]]--
		--[[ FUNKCJA NIEDOKOŃCZONA ]]--
		--[[ FUNKCJA NIEDOKOŃCZONA ]]--
		--[[ FUNKCJA NIEDOKOŃCZONA ]]--
		--[[ FUNKCJA NIEDOKOŃCZONA ]]--
		--[[ FUNKCJA NIEDOKOŃCZONA ]]--
		--[[ FUNKCJA NIEDOKOŃCZONA ]]--
		--[[ FUNKCJA NIEDOKOŃCZONA ]]--

		local fuel = getElementData(vehicle, "vehicle.fuel")
		local mileage = getElementData(vehicle, "vehicle.mileage")

		local query = dbQuery(handler, "UPDATE lsrp_cars SET car_mileage = '"..mileage.."' , car_fuel = '".. fuel .."' WHERE car_uid = "..getElementData(vehicle, "vehicle.uid"))
		dbFree(query)

		-- wizualne pobierz
		local visual = ""
		for i = 0, 6 do
			local panel = getVehiclePanelState(vehicle, i)
			visual = visual..panel..","
		end

		for i = 0, 5 do
			local state = getVehicleDoorState(vehicle, i)
			if i < 5 then
				visual = visual..state..","
			else
				visual = visual..state
			end
		end

		local query = dbQuery(handler, "UPDATE lsrp_cars SET car_visual = '".. visual .."', car_health = '".. getElementHealth(vehicle) .."' WHERE car_uid = "..getElementData(vehicle, "vehicle.uid"))
		dbFree(query)

		outputDebugString("[unload] Pojazd ".. getElementData(vehicle, "vehicle.name") .." (UID: ".. getElementData(vehicle, "vehicle.uid") ..") został odspawnowany pomyślnie")
		lsrp_DestroyVehicle(vehicle_id)
	else
		return false
	end
end
addEvent( "UnspawnVehicle", true )
addEventHandler( "UnspawnVehicle", resourceRoot, UnspawnVehicle )

-- funkcja do c-side ale po s-side
function ListPlayerVehicles(thePlayer, uid)
	local query = dbQuery(handler, "SELECT * FROM lsrp_cars WHERE car_owner = "..tonumber(uid).." AND car_ownertype = 1")
	local result = dbPoll(query, -1)

	carsarray = {}
	local index = 0

	if result then
		carsarray = {}
		local index = 0
		local veh_num = table.getn(result)

		for i = 1, veh_num do
			carsarray[index] = {}
			carsarray[index][0] = result[i]["car_uid"]
			carsarray[index][1] = result[i]["car_name"]
			carsarray[index][2] = result[i]["car_model"]
			carsarray[index][3] = result[i]["car_uid"] -- tylko dla testu
			index = index + 1
		end
	end

	-- mysql free
	if query then dbFree(query) end

	-- powrót do c-side
	triggerClientEvent (thePlayer, "fillVehicles", thePlayer, carsarray )
end
addEvent( "ListPlayerVehicles", true )
addEventHandler( "ListPlayerVehicles", resourceRoot, ListPlayerVehicles )

-- parkowanie pojazdu
function ParkVehicle(theVehicle)
	if not isElement(theVehicle) then return false end
	local x, y, z = getElementPosition(theVehicle)
	local rx, ry, rz = getElementRotation(theVehicle)

	local query = dbQuery(handler, "UPDATE lsrp_cars SET car_posx = '".. x .."', car_posy = '".. y .."', car_posz = '".. z .."', car_posa = '".. rz .."' WHERE car_uid = '".. getElementData(theVehicle, "vehicle.uid") .."'")
	if query then dbFree(query) end

	return true
end

-- wyłączenie auto odpalenia
function rp_engining(theVehicle, leftSeat, jackerPlayer)
	if getElementData(theVehicle, "vehicle.enginerun") == false then
		setVehicleEngineState ( theVehicle, false )
	else
		setVehicleEngineState ( theVehicle, true )
	end

	if getElementData(theVehicle, "vehicle.lights") == 1 then
		setVehicleOverrideLights(theVehicle, 1)
	else
		setVehicleOverrideLights(theVehicle, 2)
	end
end
addEventHandler ( "onPlayerVehicleEnter", getRootElement ( ), rp_engining )

-- czy wóz w ogóle ma kierowców
function isVehicleOccupied(theVehicle)
	local players = getElementsByType ( "player" )
	for it, player in ipairs(players) do
		if(getPedOccupiedVehicle(player) == theVehicle) then
			return true
		end
	end

	return false
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

-- pobierz najbliższą stacje
function getPlayerNearbyGasStation(thePlayer)
	local x, y, z = getElementPosition(thePlayer)
	local station = nil

	for i=0, table.getn(gasStation) do
		local distance = getDistanceBetweenPoints2D(x, y, gasStation[i][2], gasStation[i][3])

		if distance < 10 then
			station = i
			break
		end
	end
	return station
end

-- sprawdzanie blipów
function checkBlip(thePlayer, seat, jacked)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	local player_id = tonumber(getElementData(thePlayer, "id"))
	if isElement(blip[player_id]) then
		destroyElement(blip[player_id])
		removeEventHandler("onVehicleEnter", getRootElement(), checkBlip)
	end
end

-- WHYIMSOBAD S-SIDE SYNC OPON

-- Silniki rowerów
function enterBikes ( thePlayer, seat, jacked ) -- when a player enters a vehicle
    local model = getElementModel(source)
    if model == 509 or model == 481 or model == 510 then
    	if getElementData(source, "vehicle.enginerun") == false then
    		changeVehicleEngineState(source)
    	end
    end
end
addEventHandler ( "onVehicleEnter", getRootElement(), enterBikes )