-- standardowy skrypt blurowy ze skryptu blur + funkcja dxDrawBlurredRectangle :)


local scx, scy = guiGetScreenSize()

Settings = {}
Settings.resized = 3
Settings.var = {}
Settings.var.blur = 1
Settings.screenRectangle = {}

local current 

function checkRender()
	local functions = getEventHandlers( "onClientRender", root )
	for k,v in pairs (functions) do
		if v == preRender then
			myScreenSource = nil
			removeEventHandler ("onClientRender", root, preRender)
		end
	end
end
setTimer (checkRender, 1000, 0, false)

function createShader()
		if getVersion ().sortable < "1.1.0" then
			outputChatBox( "Resource is not compatible with this client." )
			return
		end
        myScreenSource = dxCreateScreenSource( scx/Settings.resized, scy/Settings.resized)
        blurHShader,tecName = dxCreateShader( "shaders/blurH.fx" )
        blurVShader,tecName = dxCreateShader( "shaders/blurV.fx" )
		bAllValid = myScreenSource and blurHShader and blurVShader 

		if not bAllValid then
			outputChatBox( "Could not create some things. Please use debugscript 3" )
		end
end

 function dxDrawBlurredRectangle (x, y, size_x, size_y, color)
 		if not myScreenSource then
 			createShader()
 			addEventHandler ("onClientRender", root, preRender)
 		end
        if bAllValid and current then
			dxDrawImageSection  (x, y, size_x, size_y, x/Settings.resized, y/Settings.resized, size_x/Settings.resized, size_y/Settings.resized, current, 0,0,0, color)
        end
end

function preRender ()
	if not Settings.var then
		return
	end
	RTPool.frameStart()
	dxUpdateScreenSource( myScreenSource )
	current = myScreenSource
	current = applyGBlurH( current, Settings.var.blur )
	current = applyGBlurV( current, Settings.var.blur )
	dxSetRenderTarget()
end

function applyGBlurH( Src, blur )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurHShader, "TEX0", Src )
	dxSetShaderValue( blurHShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurHShader, "BLUR", blur )
	dxDrawImage( 0, 0, mx, my, blurHShader )
	return newRT
end

function applyGBlurV( Src, blur )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurVShader, "TEX0", Src )
	dxSetShaderValue( blurVShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurVShader, "BLUR", blur )
	dxDrawImage( 0, 0, mx,my, blurVShader )
	return newRT
end
RTPool = {}
RTPool.list = {}

function RTPool.frameStart()
	for rt,info in pairs(RTPool.list) do
		info.bInUse = false
	end
end

function RTPool.GetUnused( mx, my )
	-- Find unused existing
	for rt,info in pairs(RTPool.list) do
		if not info.bInUse and info.mx == mx and info.my == my then
			info.bInUse = true
			return rt
		end
	end
	-- Add new
	local rt = dxCreateRenderTarget( mx, my )
	if rt then
		RTPool.list[rt] = { bInUse = true, mx = mx, my = my }
	end
	return rt
end


--
--	TEXTURY
--
function setVehicleTexture(vehicle)
	local shader = dxCreateShader("shaders/blint.fx")
	local texture = dxCreateTexture("shaders/texture.png")
	dxSetShaderValue( shader, "Tex0", texture )
	engineApplyShaderToWorldTexture ( shader, "remapelegybody128", vehicle )
end
addEvent("onVehicleApplyTexture", true)
addEventHandler("onVehicleApplyTexture", localPlayer, setVehicleTexture)

function createReplaceShader()
	local shader = dxCreateShader("shaders/blint.fx")
	return shader
end
 
addCommandHandler("stest", function()
	local shader = dxCreateShader("shaders/blint.fx")
	local texture = dxCreateTexture("shaders/texture.png")
	dxSetShaderValue( shader, "Tex0", texture )
	engineApplyShaderToWorldTexture ( shader, "remapelegybody128", getPedOccupiedVehicle ( localPlayer ) )

	-- wall11

	local w_shader = dxCreateShader("shaders/blint.fx")
	local wall = dxCreateTexture("shaders/wall.png")
	dxSetShaderValue( w_shader, "Tex0", wall )
	engineApplyShaderToWorldTexture ( w_shader, "wall11" )
end)