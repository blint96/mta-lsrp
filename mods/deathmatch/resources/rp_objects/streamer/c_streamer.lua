-- Zmienne gracza
local p_vw = 0
local p_x = 0
local p_y = 0
local p_z = 0

-- Zmienne kuli sphere
local s_col = nil
local s_center = nil
local s_x = 0
local s_y = 0
local s_z = 0
local s_vw = 0

--- Zmienne dla streamera
local streamingObjects = {}

-- Init streamer
function setPlayerObjectStreamerEnabled()
	outputConsole("[streamer] Enabling streamer ...")
	setTimer(streamerLoop, 2500, 0)
end 
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), setPlayerObjectStreamerEnabled)

-- Streamer looping
function streamerLoop()
	local logged = getElementData(localPlayer, "player.logged")
	if logged == true then 
		-- streamer ma działać tylko dla zalogowanych
		p_vw = getElementDimension(localPlayer)
		p_x, p_y, p_z = getElementPosition(localPlayer)
		streamerFunction()
	end
end

-- Streamer debug
function streamerFunction()
	local distance = getDistanceBetweenPoints3D(p_x, p_y, p_z, s_x, s_y, s_z)
	if (distance > 150) or (s_vw ~= p_vw) then 
		-- zmieniaj pozycje środka streamowania
		if isElement(s_col) then destroyElement(s_col) end
		s_col = createColSphere(p_x, p_y, p_z, 300)
		s_x = p_x s_y = p_y s_z = p_z s_vw = p_vw

		-- debug
		if isElement(s_center) then destroyElement(s_center) end
		s_center = createColSphere(p_x, p_y, p_z, 10)

		-- Pobierz nowe obiekty, usuń stare
		for k, v in pairs(streamingObjects) do
			if isElement(streamingObjects[k]["elem"]) then 
				streamingObjects[k]["uid"] = 0
				destroyElement(streamingObjects[k]["elem"])
				streamingObjects[k]["elem"] = nil
			end
		end
		triggerServerEvent("onPlayerRequestObjects", getRootElement(), localPlayer, p_x, p_y, p_z, p_vw, 300)
	end 

	outputConsole("[streamer-debug] VW: ".. p_vw ..", POS: (".. p_x ..", ".. p_y ..", ".. p_z ..")")
end

function receiveNewObjects(objects)
	local index = 0
	for k, v in pairs(objects) do 
		local temp = createObject( objects[k]["model"], objects[k]["posx"], objects[k]["posy"], objects[k]["posz"], objects[k]["rotx"], objects[k]["roty"], objects[k]["rotz"] )
		if temp then
			streamingObjects[index] = {}
			streamingObjects[index]["uid"] = objects[k]["uid"]
			streamingObjects[index]["elem"] = temp

			setElementData(temp, "object.uid", objects[k]["uid"])
			setElementData(temp, "object.streamed", 1)
			index = index + 1
		end	
	end
	outputChatBox("#33AA33Receiving new #AA9999".. index .."#33AA33 objects!", 255, 255, 255, true)
end
addEvent("onServerSendObjects", true)
addEventHandler("onServerSendObjects", localPlayer, receiveNewObjects)

--[[
foreach przez wszystkie obiekty w tej nowej sphere i usuwanie tych, ktore maja getElement(uid)
wstawianie nowych
ale tylko gdy pozycja gracza jest rozna o 150 od center sphere
IMPORTANT! Jak będzie robione /oc to trzeba wszystkim wykonać pobranie obiektów na nowo :)
- /oc, dodawanie do tabeli i resync dla /ocujacego
]]--