function getObjectListInSphere(thePlayer, theX, theY, theZ, theVW, theDistance)
	-- triggeruj do clienta
	local temp_sphere = createColSphere(theX, theY, theZ, theDistance)
	local sending = {}
	local count = 0
	for k, v in pairs(objects) do 
		if (objects[k]["vw"] == theVW) and (objects[k]["uid"] > 0) then 
			local distance = getDistanceBetweenPoints3D(theX, theY, theZ, objects[k]["posx"], objects[k]["posy"], objects[k]["posz"])
			if (distance <= 300) then 
				sending[count] = {}
				sending[count]["uid"] = objects[k]["uid"]
				sending[count]["vw"] = objects[k]["vw"]
				sending[count]["model"] = objects[k]["model"]
				sending[count]["posx"] = objects[k]["posx"]
				sending[count]["posy"] = objects[k]["posy"]
				sending[count]["posz"] = objects[k]["posz"]
				sending[count]["rotx"] = objects[k]["rotx"]
				sending[count]["roty"] = objects[k]["roty"]
				sending[count]["rotz"] = objects[k]["rotz"]
				count = count + 1
			end
		end
	end
	destroyElement(temp_sphere)

	triggerClientEvent(thePlayer, "onServerSendObjects", thePlayer, sending)
end
addEvent("onPlayerRequestObjects", true)
addEventHandler("onPlayerRequestObjects", getRootElement(), getObjectListInSphere)