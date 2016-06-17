local spawnX, spawnY, spawnZ = 1959.55, -1714.46, 10

function onPlayerDeath ( ammo, attacker, weapon, bodypart )
	local d_posx, d_posy, d_posz = getElementPosition(source)
	local world = getElementDimension(source)
	exports.rp_items:savePlayerWeaponsWhenUsed(source) -- odużyj bronie jak miał użyte
	setElementData(source, "player.bw", 5 * 60)

	-- inaczej troche
	-- toggleAllControls ( source, false ) 
	toggleControl(source, "forwards", false)
	toggleControl(source, "backwards", false)
	toggleControl(source, "left", false)
	toggleControl(source, "right", false)
	toggleControl(source, "jump", false)
	toggleControl(source, "walk", false)

	setTimer( function(source) respawnPlayer(source) setElementPosition(source, d_posx, d_posy, d_posz) setElementDimension(source, world) setPedAnimation ( source, "CRACK", "crckdeth2", 1, false, true) end, 2000, 1, source, spawnX, spawnY, spawnZ )

	-- usuwanie przyczepialnych broni
	for k, object in ipairs ( getElementsByType("object") ) do
		if tonumber(getElementData(object, "object.stickto")) == tonumber(getElementData(source, "player.uid")) then
			destroyElement(object)
		end
	end
end
addEventHandler ( "onPlayerWasted", getRootElement(), onPlayerDeath )