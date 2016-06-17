function showPopup(thePlayer, message, interval)
	triggerClientEvent ( thePlayer, "showPopup", thePlayer, message, interval )
end

function showDoorInfo(thePlayer, message, interval, icon, door)
	triggerClientEvent ( thePlayer, "showDoorInfo", thePlayer, message, interval, icon, door )
end