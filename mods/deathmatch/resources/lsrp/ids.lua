-- idy graczy
local ids = {}

function assignID()
    for i=1,getMaxPlayers() do
        if not ids[i] then
            ids[i] = source
            setElementData(source,"id",i,not optimize)
            break
        end
    end
end
addEventHandler("onPlayerJoin",root,assignID)

function startup()
    for k, v in pairs(getElementsByType("player")) do
        local id = getElementData(v,"id")
        if id then ids[id] = v end
    end
end
addEventHandler("onResourceStart",resourceRoot,startup)

function getPlayerID(player)
    for k, v in pairs(ids) do
        if v == player then return k end
    end
end

function freeID()
    local id = getElementData(source,"id")
    if not id then return end
    ids[id] = nil
end
addEventHandler("onPlayerQuit",root,freeID)

function getPlayerByID(id)
    local player = ids[id]
    return player or false
end