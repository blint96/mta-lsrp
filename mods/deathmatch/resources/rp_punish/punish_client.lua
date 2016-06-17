local is_show = false
local the_admin = "Administrator"
local the_owner = "Gracz"
local the_reason = "Nadmierne odwalanie"
local the_punish = "Kara"

addEventHandler("onClientRender",getRootElement(),
function()
	-- Jakiś warunek wyświetlania
	if is_show then
	    local screen_x, screen_y = guiGetScreenSize()
	    dxDrawRectangle(0.70 * screen_x, 0.70 * screen_y, 0.25 * screen_x, 0.20 * screen_y, tocolor(0, 0, 0, 150))
	    dxDrawRectangle(0.70 * screen_x, 0.70 * screen_y, 0.25 * screen_x, 0.06 * screen_y, tocolor(51, 153, 204, 200))
	    --dxDrawLine(0.70 * screen_x, 0.70 * screen_y, 0.95 * screen_x, 0.70 * screen_y, tocolor(0, 0, 0, 200), 2)
	    --dxDrawLine(0.70 * screen_x, 0.90 * screen_y, 0.95 * screen_x, 0.90 * screen_y, tocolor(0, 0, 0, 200), 2)
	    local font = dxCreateFont(":lsrp/gamemode_replacements/fonts/roboto.ttf", 18)
	    -- Typ kary
	    dxDrawText(the_punish, 0.71 * screen_x, 0.71 * screen_y, 0.95 * screen_x, 0.70 * screen_y, tocolor(0, 0, 0), 1.0, font)
	    -- Kto
	    dxDrawLine(0.70 * screen_x, 0.758 * screen_y, 0.95 * screen_x, 0.758 * screen_y, tocolor( 51, 153, 255, 200), 1) -- oddzielenie
	    font = dxCreateFont(":lsrp/gamemode_replacements/fonts/roboto.ttf", 12)
	    dxDrawText("#FFFFFFAdmin: #CCCCFF"..the_admin, 0.71 * screen_x, 0.7625 * screen_y, 0.95 * screen_x, 0.70 * screen_y, tocolor(255, 255, 255), 1.0, font, "left", "top", false, false, false, true) --admin
	    -- Komu
	    dxDrawText("#FFFFFFGracz: #CCCCFF"..the_owner, 0.71 * screen_x, 0.7815 * screen_y, 0.95 * screen_x, 0.70 * screen_y, tocolor(255, 255, 255), 1.0, font, "left", "top", false, false, false, true) -- gracz
	    -- Powód
		dxDrawText(the_reason, 0.71 * screen_x, 0.81 * screen_y, 0.95 * screen_x, 0.70 * screen_y, tocolor(150, 150, 150), 1.0, font, "left", "top", false, true)
	end
end)

function showPunishForPlayer(theAdmin, theOwner, theReason, thePunish) the_admin = theAdmin the_owner = theOwner the_reason = theReason the_punish = thePunish is_show = true end addEvent("showPunishForPlayer", true) addEventHandler("showPunishForPlayer", localPlayer, showPunishForPlayer)
function hidePunishForPlayer() is_show = false end addEvent("hidePunishForPlayer", true) addEventHandler("hidePunishForPlayer", localPlayer, hidePunishForPlayer)

