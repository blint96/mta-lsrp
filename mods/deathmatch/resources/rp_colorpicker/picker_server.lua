function openPicker(thePlayer, id, start, title)
	triggerClientEvent("openPicker", thePlayer, id, start ,title)
end

function pickerUpdateColor(id, hex, r, g, b)
	-- client to ten co wykonuje
	triggerEvent ( "onPickerColorUpdate", client, id, hex, r, g, b )
end
addEvent("pickerUpdateColor",true)
addEventHandler("pickerUpdateColor", root, pickerUpdateColor)

function pickerClose(id, hex, r, g, b)
	triggerEvent ( "onPickerColorClose", client, id, hex, r, g, b )
end
addEvent("pickerClose",true)
addEventHandler("pickerClose", root, pickerClose)