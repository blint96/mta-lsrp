function onJoinHandler ( )
	-- source - wchodzący
	setElementData(source, "player.logged", false)

	local banned = exports.rp_punish:checkBans(source);
	if banned then
		kickPlayer ( source, "Twoje konto jest zbanowane, zajrzyj na forum." )
	end
end
addEventHandler ( "onPlayerJoin", getRootElement(), onJoinHandler )