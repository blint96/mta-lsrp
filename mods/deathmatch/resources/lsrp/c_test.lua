-- Ciekawa f-cja
function AbsoluteToRelative( gX, gY )
    local rX, rY = guiGetScreenSize()
    local fx = gX/rX
    local fy = gY/rY
    return fx, fy
end

-- X: 1941.201171875, Y: -1709.62109375, Z: 13.3828125
local x = 1941.00
local y = -1709.00
local z = 13.40

function playerRealName(player)
	player_name = getElementData(player, "player.displayname")
	player_name = player_name:gsub("_", " ")

	return player_name
end

function getDustFont(size)
    local font = dxCreateFont("gamemode_replacements/fonts/DustHome.ttf", tonumber(size))
    return font
end

function getRobotoFont(size)
    local font = dxCreateFont("gamemode_replacements/fonts/roboto.ttf", tonumber(size))
    return font
end

--[[
    Stacje benz pobrane metodą na dziada
    X: 1941.6240234375, Y: -1769.416015625, Z: 13.640625
X: 1941.6494140625, Y: -1776.30859375, Z: 13.640625
]]--
gasStation = {}
gasStation[0] = {"Stacja Idlewood", 1941.62, -1776.3, 13, 3}
gasStation[1] = {"Stacja Idlewood", 1941.62, -1769.41, 13, 3}

local big_font = dxCreateFont("gamemode_replacements/fonts/DustHome.ttf", 28)
local gas_font = dxCreateFont("gamemode_replacements/fonts/DustHome.ttf", 12)
addEventHandler("onClientRender",getRootElement(),
function()
    local px,py,pz = getElementPosition(getLocalPlayer())
    local distance = getDistanceBetweenPoints3D ( x, y, z,px,py,pz )

    -- 3D dla stacji
    for i = 0, table.getn(gasStation) do
        local s_distance = getDistanceBetweenPoints2D(px, py, gasStation[i][2], gasStation[i][3])
        if s_distance < 5 then
            local s_sx, s_sy = getScreenFromWorldPosition ( gasStation[i][2], gasStation[i][3], gasStation[i][4], 0.06 )
            if not s_sy then return end

            dxDrawText ( "#FFFFFFStacja benzynowa #660000($3/litr)\n#FFFFFF/tankuj", s_sx, s_sy - 30, s_sx, s_sy - 30, tocolor(100,255,100,255), 1, gas_font, "center", "bottom", false, false, false, true )
        end
    end
    -- koniec stacji

    -- Info o wersji MTA
    local x,y = guiGetScreenSize()
    dxDrawText(SERVER_VERSION, x - 150, 10)
    -- Koniec info

    if (getElementData(localPlayer, "player.logged") == true) then
        --[[ HUD INIT ]] --
        -- [[ POTEM SPRAWDŹ CZY ZALOGOWANY ETC !!!! ]] --
        local base_x, base_y = 1366, 768
        -- BG pierw
        dxDrawImage ( tonumber((965/base_x) * x), tonumber((60/base_y) * y), (400/base_x) * x, (150/base_y) * y, 'gamemode_dialogs/new_gui.png' )

        -- Broń na hudzie
        local weapon = getPedWeapon ( localPlayer )
        dxDrawImage ( tonumber((1030/base_x) * x), tonumber((105/base_y) * y), (128/base_x) * x, (64/base_y) * y, 'gamemode_dialogs/img/'.. weapon ..'.png' )

        -- KAsa na HUDZIE
        dxDrawBorderedText("$"..string.format("%010d", tonumber(getElementData(localPlayer, "player.cash"))), tonumber((1160/base_x) * x), tonumber((145/base_y) * y), tonumber((1340/base_x) * x), tonumber((100/base_y) * y), tocolor(73,208,141,200), 1.4, "pricedown", "right", "center", false, false, false)

        -- HP na HUDZIE
        local max_hp = tonumber((247/base_x) * x)
        local current_hp = (max_hp * tonumber(getElementHealth(localPlayer))) / 100
        dxDrawRectangle ( tonumber((1090/base_x) * x), tonumber((146/base_y) * y), current_hp, tonumber((23/base_y) * y), tocolor(102, 0, 0, 125) )
        -- [[ /HUD EXIT ]] --
    end

    if tonumber(getElementData(localPlayer, "player.bw")) > 0 then
        dxDrawRectangle(0, 0, x, y, tocolor(50, 0, 0, 185))
    end

    local px,py,pz = getElementPosition(getLocalPlayer())
    local distance = getDistanceBetweenPoints3D ( x, y, z,px,py,pz )

    local sx, sy = getScreenFromWorldPosition ( x, y, z+0.95, 0.06 )
    if not sy then return end

    if distance < 30.0 then
        local is_coll = processLineOfSight(px, py, pz, x, y ,z, false)
        if is_coll == false then
    	   dxDrawText ( "Los Santos Role Play \n3D text test", sx, sy - 30, sx, sy - 30, tocolor(255,100,100,255), math.min ( 0.1*(150/distance)*1.2,4), "bankgothic", "center", "bottom", false, false, false )
        end
    end
end
)

