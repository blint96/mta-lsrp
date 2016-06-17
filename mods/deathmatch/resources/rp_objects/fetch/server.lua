local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

-- Informacje o obiektach i ich materiałach
objectTexturesInfo = {}
function addObjectTextureInfo(object_element)
    local query = dbQuery(handler, "SELECT * FROM lsrp_materials WHERE mat_objectuid = "..tonumber(getElementData(object_element, "object.uid")))
    local result = dbPoll(query, -1)
    -- czyszczonko
    if not result then if query then dbFree(query) end return false end
    if not result[1] then if query then dbFree(query) end return false end
    -- /czyszczonko
    if query then dbFree(query) end

    objectTexturesInfo[object_element] = {}
    objectTexturesInfo[object_element]["uid"] = result[1]["mat_objectuid"]
    objectTexturesInfo[object_element]["texname"] = result[1]["mat_texturename"]
    objectTexturesInfo[object_element]["tex"] = result[1]["mat_textureuid"]
    return true
end

function getObjectTextureInfo(object)
    if objectTexturesInfo[object] then 
        return objectTexturesInfo[object]["uid"], objectTexturesInfo[object]["texname"], objectTexturesInfo[object]["tex"]
    else
        return false, false, false
    end
end









function renderObjectTexture(object, thePlayer)
	local uid, texname, tex = getObjectTextureInfo(object)
    if uid then 
	   fetchRemote ( "http://mta.ls-rp.net/walls/" .. tex .. ".png", getWallTextureCallback, "", false, object, thePlayer, texname, tex)
    end
end
addEvent("onRenderObjectTexture", true)
addEventHandler("onRenderObjectTexture", getRootElement(), renderObjectTexture)

function getWallTextureCallback( responseData, errno, object, thePlayer, texname, tex_uid )
    if errno == 0 then
    	syncing = object
        triggerClientEvent( thePlayer, "onClientDownloadWallTexture", thePlayer, responseData, syncing, texname, tex_uid )
    end
end