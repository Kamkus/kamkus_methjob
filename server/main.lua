  
  
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

RegisterNetEvent("Sell")
AddEventHandler("Sell", function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	amount = xPlayer.getInventoryItem('meth').count
	print("xDDDD")
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {["@identifier"] = xPlayer.identifier})
	if result[1].lvl == 1 or result[1].lvl == 2 then
		TriggerClientEvent("methjob_notify", _source, "This is some shitty stuff. I will pay maximum " .. Config.prices.lvl1 ..  " per each Meth", "info")
		xPlayer.addMoney(amount* Config.prices.lvl1)
		TriggerClientEvent("methjob_notify", _source, "You sold! " .. amount ..  " meth for " .. amount* Config.prices.lvl1 .. " $", "Success")
	elseif result[1].lvl == 3 or result[1].lvl == 4 then
		TriggerClientEvent("methjob_notify", _source, "This isn't the worst but isn't the best stuff. I will pay " .. Config.prices.lvl3 ..  " per each Meth", "info")
		xPlayer.addMoney(amount* Config.prices.lvl3)
		TriggerClientEvent("methjob_notify", _source, "You sold! " .. amount ..  " meth for " .. amount* Config.prices.lvl3 .. " $", "Success")
	elseif result[1].lvl == 5 or result[1].lvl == 6 or result[1].lvl == 7 or result[1].lvl == 8 then
		TriggerClientEvent("methjob_notify", _source, "This is good men! I like this stuff. I will pay " .. Config.prices.lvl5 ..  " per each Meth", "info")
		xPlayer.addMoney(amount* Config.prices.lvl5)
		TriggerClientEvent("methjob_notify", _source, "You sold! " .. amount ..  " meth for " .. amount* Config.prices.lvl5 .. " $", "Success")
	else
		TriggerClientEvent("methjob_notify", _source, "This stuff is fukkin amazing! I love it men! " .. Config.prices.lvl10 ..  " per each Meth", "info")
		xPlayer.addMoney(amount* Config.prices.lvl10)
		TriggerClientEvent("methjob_notify", _source, "You sold! " .. amount ..  " meth for " .. amount* Config.prices.lvl10 .. " $", "Success")
	end
	xPlayer.removeInventoryItem('meth', amount)
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
