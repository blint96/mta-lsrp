function imitationMe(thePlayer, text)
	local message = "#C2A2DA* " .. playerRealName(thePlayer) .. " " .. text
	local posX, posY, posZ = getElementPosition( thePlayer )
	local chatSphere = createColSphere( posX, posY, posZ, 10 )
	local nearbyPlayers = getElementsWithinColShape( chatSphere, "player" )

	for index, nearbyPlayer in ipairs( nearbyPlayers ) do
        outputChatBox( message, nearbyPlayer, 255, 255, 255, true)
    end

    destroyElement(chatSphere) -- optymalizacja
end

function imitationChat(thePlayer, text, tool)
	local output = nil
	if not tool then
		output = playerRealName(thePlayer) .. " mówi: " .. text
	else 
		output = playerRealName(thePlayer) .. " mówi (".. tool .."): " .. text
	end

	local posX, posY, posZ = getElementPosition( thePlayer )
	local chatSphere = createColSphere( posX, posY, posZ, 10 )
	local nearbyPlayers = getElementsWithinColShape( chatSphere, "player" )

	for index, nearbyPlayer in ipairs(nearbyPlayers) do
		if getElementDimension(thePlayer) == getElementDimension(nearbyPlayer) then
			local ox, oy, oz = getElementPosition(nearbyPlayer)
			local distance = getDistanceBetweenPoints2D(posX, posY, ox, oy)
			if distance < 2 then
				outputChatBox( "#FFFFFF"..output, nearbyPlayer, 255, 255, 255, true)
			elseif distance < 4 then
				outputChatBox( "#EEEEEE"..output, nearbyPlayer, 255, 255, 255, true)
			elseif distance < 6 then
				outputChatBox( "#DDDDDD"..output, nearbyPlayer, 255, 255, 255, true)
			elseif distance < 8 then
				outputChatBox( "#CCCCCC"..output, nearbyPlayer, 255, 255, 255, true)
			else
				outputChatBox( "#BBBBBB"..output, nearbyPlayer, 255, 255, 255, true)
			end
		end
	end

	destroyElement(chatSphere) -- optymalizacja
	return true
end