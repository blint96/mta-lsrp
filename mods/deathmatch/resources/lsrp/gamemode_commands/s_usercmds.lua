-- /plac
function playerPay(thePlayer, theCmd, theTarget, theAmount)
    if not theTarget or not theAmount then 
        outputChatBox("#CCCCCCUżycie: /plac [ID Gracza] [Kwota]", thePlayer, 255, 255, 255, true)
        return
    end

    local target = exports.lsrp:getPlayerByID(tonumber(theTarget))
    if not target then
        exports.lsrp:showPopup(thePlayer, "Taki gracz nie jest podłączony do serwera.", 5 )
        return 
    end

    if target == thePlayer then
        exports.lsrp:showPopup(thePlayer, "Nie możesz podać sobie gotówki.", 5 )
        return
    end

    if (getElementData(target, "player.logged") == false) then
        exports.lsrp:showPopup(thePlayer, "Ten gracz nie zalogował się jeszcze do gry.", 5 )
        return
    end

    local ox, oy, oz = getElementPosition(thePlayer)
    local rx, ry, rz = getElementPosition(target)
    local distance = getDistanceBetweenPoints3D ( ox, oy, oz, rx, ry, rz )
    if getElementDimension(target) ~= getElementDimension(thePlayer) then
        exports.lsrp:showPopup(thePlayer, "Taki gracz jest poza Twoim zasięgiem!", 5 )
        return
    end

    if distance > 5.0 then
        exports.lsrp:showPopup(thePlayer, "Taki gracz jest poza Twoim zasięgiem!", 5 )
        return
    end

    local amount = tonumber(theAmount)
    if amount <= 0 then 
        exports.lsrp:showPopup(thePlayer, "Kwota musi być dodatnia.", 5 )
        return
    end

    local current_money = tonumber(getElementData(thePlayer, "player.cash"))
    if amount > current_money then 
        exports.lsrp:showPopup(thePlayer, "Nie posiadasz tyle pieniędzy.", 5 )
        return
    end

    local after_money = current_money - amount
    setElementData(thePlayer, "player.cash", after_money)
    setPlayerMoney(thePlayer, after_money)

    local current_money_target = tonumber(getElementData(target, "player.cash"))
    local after_money_target = current_money_target + amount
    setElementData(target, "player.cash", after_money_target)
    setPlayerMoney(target, after_money_target)

    -- Informacje o przelewie
    outputChatBox("#CCCCFF** Otrzymałeś #669966$".. amount .."#CCCCFF od ".. playerRealName(thePlayer) ..".", target, 255, 255, 255, true)
    outputChatBox("#CCCCFF** Podałeś #669966$".. amount .."#CCCCFF do ".. playerRealName(target)..".", thePlayer, 255, 255, 255, true)

    -- Animacja przelewu
    setPedAnimation ( thePlayer, "DEALER", "shop_pay", -1, false, false, true, false)

    -- Me przelewu
    exports.lsrp:imitationMe(thePlayer, "podaje trochę gotówki ".. playerRealName(target) ..".")
end
addCommandHandler("plac", playerPay)
addCommandHandler("pay", playerPay)

-- Szpital, potem jakiś delay etc.
function setPlayerIntoHospital(thePlayer, theCmd)
    local x, y, z = getElementPosition(thePlayer)
    local hospital_x, hospital_y, hospital_z = 1172, -1323, 15
    local distance = getDistanceBetweenPoints3D(x, y, z, hospital_x, hospital_y, hospital_z)
    if distance > 20.0 then
        showPopup(thePlayer, "Nie jesteś w pobliżu szpitala!", 5)
        return
    end

    -- sprawdź czy ma kasę
    if(100 > tonumber(getElementData(thePlayer, "player.cash"))) then
        showPopup(thePlayer, "Nie masz wystarczająco pieniędzy na hospitalizację!", 5)
        return
    end

    -- Zabierz kasę i podziękuj
    setElementHealth(thePlayer, 100)
    local before = getElementData(thePlayer, "player.cash")
    setPlayerMoney(thePlayer, tonumber(before) - 100)
    setElementData(thePlayer, "player.cash", tonumber(before) - 100)
    showPopup(thePlayer, "Hospitalizacja dobiegła końca!", 5)
end
addCommandHandler("szpital", setPlayerIntoHospital)

-- Opis
function playerDescribeCommand(thePlayer, theCmd, ...)
    local playerid = getPlayerID(thePlayer)
    local describe = table.concat({...}, " ")
    if string.len(describe) == 0 then 
        setElementData(thePlayer, "player.describe", nil)
        outputChatBox("Usunąłeś opis.", thePlayer)
        return
    end

    if not describe or string.len(describe) > 128 then 
        showPopup(thePlayer, "Wprowadzony opis jest nieprawidłowy!", 5)
        return
    end

    outputChatBox("Ustawiono nowy opis: " .. describe, thePlayer)
    setElementData(thePlayer, "player.describe", describe)
end
addCommandHandler("opis", playerDescribeCommand)

