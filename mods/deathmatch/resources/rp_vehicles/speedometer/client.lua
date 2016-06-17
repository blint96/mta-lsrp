g_root = getRootElement()
g_rootElement = getResourceRootElement( getThisResource() )
g_Player = getLocalPlayer()

c_EnableScaling = true
-- --> These values will be scaled with screen size
-- Offsets from the lower right screen corner
c_XOffset = 10
c_YOffset = 10
c_ImageW = 200
c_ImageH = 200
c_BarW = 0
c_BarH = 0
c_BarYOffset = 70
-- <--

-- All other values are fixed
c_FireTimeMs = 5000
c_BarAlpha = 120
c_BarFlashInterval = 300

g_tFireStart = nil

function drawNeedle()
    if not isPedInVehicle(g_Player) then
        -- Fallback for player exiting car without onClientVehicleStartExit event
        --   (e.g. falling off a bike)
        hideSpeedometer()
    end
    local vehSpeed = getVehicleSpeed()
    --local vehHealth = getElementHealth(source,getPedOccupiedVehicle(g_Player))

    if vehHealth and (vehHealth > 0) then
        -- Show a little red/green health bar on the speedo
        local hp = (vehHealth-250)/750
        local curBarLen = hp*g_BarW
        if curBarLen < 1 then curBarLen = 1 end

        -- green/yellow till 50%, then yellow/red
        local r = 255*(1 - hp)/0.5
        if r > 255 then r = 255 end
        local g = 255*hp/0.5
        if g > 255 then g = 255 end
        if g < 0 then g = 0 end
       
        if hp >= 0 then
            g_tFireStart = nil
            dxDrawRectangle(x + g_ImageW/2 - g_BarW/2, y + g_BarYOffset, curBarLen, g_BarH, tocolor(r, g, 0, c_BarAlpha))
        else
            -- Flash red bar for 5s when car is about to blow
            if not g_tFireStart then g_tFireStart = getTickCount() end
            local firePerc = (c_FireTimeMs - (getTickCount() - g_tFireStart)) / c_FireTimeMs
            if firePerc < 0 then firePerc = 0 end
            local a = c_BarAlpha
            if (getTickCount()/c_BarFlashInterval)%2 > 1 then a = 0 end
            dxDrawRectangle(x + g_ImageW/2 - g_BarW/2, y + g_BarYOffset, firePerc*g_BarW, g_BarH, tocolor(255, 0, 0, a))
        end    
    end
    -- Draw rotated needle image
    -- Image is scaled exactly 1° per kmh of speed, so we can use vehSpeed directly
    dxDrawImage(x, y, g_ImageW, g_ImageH, "speedometer/needle.png", vehSpeed, 0, 0, white, true)

    -- Dodaj paliwo i jego wskaźnik (paliwo wskaznik maks 74 wartosc)
    g_screenWidth, g_screenHeight = guiGetScreenSize()
    local scale = (g_screenWidth/1000 + g_screenHeight/850)/2

    dxDrawRectangle ( x+(round(63 * scale)), y+(round(165 * scale)), round(77 * scale), round(17 * scale), tocolor(255, 255, 255, a)) -- tlo_1
    dxDrawRectangle ( x+(round(64 * scale)), y+(round(166 * scale)), round(75 * scale), round(15 * scale), tocolor(0, 51, 102, a)) -- tlo_2
    dxDrawRectangle ( x+(round(64 * scale)), y+(round(166 * scale)), round(setFuelLevel() * scale), round(15 * scale), tocolor(102, 153, 204, a)) -- paliwo_wskaznik
end

-- funkcja do paliwa
function setFuelLevel()
    local vehicle = getPedOccupiedVehicle(getLocalPlayer())
    local max_gas = GetVehicleMaxFuel(getElementModel(vehicle)) -- tymczasowo
    local current_gas = getElementData(getPedOccupiedVehicle(getLocalPlayer()), "vehicle.fuel")

    local percent = (current_gas * 100) / max_gas
    local bar_value = (75 * tonumber(percent)) / 100
    return bar_value
end

function showSpeedometer()
    guiSetVisible(disc, true)
    addEventHandler("onClientRender", g_root, drawNeedle)
end
function hideSpeedometer()
    guiSetVisible( disc, false)
	removeEventHandler("onClientRender", g_root, drawNeedle)
end

function getVehicleSpeed()
    if isPedInVehicle(g_Player) then
        local vx, vy, vz = getElementVelocity(getPedOccupiedVehicle(g_Player))
        return math.sqrt(vx^2 + vy^2 + vz^2) * 161
    end
    return 0
end


addEventHandler("onClientVehicleEnter", g_root,
	function(thePlayer)
		if thePlayer == g_Player then
            local model = getElementModel(source)
            if model == 509 or model == 481 or model == 510 then
                -- nic, bo to rowery
            else
                showSpeedometer()
            end
		end
	end
)

addEventHandler("onClientVehicleStartExit", g_root,
	function(thePlayer)
		if thePlayer == g_Player then
			hideSpeedometer()
		end
	end
)

function round(num)
    return math.floor(num + 0.3)
end

function initGui()
    if disc then
        destroyElement(disc)
    end
    g_screenWidth, g_screenHeight = guiGetScreenSize()
    local scale
    if c_EnableScaling then
        scale = (g_screenWidth/1000 + g_screenHeight/850)/2
    else
        scale = 1
    end
    g_XOffset = round(c_XOffset*scale)
    g_YOffset = round(c_YOffset*scale)
    g_ImageW = round(c_ImageW*scale)
    g_ImageH = round(c_ImageH*scale)
    g_BarW = round(c_BarW*scale)
    g_BarH = round(c_BarH*scale)
    g_BarYOffset = round(c_BarYOffset*scale)
    disc = guiCreateStaticImage(g_screenWidth - g_ImageW - g_XOffset, g_screenHeight - g_ImageH - g_YOffset, g_ImageW, g_ImageH, "speedometer/disc.png", false)
    x, y = guiGetPosition(disc, false)

    guiSetAlpha(disc, 0.60)
end

addEventHandler("onClientResourceStart", g_rootElement,
	function ()
        initGui()
        guiSetVisible(disc, false)
        setTimer(function()
            local w, h = guiGetScreenSize()
            if (w ~= g_screenWidth) or (h ~= g_screenHeight) then
                initGui()
            end
        end, 500, 0)
		if isPedInVehicle(g_Player) then
			showSpeedometer()
		end
	end
)

-- paliwko dodać można
