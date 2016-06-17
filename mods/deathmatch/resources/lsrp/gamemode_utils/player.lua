function playerRealName(player)
	player_name = getElementData(player, "player.displayname")
	player_name = player_name:gsub("_", " ")

	return player_name
end

function playerOriginalName(player)
	return getElementData(player, "player.displayname")
end

function getPlayerAdmin(player)
	local admin = tonumber(getElementData(player, "player.admin"))
	if admin == 0 then
		return ADMIN_LEVEL_NONE
	end

	if admin > 0 then
		return ADMIN_LEVEL_ADM
	end

	if admin == -2 then
		return ADMIN_LEVEL_SPT2
	end

	if admin == -3 then
		return ADMIN_LEVEL_SPT3
	end
end

-- Ustawianie gracza do BW po zalogowaniu
function setPlayerAfterLogBW(thePlayer, x, y, z, int, vw)
	if (getElementData(thePlayer, "player.bw")) > 0 then
		setElementPosition(thePlayer, x, y, z)
		setElementDimension(thePlayer, vw)
		setElementInterior(thePlayer, int)
		setPedAnimation ( thePlayer, "CRACK", "crckdeth2", 1, false, true)
		toggleAllControls ( thePlayer, false ) 
	end
end

-- Doczepianie obiektów broni na scrollu
function setPlayerWeaponsOnScroll(thePlayer)
	-- SECONDARY
	if getElementData(thePlayer, "player.sweapon") ~= nil then
		local array = getElementData(thePlayer, "player.sweapon")
		local objects = getElementsByType ( "object" )
		if array[2] then
			if (getPedWeaponSlot ( thePlayer ) == exports.rp_items:getWeaponType(tonumber(array[2]))) then
				-- ma w ręku, to usuń ze scrolla jeśli jest
				for k, object in ipairs ( objects ) do
					if getElementModel(object) == weaponsOb[tonumber(array[2])] then
						if tonumber(getElementData(object, "object.stickto")) == tonumber(getElementData(thePlayer, "player.uid")) then
							exports.boneattach:detachElementFromBone(object)
							destroyElement(object)
							break
						end
					end
				end
			else
				-- ma na scrollu, więc dodaj jeśli nie ma przyczepionego
				local is_attached = false
				for k, object in ipairs ( objects ) do
					if tonumber(getElementData(object, "object.stickto")) == tonumber(getElementData(thePlayer, "player.uid")) then
						if getElementModel(object) == weaponsOb[tonumber(array[2])] then
							setElementDimension(object, getElementDimension(thePlayer))
							setElementInterior(object, getElementInterior(thePlayer))
							is_attached = true
							break
						end
					end
				end

				if not is_attached then
					-- attach
					if not weaponsOb[tonumber(array[2])] then return end
					local weapon = createObject(weaponsOb[tonumber(array[2])], 0.0, 0.0, 0.0)
					if weapon then
						setElementData(weapon, "object.stickto", tonumber(getElementData(thePlayer, "player.uid")))
					end

					local w_type = exports.rp_items:getWeaponType(tonumber(array[2]))
					if w_type == 5 or w_type == 3 then
						exports.boneattach:attachElementToBone(weapon , thePlayer, 3, -0.1, -0.20, 0.2, 0.0, 55, 0.0)
					elseif w_type == 2 or w_type == 4 then
						exports.boneattach:attachElementToBone(weapon , thePlayer, 14, 0.15, 0.0, 0.0, 0.0, -75, 90)
					end
				end
			end
		end
	end

	-- PRIMARY TYLKO
	if getElementData(thePlayer, "player.pweapon") ~= nil then
		local array = getElementData(thePlayer, "player.pweapon")
		local objects = getElementsByType ( "object" )
		if array[2] then
			if (getPedWeaponSlot ( thePlayer ) == exports.rp_items:getWeaponType(tonumber(array[2]))) then
				-- ma w ręku, to usuń ze scrolla jeśli jest
				for k, object in ipairs ( objects ) do
					if getElementModel(object) == weaponsOb[tonumber(array[2])] then
						if tonumber(getElementData(object, "object.stickto")) == tonumber(getElementData(thePlayer, "player.uid")) then
							exports.boneattach:detachElementFromBone(object)
							destroyElement(object)
							break
						end
					end
				end
			else
				-- ma na scrollu, więc dodaj jeśli nie ma przyczepionego
				local is_attached = false
				for k, object in ipairs ( objects ) do
					if tonumber(getElementData(object, "object.stickto")) == tonumber(getElementData(thePlayer, "player.uid")) then
						if getElementModel(object) == weaponsOb[tonumber(array[2])] then
							setElementDimension(object, getElementDimension(thePlayer))
							setElementInterior(object, getElementInterior(thePlayer))
							is_attached = true
							break
						end
					end
				end

				if not is_attached then
					-- attach
					if not weaponsOb[tonumber(array[2])] then return end
					local weapon = createObject(weaponsOb[tonumber(array[2])], 0.0, 0.0, 0.0)
					if weapon then
						setElementData(weapon, "object.stickto", tonumber(getElementData(thePlayer, "player.uid")))
					end

					local w_type = exports.rp_items:getWeaponType(tonumber(array[2]))
					if w_type == 5 or w_type == 3 then
						exports.boneattach:attachElementToBone(weapon , thePlayer, 3, -0.1, -0.20, 0.2, 0.0, 55, 0.0)
					elseif w_type == 2 or w_type == 4 then
						exports.boneattach:attachElementToBone(weapon , thePlayer, 14, 0.15, 0.0, 0.0, 0.0, -75, 90)
					elseif w_type == 1 then
						-- kije, łopaty, siostry i bracia
						exports.boneattach:attachElementToBone(weapon , thePlayer, 3, -0.30, 0.1, -0.30, 140, 0, 0)
					end
				end
			end
		end
	end
end