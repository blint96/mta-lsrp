-- [[ ----- ----- ----- MASTER UPDATE ----- ----- ---- ]] --

-- Main group info array
groupsarray_c = {}
playerGroups = {}
extraValue = nil -- pomocnicza

-- Server-available function to update local groups list
function updateClientList(groupsarray)
	groupsarray_c = groupsarray
end
addEvent( "updateClientList", true )
addEventHandler( "updateClientList", localPlayer, updateClientList)

function updateClientSidePlayerGroups(array)
	playerGroups = array
end
addEvent( "updateClientSidePlayerGroups", true )
addEventHandler( "updateClientSidePlayerGroups", localPlayer, updateClientSidePlayerGroups)

-- [[ -------------------------------------------------]] --





-- [[ ----- ----- ----- /ag info [id] ----- ----- ---- ]] --

-- Creates info window and sets it's listeners
addEventHandler("onClientResourceStart", resourceRoot,
	function()

		--------------------------------------------
		--	TYMCZASOWE KURWA NA SZYBKO
		--
		--------------------------------------------
		wnd_temp_groups = guiCreateWindow(0.37, 0.28, 0.26, 0.48, "Twoje grupy", true)
        guiWindowSetSizable(wnd_temp_groups, false)
        grid_temp_groups = guiCreateGridList(0.04, 0.08, 0.92, 0.74, true, wnd_temp_groups)
        guiGridListAddColumn(grid_temp_groups, "Nr", 0.2)
        guiGridListAddColumn(grid_temp_groups, "Nazwa", 0.8)
        for i = 1, 5 do
            guiGridListAddRow(grid_temp_groups)
        end
        guiGridListSetItemText(grid_temp_groups, 0, 1, "-", false, false)
        guiGridListSetItemText(grid_temp_groups, 0, 2, "-", false, false)
        guiGridListSetItemText(grid_temp_groups, 1, 1, "-", false, false)
        guiGridListSetItemText(grid_temp_groups, 1, 2, "-", false, false)
        guiGridListSetItemText(grid_temp_groups, 2, 1, "-", false, false)
        guiGridListSetItemText(grid_temp_groups, 2, 2, "-", false, false)
        guiGridListSetItemText(grid_temp_groups, 3, 1, "-", false, false)
        guiGridListSetItemText(grid_temp_groups, 3, 2, "-", false, false)
        guiGridListSetItemText(grid_temp_groups, 4, 1, "-", false, false)
        guiGridListSetItemText(grid_temp_groups, 4, 2, "-", false, false)
        btn_temp_group = guiCreateButton(0.28, 0.87, 0.45, 0.10, "Zamknij", true, wnd_temp_groups)
        guiSetProperty(btn_temp_group, "NormalTextColour", "FFAAAAAA")  
        guiSetVisible(wnd_temp_groups, false)

        -- [[ od /g 1 info ]] --
        wnd_g_info = guiCreateWindow(0.33, 0.30, 0.35, 0.34, "Nazwa grupy (1)", true)
        guiWindowSetSizable(wnd_g_info, false)
        grid_g_info = guiCreateGridList(0.03, 0.12, 0.94, 0.67, true, wnd_g_info)
        guiGridListAddColumn(grid_g_info, "", 0.3)
        guiGridListAddColumn(grid_g_info, "", 0.7)
        for i = 1, 6 do
            guiGridListAddRow(grid_g_info)
        end
        guiGridListSetItemText(grid_g_info, 0, 1, "Typ grupy:", false, false)
        guiGridListSetItemText(grid_g_info, 0, 2, "-", false, false)
        guiGridListSetItemText(grid_g_info, 1, 1, "Budżet:", false, false)
        guiGridListSetItemText(grid_g_info, 1, 2, "-", false, false)
        guiGridListSetItemText(grid_g_info, 2, 1, "Dotacja:", false, false)
        guiGridListSetItemText(grid_g_info, 2, 2, "-", false, false)
        guiGridListSetItemText(grid_g_info, 3, 1, "Tag:", false, false)
        guiGridListSetItemText(grid_g_info, 3, 2, "-", false, false)
        guiGridListSetItemText(grid_g_info, 4, 1, "Opcja 1:", false, false)
        guiGridListSetItemText(grid_g_info, 4, 2, "-", false, false)
        guiGridListSetItemText(grid_g_info, 5, 1, "Opcja 2:", false, false)
        guiGridListSetItemText(grid_g_info, 5, 2, "-", false, false)
        btn_g_info_close = guiCreateButton(0.34, 0.83, 0.32, 0.12, "Zamknij", true, wnd_g_info)
        guiSetProperty(btn_g_info_close, "NormalTextColour", "FFAAAAAA") 
        guiSetVisible(wnd_g_info, false)
		--------------------------------------------
		--	
		--	TYMCZASOWE KURWA NA SZYBKO
		--------------------------------------------

		wnd_group_info = guiCreateWindow(0.60, 0.28, 0.28, 0.39, "Informacje o grupie", true)
		btn_group_inf_close = guiCreateButton(0.31, 0.78, 0.38, 0.16, "Zamknij", true, wnd_group_info)	
		grid_group_inf = guiCreateGridList(0.05, 0.08, 0.89, 0.65, true, wnd_group_info)
		
		guiGridListAddColumn(grid_group_inf, "Typ", 0.5)
		guiGridListAddColumn(grid_group_inf, "Wartość", 0.5)
		
		for i = 1, 10 do
			guiGridListAddRow(grid_group_inf)
		end

		for i = 0, 6 do
			guiGridListSetItemText(grid_group_inf, i, 1, "-", false, false)
			guiGridListSetItemText(grid_group_inf, i, 2, "-", false, false)
		end
		
		guiSetAlpha(grid_group_inf, 0.80)
		guiWindowSetSizable(wnd_group_info, false)
		guiSetVisible(wnd_group_info, false)
		guiGridListSetSortingEnabled ( grid_group_inf, false )

		addEventHandler("onClientGUIClick", btn_group_inf_close, closeGroupInfoWindow, false)
		addEventHandler("onClientGUIClick", btn_temp_group, function() guiSetVisible(wnd_temp_groups, false) lsrp_hideCursor() end, false)
		addEventHandler("onClientGUIClick", btn_g_info_close, function() guiSetVisible(wnd_g_info, false) lsrp_hideCursor() end, false)
	end
)

