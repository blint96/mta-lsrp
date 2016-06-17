function setPlayerReplacements()
	-- 339 - test - katana
	--[[txd = engineLoadTXD ( "gamemode_replacements/weapons/lightsaber/lightsaber.txd" )
	engineImportTXD ( txd, 339 )
	dff = engineLoadDFF ( "gamemode_replacements/weapons/lightsaber/lightsaber.dff" )
	engineReplaceModel ( dff, 339 )]]--

	-- Worek na zwłoki
	txd = engineLoadTXD ( "gamemode_replacements/objects/corpse/corpse.txd" )
	engineImportTXD ( txd, 1574 )
	dff = engineLoadDFF ( "gamemode_replacements/objects/corpse/corpse.dff" )
	engineReplaceModel ( dff, 1574 )
	col = engineLoadCOL( "gamemode_replacements/objects/corpse/corpse.col" )
	engineReplaceCOL( col, 1574 )

	-- skin Dziwki
	txd = engineLoadTXD ( "gamemode_replacements/skins/whore/whore.txd" )   
	engineImportTXD ( txd, 87 )
	dff = engineLoadDFF ( "gamemode_replacements/skins/whore/whore.dff" )
	engineReplaceModel ( dff, 87 )

	-- skin Gutka
	txd = engineLoadTXD ( "gamemode_replacements/skins/gutek/gutek.txd" )   
	engineImportTXD ( txd, 298 )
	dff = engineLoadDFF ( "gamemode_replacements/skins/gutek/gutek.dff" )
	engineReplaceModel ( dff, 298 )

	-- Elegant
	txd = engineLoadTXD ( "gamemode_replacements/vehicles/elegant/elegant.txd" )
	engineImportTXD ( txd, 507 )
	dff = engineLoadDFF ( "gamemode_replacements/vehicles/elegant/elegant.dff" )
	engineReplaceModel ( dff, 507 )

	-- Nowa manana
	txd = engineLoadTXD ( "gamemode_replacements/vehicles/manana/manana.txd" )
	engineImportTXD ( txd, 410 )
	dff = engineLoadDFF ( "gamemode_replacements/vehicles/manana/manana.dff" )
	engineReplaceModel ( dff, 410 )

	-- Kuruma -> Sentinel
	txd = engineLoadTXD ( "gamemode_replacements/vehicles/sentinel/kuruma.txd" )
	engineImportTXD ( txd, 405 )
	dff = engineLoadDFF ( "gamemode_replacements/vehicles/sentinel/kuruma.dff" )
	engineReplaceModel ( dff, 405 )

	-- LSPD
	txd = engineLoadTXD ( "gamemode_replacements/vehicles/lspd/lspd.txd" )
	engineImportTXD ( txd, 596 )
	dff = engineLoadDFF ( "gamemode_replacements/vehicles/lspd/lspd.dff" )
	engineReplaceModel ( dff, 596 )

	-- podmianka Premiera Krystoferowa
	txd = engineLoadTXD ( "gamemode_replacements/vehicles/premier/premier.txd" )
	engineImportTXD ( txd, 426 )
	dff = engineLoadDFF ( "gamemode_replacements/vehicles/premier/premier.dff" )
	engineReplaceModel ( dff, 426 )

	-- podmianka Elegy Krystoferowa
	txd = engineLoadTXD ( "gamemode_replacements/vehicles/elegy/elegy.txd" )
	engineImportTXD ( txd, 562 )
	dff = engineLoadDFF ( "gamemode_replacements/vehicles/elegy/elegy.dff" )
	engineReplaceModel ( dff, 562 )

	-- podmianka Uranus BMW - troche waży :/
	--[[txd = engineLoadTXD ( "gamemode_replacements/vehicles/uranus/uranus.txd" )
	engineImportTXD ( txd, 558 )
	dff = engineLoadDFF ( "gamemode_replacements/vehicles/uranus/uranus.dff" )
	engineReplaceModel ( dff, 558 )]]--

	-- podmianka Cometa Krystoferowa
	txd = engineLoadTXD ( "gamemode_replacements/vehicles/comet/comet.txd" )
	engineImportTXD ( txd, 480 )
	dff = engineLoadDFF ( "gamemode_replacements/vehicles/comet/comet.dff" )
	engineReplaceModel ( dff, 480 )

	-- Ściana połowka
	txd = engineLoadTXD ( "gamemode_replacements/objects/wall.txd" )
	engineImportTXD ( txd, 3060 )
	dff = engineLoadDFF ( "gamemode_replacements/objects/wall.dff" )
	engineReplaceModel ( dff, 3060 )
	col = engineLoadCOL( "gamemode_replacements/objects/wall.col" )
	engineReplaceCOL( col, 3060 )

	-- Ściana potrójna
	txd = engineLoadTXD ( "gamemode_replacements/objects/wall001potrojna.txd" )
	engineImportTXD ( txd, 3924 )
	dff = engineLoadDFF ( "gamemode_replacements/objects/wall001potrojna.dff" )
	engineReplaceModel ( dff, 3924 )
	col = engineLoadCOL( "gamemode_replacements/objects/wall001potrojna.col" )
	engineReplaceCOL( col, 3924 )

	-- Ściana średnia
	txd = engineLoadTXD ( "gamemode_replacements/objects/wall001srednia.txd" )
	engineImportTXD ( txd, 3923 )
	dff = engineLoadDFF ( "gamemode_replacements/objects/wall001srednia.dff" )
	engineReplaceModel ( dff, 3923 )
	col = engineLoadCOL( "gamemode_replacements/objects/wall001srednia.col" )
	engineReplaceCOL( col, 3923 )

	-- Ściana z oknem
	txd = engineLoadTXD ( "gamemode_replacements/objects/wall001zoknem.txd" )
	engineImportTXD ( txd, 3921 )
	dff = engineLoadDFF ( "gamemode_replacements/objects/wall001zoknem.dff" )
	engineReplaceModel ( dff, 3921 )
	col = engineLoadCOL( "gamemode_replacements/objects/wall001zoknem.col" )
	engineReplaceCOL( col, 3921 )

	-- Ściana z drzwiami
	txd = engineLoadTXD ( "gamemode_replacements/objects/wall001zdrzwiami.txd" )
	engineImportTXD ( txd, 3925 )
	dff = engineLoadDFF ( "gamemode_replacements/objects/wall001zdrzwiami.dff" )
	engineReplaceModel ( dff, 3925 )
	col = engineLoadCOL( "gamemode_replacements/objects/wall001zdrzwiami.col" )
	engineReplaceCOL( col, 3925 )
end
addEventHandler("onClientResourceStart", root, setPlayerReplacements)