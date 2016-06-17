-- Trochę zmiennych
local screenX, screenY = guiGetScreenSize()
local components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted", "radar" }

local isShow = false
local boundUpY = screenY / 7
local boundDownY = screenY - screenY / 1.2

local currentUp = 0
local currentDown = 0

local bots = { }

-- Te belki takie od filmików
addEventHandler("onClientRender", root, 
	function() 

		-- LABELKI BOTÓW
		local px, py, pz = getElementPosition(getLocalPlayer())
		local id = 0
		for _, bot in ipairs(bots) do 
			if bot ~= nil then 
				local x, y, z = getPedBonePosition( bot, 8 );
				local is_coll = processLineOfSight(px, py, pz, x, y, z, true, false, false, true, false, false)

				if not is_coll then 
					id = id + 1
					local distance = getDistanceBetweenPoints3D ( px, py, pz, x, y, z )
					if distance < 15.0 then
						local sX, sY = getScreenFromWorldPosition( x, y, z+0.35 );
						if sX then
							dxDrawText("#CCCCCC [BOT] ("..id..")", sX, sY, sX, sY, tocolor(5,150,200,255), 1.0, "default-bold", "center", "bottom", false, false, false, true )
						end
					end
				end
			end
		end

		if isShow then
			if currentUp < boundUpY then 
				currentUp = currentUp + 4
			end

			if currentDown > tonumber((-1) * boundDownY) then 
				currentDown = currentDown - 4
			end

			dxDrawRectangle ( 0, 0, screenX, currentUp, tocolor(0, 0, 0) )
			dxDrawRectangle ( 0, screenY, screenX, currentDown, tocolor(0, 0, 0) )
			dxDrawText("Big Smoke: Follołuj ten pieprzony kanał!", screenX * 0.35, screenY - screenY / 8, screenX * 0.30, screenY - screenY / 8, tocolor(255, 255, 255), 2 )
		end
	end
)

-- Tylko test
function spawnujGnojka()
	local static_x, static_y, static_z = getElementPosition(localPlayer)
	local x, y, z = getElementPosition(localPlayer)
	local a, b, r = getElementRotation(localPlayer)

	x = x - math.sin ( math.rad(r) ) * 4
    y = y + math.cos ( math.rad(r) ) * 4

	if 1 == 1 then
		local dummy = createPed ( 0, x, y, z )
		setElementModel(dummy, 311)

		-- Poprawka z kamerą
		local cam = getCamera()
		detachElements( cam )
		setElementPosition( cam, 0,0,0 )
		setCameraTarget(localPlayer)

		setElementInterior(dummy, getElementInterior(localPlayer))
		setElementDimension(dummy, getElementDimension(localPlayer))
		setElementRotation(dummy, 0, 0, r + 180)
		return dummy
	end
end

-- Pokazywajka
addCommandHandler("npctest1", function() 
	isShow = not isShow 
	currentUp = 0 
	currentDown = 0 
	showChat(not isShow)

	if isShow then
		spawnujGnojka()
		local cam = getCamera()
    	setElementPosition( cam, 0,0,0 )
    	attachElements( cam, localPlayer, 0.5,-2,0.8, 0,0, 10 )
	else
		setCameraTarget(localPlayer)
	end

	for _, component in ipairs( components ) do
		setPlayerHudComponentVisible( component, not isShow )
	end

end)

--
-- INFO: George to ogólne określenie na wszystkie nieludzkie stworzenia poruszające się po Los Santos
-- INFO: Aktualna sygnatura to X, pozostałe dziewięć wersji działało na SA:MP
-- INFO: George X - podążający za graczem
--

function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function pedFollowLocalPlayer()
	-- Rotacja
	local px, py, pz = getElementPosition(localPlayer)
	local bx, by, bz = getElementPosition(bott)

	local prx, pry, prz = getElementRotation(localPlayer)

	local distance = getDistanceBetweenPoints3D ( px, py, pz, bx, by, bz )
	if distance > 2.0 and getElementHealth(bott) > 0.0 then
		setPedRotation( bott, findRotation(bx, by, px, py) );
        setPedLookAt( bott, px, py, pz + 0.5 );
		setPedControlState ( bott, "walk", true )
		setPedControlState ( bott, "forwards", true )
	else
		setPedControlState ( bott, "walk", false )
		setPedControlState ( bott, "forwards", false )
	end
end

addCommandHandler("npctest2", function()
	outputChatBox("TEST AI: śledzenie gracza.")
	local x, y, z = getElementPosition(localPlayer)
	bott = addBot(x, y, z, 311)
	setPedWalkingStyle(bott, 118)
	setPedControlState ( bott, "walk", true )
	setPedControlState ( bott, "forwards", true )
	setTimer(pedFollowLocalPlayer, 100, 0)
end)

-----------------------------------------------------------------
-- Dodawajka randomowych botów
-- Albo po prostu funckja na dodanie bota
-----------------------------------------------------------------

function addBot(x, y, z, skin)
	local new = createPed ( skin, x, y, z )
	table.insert ( bots, new )
	outputChatBox("[DEBUG] ARRAY SIZE: "..table.getn(bots))
	return new
end

function delBot(botid)
	destroyElement(bots[tonumber(id)])
	table.remove(bots, tonumber(id))
end

addCommandHandler("npcadd", function(cmd, skin) local x, y, z = getElementPosition(localPlayer) local skin = tonumber(skin) addBot(x, y, z, skin) end)
addCommandHandler("npcdel", function(cmd, id) destroyElement(bots[tonumber(id)]) table.remove(bots, tonumber(id)) end)