-- Closes the information window
function closeGroupInfoWindow()
   guiSetVisible(wnd_group_info, false)
   lsrp_hideCursor()
end
addEvent("closeGroupInfoWindow", true)

-- Pokazywajka informacji o grupie nie dla adminów --
function showGroupInfoViewPlayer(slot)
	local playerid = tonumber(getElementData(localPlayer, "id"))
	local group_id = playerGroups[playerid][tonumber(slot)]["group_id"]

	-- tablica na nazwy grup

	guiSetText(wnd_g_info, groupsarray_c[group_id]["name"].." (".. groupsarray_c[group_id]["uid"] ..") - Informacje")
	guiGridListSetItemText(grid_g_info, 0, 1, "Typ grupy:", false, false)
	--guiGridListSetItemText(grid_g_info, 0, 2, groupsarray_c[group_id]["type"], false, false)
	guiGridListSetItemText(grid_g_info, 0, 2, groupTypes[groupsarray_c[group_id]["type"]] , false, false)
	-- Nazwa
	guiGridListSetItemText(grid_g_info, 1, 1, "Budżet:", false, false)
	guiGridListSetItemText(grid_g_info, 1, 2, "$"..groupsarray_c[group_id]["cash"], false, false)
	-- Stan konta
	guiGridListSetItemText(grid_g_info, 2, 1, "Dotacja:", false, false)
	guiGridListSetItemText(grid_g_info, 2, 2, "$"..groupsarray_c[group_id]["dotation"], false, false)
	-- Typ
	guiGridListSetItemText(grid_g_info, 3, 1, "Tag:", false, false)
	guiGridListSetItemText(grid_g_info, 3, 2, groupsarray_c[group_id]["tag"], false, false)
	-- Właściciel
	guiGridListSetItemText(grid_g_info, 4, 1, "Opcja 1:", false, false)
	guiGridListSetItemText(grid_g_info, 4, 2, groupsarray_c[group_id]["value1"], false, false)
	-- Wartości 1, 2, 3
	guiGridListSetItemText(grid_g_info, 5, 1, "Opcja 2:", false, false)
	guiGridListSetItemText(grid_g_info, 5, 2, groupsarray_c[group_id]["value2"], false, false)
	
	guiSetVisible(wnd_g_info, true)
	lsrp_showCursor()
