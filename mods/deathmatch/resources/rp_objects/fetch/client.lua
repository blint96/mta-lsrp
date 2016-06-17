-- [[ INIT ]] --
-- Tablica na ściągnięte aktualnie tekstury
-- TRZEBA ZROBIĆ KONIECZNIE WYJĄTEK ŻEBY NIE BYŁO OVERFLOWA JAK NIE BĘDZIE MIEJSCA, PO PROSTU ERROR I CHUJ
storedTextures = {}
MAX_STORED_TEXTURES = 1000
--[[
	// UID tekstury z plików
	storedTextures[k]["texture_uid"] =

	// element na shader
	storedTextures[k]["shader"] = nil

	// ++ gdy stremujemy obiekt z tym i -- gdy jakiś obiekt odchodzi a jak zero to czyścić tabele
	storedTextures[k]["num_of_instances"] = 
]]

for i = 1, MAX_STORED_TEXTURES do 
	storedTextures[i] = {}
	storedTextures[i]["texture_uid"] = nil
	storedTextures[i]["shader"] = nil
	storedTextures[i]["texture"] = nil
    storedTextures[i]["object"] = nil
end

-- 
storedObjects = {}
--[[
    Indeksami będzie po prostu element obiektu żeby na onStream i outStream usuwało się
]]--

-- [[ /INIT ]] --


-- [[ FUNC ]] --
function getFreeWallTexturesCell()
	local is_free = false
	for i = 1, MAX_STORED_TEXTURES do 
		if not storedTextures[i]["shader"] and not storedTextures[i]["texture_uid"] then 
			is_free = i
			break
		end
	end
	return is_free
end

function getStoredFromTexUID(tex_uid)
    for i = 1, MAX_STORED_TEXTURES do
        if storedTextures[i] then 
            if storedTextures[i]["texture_uid"] == tonumber(tex_uid) then 
                return i
            end
        end
    end
    return false
end

function getStoredIDFromObject(object)
    local id = false;
    for i = 1, MAX_STORED_TEXTURES do
        if storedTextures[i] then 
            if storedTextures[i]["object"] == object then 
                id = i
                break
            end
        end
    end
    return id
end

function applyShaderToObject(pixels, object, texName, texUid)
    local free_id = getFreeWallTexturesCell()
    storedTextures[free_id]["texture_uid"] = texUid
    storedTextures[free_id]["shader"] = exports.score_wisb:createReplaceShader()
    storedTextures[free_id]["texture"] = dxCreateTexture( pixels, "dxt5" )
    storedTextures[free_id]["object"] = object

    dxSetShaderValue( storedTextures[free_id]["shader"], "Tex0", storedTextures[free_id]["texture"] )
    engineApplyShaderToWorldTexture ( storedTextures[free_id]["shader"], texName, object )

end

function removeShaderFromObject(object)
	-- to samo co up
end
-- [[ /FUNC ]] --

addEvent( "onClientDownloadWallTexture", true )
addEventHandler( "onClientDownloadWallTexture", localPlayer,
    function( pixels, targetElement, texName, tex_uid )
        if targetElement then 
            local new_id = getFreeWallTexturesCell()
            if not new_id then
            	outputChatBox("ERR N1: Brak miejsca na teksture!") 
            	return
            end
            applyShaderToObject(pixels, targetElement, texName, tex_uid)
        end
    end
)

addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ( )
        if getElementType( source ) == "object" then
            triggerServerEvent ( "onRenderObjectTexture", getRootElement(), source, localPlayer )
        end
    end
);

-- Stary unstream
--[[ addEventHandler( "onClientElementStreamOut", getRootElement( ),
    function ( )
        if getElementType( source ) == "object" then
            local index_id = getStoredIDFromObject(source)

            -- w tym miejscu usuń shader i teksture
            if index_id then
                destroyElement(storedTextures[index_id]["texture"])
                destroyElement(storedTextures[index_id]["shader"])

                storedTextures[index_id]["texture_uid"] = nil
                storedTextures[index_id]["shader"] = nil
                storedTextures[index_id]["texture"] = nil
                storedTextures[index_id]["object"] = nil
            end
        end
    end
); ]]--

-- Nowy unstream
function unstreamingObjectLoop()
    local x, y, z = getElementPosition(localPlayer)
    for i = 1, MAX_STORED_TEXTURES do
        if storedTextures[i] then 
            if storedTextures[i]["object"] then 
                if getElementDimension(storedTextures[i]["object"]) == getElementDimension(localPlayer) then
                    -- są na tym samym VW, sprawdź odległość
                    local ox, oy, oz = getElementPosition(storedTextures[i]["object"])
                    local distance = getDistanceBetweenPoint3D(x, y, z, ox, oy, oz)

                    if distance > 300.0 then 
                        destroyElement(storedTextures[i]["texture"])
                        destroyElement(storedTextures[i]["shader"])
                        storedTextures[i]["texture_uid"] = nil
                        storedTextures[i]["shader"] = nil
                        storedTextures[i]["texture"] = nil
                        storedTextures[i]["object"] = nil
                        outputChatBox("unstream")
                    end
                else 
                    -- są na innych VW, po prostu usuń
                    destroyElement(storedTextures[i]["texture"])
                    destroyElement(storedTextures[i]["shader"])
                    storedTextures[i]["texture_uid"] = nil
                    storedTextures[i]["shader"] = nil
                    storedTextures[i]["texture"] = nil
                    storedTextures[i]["object"] = nil
                    outputChatBox("unstream")
                end
            end
        end
    end
end
setTimer ( unstreamingObjectLoop, 15000, 0)