-- BANKOMATY
function useCashMachine(thePlayer, theCommand, theOption, theValue)
	local x, y, z = getElementPosition(thePlayer)

	local searchSphere = createColSphere( x, y, z, 2 )
	local nearbyObjects = getElementsWithinColShape( searchSphere, "object" )

	local is_machine_available = false
	for index, object in ipairs( nearbyObjects ) do
        if tonumber(getElementModel(object)) == 2942 then
        	is_machine_available = true
        	break;
        end
    end

    if not is_machine_available then
    	showPopup(thePlayer, "Brak bankomatów w pobliżu.", 5)
    	return
    end

    if theOption == nil then
    	outputChatBox("#CCCCCCUżycie: /bankomat [stan | wplac | wyplac] [Ilość]", thePlayer, 255, 255, 255, true)
    	return 
    end

    if theOption == "stan" then
    	outputChatBox("#669999> Stan konta banowego wynosi: #669966$"..getElementData(thePlayer, "player.bankcash"), thePlayer, 255, 255, 255, true)
    	return
    end

    if theOption == "wplac" then
    	if (theValue == nil) or (tonumber(theValue) <= 0) or (tonumber(theValue) > tonumber(getElementData(thePlayer, "player.cash"))) then
    		outputChatBox("#CCCCCCUżycie: /bankomat wplac [Kwota]", thePlayer, 255, 255, 255, true)
    		return
    	end

    	-- Dodaj forsę do banku
    	local before_bank = getElementData(thePlayer, "player.bankcash")
    	setElementData(thePlayer, "player.bankcash", tonumber(before_bank) + tonumber(theValue))

    	-- Usuń forsę z EQ
    	local before_pocket = getElementData(thePlayer, "player.cash")
    	setPlayerMoney(thePlayer, tonumber(before_pocket) - tonumber(theValue))
    	setElementData(thePlayer, "player.cash", tonumber(before_pocket) - tonumber(theValue))

    	-- Info
    	outputChatBox("#669999> Wpłacono #669966$"..theValue.."#669999 na konto bankowe.", thePlayer, 255, 255, 255, true)
    	outputChatBox("#669999> Stan konta wynosi #669966$"..getElementData(thePlayer, "player.bankcash")..".", thePlayer, 255, 255, 255, true)
    	outputChatBox(" ", thePlayer)
    end

    if theOption == "wyplac" then
    	if (theValue == nil) or (tonumber(theValue) <= 0) or (tonumber(theValue) > tonumber(getElementData(thePlayer, "player.bankcash"))) then
    		outputChatBox("#CCCCCCUżycie: /bankomat wyplac [Kwota]", thePlayer, 255, 255, 255, true)
    		return
    	end

    	-- Usuń z banku
    	local before_bank = getElementData(thePlayer, "player.bankcash")
    	setElementData(thePlayer, "player.bankcash", tonumber(before_bank) - tonumber(theValue))

    	-- Dodaj do EQ
    	local before_pocket = getElementData(thePlayer, "player.cash")
    	setPlayerMoney(thePlayer, tonumber(before_pocket) + tonumber(theValue))
    	setElementData(thePlayer, "player.cash", tonumber(before_pocket) + tonumber(theValue))

    	-- Info
    	outputChatBox("#669999> Wypłacono #669966$"..theValue.."#669999 z konta bankowego.", thePlayer, 255, 255, 255, true)
    	outputChatBox("#669999> Stan konta wynosi #669966$"..getElementData(thePlayer, "player.bankcash")..".", thePlayer, 255, 255, 255, true)
    	outputChatBox(" ", thePlayer)
    end

    destroyElement(searchSphere) -- optymalizacja
end
addCommandHandler("bankomat", useCashMachine)

function showVehicleInfos(thePlayer, command)
	local dl = tonumber(getElementData(thePlayer, "player.dl"))
	if dl == 0 then
		setElementData(thePlayer, "player.dl", 1)
	else 
		setElementData(thePlayer, "player.dl", 0)
	end
end
addCommandHandler("dl", showVehicleInfos)

function showAdminsOnDuty(thePlayer, command)
	-- potem do zmiany, cout admins etc.
	--[[if getPlayerAdmin(thePlayer) == ADMIN_LEVEL_NONE then
		showPopup(player, "Brak administratorów na służbie.", 7)
		return
	end]]--

	local admins = {}

	if getPlayerAdmin(thePlayer) ~= 0 then
		local index = 0
		for i, player in ipairs(getElementsByType("player")) do
			if getElementData(player, "player.admin") ~= 0 then
				admins[index] = {}
				admins[index][1] = getElementData(player, "id")
				admins[index][2] = rank[getElementData(player, "player.color")]
				
                if exports.rp_groups:isPlayerOnAdminDuty(player) == true then
                    admins[index][3] = getElementData(player, "player.gname")
                else
                    admins[index][3] = getElementData(player, "player.gname").." - [OFFDUTY]"
                end
				index = index + 1
			end
		end
		triggerClientEvent ( thePlayer, "fillAdminsTable", thePlayer, admins)
	else
        local index = 0
        for i, player in ipairs(getElementsByType("player")) do
            if exports.rp_groups:isPlayerOnAdminDuty(player) == true then
                if getElementData(player, "player.admin") ~= 0 then
                    admins[index] = {}
                    admins[index][1] = getElementData(player, "id")
                    admins[index][2] = rank[getElementData(player, "player.color")]
                    admins[index][3] = getElementData(player, "player.gname")
                    index = index + 1
                end
            end
        end

        if index > 0 then
		  triggerClientEvent ( thePlayer, "fillAdminsTable", thePlayer, admins)
        else
            showPopup(player, "Brak administratorów na służbie.", 7)
        end

	end
end
addCommandHandler("a", showAdminsOnDuty)
addCommandHandler("admin", showAdminsOnDuty)
addCommandHandler("admins", showAdminsOnDuty)