end
addEvent( "showGroupInfoViewPlayer", true )
addEventHandler( "showGroupInfoViewPlayer", getLocalPlayer(), showGroupInfoViewPlayer )

-- Populates the info window and displays it.
function showGroupInfoView(group_id, grouptypes)
	-- UID
	guiGridListSetItemText(grid_group_inf, 0, 1, "UID grupy", false, false)
	guiGridListSetItemText(grid_group_inf, 0, 2, groupsarray_c[group_id]["uid"], false, false)
	-- Nazwa
	guiGridListSetItemText(grid_group_inf, 1, 1, "Nazwa", false, false)
	guiGridListSetItemText(grid_group_inf, 1, 2, groupsarray_c[group_id]["name"], false, false)
	-- Stan konta
	guiGridListSetItemText(grid_group_inf, 2, 1, "Stan konta", false, false)
	guiGridListSetItemText(grid_group_inf, 2, 2, groupsarray_c[group_id]["cash"], false, false)
	-- Typ
	guiGridListSetItemText(grid_group_inf, 3, 1, "Typ", false, false)
	--guiGridListSetItemText(grid_group_inf, 3, 2, grouptypes[tonumber(groupsarray_c[group_id]["type"])], false, false)
	guiGridListSetItemText(grid_group_inf, 3, 2, groupTypes[groupsarray_c[group_id]["type"]] .. "(".. groupsarray_c[group_id]["type"] ..")", false, false)
	-- Właściciel
	guiGridListSetItemText(grid_group_inf, 4, 1, "Właściciel", false, false)
	guiGridListSetItemText(grid_group_inf, 4, 2, groupsarray_c[group_id]["owner"], false, false)
	-- Wartości 1, 2, 3
	guiGridListSetItemText(grid_group_inf, 5, 1, "Wartość 1, 2, 3", false, false)
	guiGridListSetItemText(grid_group_inf, 5, 2, groupsarray_c[group_id]["value1"] .. ", " .. groupsarray_c[group_id]["value2"] .. ", " .. groupsarray_c[group_id]["value3"], false, false)
	-- Tag
	guiGridListSetItemText(grid_group_inf, 6, 1, "Tag", false, false)
	guiGridListSetItemText(grid_group_inf, 6, 2, groupsarray_c[group_id]["tag"], false, false)
	
	guiSetVisible(wnd_group_info, true)
	lsrp_showCursor()
end
addEvent( "showGroupInfoView", true )
addEventHandler( "showGroupInfoView", getLocalPlayer(), showGroupInfoView )

-- [[ -------------------------------------------------]] --





-- [[ ----- ----- ----- /ag lista --- ----- ----- ---- ]] --

