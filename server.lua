

function getIdentity(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local identity = result[1]

		return {
			identifier = identity['identifier'],
			name = identity['name'],
			firstname = identity['firstname'],
			lastname = identity['lastname'],
			dateofbirth = identity['dateofbirth'],
			sex = identity['sex'],
			height = identity['height'],
			job = identity['job'],
			group = identity['group']
		}
	else
		return nil
	end
end


function loadExistingPlayers()
	TriggerEvent("es:getPlayers", function(curPlayers)
		for k,v in pairs(curPlayers)do
			TriggerClientEvent("reply:setGroup", v.get('source'), v.get('group'))
		end
	end)
end

loadExistingPlayers()

AddEventHandler('es:playerLoaded', function(Source, user)
	TriggerClientEvent('reply:setGroup', Source, user.getGroup())
end)

AddEventHandler('chatMessage', function(source, color, msg)
	cm = stringsplit(msg, " ")
	if cm[1] == "/reply" or cm[1] == "/r" then
		CancelEvent()
		if tablelength(cm) > 1 then
			local tPID = tonumber(cm[2])
			local names2 = GetPlayerName(tPID)
			local names3 = GetPlayerName(source)
			local textmsg = ""
			for i=1, #cm do
				if i ~= 1 and i ~=2 then
					textmsg = (textmsg .. " " .. tostring(cm[i]))
				end
			end
			local grupos = getIdentity(source)
		    if grupos.group ~= 'user' then
			    TriggerClientEvent('textmsg', tPID, source, textmsg, names2, names3)
			    TriggerClientEvent('textsent', source, tPID, names2)
		    else
				ESX.ShowNotification('~r~Nie masz permisji!')
			end
		end
	end	
	
	if cm[1] == "/report" then
		CancelEvent()
		if tablelength(cm) > 1 then
			local names1 = GetPlayerName(source)
			local textmsg = ""
			for i=1, #cm do
				if i ~= 1 then
					textmsg = (textmsg .. " " .. tostring(cm[i]))
				end
			end
		    TriggerClientEvent("sendReport", -1, source, names1, textmsg)
		end
	end	
end)


function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end



function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end
