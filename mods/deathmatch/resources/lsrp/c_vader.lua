local sound_breath = nil
local breath_timer = nil

function checkSounds()
	-- wciśniemy na dziada
	if tonumber(getElementData(localPlayer, "player.bw")) > 0 then
	    if not block then
	        setPedAnimation ( localPlayer, "CRACK", "crckdeth2", 1, false, true)
	    end
   	end

	local l_x, l_y, l_z = getElementPosition(getLocalPlayer())
	local players = getElementsByType("player")

	if isSoundPaused(sound_breath) == true then
		-- jeśli jest spauzowana to sprawdź czy powinna być

		for index, player in pairs(players) do 
			if getElementModel(player) == 312 then
				local x, y, z = getElementPosition (player)
				local distance = getDistanceBetweenPoints2D(x, y, l_x, l_y)

				if distance < 25.0 then
					if getElementDimension(player) == getElementDimension(getLocalPlayer()) then
						-- player ma skin Vadera i są w pobliżu siebie
						setSoundPaused(sound_breath, false)
					end
				end
			end
		end 
	else
		-- jeżeli nie jest spauzowana to sprawdź czy powinna być i uaktualnij pozycje
		local is_vader = false;

		for index, player in pairs(players) do 
			if getElementModel(player) == 312 then
				local x, y, z = getElementPosition (player)
				local distance = getDistanceBetweenPoints2D(x, y, l_x, l_y)

				if distance < 25.0 then
					is_vader = true;
					setElementPosition(sound_breath, x, y, z)
				end
			end
		end

		if is_vader == false then
			setSoundPaused(sound_breath, true)
		end
	end
end

-- włącz wszystko
function setupVaderBreath()
	sound_breath = playSound3D("gamemode_replacements/sounds/vader/vader.mp3", 0.0, 0.0, 0.0, true)
	setSoundVolume(sound_breath, 0.15)
	setSoundPaused(sound_breath, true)

	breath_timer = setTimer ( checkSounds, 100, 0 )

	-- podmiana za Vadera
	txd = engineLoadTXD ( "gamemode_replacements/skins/vader_test/vader.txd" )
	engineImportTXD ( txd, 312 )
	dff = engineLoadDFF ( "gamemode_replacements/skins/vader_test/vader.dff" )
	engineReplaceModel ( dff, 312 )
end
addEventHandler("onClientResourceStart", root, setupVaderBreath)

-- wyłącz wszystko
function destroyVaderBreath( reason )
    killTimer(breath_timer)
    stopSound(sound_breath)
end
addEventHandler( "onClientResourceStop", root, destroyVaderBreath )