-- Creates list window and adds listeners
addEventHandler("onClientResourceStart", resourceRoot,
	function()
		grouplist_wnd_main = guiCreateWindow(240, 207, 529, 380, "Lista grup", false)
		grouplist_btn_close = guiCreateButton(219, 325, 105, 33, "Zamknij", false, grouplist_wnd_main)
		grouplist_scrollpane_main = guiCreateScrollPane(24, 35, 481, 280, false, grouplist_wnd_main)
		grouplist_gridlist_main = guiCreateGridList(16, 16, 455, 254, false, grouplist_scrollpane_main)
		
		guiGridListAddColumn(grouplist_gridlist_main, "UID", 0.3)
		guiGridListAddColumn(grouplist_gridlist_main, "Nazwa", 0.3)
		guiGridListAddColumn(grouplist_gridlist_main, "Typ", 0.3)
		
		for i = 1, _G_MAXGROUPS do
			guiGridListAddRow(grouplist_gridlist_main)
		end
		
		guiGridListSetItemText(grouplist_gridlist_main, 0, 1, "#0", false, false)
		guiGridListSetItemText(grouplist_gridlist_main, 0, 2, "JebacPD", false, false)
		guiGridListSetItemText(grouplist_gridlist_main, 0, 3, "0", false, false)

		guiWindowSetSizable(grouplist_wnd_main, false)
		guiSetVisible(grouplist_wnd_main, false)   
		
		addEventHandler("onClientGUIClick", grouplist_btn_close, hideGroupList, false)
		addEventHandler("onClientGUIClick", grouplist_gridlist_main, groupClick, false)
	end
)

-- Handler of the /ag lista click
function groupClick ( button, state, sx, sy, x, y, z, elem, gui )
		-- if state is down ( not to trigger the function twice on mouse button up/down), clicked gui and the element is our player list
		if source == grouplist_gridlist_main then
			local groupUID = guiGridListGetItemText ( grouplist_gridlist_main, guiGridListGetSelectedItem ( grouplist_gridlist_main ), 1 )
			groupUID = groupUID:gsub("%#", "")

			triggerServerEvent( "GetGroupInfo", getRootElement(), getLocalPlayer(), groupUID )
			
			outputChatBox ("Kliknięta grupa to: " .. groupUID )	 -- output it to chat box
		end

		if ( ( state == "down" ) and ( gui == true ) and ( source == grouplist_gridlist_main ) ) then
				-- get the player name from the selected row, first column 
				local playerName = guiGridListGetItemText ( grouplist_gridlist_main, guiGridListGetSelectedItem ( grouplist_gridlist_main ), 1 )
				outputChatBox ( playerName )	 -- output it to chat box
		end
end

-- Populates and shows the list
function showGroupList()
	for i = 1, _G_MAXGROUPS do
		guiGridListSetItemText(grouplist_gridlist_main, i, 1, "", false, false)
		guiGridListSetItemText(grouplist_gridlist_main, i, 2, "", false, false)
		guiGridListSetItemText(grouplist_gridlist_main, i, 3, "", false, false)
	end

	local index = 0
	for i = 0, #groupsarray_c do
		guiGridListSetItemText(grouplist_gridlist_main, index, 1, "#"..groupsarray_c[i]["uid"], false, false)
		guiGridListSetItemText(grouplist_gridlist_main, index, 2, groupsarray_c[i]["name"], false, false)
		guiGridListSetItemText(grouplist_gridlist_main, index, 3, groupsarray_c[i]["type"], false, false)
		index = index + 1
	end

	guiSetVisible(grouplist_wnd_main, true)
	lsrp_showCursor()
end
addEvent( "showGroupList", true )
addEventHandler( "showGroupList", localPlayer, showGroupList )

-- Hides the /ag lista window
function hideGroupList()
	guiSetVisible(grouplist_wnd_main, false)
	lsrp_hideCursor()
end

-- [[ -------------------------------------------------]] --





-- [[ ----- ----- ----- /ag typ ----- ----- ----- ---- ]] --