function DescWrap(string)
    local spaceCounter = 0
    local tempStore = {}
    for i = 1, string.len(string) do 
        local char = string:sub(i, i)
        tempStore[i] = char

        if char == " " and string:sub(i + 1, i + 1) ~= " " then 
            spaceCounter = spaceCounter + 1
        end

        if spaceCounter >= 5 then 
            tempStore[i] = "\n"
            spaceCounter = 0
        end
    end

    -- tempStore do stringa i returnuj
    local final = table.concat(tempStore)
    return final
end

-- Nicki nad głowami graczy NIE RETURN END TYLKO COŚ INNEGO, PAMIĘTAJ!
addEventHandler( "onClientRender", getRootElement(),
    function( )
    	local px, py, pz = getElementPosition(getLocalPlayer())
    	local id = 0
       	for _, plr in ipairs( getElementsByType( "player" ) ) do

       		--if plr ~= getLocalPlayer() then
            local showtags = getElementData(localPlayer, "player.showtags")
            if plr ~= nil then

	            local x, y, z = getPedBonePosition( plr, 8 ); -- head

                -- sprawdzamy czy w ogóle może to zobaczyć (tutaj potem dodać wyjątek dla aut, niepotrzebne)
                local is_coll = processLineOfSight(px, py, pz, x, y, z, true, false, false, true, false, false)
                if is_coll == false then
    	            id = id + 1
    	            -- sprawdź odległość
    	            local distance = getDistanceBetweenPoints3D ( px, py, pz, x, y, z )
    	            if distance < 15.0 then
        	            local sX, sY = getScreenFromWorldPosition( x, y, z+0.35 );
        	            if sX then
                            local flags = nil;
                            if getElementData(plr, "player.afk") == 1 then
                                flags = "AFK"
                            end

                            if tonumber(getElementData(plr, "player.bw")) > 0 then
                                if flags ~= nil then
                                    flags = flags..", nieprzytomny"
                                else
                                    flags = "nieprzytomny"
                                end
                            end

                            -- Dodajemy opisy, potem wyłączanie dodać ładnie
                            if getElementAlpha(plr) > 0 then
                                if getElementData(plr, "player.describe") ~= nil then 
                                    local spinex, spiney, spinez = getPedBonePosition(plr, 3)
                                    local oX, oY = getScreenFromWorldPosition( spinex, spiney, spinez );
                                    if plr ~= localPlayer then 
                                        dxDrawText( DescWrap(getElementData(plr, "player.describe")), oX, oY, oX, oY, tocolor(204,153,255,200), 1.0, "default-bold", "center", "bottom", false, true, false, true )
                                    end
                                end
                            end

                            -- Potem trzeba sprawdzenie zrobić, czy ma duty admina, PD etc.
                            if showtags > 0 then
                                if getElementAlpha(plr) > 0 then
                                    if flags ~= nil then
                                        if (tonumber(getElementData(plr, "player.admin")) ~= 0) then
                                            dxDrawText( rank_col[tonumber(getElementData(plr, "player.color"))] .. playerRealName(plr) .." #CCCCCC("..getElementData(plr, "id")..")\n("..flags..")", sX, sY, sX, sY, tocolor(5,150,200,255), 1.0, "default-bold", "center", "bottom", false, false, false, true )
                                        else 
                                            dxDrawText("#CCCCCC".. playerRealName(plr) .." #CCCCCC("..getElementData(plr, "id")..")\n("..flags..")", sX, sY, sX, sY, tocolor(5,150,200,255), 1.0, "default-bold", "center", "bottom", false, false, false, true )
                                        end
                                    else 
                                        if (tonumber(getElementData(plr, "player.admin")) ~= 0) then
                                            dxDrawText(rank_col[tonumber(getElementData(plr, "player.color"))] .. playerRealName(plr) .." #CCCCCC("..getElementData(plr, "id")..")", sX, sY, sX, sY, tocolor(5,150,200,255), 1.0, "default-bold", "center", "bottom", false, false, false, true )
                                        else 
                                            dxDrawText("#CCCCCC".. playerRealName(plr) .." #CCCCCC("..getElementData(plr, "id")..")", sX, sY, sX, sY, tocolor(5,150,200,255), 1.0, "default-bold", "center", "bottom", false, false, false, true )
                                        end
                                    end
                                end
                            else
                                if plr == localPlayer then
                                    -- nie pokazuj włąsnej
                                else
                                    if flags ~= nil then
                                        if (tonumber(getElementData(plr, "player.admin")) ~= 0) then
                                            dxDrawText( rank_col[tonumber(getElementData(plr, "player.color"))] .. playerRealName(plr) .." #CCCCCC("..getElementData(plr, "id")..")\n("..flags..")", sX, sY, sX, sY, tocolor(5,150,200,255), 1.0, "default-bold", "center", "bottom", false, false, false, true )
                                        else 
                                            dxDrawText("#CCCCCC".. playerRealName(plr) .." #CCCCCC("..getElementData(plr, "id")..")\n("..flags..")", sX, sY, sX, sY, tocolor(5,150,200,255), 1.0, "default-bold", "center", "bottom", false, false, false, true )
                                        end
                                    else 
                                        if (tonumber(getElementData(plr, "player.admin")) ~= 0) then
                                            dxDrawText(rank_col[tonumber(getElementData(plr, "player.color"))] .. playerRealName(plr) .." #CCCCCC("..getElementData(plr, "id")..")", sX, sY, sX, sY, tocolor(5,150,200,255), 1.0, "default-bold", "center", "bottom", false, false, false, true )
                                        else 
                                            dxDrawText("#CCCCCC".. playerRealName(plr) .." #CCCCCC("..getElementData(plr, "id")..")", sX, sY, sX, sY, tocolor(5,150,200,255), 1.0, "default-bold", "center", "bottom", false, false, false, true )
                                        end
                                    end
                                end
                            end
        	            end
                    end
                end
        	end
        end
    end
)

