local syncTable = {}
for i = 1, 2500 do 
    syncTable[i] = {} 
end
function addPlayerAsSynced(thePlayer, theVehicle)
    --if not thePlayer or not theVehicle then return end
    local player_id = tonumber(getElementData(thePlayer, "id"))
    local vehicle_id = tonumber(getElementData(theVehicle, "id"))

    if syncTable[vehicle_id] then
        syncTable[vehicle_id][player_id] = true
    else 
        syncTable[vehicle_id] = {}
        syncTable[vehicle_id][player_id] = true
    end
end

function isPlayerSyncingVehicle(thePlayer, theVehicle)
    --if not thePlayer or not theVehicle then return end
    local player_id = tonumber(getElementData(thePlayer, "id"))
    local vehicle_id = tonumber(getElementData(theVehicle, "id"))
    if syncTable[vehicle_id] then 
        if syncTable[vehicle_id][player_id] == true then 
            return true
        else
            return false
        end
    else
        return false
    end
end

function stopPlayerSyncingInTable(thePlayer, theVehicle)
    local player_id = tonumber(getElementData(thePlayer, "id"))
    local vehicle_id = tonumber(getElementData(theVehicle, "id"))

    syncTable[vehicle_id][player_id] = false
end

function collectingLoop()
    local players = getElementsByType("player") 
    for k, v in ipairs(players) do
        local player_id = tonumber(getElementData(v, "id"))
        local px, py, pz = getElementPosition(v)
        for veh = 1, 2500 do 
            local vehicle = getVehicleByID(veh)
            if vehicle then 
                if isPlayerSyncingVehicle(v, vehicle) then
                    local x, y, z = getElementPosition(vehicle)
                    local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
                    if distance > 300.0 then 
                        triggerClientEvent( v, "onClientStopSyncing", v, vehicle )
                        stopPlayerSyncingInTable(v, vehicle)
                    end
                end
            else 
                -- dla nieistniejących
                if syncTable[veh][player_id] == true then 
                    syncTable[veh][player_id] = false
                end
            end
        end
    end
end

-- koniec gówien z syncem

function startTextureDownload ( vehicle, thePlayer )
    local vehicle_uid = getElementData(vehicle, "vehicle.uid")
    fetchRemote ( "http://mta.ls-rp.net/textures/" .. vehicle_uid .. ".png", getTextureCallback, "", false, vehicle, thePlayer )
end
addEvent("onRenderVehicleTexture", true)
addEventHandler("onRenderVehicleTexture", getRootElement(), startTextureDownload)
 
function getTextureCallback( responseData, errno, vehicle, thePlayer )
    -- TU WSZEDZIE BYŁ ROOT ZAMIAST VEHICLE w ONELEMENTSTARTSYNC ETC!!!!
    if errno == 0 then
    	syncing = vehicle -- nie wiem co to tutaj robi do cholery jasnej, narazie nie usuwam
        if not isPlayerSyncingVehicle(thePlayer, vehicle) then
            addPlayerAsSynced(thePlayer, vehicle)
            triggerClientEvent( thePlayer, "onClientDownloadTexture", thePlayer, responseData, vehicle )
        end

        -- Add custom paint
    	--[[addEventHandler ('onElementStartSync', vehicle, 
    	function(syncer) 
            if source == syncing then 

                if not isPlayerSyncingVehicle(syncer, syncing) then 
                    addPlayerAsSynced(syncer, syncing)
                    triggerClientEvent( syncer, "onClientDownloadTexture", syncer, responseData, syncing )
                    outputChatBox("pobierasz teksture "..getElementData(syncing, "vehicle.name"), syncer)
                end
    		end
    	end)]]--

    	--local current_world = getElementDimension(vehicle)
    	--setElementDimension(vehicle, 1)
    	--setTimer(function() setElementDimension(vehicle, current_world) end, 1000, 1)
    end
end