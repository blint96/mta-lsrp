-- PERMY - 254 = WSZYSTKO
-- hasbit(permygracza, binarkaperma)
GROUP_PERM_NONE 		= 		0
GROUP_PERM_VEHS 		= 		2
GROUP_PERM_OFFER 		= 		4
GROUP_PERM_ORDER		=		8
GROUP_PERM_GATES		=		16
GROUP_PERM_DOORS		=		32
GROUP_PERM_OOC			=		64
GROUP_PERM_LEADER		=		128

-- PAYDAY
_PAYDAY_LIMIT 			= 45
_MIN_DOTATION			= 150

-- LIMITY
_G_MAXGROUPS			= 1000
_G_MAX_GROUP_SLOTS		= 5

-- TYPY
_G_GROUPTYPE_COUNT		= 45
_G_TYPE_NONE		  	= 0
_G_TYPE_GASSTATION		= 1
_G_TYPE_GASTRONOMY		= 2
_G_TYPE_BAR		   		= 3
_G_TYPE_HOTEL		 	= 4
_G_TYPE_TAXI		  	= 5
_G_TYPE_WORKSHOP	  	= 6
_G_TYPE_CARDEALER	 	= 7
_G_TYPE_TIMBER			= 8
_G_TYPE_BANK		  	= 9
_G_TYPE_DRIVING	   		= 10
_G_TYPE_CLOTHES	   		= 11
_G_TYPE_GYM		   		= 12
_G_TYPE_RANGE		 	= 13
_G_TYPE_TRANSPORT	 	= 14
_G_TYPE_RACERS			= 15
_G_TYPE_SECURITY	  	= 16
_G_TYPE_COURT		 	= 17
_G_TYPE_CRIMINAL	  	= 18
_G_TYPE_MAFIA		 	= 19
_G_TYPE_CARTEL			= 20
_G_TYPE_DEALERS	   		= 21
_G_TYPE_POLICE			= 22
_G_TYPE_MEDICAL	   		= 23
_G_TYPE_FBI		   		= 24
_G_TYPE_FIREDEPT	  	= 25
_G_TYPE_NEWS		  	= 26
_G_TYPE_GOV		   		= 27
_G_TYPE_ARMY		  	= 28
_G_TYPE_PRISON			= 29
_G_TYPE_AUTOSALE		= 30
_G_TYPE_DRUGSTORE		= 31
_G_TYPE_AIRPORT			= 32
_G_TYPE_SAWMILL			= 33
_G_TYPE_QUARRY			= 34
_G_TYPE_FAMILY			= 35
_G_TYPE_FISHING			= 36
_G_TYPE_TRUCKERS		= 37
_G_TYPE_HARDCORE		= 38
_G_TYPE_HIRE			= 39
_G_TYPE_SKATE 			= 40
_G_TYPE_RADIO 			= 41
_G_TYPE_FARM			= 42
_G_TYPE_DOC				= 43
_G_TYPE_SPORT 			= 44
_G_TYPE_CORONER 		= 45

---------------------------------------------------------------------------------------------------
-- Ustawienia grup
---------------------------------------------------------------------------------------------------

-- Ustawienia grup >> groupSettings[IDGrupy][1,2,3] -> 1 - czy ma radio, 2 - czy duty poza biznesem
groupSettings = {}
for k = 0, _G_GROUPTYPE_COUNT do 
	groupSettings[k] = {false, false}
end
groupSettings[_G_TYPE_POLICE] = {true, true}
groupSettings[_G_TYPE_MEDICAL] = {true, true}
groupSettings[_G_TYPE_FIREDEPT] = {true, true}
groupSettings[_G_TYPE_FBI] = {true, true}
groupSettings[_G_TYPE_ARMY] = {true, true}
groupSettings[_G_TYPE_SECURITY] = {true, true}
groupSettings[_G_TYPE_COURT] = {true, true}
groupSettings[_G_TYPE_DOC] = {true, true}
groupSettings[_G_TYPE_NEWS] = {true, true}
groupSettings[_G_TYPE_TRUCKERS] = {true, true}
groupSettings[_G_TYPE_FARM] = {false, true}
groupSettings[_G_TYPE_CORONER] = {true, true}
groupSettings[_G_TYPE_RADIO] = {true, true}
groupSettings[_G_TYPE_AIRPORT] = {true, true}

