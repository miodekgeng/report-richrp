ESX = nil
local showreport = true

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent("textsent")
AddEventHandler('textsent', function(tPID, names2)
  if names2 then
    ESX.ShowNotification("Odpowiedź wysłana do: " .. names2 .." ~y~ID: " .. tPID)
  else
    ESX.ShowNotification('~r~Ten gracz jest offline!')
  end
end)

RegisterNetEvent('reportstatus')
AddEventHandler('reportstatus', function()
  if not showreport then
    showreport = true
    ESX.ShowNotification('~g~Włączyłeś/aś widoczność reporta')
  else
    showreport = false
    ESX.ShowNotification('~r~Wyłączyłeś/aś widoczność reporta')
  end
end)

RegisterNetEvent("textmsg")
AddEventHandler('textmsg', function(source, textmsg, names2, names3)
	TriggerEvent('chatMessage', "", {205, 0, 0}, " ^*🔰 Wiadomość od Administratora [".. source .."] " .. names3 .."  ".."^0: " .. textmsg)
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/reply',  'Odpowiedz na zgłoszenie',  { { name = 'ID zgłoszenia', help = 'Wpisz ID gracza który wysyłał zgłoszenie.' }, { name = 'Wiadomość', help = 'Treść odpowiedzi' } } )
	TriggerEvent('chat:addSuggestion', '/report',   'Wyślij zgłoszenie Administratorowi (Bezsensowne zgłoszenia będą równały się z banem)',   { { name = 'Wiadomość', help = 'Opisz tutaj dokładnie swój problem' } } )
end)

RegisterNetEvent('sendReport')
AddEventHandler('sendReport', function(id, name, message, admins)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    TriggerEvent('chatMessage', "", {0, 255, 0}, 'Zgłoszenie zostało wysłane do '..admins..' administratorów online!')
    TriggerServerEvent("checkadmin", name, message, id)
  elseif pid ~= myId then
    TriggerServerEvent("checkadmin", name, message, id)
  end
end)

RegisterNetEvent('sendReportToAllAdmins')
AddEventHandler('sendReportToAllAdmins', function(id, name, message, i)
  local myId = PlayerId()
  local pid = GetPlayerFromServerId(id)
  if pid == myId then
    if showreport then
      TriggerEvent('chatMessage', "", {255, 0, 0}, " 🚩 ZGŁOSZENIE | [".. i .."] " .. name .."  "..":^0  " .. message)
    end
  end
end)