-- MOŻE LAGOWAĆ?
local busstops = {}
local is_in_bus = false
local bus_font = exports.lsrp:getRobotoFont(12)
local current_stop = nil
local is_blocked = false

function syncBusStops(list_of_busstops)
	busstops = list_of_busstops
end
addEvent("onSyncBus", true)
addEventHandler("onSyncBus", getRootElement(), syncBusStops)

function renderBusStopForPlayer(bus_id)
	
end

addEventHandler("onClientRender", getRootElement(), 
	function() 
		local x, y, z = getElementPosition(localPlayer)
		for key, value in pairs(busstops) do
			if busstops[key] then 
				local distance = getDistanceBetweenPoints3D(x, y, z, tonumber(busstops[key]["bus_x"]), tonumber(busstops[key]["bus_y"]), tonumber(busstops[key]["bus_z"]))
				if distance < 10.0 then 
					local sX, sY = getScreenFromWorldPosition( tonumber(busstops[key]["bus_x"]), tonumber(busstops[key]["bus_y"]), tonumber(busstops[key]["bus_z"]) );
					if sX and sY then 
						local text = "#99CCFFPrzystanek (".. busstops[key]["bus_uid"] ..")\n#FF9999"..busstops[key]["bus_name"]
						dxDrawText( text, sX, sY, sX, sY, tocolor(51,153,153,200), 1.0, bus_font, "center", "bottom", false, true, false, true )
					end
				end
			end
		end
	end
)

function getPlayerBusstop()
	local x, y, z = getElementPosition(localPlayer)
	local index = nil

	for key, value in pairs(busstops) do 
		if busstops[key] then 
			local distance = getDistanceBetweenPoints3D(x, y, z, tonumber(busstops[key]["bus_x"]), tonumber(busstops[key]["bus_y"]), tonumber(busstops[key]["bus_z"]))
			if distance < 5.0 then 
				index = key
				break
			end
		end
	end 
	return index
end

--[[ Latanie po przystankach ]]--
function onEnterBus()
	if is_in_bus then 
		-- WYJDŹ Z BUSA
		setBusKeysBind(false)
		setCameraTarget(localPlayer)
		setElementFrozen(localPlayer, false)
		is_in_bus = false
		return
	end

	local id = getPlayerBusstop()
	if id then 
		-- WCHODZISZ DO BUSA
		is_blocked = false
		setBusKeysBind(true)
		current_stop = id
		is_in_bus = true
		setElementFrozen(localPlayer, true)
		local x, y, z = busstops[id]["bus_x"], busstops[id]["bus_y"], busstops[id]["bus_z"]
		setCameraMatrix ( x, y, z + 70, x, y, z )
	end
end
addEvent("onEnterBus", true)
addEventHandler("onEnterBus", getRootElement(), onEnterBus)

--[[
	Bindy
]]--
function setBusKeysBind(toggle)
	if not toggle then 
		-- usuń
		unbindKey ( "arrow_u", "up", rideThere ) 
		unbindKey ( "arrow_d", "up", exitBus ) 
		unbindKey ( "arrow_l", "up", gotoNextStop ) 
		unbindKey ( "arrow_r", "up", gotoPreviousStop ) 
	else
		-- dodaj
		bindKey ( "arrow_u", "up", rideThere ) 
		bindKey ( "arrow_d", "up", exitBus ) 
		bindKey ( "arrow_l", "up", gotoNextStop )
		bindKey ( "arrow_r", "up", gotoPreviousStop )
	end
end

function exitBus()
	if is_blocked then return end
	setBusKeysBind(false)
	setCameraTarget(localPlayer)
	setElementFrozen(localPlayer, false)
	is_in_bus = false
end

function rideThere()
	if is_blocked then return end
	setElementPosition(localPlayer, busstops[current_stop]["bus_x"], busstops[current_stop]["bus_y"], busstops[current_stop]["bus_z"])
	smoothMoveCamera(busstops[current_stop]["bus_x"],busstops[current_stop]["bus_y"],busstops[current_stop]["bus_z"] + 70, busstops[current_stop]["bus_x"],busstops[current_stop]["bus_y"], busstops[current_stop]["bus_z"],busstops[current_stop]["bus_x"],busstops[current_stop]["bus_y"],busstops[current_stop]["bus_z"]+10,busstops[current_stop]["bus_x"],busstops[current_stop]["bus_y"],busstops[current_stop]["bus_z"], 3000)
	
	is_blocked = true
	setTimer(function() is_blocked = false exitBus() end, 3000, 1)
end

function gotoNextStop()
	next_stop = current_stop + 1
	smoothMoveCamera(busstops[current_stop]["bus_x"],busstops[current_stop]["bus_y"],busstops[current_stop]["bus_z"] + 70, busstops[current_stop]["bus_x"],busstops[current_stop]["bus_y"], busstops[current_stop]["bus_z"],busstops[next_stop]["bus_x"],busstops[next_stop]["bus_y"],busstops[next_stop]["bus_z"]+70,busstops[next_stop]["bus_x"],busstops[next_stop]["bus_y"],busstops[next_stop]["bus_z"], 10000)
	is_blocked = true
	setTimer(function() is_blocked = false end, 10000, 1)

	current_stop = current_stop + 1
	if current_stop > table.getn(busstops) then 
		current_stop = 1
	end
end

function gotoPreviousStop()
	next_stop = current_stop - 1
	smoothMoveCamera(busstops[current_stop]["bus_x"],busstops[current_stop]["bus_y"],busstops[current_stop]["bus_z"] + 70, busstops[current_stop]["bus_x"],busstops[current_stop]["bus_y"], busstops[current_stop]["bus_z"],busstops[next_stop]["bus_x"],busstops[next_stop]["bus_y"],busstops[next_stop]["bus_z"]+70,busstops[next_stop]["bus_x"],busstops[next_stop]["bus_y"],busstops[next_stop]["bus_z"], 10000)
	is_blocked = true
	setTimer(function() is_blocked = false end, 10000, 1)

	current_stop = current_stop - 1
	if current_stop < 1 then
		current_stop = 1;
	end
end