--
-- c_switch.lua
--

----------------------------------------------------------------
----------------------------------------------------------------
-- Effect switching on and off
----------------------------------------------------------------
----------------------------------------------------------------

--------------------------------
-- onClientResourceStart
--		Auto switch on at start
--------------------------------
addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		triggerEvent( "switchContrast", localPlayer, false )
	end
)

--------------------------------
-- Command handler
--		Toggle via command
--------------------------------


--------------------------------
-- Switch effect on or off
--------------------------------
function switchContrast( bOn )
	outputDebugString( "switchContrast: " .. tostring(bOn) )
	if bOn then
		enableContrast()
	else
		disableContrast()
	end
end
addEvent( "switchContrast", true )
addEventHandler( "switchContrast", localPlayer, switchContrast )


