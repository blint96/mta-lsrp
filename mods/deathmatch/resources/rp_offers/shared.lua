-- typy ofert
OFFER_TYPE_CAR = 1
OFFER_TYPE_GREET = 2
OFFER_TYPE_REPAIR = 3
OFFER_TYPE_PRODUCT = 4
OFFER_TYPE_PAINT = 5

function getOfferTypeString(offer)
	local string = "Nieznana"
	if offer == OFFER_TYPE_CAR then
		string = "Pojazd"
	elseif offer == OFFER_TYPE_GREET then
		string = "Powitanie"
	elseif offer == OFFER_TYPE_REPAIR then
		string = "Naprawa"
	elseif offer == OFFER_TYPE_PRODUCT then
		string = "Produkt"
	elseif offer == OFFER_TYPE_PAINT then
		string = "Lakierowanie"
	else
		string = "Nieznana"
	end	

	return string
end