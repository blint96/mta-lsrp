function cancelAnim()
	setPedAnimation(getLocalPlayer(), false)
	local block, animation = getPedAnimation(getLocalPlayer())
	if not block then
        --setPedAnimation(getLocalPlayer(), "BSKTBALL","BBALL_idle_O", 1)
        triggerServerEvent("stopPlayerAnimation", getRootElement(), getLocalPlayer())
    end 
end

addEventHandler( "onClientResourceStart", resourceRoot,
    function ( )
    	bindKey ( "mouse2", "down", cancelAnim )
    end
)