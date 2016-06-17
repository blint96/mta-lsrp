function handleMinimize()
    setElementData(localPlayer, "player.afk", 1)
end
addEventHandler( "onClientMinimize", root, handleMinimize )

function handleRestore()
	setElementData(localPlayer, "player.afk", 0)
end
addEventHandler("onClientRestore",root,handleRestore)