-- IDy pojazdów ETC
addEventHandler( "onClientRender", getRootElement(),
    function( )
        local dl = tonumber(getElementData(getLocalPlayer(), "player.dl"))
        if dl == 0 then return end

        local px, py, pz = getElementPosition(getLocalPlayer())
        local id = 0
        for _, veh in ipairs( getElementsByType( "vehicle" ) ) do

            if veh ~= nil then

                local x, y, z = getElementPosition( veh ); -- pozycja wozu

                -- sprawdzamy czy w ogóle może to zobaczyć (tutaj potem dodać wyjątek dla aut, niepotrzebne)
                local is_coll = processLineOfSight(px, py, pz, x, y, z, false, false, false, false, false, false)
                if is_coll == false then
                    id = id + 1
                    -- sprawdź odległość
                    local distance = getDistanceBetweenPoints3D ( px, py, pz, x, y, z )
                    if distance < 15.0 then
                        local sX, sY = getScreenFromWorldPosition( x, y, z+0.35 );
                        if sX then
                            if getElementDimension(veh) == getElementDimension(getLocalPlayer()) then
                                dxDrawText("[id: "..getElementData(veh, "id")..", model: "..getElementModel(veh)..", hp: "..math.floor(tonumber(getElementHealth(veh))).."]\n".."pos: "..math.floor(x)..", "..math.floor(y)..", "..math.floor(z), sX, sY, sX, sY, tocolor(0,102,204,255), 1.0, "default-bold", "center", "bottom", false, false, false, true )
                            end
                        end
                    end
                end
            end
        end
    end
)

function dxDrawBorderedText( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
    dxDrawText ( text, x - 1, y - 1, w - 1, h - 1, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x + 1, y - 1, w + 1, h - 1, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x - 1, y + 1, w - 1, h + 1, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x + 1, y + 1, w + 1, h + 1, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x - 1, y, w - 1, h, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x + 1, y, w + 1, h, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x, y - 1, w, h - 1, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x, y + 1, w, h + 1, tocolor ( 0, 0, 0, 155 ), scale, font, alignX, alignY, clip, wordBreak, false )
    dxDrawText ( text, x, y, w, h, color, scale, font, alignX, alignY, clip, wordBreak, postGUI )
end