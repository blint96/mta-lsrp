function syncPedLookAt(ped, tx, ty, tz)
	local who = source
	local to_who = getElementsByType("player")

	-- potem trzeba dodać sphere i tylko tym co są w pobliżu updateować te główki
	triggerLatentClientEvent ( to_who, "syncPedLookAtClient", 50000, false, ped, ped, tx, ty, tz )
end

addEvent ( "setPedLookAtGlobal", true )
addEventHandler ( "setPedLookAtGlobal", getRootElement(), syncPedLookAt )