-- Creates the /ag typ window
addEventHandler("onClientResourceStart", resourceRoot,
	function()
		wnd_group_type = guiCreateWindow(0.32, 0.07, 0.35, 0.58, "Wybierz typ grupy", true)
		wnd_group_type_list = guiCreateGridList(0.02, 0.05, 0.96, 0.86, true, wnd_group_type)
		wnd_group_type_exit = guiCreateButton(0.39, 0.93, 0.23, 0.05, "Anuluj", true, wnd_group_type)	

		guiGridListAddColumn(wnd_group_type_list, "Typ", .3)
		guiGridListAddColumn(wnd_group_type_list, "Nazwa", .7)
		
		for i = 1, _G_GROUPTYPE_COUNT do
			guiGridListAddRow(wnd_group_type_list)
		end

		guiWindowSetSizable(wnd_group_type, false)
		guiSetVisible(wnd_group_type, false)   
		
		addEventHandler("onClientGUIClick", wnd_group_type_list, groupTypeClick, false)
		addEventHandler("onClientGUIClick", wnd_group_type_exit, hideGroupTypeList, false)
	end
)

-- Hides the group type list
function hideGroupTypeList()
	guiSetVisible(wnd_group_type, false)
	lsrp_hideCursor()
end

-- Fills in the types, w group_id trzymamy id grupy do zmiany
function showGroupTypeView(group_id)
	extraValue = group_id
	for i = 0, #groupTypes do
		guiGridListSetItemText(wnd_group_type_list, i, 1, "#"..i, false, false)
		guiGridListSetItemText(wnd_group_type_list, i, 2, groupTypes[i], false, false)
	end

	guiSetVisible(wnd_group_type, true)
	lsrp_showCursor()
end
addEvent( "showGroupTypeView", true )
addEventHandler( "showGroupTypeView", localPlayer, showGroupTypeView )

-- Handles the group type selection and passes it back to server
function groupTypeClick ( button, state, sx, sy, x, y, z, elem, gui )
	if source == wnd_group_type_list then
		local grouptype = guiGridListGetItemText ( wnd_group_type_list, guiGridListGetSelectedItem ( wnd_group_type_list ), 1 )
		grouptype = grouptype:gsub("%#", "")

		guiSetVisible( wnd_group_type, false )
		lsrp_hideCursor()
		triggerServerEvent( "ChangeGroupType", getRootElement(), grouptype, extraValue )
	end
end

-- [[ -------------------------------------------------]] --