function getGroupSettings(group_type)
	return groupSettings
end

---------------------------------------------------------------------------------------------------
-- Typy grup
---------------------------------------------------------------------------------------------------
groupTypes = {}
for k = 0, _G_GROUPTYPE_COUNT do 
	groupTypes[k] = "Brak typu"
end
groupTypes[_G_TYPE_GASSTATION] = "Stacja benzynowa"
groupTypes[_G_TYPE_GASTRONOMY] = "Gastronomia"
groupTypes[_G_TYPE_BAR] = "Bar"
groupTypes[_G_TYPE_HOTEL] = "Hotel"
groupTypes[_G_TYPE_TAXI] = "Taxi"
groupTypes[_G_TYPE_WORKSHOP] = "Warsztat"
groupTypes[_G_TYPE_CARDEALER] = "Salon samochodowy"
groupTypes[_G_TYPE_TIMBER] = "Timber err."
groupTypes[_G_TYPE_BANK] = "Bank"
groupTypes[_G_TYPE_DRIVING] = "Szkoła jazdy"
groupTypes[_G_TYPE_CLOTHES] = "Ciucholand"
groupTypes[_G_TYPE_GYM] = "Siłownia"
groupTypes[_G_TYPE_RANGE] = "Strzelnica"
groupTypes[_G_TYPE_TRANSPORT] = "Firma transportowa"
groupTypes[_G_TYPE_RACERS] = "Ściganci"
groupTypes[_G_TYPE_SECURITY] = "Firma ochroniarska"
groupTypes[_G_TYPE_COURT] = "Więzienie"
groupTypes[_G_TYPE_CRIMINAL] = "Organizacja przestępcza"
groupTypes[_G_TYPE_MAFIA] = "Mafia"
groupTypes[_G_TYPE_CARTEL] = "Kartel narkotykowy"
groupTypes[_G_TYPE_DEALERS] = "Dilerzy"
groupTypes[_G_TYPE_POLICE] = "Police Department"
groupTypes[_G_TYPE_MEDICAL] = "Medical Services"
groupTypes[_G_TYPE_FIREDEPT] = "Fire Department"
groupTypes[_G_TYPE_FBI] = "FBI"
groupTypes[_G_TYPE_NEWS] = "Stacja radiowa"
groupTypes[_G_TYPE_GOV] = "Urząd"
groupTypes[_G_TYPE_ARMY] = "Armia"
groupTypes[_G_TYPE_PRISON] = "Więzienie"
groupTypes[_G_TYPE_AUTOSALE] = "Komis aut"
groupTypes[_G_TYPE_DRUGSTORE] = "Sklep z narkotykami"
groupTypes[_G_TYPE_AIRPORT] = "Lotnisko"
groupTypes[_G_TYPE_SAWMILL] = "Młyn"
groupTypes[_G_TYPE_QUARRY] = "Kanalarze"
groupTypes[_G_TYPE_FAMILY] = "Rodzina"
groupTypes[_G_TYPE_FISHING] = "Rybiarze"
groupTypes[_G_TYPE_TRUCKERS] = "Firma transportowa"
groupTypes[_G_TYPE_HARDCORE] = "Hardcore"
groupTypes[_G_TYPE_HIRE] = "Wypożyczalnia"
groupTypes[_G_TYPE_SKATE] = "Skejci"
groupTypes[_G_TYPE_RADIO] = "Stacja radiowa"
groupTypes[_G_TYPE_FARM] = "Farma"
groupTypes[_G_TYPE_DOC] = "Więzienie"
groupTypes[_G_TYPE_SPORT] = "Sklep sportowy"
groupTypes[_G_TYPE_CORONER] = "Coroner"

