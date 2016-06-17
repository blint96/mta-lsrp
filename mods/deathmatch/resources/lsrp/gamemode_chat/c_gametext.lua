-- test
local text_dx = nil

function gameTextFunction()
    local is_visible = getElementData(getLocalPlayer(), "player.gtx")
    if is_visible == false then return end

    local screenx, screeny = guiGetScreenSize()
    dxDrawText(text_dx ,screenx/2-248,screeny/2-148,screenx/2+250,screeny/2+150,tocolor(0,0,0),2.05,"pricedown","center","center",false,true,false) -- make text
    dxDrawText(text_dx ,screenx/2-248,screeny/2-148,screenx/2+248,screeny/2+148,tocolor(255,255,255),2.0,"pricedown","center","center",false,true,false) -- make text
end
addEventHandler("onClientRender", getRootElement(), gameTextFunction) 

function gameTextForPlayer(text, seconds)
	local timer_time = tonumber(seconds) * 1000 -- przystosowanie pod timer
	setTimer(hideGameTextForPlayer, timer_time, 1)
	setElementData(getLocalPlayer(), "player.gtx", true)
	text_dx = text
end
addEvent( "gameTextForPlayer", true )
addEventHandler( "gameTextForPlayer", localPlayer, gameTextForPlayer )

function hideGameTextForPlayer()
    setElementData(getLocalPlayer(), "player.gtx", false)
end