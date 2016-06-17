handler = nil

function start ( )
	handler = mysql_connect("localhost", "", "", "", 3306, "/var/run/mysqld/mysqld.sock", "") -- Establish the connection
	if(handler) then
		outputDebugString("[MySQL] Połączono z bazą danych!")
	else
		outputDebugString("[MySQL] NIE UDAŁO SIĘ POŁĄCZYĆ Z BAZĄ MySQL!!!")
	end
end
addEventHandler("onResourceStart", resourceRoot, start)



function getHandler()
	return handler
end