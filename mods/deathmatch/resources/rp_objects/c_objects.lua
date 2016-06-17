local is_mouse_edit = false
local additional_z = 0.0
local object_on_edit = nil

function getObjectByUID(uid)
	local objects = getElementsByType ( "object" )
	for i, object in ipairs(objects) do
		if tonumber(getElementData(object, "object.uid")) == uid then
			return object
		end
	end

	return false
end

--[[
	Klikanie na obiekt
]]--
function clickOnObject(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if getElementData(getLocalPlayer(), "player.objedit") == 0 then
		if isElement(clickedElement) then
			if button == "left" and state == "down" then
				if getElementType(clickedElement) == "object" then
					setPlayerToEditObject(clickedElement)
					setElementData(getLocalPlayer(), "player.objedit", getElementData(clickedElement, "object.uid"))
				end
			end
		end
	end
end
addEventHandler ( "onClientClick", getRootElement(), clickOnObject )

-- edit position
function saveEditedObject(ed_element)
	local object = getObjectByUID(getElementData(getLocalPlayer(), "player.objedit"))
	if not isElement(object) then return end

	local x, y, z = getElementPosition(object)
	local rx, ry, rz = getElementRotation(object)

	if ed_element == "posx" then
		x = tonumber(guiGetText(obj_edit_posx))
		setElementPosition(object, tonumber(guiGetText(obj_edit_posx)), y, z)
	elseif ed_element == "posy" then
		y = tonumber(guiGetText(obj_edit_posy))
		setElementPosition(object, x, tonumber(guiGetText(obj_edit_posy)), z)
	elseif ed_element == "posz" then
		z = tonumber(guiGetText(obj_edit_posz))
		setElementPosition(object, x, y, tonumber(guiGetText(obj_edit_posz)))
	elseif ed_element == "rotx" then
		rx = tonumber(guiGetText(obj_edit_rotx))
		setElementRotation(object, rx, ry, rz)
	elseif ed_element == "roty" then
		ry = tonumber(guiGetText(obj_edit_roty))
		setElementRotation(object, rx, ry, rz)
	elseif ed_element == "rotz" then
		rz = tonumber(guiGetText(obj_edit_rotz))
		setElementRotation(object, rx, ry, rz)
	else
		outputConsole("błąd")
	end

	triggerServerEvent("SaveObject", getRootElement(), getElementData(getLocalPlayer(), "player.objedit"), x, y, z, rx, ry, rz)
end

-- select object
function setPlayerToEditObject(object)
	--guiSetInputEnabled(true)
	local x, y, z = getElementPosition(object)
	local rx, ry, rz = getElementRotation(object)

	-- Optymalizacja
	object_on_edit = object
	setElementCollidableWith(object_on_edit, localPlayer, false)

	-- info o rotacji
	guiSetText(obj_edit_posx, x)
	guiSetText(obj_edit_posy, y)
	guiSetText(obj_edit_posz, z)
	guiSetText(obj_edit_rotx, rx)
	guiSetText(obj_edit_roty, ry)
	guiSetText(obj_edit_rotz, rz)
	guiSetVisible(wnd_object_edit, true)
	showCursor(true)
end
addEvent("setPlayerToEditObject", true)
addEventHandler("setPlayerToEditObject", getLocalPlayer(), setPlayerToEditObject)

-- anuluj wybieranie
function setPlayerToNotSelectObject()
	if getElementData(getLocalPlayer(), "player.objedit") ~= -1 then
		setElementData(getLocalPlayer(), "player.objedit", -1)

		is_mouse_edit = false
		guiSetInputEnabled(false)
		showCursor(false)
		guiSetVisible(wnd_object_edit, false)
	end
end

-- ustaw gracza na wybieranie obiektu
function setPlayerToSelectObject()
	showCursor(true)
end
addEvent("setPlayerToSelectObject", true)
addEventHandler ( "setPlayerToSelectObject", getRootElement(), setPlayerToSelectObject )

--[[
	GUI Edytora
]]--
function deleteObjectByButton(button, state)
	if button == "left" and state == "up" then
		guiSetInputEnabled(false)
		showCursor(false)
		guiSetVisible(wnd_object_edit, false)

		-- fajny efekt dymka jak usunie
		local x, y, z = getElementPosition(getObjectByUID(getElementData(getLocalPlayer(), "player.objedit")))
		local effect = createEffect("camflash", x, y, z)
		setTimer ( destroyElement, 3000, 1, effect)

		-- trigger
		triggerServerEvent("RemoveObject", getRootElement(), getObjectByUID(getElementData(getLocalPlayer(), "player.objedit")))

		-- elementdata
		setElementData(getLocalPlayer(), "player.objedit", -1)
	end
end
function closeEditGUI(button, state)
	-- gdzieś trzymać będzie trzeba editing obiect, jakkolwiek
	if button == "left" and state == "up" then
		guiSetInputEnabled(false)
		showCursor(false)
		guiSetVisible(wnd_object_edit, false)
		setElementCollidableWith(object_on_edit, localPlayer, false)
		is_mouse_edit = false
		setElementData(getLocalPlayer(), "player.objedit", -1)
	end
end
addEventHandler("onClientResourceStart", resourceRoot,
    function()
    	bindKey ( "lalt", "up", setPlayerToNotSelectObject )

        wnd_object_edit = guiCreateWindow(0.75, 0.34, 0.21, 0.46, "Edycja obiektu", true)
        guiWindowSetSizable(wnd_object_edit, false)

        lab_edit_posx = guiCreateLabel(0.05, 0.10, 0.35, 0.05, "Pozycja X:", true, wnd_object_edit)
        lab_edit_posy = guiCreateLabel(0.05, 0.25, 0.35, 0.05, "Pozycja Y:", true, wnd_object_edit)
        lab_edit_posz = guiCreateLabel(0.05, 0.42, 0.31, 0.05, "Pozycja Z:", true, wnd_object_edit)

        lab_edit_rotx = guiCreateLabel(0.58, 0.10, 0.25, 0.05, "Rotacja X:", true, wnd_object_edit)
        lab_edit_roty = guiCreateLabel(0.58, 0.25, 0.31, 0.05, "Rotacja Y:", true, wnd_object_edit)
        lab_edit_rotz = guiCreateLabel(0.58, 0.42, 0.27, 0.05, "Rotacja Z:", true, wnd_object_edit)   

        obj_edit_posx = guiCreateEdit(0.05, 0.15, 0.35, 0.09, "1000.0", true, wnd_object_edit)
        addEventHandler("onClientGUIChanged", obj_edit_posx, function(element) saveEditedObject("posx") end, false)

        obj_edit_posy = guiCreateEdit(0.05, 0.31, 0.35, 0.09, "1000.0", true, wnd_object_edit)
        addEventHandler("onClientGUIChanged", obj_edit_posy, function(element) saveEditedObject("posy") end, false)

        obj_edit_posz = guiCreateEdit(0.05, 0.47, 0.35, 0.09, "1000.0", true, wnd_object_edit)
        addEventHandler("onClientGUIChanged", obj_edit_posz, function(element) saveEditedObject("posz") end, false)

        -- Zapisywajka
        btn_edit_save = guiCreateButton(0.30, 0.81, 0.42, 0.15, "Zapisz", true, wnd_object_edit)
        addEventHandler ( "onClientGUIClick", btn_edit_save, closeEditGUI, false )

        -- Usuwanie obiektu
        btn_edit_delete = guiCreateButton(0.30, 0.70, 0.42, 0.10, "Usuń", true, wnd_object_edit)
        addEventHandler ( "onClientGUIClick", btn_edit_delete, deleteObjectByButton, false )

        -- Edytowanie przesuwaniem
        btn_edit_move = guiCreateButton(0.30, 0.60, 0.42, 0.10, "Edycja myszką", true, wnd_object_edit)
        addEventHandler ( "onClientGUIClick", btn_edit_move, function() is_mouse_edit = true guiSetInputEnabled(false) guiSetVisible(wnd_object_edit, false) bindKey("mouse1", "up", saveMousedObject) setMouseRollAddition(true) end, false )

        obj_edit_rotx = guiCreateEdit(0.58, 0.15, 0.35, 0.09, "1000.0", true, wnd_object_edit)
        addEventHandler("onClientGUIChanged", obj_edit_rotx, function(element) saveEditedObject("rotx") end, false)

        obj_edit_roty = guiCreateEdit(0.58, 0.31, 0.35, 0.09, "1000.0", true, wnd_object_edit)
        addEventHandler("onClientGUIChanged", obj_edit_roty, function(element) saveEditedObject("roty") end, false)

        obj_edit_rotz = guiCreateEdit(0.58, 0.47, 0.35, 0.09, "1000.0", true, wnd_object_edit)
        addEventHandler("onClientGUIChanged", obj_edit_rotz, function(element) saveEditedObject("rotz") end, false)

        guiSetVisible(wnd_object_edit, false) 
    end
)

--[[
	Ficzer z mouse rollem
	"mouse_wheel_up", "mouse_wheel_down"
]]--
function setMouseRollAddition(toggle)
	if not toggle then 
		-- unbindy
		unbindKey("arrow_u", "up", moveRollUp)
		unbindKey("arrow_d", "up", moveRollDown)
	else
		-- bindy
		additional_z = 0.0
		bindKey("arrow_u", "up", moveRollUp)
		bindKey("arrow_d", "up", moveRollDown)
	end
end

function moveRollUp() additional_z = additional_z + 0.1 end
function moveRollDown() additional_z = additional_z - 0.1 end

--[[
	Przenoszenie myszką
]]--
function saveMousedObject()
	unbindKey ( "mouse1", "up", saveMousedObject )
	local uid = tonumber(getElementData(getLocalPlayer(), "player.objedit"))
	if uid > 0 then
		if is_mouse_edit == true then
			local x, y, z = getElementPosition(getObjectByUID(uid))
			local rx, ry, rz = getElementRotation(getObjectByUID(uid))

			triggerServerEvent("SaveObject", getRootElement(), getElementData(getLocalPlayer(), "player.objedit"), x, y, z, rx, ry, rz)
			
			setMouseRollAddition(false)
			is_mouse_edit = false
			showCursor(false)
			setElementCollidableWith(object_on_edit, localPlayer, true)

			-- dodać?
			guiSetVisible(wnd_object_edit, false)

			setElementData(getLocalPlayer(), "player.objedit", -1)
		end
	end
end

function followObjectMouse()
	local uid = tonumber(getElementData(getLocalPlayer(), "player.objedit"))
	if uid > 0 then
		if is_mouse_edit == true then
			local screenx, screeny, worldx, worldy, worldz = getCursorPosition()
            local px, py, pz = getCameraMatrix()

			local hit, x, y, z, elementHit = processLineOfSight ( px, py, pz, worldx, worldy, worldz, true, false, false, false )
			if elementHit == object_on_edit then return end

			local ox, oy, oz = getElementPosition(object_on_edit)
			local setting_z = z + tonumber(additional_z)
			setElementPosition(object_on_edit, x, y, setting_z)
			--outputChatBox( string.format( "Cursor world position: X=%.4f Y=%.4f Z=%.4f", x, y, z ) )
		end
	end
end
addEventHandler ( "onClientRender", getRootElement(), followObjectMouse )

function setDevmod()
	if getElementData(getLocalPlayer(), "player.admin") > 0 then
		setDevelopmentMode ( true )
	end
end
addCommandHandler("dev", setDevmod)

addEventHandler("onClientResourceStart", resourceRoot, function()
    if #getElementsByType("object") > 500 then
		engineSetAsynchronousLoading( true, true )
		--outputChatBox("engineSetAsynchronousLoading( true, false )")
    end
end)