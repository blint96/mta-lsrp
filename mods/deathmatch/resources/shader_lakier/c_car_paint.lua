--
-- c_car_paint.lua
--

local myShader = nil

addEventHandler( "onClientResourceStart", resourceRoot,
	function()
		setShaderApply(false)
	end
)

function setShaderApply(apply)
	if apply then 
		myShader, tec = dxCreateShader ( "car_paint.fx" )
		if myShader then 
			local textureVol = dxCreateTexture ( "images/smallnoise3d.dds" );
			local textureCube = dxCreateTexture ( "images/cube_env256.dds" );
			dxSetShaderValue ( myShader, "sRandomTexture", textureVol );
			dxSetShaderValue ( myShader, "sReflectionTexture", textureCube );

			-- Apply to world texture
			engineApplyShaderToWorldTexture ( myShader, "vehiclegrunge256" )
			engineApplyShaderToWorldTexture ( myShader, "?emap*" )
		end
	else
		if myShader then
			destroyElement(myShader)
		end
	end
end
addEvent("onShaderApply", true)
addEventHandler("onShaderApply", getRootElement(), setShaderApply)

addCommandHandler("shaderloop", function()
	local count = 0
	for k, v in pairs(getElementsByType("shader")) do 
		count = count + 1
	end

	outputChatBox(count)
end)