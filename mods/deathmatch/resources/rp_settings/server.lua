local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")
-- test
-- test2
-- test3
--test 4

function sendPlayerChangeShaderRequest(thePlayer, theShader)
	exports.rp_shaders:changeShaderStatus(thePlayer, theShader)
end
addEvent("onPlayerChangeShaderStatus", true)
addEventHandler("onPlayerChangeShaderStatus", getRootElement(), sendPlayerChangeShaderRequest)

function onPlayerChangeOwnNickVisibility(thePlayer)
	-- QUERY potem dodać
	local showtags = tonumber(getElementData(thePlayer, "player.showtags"))
	if showtags > 0 then 
		setElementData(thePlayer, "player.showtags", 0)
	else
		setElementData(thePlayer, "player.showtags", 1)
	end

	local query = dbQuery(handler, "UPDATE lsrp_members SET user_showtags = '".. tonumber(getElementData(thePlayer, "player.showtags")) .. "' WHERE user_id = '".. tonumber(getElementData(thePlayer, "player.gid")) .."'")
	dbFree(query)
end
addEvent("onPlayerChangeOwnNickVisibility", true)
addEventHandler("onPlayerChangeOwnNickVisibility", getRootElement(), onPlayerChangeOwnNickVisibility)