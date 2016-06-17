local dbConfig = {}
local dbStat = {}

dbConfig.host = get("dbHost") or "127.0.0.1"
dbConfig.hostType = get("dbHostType") or "host"
dbConfig.user = get("dbUser") or "root"
dbConfig.pass = get("dbPass") or ""
dbConfig.name = get("dbName") or ""
dbConfig.prefix = split(get("dbPrefix"), ",")
dbConfig.timeout = tonumber(get("dbTimeout")) or -1

dbStat.correctQuery = 0
dbStat.wrongQuery = 0

function dbStartConnection()
	dbConfig["connect"] = dbConnect("mysql", "dbname="..dbConfig["name"]..";"..dbConfig["hostType"].."="..dbConfig["host"], dbConfig["user"], dbConfig["pass"])

	if dbConfig["connect"] then outputDebugString("[MySQL] Połączono z bazą danych MySQL")
	else
		outputDebugString("[MySQL] Failed connect to database", 1)
		cancelEvent()
	end
end

function getDbHandler()
	return dbConfig["connect"]
end

function dbQueryEx(str, ...)
	local arg = {...}
	str = dbPrefix(str)

	local queryHandle = dbQuery(dbConfig["connect"], str, unpack(arg))
	if queryHandle then
		local result = {dbPoll(queryHandle, dbConfig["timeout"])}
		if result[1] then
			dbStat["correctQuery"] = dbStat["correctQuery"] + 1
		elseif result[1] == false then 
			dbStat["wrongQuery"] = dbStat["wrongQuery"] + 1 --DB error result
		else 
			dbStat["wrongQuery"] = dbStat["wrongQuery"] + 1 --DB not responding
			dbFree(queryHandle)
		end
		return unpack(result)
	else
		dbStat["wrongQuery"] = dbStat["wrongQuery"] + 1 --DB error send query
		return false
	end
end

function dbExecEx(str, ...)
	local arg = {...}
	str = dbPrefix(str)
	
	local queryHandle = dbExec(dbConfig["connect"], str, unpack(arg))
	if queryHandle then dbStart["correctQuery"] = dbStat["correctQuery"] + 1
	else dbStat["wrongQuery"] = dbStat["wrongQuery"] + 1 end --DB error send query

	return queryHandle
end

function dbPrefix(str)
	return string.gsub(str, "#pref([1-9])_",
		function(arg1) 
			return (dbConfig["prefix"][tonumber(arg1)] or "table").."_"
		end
	)
end

addEventHandler("onResourceStart", resourceRoot, dbStartConnection)