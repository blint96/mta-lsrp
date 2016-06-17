local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
local spawnX, spawnY, spawnZ = 1566.17, -1310.42, 17.15
timer_1000 = nil
timer_minute = nil
timer_100 = nil

-- Tu małe pierdoły
function onMinuteTimer()
    for i, player in ipairs(getElementsByType("player")) do
      if (getElementData(player, "player.logged") == true) then
        -- Czas w grze
        local p_minutes = getElementData(player, "player.minutes")
        p_minutes = p_minutes + 1
        if p_minutes > 59 then
          setElementData(player, "player.minutes", 0)
          setElementData(player, "player.hours", tonumber(getElementData(player, "player.hours")) + 1)

          -- Dodaj GSki, potem dodaj dla Premium wyjątek
          local gamepoints = tonumber(getElementData(player, "player.gamescore"))
          gamepoints = gamepoints + 25
          setElementData(player, "player.gamescore", gamepoints)

          local query = dbQuery(handler, "UPDATE lsrp_members SET user_gamepoints = '".. gamepoints .."' WHERE user_id = '" .. getElementData(player, "player.gid") .. "'")
          dbFree(query)
        else
          setElementData(player, "player.minutes", p_minutes)
        end
      end
    end
end

-- Tu pakować jak najmniej
function on100timer()
  for i, player in ipairs(getElementsByType("player")) do
    if (getElementData(player, "player.logged") == true) then
      -- Obiekty broni na scrollu
      setPlayerWeaponsOnScroll(player)
    end
  end
end

-- Tu większość
function on1000timer()

    -- tylko na chwile tutaj
    exports.rp_vehicles:collectingLoop()

  	-- pętla co sekundę przez wszystkich graczy
  	for i, player in ipairs(getElementsByType("player")) do
  		-- sprawdzenie Vadera
        if (getElementData(player, "player.logged") == true) then
       		local skin = getElementModel(player)
       		if skin == 312 then
            if (tonumber(getPlayerAdmin(player) ~= 1)) then
              setElementModel(player, 1)
            end
       		end	

          -- Doczepiaj bronie 
          --setPlayerWeaponsOnScroll(player)

          local bw_time = tonumber(getElementData(player, "player.bw"))
          if bw_time > 0 then
            bw_time = bw_time - 1
            setElementData(player, "player.bw", bw_time)
            setElementHealth(player, 20)
            if bw_time == 0 then
              -- koniec BW tutaj
              toggleAllControls ( player, true ) 
              setPedAnimation(player, "BSKTBALL","BBALL_idle_O", 1)
            else
              setPedAnimation ( player, "CRACK", "crckdeth2", 1, false, true)
            end

            -- Sprawdzanie animki, pozycji etc
            -- Tekst ile BW mu zostało
          end

          -- AJ
          local time = tonumber(getElementData(player, "player.aj"))
          if (time > 0) then
            time = time - 1
            if (time == 0) then
              -- wypuszczanie w tym miejscu 
              setElementData(player, "player.aj", 0)
              setElementPosition(player, spawnX, spawnY, spawnZ)
              outputChatBox("#CCCCCCOpuściłeś adminjail.", player, 255, 255, 255, true)
            end
            setElementData(player, "player.aj", time)
            gameTextForPlayer(player, "Pozostały czas AJ: "..time.." sekund", 1)
          end
        end
    end

    -- pętla co sekunde dla pojazdów i 
    for i, vehicle in ipairs(getElementsByType("vehicle")) do

    	-- ustawianie niezniszczalności jak nikogo w środku nie ma #SAMP
    	if not isVehicleOccupied(vehicle) then
    		if not isVehicleDamageProof(vehicle) then
    			setVehicleDamageProof(vehicle, true)
    		end
    	else 
    		if isVehicleDamageProof(vehicle) then
    			setVehicleDamageProof(vehicle, false)
    		end
    	end

      -- co by się nie zapalił, nie wybuchał etc
      if getElementHealth(vehicle) < 350 then
        setElementHealth(vehicle, 350)
      end

      local model = getElementModel(vehicle)
      if model ~= 509 and model ~= 481 and model ~= 510 then
        -- sprawdź czy odpalony a ma 350 hp
        if getElementHealth(vehicle) <= 350 then
          if getElementData(vehicle, "vehicle.enginerun") == true then
            setVehicleEngineState ( vehicle, false )
            setElementData(vehicle, "vehicle.enginerun", false)
          end
        end

        -- paliwo
        if getElementData(vehicle, "vehicle.fuel") <= 0 then
          if getElementData(vehicle, "vehicle.enginerun") == true then
            setElementData(vehicle, "vehicle.fuel", 0)
            setVehicleEngineState ( vehicle, false )
            setElementData(vehicle, "vehicle.enginerun", false)
          end
        end
      end

      -- naprawiaj wizualne do 900 HP
      if getElementHealth(vehicle) > 900 then
        for i = 0, 6 do
          local panel = getVehiclePanelState(vehicle, i)
          if panel ~= 0 then
            setVehiclePanelState(vehicle, i, 0)
          end
        end

        for i = 0, 5 do
          local state = getVehicleDoorState(vehicle, i)
          if state ~= 0 and state ~= 1 then
            setVehicleDoorState(vehicle, i, 0)
          end
        end
      end

      -- przebieg
      if getElementData(vehicle, "vehicle.enginerun") == true then
        local current = getElementSpeed(vehicle) / 1000
        local mileage = getElementData(vehicle, "vehicle.mileage")
        if current > 0 then
          setElementData(vehicle, "vehicle.mileage", mileage + current)
        end
      end

      -- paliwo
      if getElementData(vehicle, "vehicle.enginerun") == true then
        local speed = getElementSpeed(vehicle, 1)
        local fuel = getElementData(vehicle, "vehicle.fuel")
        if ( speed < 1 ) then
          setElementData(vehicle, "vehicle.fuel", fuel - 0.001)
        elseif(speed >= 1 and speed <= 40) then
          setElementData(vehicle, "vehicle.fuel", fuel - 0.005)
        elseif(speed >= 41 and speed <= 80) then
          setElementData(vehicle, "vehicle.fuel", fuel - 0.008)
        elseif(speed >= 81 and speed <= 120) then
          setElementData(vehicle, "vehicle.fuel", fuel - 0.010)
        elseif(speed >= 121 and speed <= 150) then
          setElementData(vehicle, "vehicle.fuel", fuel - 0.015)
        else
          setElementData(vehicle, "vehicle.fuel", fuel - 0.022)
        end
      end
    end
end
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), function()  timer_1000 = setTimer(on1000timer, 1000, 0) timer_minute = setTimer(onMinuteTimer, 60000, 0) timer_100 = setTimer(on100timer, 100, 0) end )
-- zamiast podpinania do Root bo wtedy sie wykona co kazdy start dowolnego Resource