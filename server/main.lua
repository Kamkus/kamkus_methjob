  
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('table', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    TriggerClientEvent("methjob_place", playerId)
end)

RegisterNetEvent("DeleteTable")
AddEventHandler("DeleteTable", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('table', 1)
end)

RegisterNetEvent("AddTable")
AddEventHandler("AddTable", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addInventoryItem('table', 1)
end)

RegisterNetEvent("Update")
AddEventHandler("Update", function(amountxp, amountmeth)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier})
	local newAmount = 0
	currentXp = result[1].xp
	currentLvl = result[1].lvl
	if(currentLvl%2 == 0.0) then
	 newAmount = amountmeth + (0.5*currentLvl)
else
	 newAmount = (amountmeth + (0.5*currentLvl))-0.5
end
	xPlayer.addInventoryItem('meth', newAmount)
	TriggerClientEvent("methjob_notify", _source, "Cooking time is over. You cooked " .. newAmount .. " meth", "success")
	xPlayer.addInventoryItem('table', 1)
	if(currentLvl<40) then
	if(currentXp + amountxp >= 100+ (currentLvl*50) ) then
		MySQL.Async.fetchAll("UPDATE users SET xp = @xp WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier, ["@xp"]= (currentXp + amountxp)-(100 + (currentLvl*50))}, function(result)
end) 
		MySQL.Async.fetchAll("UPDATE users SET lvl = lvl + @lvl WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier, ["@lvl"] = 1}, function(result)
end) 
		TriggerClientEvent("methjob_update", _source, (((currentXp+ amountxp)- (100+50*currentLvl))/(100+ (50*(currentLvl+1))))*100, amountxp)
 else
   MySQL.Async.fetchAll("UPDATE users SET xp = xp + @xp WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier, ["@xp"]= amountxp}, function(result)
end)
  TriggerClientEvent("methjob_update", _source, ((currentXp+amountxp)/(100+(50*currentLvl)))*100, amountxp)
end
else
	TriggerClientEvent("methjob_notify", _source, "You didn't get any more experience. You have maximum level", "error")
end
end)
