-- Tutaj będzie trzeba tablice na pojazdy dodać
-- I w momencie jak stop sync to funkcja na usuwanie shadera z tablicy (OPTYMALIZACJA)
vehicleShaders = {}
for i = 1, 2500 do 
    vehicleShaders[i] = {}
    vehicleShaders[i]["vehicle_texture"] = nil;
    vehicleShaders[i]["vehicle_shader"] = nil;
end

addEvent( "onClientDownloadTexture", true )
addEventHandler( "onClientDownloadTexture", localPlayer,
    function( pixels, targetElement )
        if targetElement then 
            local vehicleid = tonumber(getElementData(targetElement, "id"))
            if isElement(vehicleShaders[vehicleid]["vehicle_texture"]) then
                destroyElement( vehicleShaders[vehicleid]["vehicle_texture"] )
            end

            vehicleShaders[vehicleid]["vehicle_shader"] = exports.score_wisb:createReplaceShader()
            vehicleShaders[vehicleid]["vehicle_texture"] = dxCreateTexture( pixels, "dxt5" )

            dxSetShaderValue( vehicleShaders[vehicleid]["vehicle_shader"], "Tex0", vehicleShaders[vehicleid]["vehicle_texture"] )
            engineApplyShaderToWorldTexture ( vehicleShaders[vehicleid]["vehicle_shader"], "remapelegybody128", targetElement )
            engineApplyShaderToWorldTexture ( vehicleShaders[vehicleid]["vehicle_shader"], "vehiclegrunge256", targetElement )
            engineApplyShaderToWorldTexture ( vehicleShaders[vehicleid]["vehicle_shader"], "?emap*", targetElement )
            engineApplyShaderToWorldTexture ( vehicleShaders[vehicleid]["vehicle_shader"], "@hite", targetElement )
            engineApplyShaderToWorldTexture ( vehicleShaders[vehicleid]["vehicle_shader"], "kurumabody64", targetElement )
        end
    end
)

addEvent( "onClientStopSyncing", true )
addEventHandler( "onClientStopSyncing", localPlayer,
    function( targetElement )
        if targetElement then 
            local vehicleid = tonumber(getElementData(targetElement, "id"))
            if isElement(vehicleShaders[vehicleid]["vehicle_texture"]) then 
                destroyElement(vehicleShaders[vehicleid]["vehicle_texture"])
            end

            if isElement(vehicleShaders[vehicleid]["vehicle_shader"]) then
                destroyElement(vehicleShaders[vehicleid]["vehicle_shader"])
            end
        end
    end
)

addEvent( "onClientStopSyncingDestroy", true )
addEventHandler( "onClientStopSyncingDestroy", localPlayer,
    function( targetElement, vehicleid )
        if targetElement then 
            if isElement(vehicleShaders[vehicleid]["vehicle_texture"]) then 
                destroyElement(vehicleShaders[vehicleid]["vehicle_texture"])
            end

            if isElement(vehicleShaders[vehicleid]["vehicle_shader"]) then
                destroyElement(vehicleShaders[vehicleid]["vehicle_shader"])
            end
        end
    end
)
 

addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ( )
        if getElementType( source ) == "vehicle" then
            triggerServerEvent ( "onRenderVehicleTexture", getRootElement(), source, localPlayer )
        end
    end
);