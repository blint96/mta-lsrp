SHADER_NONE 		= 		0
SHADER_WATER 		= 		2
SHADER_VISIBLE 		= 		4
SHADER_ROADSHINE		=		8
SHADER_LAKIER		=		16
SHADER_CONTRAST		=		32
SHADER_BLOOM			=		64

playerShaders = {}
local handler = call ( getResourceFromName ( "rp_mysql" ), "getDbHandler")

function hasbit(x, p)
  return x % (p + p) >= p       
end

------------------------------------------------------------
--	Dla zewnętrznych systemów
--	to odświeży shadery włączając/wyłączając poszczególne po player.shaders
------------------------------------------------------------
function changeShaderStatus(thePlayer, shader)
	local shaders = tonumber(getElementData(thePlayer, "player.shaders"))
	if hasbit(shaders, shader) then 
		-- wyłącz
		local final = shaders - tonumber(shader)
		setElementData(thePlayer, "player.shaders", tonumber(final))
		shaders = final
	else
		-- włączr
		local final = shaders + tonumber(shader)
		setElementData(thePlayer, "player.shaders", tonumber(final))
		shaders = final
	end

	refreshPlayerShaders(thePlayer)
	local query = dbQuery(handler, "UPDATE lsrp_members SET user_shaders = "..tonumber(shaders).." WHERE user_id = "..tonumber(getElementData(thePlayer, "player.gid")))
	dbFree(query)
end

------------------------------------------------------------
--	Dla zewnętrznych systemów
--	to odświeży shadery włączając/wyłączając poszczególne po player.shaders
------------------------------------------------------------
function refreshPlayerShaders(source)
	-- podliczenia, bitowanie
	local playerid = tonumber(getElementData(source, "id"))
	local shaders = tonumber(getElementData(source, "player.shaders"))
	playerShaders[playerid] = 0

	-- WODA
	if (hasbit(shaders, SHADER_WATER)) then
		playerShaders[playerid] = playerShaders[playerid] + SHADER_WATER
		exports.shader_water:toggleShader(source, true)
	else
		exports.shader_water:toggleShader(source, false)
	end

	-- VISIBLE
	if (hasbit(shaders, SHADER_VISIBLE)) then
		playerShaders[playerid] = playerShaders[playerid] + SHADER_VISIBLE
		exports.shader_visible:toggleShader(source, true)
	else
		exports.shader_visible:toggleShader(source, false)
	end

	-- Roadshine
	if (hasbit(shaders, SHADER_ROADSHINE)) then
		playerShaders[playerid] = playerShaders[playerid] + SHADER_ROADSHINE
		exports.shader_roadshine:toggleShader(source, true)
	else
		exports.shader_roadshine:toggleShader(source, false)
	end

	-- LAKIER
	if (hasbit(shaders, SHADER_LAKIER)) then
		playerShaders[playerid] = playerShaders[playerid] + SHADER_LAKIER
		exports.shader_lakier:toggleShader(source, true)
	else
		exports.shader_lakier:toggleShader(source, false)
	end

	-- CONTRAST
	if (hasbit(shaders, SHADER_CONTRAST)) then
		playerShaders[playerid] = playerShaders[playerid] + SHADER_CONTRAST
		exports.shader_contrast:toggleShader(source, true)
	else
		exports.shader_contrast:toggleShader(source, false)
	end
end

addEventHandler("onPlayerLoginSQL", getRootElement(),
	function()
		-- podliczenia, bitowanie
		local playerid = tonumber(getElementData(source, "id"))
		local shaders = tonumber(getElementData(source, "player.shaders"))
		playerShaders[playerid] = 0

		-- WODA
		if (hasbit(shaders, SHADER_WATER)) then
			playerShaders[playerid] = playerShaders[playerid] + SHADER_WATER
			exports.shader_water:toggleShader(source, true)
		else
			exports.shader_water:toggleShader(source, false)
		end

		-- VISIBLE
		if (hasbit(shaders, SHADER_VISIBLE)) then
			playerShaders[playerid] = playerShaders[playerid] + SHADER_VISIBLE
			exports.shader_visible:toggleShader(source, true)
		else
			exports.shader_visible:toggleShader(source, false)
		end

		-- Roadshine
		if (hasbit(shaders, SHADER_ROADSHINE)) then
			playerShaders[playerid] = playerShaders[playerid] + SHADER_ROADSHINE
			exports.shader_roadshine:toggleShader(source, true)
		else
			exports.shader_roadshine:toggleShader(source, false)
		end

		-- LAKIER
		if (hasbit(shaders, SHADER_LAKIER)) then
			playerShaders[playerid] = playerShaders[playerid] + SHADER_LAKIER
			exports.shader_lakier:toggleShader(source, true)
		else
			exports.shader_lakier:toggleShader(source, false)
		end

		-- CONTRAST
		if (hasbit(shaders, SHADER_CONTRAST)) then
			playerShaders[playerid] = playerShaders[playerid] + SHADER_CONTRAST
			exports.shader_contrast:toggleShader(source, true)
		else
			exports.shader_contrast:toggleShader(source, false)
		end

		-- BLOOM
	end
)