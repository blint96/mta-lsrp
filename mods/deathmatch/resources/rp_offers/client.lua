-- Trochę zmiennych do ofert
local offerType = nil
local offerName = nil
local offerPerson = nil
local offerPrice = nil
local offerValue = nil

local screenX, screenY = guiGetScreenSize()
local rX, rY = 1366, 768
local is_offer_active = false

local is_rendered = false
local rd_opacity = 0.0


-------------------------------------------------
-- SEKCJA
-- F-CJI potrzebnych
-------------------------------------------------
addEventHandler("onClientResourceStart", root, 
	function() 
		local screenx, screeny = screenX, screenY 
		accept_offer_btn = guiCreateStaticImage((770 / rX) * screenX, (435 / rY) * screenY, screeny * 0.1, screeny * 0.1, "icons/accept.png", false)
		addEventHandler("onClientGUIClick", accept_offer_btn, function() acceptOffer() end, false)
		cancel_offer_btn = guiCreateStaticImage((870 / rX) * screenX, (435 / rY) * screenY, screeny * 0.1, screeny * 0.1, "icons/cancel.png", false)
		addEventHandler("onClientGUIClick", cancel_offer_btn, function() declineOffer() end, false)

		guiSetVisible(accept_offer_btn, false)
		guiSetVisible(cancel_offer_btn, false)
	end
)

function showOfferWindow(state)
	if not state then 
		removeEventHandler("onClientRender", root, drawOfferView)
		guiSetVisible(accept_offer_btn, false)
		guiSetVisible(cancel_offer_btn, false)
		showCursor(false)
		is_rendered = false
	else
		addEventHandler("onClientRender", root, drawOfferView)
		guiSetVisible(accept_offer_btn, true)
		guiSetVisible(cancel_offer_btn, true)
		showCursor(true)
		is_rendered = false
		rd_opacity = 0.0
	end
end

function drawOfferView()
	if not is_rendered then
		rd_opacity = rd_opacity + 0.02
		if rd_opacity > 1.0 then
			rd_opacity = 1.0
			is_rendered = true
		end

		guiSetAlpha(accept_offer_btn, rd_opacity)
		guiSetAlpha(cancel_offer_btn, rd_opacity)
	end

	-- Główny bloczek
	exports.score_wisb:dxDrawBlurredRectangle((400 / rX) * screenX, (230 / rY) * screenY, (570 / rX) * screenX, (300 / rY) * screenY)
	dxDrawRectangle((400 / rX) * screenX, (230 / rY) * screenY, (570 / rX) * screenX, (300 / rY) * screenY, 0x99000000)

	-- Linia górna
	dxDrawLine(
		(400 / rX) * screenX, 
		(250 / screenY) * screenY,
		(970 / rX) * screenX, -- szerokośc lini
		(250 / screenY) * screenY,
		0xEEEEEEEE,
		(40 / rY) * screenY
	)

	-- Tytuł
	dxDrawText(
		"Otrzymałeś nową ofertę!",
		(410 / rX) * screenX, 
		(235 / screenY) * screenY,
		(410 / rX) * screenX,
		(235 / screenY) * screenY,
		tocolor(0, 0, 0),
		2,
		"default"
	)

	-- Jaka oferta
	dxDrawText(
		"Typ oferty: "..getOfferTypeString(offerType),
		(410 / rX) * screenX, 
		(285 / screenY) * screenY,
		(410 / rX) * screenX,
		(285 / screenY) * screenY,
		tocolor(200, 200, 200),
		2,
		"default"
	)

	-- Od Kogo
	local offerer = getElementData(offerPerson, "player.displayname")
	offerer = offerer:gsub("_", " ")
	dxDrawText(
		"Oferta od: "..offerer,
		(410 / rX) * screenX, 
		(315 / screenY) * screenY,
		(410 / rX) * screenX,
		(315 / screenY) * screenY,
		tocolor(200, 200, 200),
		2,
		"default"
	)

	-- Cena
	local dxPrice = "Darmowa"
	if offerPrice > 0 then
		dxPrice = "$"..offerPrice
	end
	dxDrawText(
		"Koszt: "..dxPrice,
		(410 / rX) * screenX, 
		(345 / screenY) * screenY,
		(410 / rX) * screenX,
		(345 / screenY) * screenY,
		tocolor(200, 200, 200),
		2,
		"default"
	)
end

function acceptOffer()
	showOfferWindow(false)
	is_offer_active = false
	triggerServerEvent( "onPlayerAcceptOffer", getRootElement(), localPlayer, offerPerson, offerType, offerValue, offerPrice )
end

function declineOffer()
	showOfferWindow(false)
	is_offer_active = false
	triggerServerEvent( "onPlayerRejectOffer", getRootElement(), localPlayer, offerPerson )
end

function showOfferUI()
	showOfferWindow(true)
	is_offer_active = true
end

function onPlayerReceiveOffer(theSender, theType, theName, theValue, thePrice)
	offerPerson = theSender
	offerPrice = thePrice
	offerType = theType
	offerName = theName
	offerValue = theValue

	showOfferUI()
	return
end
addEvent("onOfferReceive", true)
addEventHandler("onOfferReceive", localPlayer, onPlayerReceiveOffer)

-------------------------------------------------
-- SEKCJA
-- TESTOWA
-------------------------------------------------
addCommandHandler("oferta", 
	function()
		if not is_offer_active then
			showOfferWindow(true)
			is_offer_active = true
		else
			showOfferWindow(false)
			is_offer_active = false
		end
	end
)