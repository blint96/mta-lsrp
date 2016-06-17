--[[

// GIE ( GUI Interpolate Effects ) - v 1.0
	-- File : GIE.lua
	-- Author : PaiN^

--]]

local screen = { guiGetScreenSize( ) }
local active_gui_elements = 
{
}

local easingTypes =
{
	"Linear", "InQuad", "OutQuad", "InOutQuad", "OutInQuad", "InElastic", "OutElastic", "InOutElastic",
	"OutInElastic", "InBack", "OutBack", "InOutBack", "OutInBack", "InBounce", "OutBounce", 
	"InOutBounce", "OutInBounce", "SineCurve", "CosineCurve" 
}

function isGUIElementActive( window )
	if not window then
		return false
	end
	if active_gui_elements[window] then
		return true
	end
	return false
end

function isGUIElement( element )
	if isElement( element ) then
		if getElementType( element ):find( "gui-" ) then
			return true
		end
	end
	return false
end

function interpolate( gui_element )
	if not isGUIElementActive( gui_element ) then
		return false
	end
	
	local tick = getTickCount( )
	local timePassed = tick - active_gui_elements[gui_element].startTime
	local difference = active_gui_elements[gui_element].endTime - active_gui_elements[gui_element].startTime
	local progress = timePassed / difference
	local x, y = interpolateBetween(
		active_gui_elements[gui_element].startPosition[1], active_gui_elements[gui_element].startPosition[2], 0,
		active_gui_elements[gui_element].endPosition[1], active_gui_elements[gui_element].endPosition[2], 0,
		progress, active_gui_elements[gui_element].easingTypes[1] )
	local w, h = interpolateBetween(
		active_gui_elements[gui_element].startSize[1], active_gui_elements[gui_element].startSize[2], 0,
		active_gui_elements[gui_element].endSize[1], active_gui_elements[gui_element].endSize[2], 0,
		progress, active_gui_elements[gui_element].easingTypes[2] )
	guiSetPosition( gui_element, x, y, false )
	guiSetSize( gui_element, w, h, false )
	if active_gui_elements[gui_element].showing == true then
		if not guiGetVisible( gui_element ) then
			guiSetVisible( gui_element, true )
			guiBringToFront( gui_element )
		end
	end
	if tick >= active_gui_elements[gui_element].endTime then
		removeEventHandler( "onClientRender", root, active_gui_elements[gui_element].func )
		if active_gui_elements[gui_element].showing == false then
			guiSetVisible( gui_element, false )
		end
		guiSetEnabled( gui_element, true )
		active_gui_elements[gui_element] = nil
		return true
	end
	return false
end

function guiAddInterpolateEffect( gui_element, startX, startY, startW, startH, endX, endY, endW, endH, progressTime, position_easingType, size_easingType, showing )
	local check 
	if not isGUIElement( gui_element ) then
		outputChatBox( "Not GUI Element" )
		check = false
	end
	startX = tonumber( startX )
	startY = tonumber( startY )
	startW = tonumber( startW )
	startH = tonumber( startH )
	endX = tonumber( endX )
	endY = tonumber( endY )
	endW = tonumber( endW )
	endH = tonumber( endH )
	coordinates = 
	{
		startX, startY, startW, startH, endX, endY, endW, endH
	}
	for i = 1, #coordinates do
		if not coordinates[i] then
			check = false
		end
	end
	for i = 1, #easingTypes do
		if check == false then
			return
		end
		if easingTypes[i] == position_easingType and easingTypes[i] == size_easingType then
			check = true
		end
	end
	if active_gui_elements[gui_element] then
		check = false
	end
	if check == false then
		return false
	else
		guiSetEnabled( gui_element, false )
		progressTime = tonumber( progressTime )
		if not progressTime then progressTime = 2 end
		active_gui_elements[gui_element] = 
		{
		}
		active_gui_elements[gui_element].startTime = getTickCount( )
		active_gui_elements[gui_element].endTime = active_gui_elements[gui_element].startTime + ( progressTime * 1000 )
		active_gui_elements[gui_element].startPosition = { coordinates[1], coordinates[2] }
		active_gui_elements[gui_element].startSize = { coordinates[3], coordinates[4] }
		active_gui_elements[gui_element].endPosition = { coordinates[5], coordinates[6] }
		active_gui_elements[gui_element].endSize = { coordinates[7], coordinates[8] }
		active_gui_elements[gui_element].easingTypes = { position_easingType, size_easingType }
		active_gui_elements[gui_element].showing = showing
		active_gui_elements[gui_element].func = function( )
			interpolate( gui_element )
		end
		addEventHandler( "onClientRender", root, active_gui_elements[gui_element].func )
		return true
	end
	return false
end

