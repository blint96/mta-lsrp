function gameTextForPlayer(thePlayer, text, time)
	triggerClientEvent (thePlayer, "gameTextForPlayer", thePlayer, text, tonumber(time) )
end