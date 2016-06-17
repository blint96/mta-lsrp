local sx, sy = guiGetScreenSize()
function updateLookAt()
    local tx, ty, tz = getWorldFromScreenPosition(sx / 2, sy / 2, 10)
    setPedLookAt(getLocalPlayer(), tx, ty, tz)

    triggerLatentServerEvent ( "setPedLookAtGlobal", 5000, false, getLocalPlayer(), getLocalPlayer(), tx, ty, tz )
end
addEventHandler("onClientPreRender", getRootElement(), updateLookAt)

-- sync
function syncPedLookAtClient(ped, tx, ty, tz)
	-- source
	if ped ~= getLocalPlayer() then
		setPedLookAt(ped, tx, ty, tz)
	end
end
addEvent("syncPedLookAtClient", true)
addEventHandler ( "syncPedLookAtClient", getRootElement(), syncPedLookAtClient )