addEventHandler("onClientResourceStart", resourceRoot,
	function()
		wnd_groups = guiCreateWindow(0.2, 0.2, 0.7, 0.7, "Twoje grupy", true)
		guiWindowSetSizable(wnd_groups, false)

		wnd_group_panel = guiCreateTabPanel(0.01, 0.05, 0.97, 0.94, true, wnd_groups)
		
		wnd_group_tab = {}
		wnd_group_tab[1] = guiCreateTab("LSPD", wnd_group_panel)
		wnd_group_tab[2] = guiCreateTab("LSFD", wnd_group_panel)
		wnd_group_tab[3] = guiCreateTab("NONE", wnd_group_panel)
		wnd_group_tab[4] = guiCreateTab("LSCF", wnd_group_panel)
		wnd_group_tab[5] = guiCreateTab("BALL", wnd_group_panel)

		wnd_group_groupname = {}
		wnd_group_logo = {}
		wnd_group_list1 = {}
		wnd_group_list2 = {}
		wnd_group_text_r1c1 = {}
		wnd_group_text_r1c2 = {}
		wnd_group_text_r2c1 = {}
		wnd_group_text_r2c2 = {}
		wnd_group_text_r3c1 = {}
		wnd_group_text_r3c2 = {}
		wnd_group_button1 = {}
		wnd_group_button2 = {}
		wnd_group_button3 = {}
		wnd_group_button4 = {}

		for i = 1, 5 do
			wnd_group_groupname[i] = guiCreateLabel(0.03, 0.03, 0.93, 0.04, "Los Santos Police Department (UID: 3)", true, wnd_group_tab[i])
			guiSetFont(wnd_group_groupname[i], "default-bold-small")
			wnd_group_logo[i] = guiCreateStaticImage(0.03, 0.12, 0.22, 0.27, ":rp_vehicles/images/vehicles/405.png", true, wnd_group_tab[i])
			wnd_group_list1[i] = guiCreateGridList(0.03, 0.54, 0.47, 0.42, true, wnd_group_tab[i])
			wnd_group_list2[i] = guiCreateGridList(0.52, 0.54, 0.44, 0.42, true, wnd_group_tab[i])
			wnd_group_text_r1c1[i] = guiCreateLabel(0.31, 0.12, 0.28, 0.05, "Stan konta: $1,234", true, wnd_group_tab[i])
			wnd_group_text_r1c2[i] = guiCreateLabel(0.60, 0.12, 0.28, 0.05, "Wartość 1", true, wnd_group_tab[i])
			wnd_group_text_r2c1[i] = guiCreateLabel(0.31, 0.17, 0.28, 0.05, "Graczy online: 3", true, wnd_group_tab[i])
			wnd_group_text_r2c2[i] = guiCreateLabel(0.60, 0.17, 0.28, 0.05, "Wartość 2", true, wnd_group_tab[i])
			wnd_group_text_r3c1[i] = guiCreateLabel(0.31, 0.22, 0.28, 0.05, "Graczy na duty: 1", true, wnd_group_tab[i])
			wnd_group_text_r3c2[i] = guiCreateLabel(0.60, 0.22, 0.28, 0.05, "Wartość 3", true, wnd_group_tab[i])
			wnd_group_button1[i] = guiCreateButton(0.03, 0.43, 0.19, 0.08, "Zaproś gracza", true, wnd_group_tab[i])
			wnd_group_button2[i] = guiCreateButton(0.28, 0.43, 0.19, 0.08, "Wyrzuć gracza", true, wnd_group_tab[i])
			wnd_group_button3[i] = guiCreateButton(0.53, 0.43, 0.19, 0.08, "Respawn pojazdów", true, wnd_group_tab[i])
			wnd_group_button4[i] = guiCreateButton(0.77, 0.43, 0.19, 0.08, "Wczytaj grupę", true, wnd_group_tab[i])
		end

		wnd_groups_label = guiCreateLabel(0.85, 0.22, 0.05, 0.05, "Exit", false, wnd_groups)
		addEventHandler("onClientGUIClick", wnd_groups_label, playerGroupsExit, false)


		guiSetVisible(wnd_groups, false)
	end
)

function playerGroupsExit()
	guiSetVisible(wnd_groups, false)
	lsrp_hideCursor()
end

function showGroups()
	local playerid = tonumber(getElementData(localPlayer, "id"))
	for i = 1, _G_MAX_GROUP_SLOTS do
		guiGridListSetItemText(grid_temp_groups, i, 1, "", false, false)
		guiGridListSetItemText(grid_temp_groups, i, 2, "", false, false)
	end

	local index = 0
	for i = 1, table.getn(playerGroups[playerid]) do
		if playerGroups[playerid][i]["group_id"] > 0 then
			guiGridListSetItemText(grid_temp_groups, index, 1, "#"..i, false, false)
			guiGridListSetItemText(grid_temp_groups, index, 2, playerGroups[playerid][i]["group_name"].." ("..playerGroups[playerid][i]["group_uid"]..")", false, false)
			index = index + 1
		end
	end

	guiSetVisible(wnd_temp_groups, true)
	lsrp_showCursor()
end
addEvent( "showGroups", true )
addEventHandler( "showGroups", localPlayer, showGroups )




-- [[ ----- ----- ----- - Tools ----- ----- ----- ---- ]] --



-- [[ -------------------------------------------------]] --







-- [[ ----- ----- ----- - Tools ----- ----- ----- ---- ]] --

function isAnyGUIVisible() --WHYIMSOBAD
	for k, v in ipairs(getElementsByType("gui-window")) do
		if guiGetVisible(v) then
			return true
		end
	end
	return false
end

function lsrp_showCursor()
	guiSetInputEnabled(true)
	showCursor(true)
end

function lsrp_hideCursor()
	if not isAnyGUIVisible() then
	   showCursor(false)
	   guiSetInputEnabled(false)
	end
end


--showCursor(false)
--guiSetInputEnabled(false)