  
ESX              = nil
local PlayerData = {}
local display = false
local display1 = false
local setting = false
cooking = false
local setted = false
good = false
Answering = false
check = false
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)
RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)


local options = {
{
	["Names"] = "Acetone", 
	["Warnings"]= {"WARNING: Substance becomes hard!", "WARNING: The substance is too bright!", "WARNING:The substance smells like HBrO3!", "WARNING: A vial with vodka has fallen into the substance!"}
},
{
	["Names"] = "Pseudoefedryna", 
	["Warnings"]= {"WARNING:The substance changes its color to raspberry!", "WARNING: Substance gives off a strange gas!", "WARNING: Substance foams!", "WARNING: The substance becomes whiter!"}
},
{
	["Names"] = "Raise", 
	["Warnings"]= {"WARNING: Substance is too cold!", "WARNING: The pressure is dropping in the vessel!","WARNING: The substance has the taste of alcohol!","WARNING: The substance is sticky!"}
},
{
	["Names"] = "Down", 
	["Warnings"]= {"WARNING: You're running out of gas!","WARNING: The vessel turns red!","WARNING: The substance starts to boil!","WARNING: The substance is too liquid!"}
},
{
	["Names"] = "preasure", 
	["Warnings"]= {"WARNING: There is a crack on the vessel!","WARNING: The vessel starts to whistle!", "WARNING: It's about to explode!", "WARNING: Substance flows out too quickly!"}
},
}

function Explode(PackageObject)
  ped = GetPlayerPed(-1)
  local currentPos = GetEntityCoords(ped)
  explode = math.random(10)
  if(explode <= Config.chance.chance/10) then
  AddExplosion(currentPos.x, currentPos.y, currentPos.z, EXPLOSION_GAS_TANK, 500.0, true, true, true) --Explode player, not table, so if you would like to run and don't care about your table, you will be one who will explode, not table.
  DeleteObject(PackageObject)
  	check = true
  	cooking = false
  	FreezeEntityPosition(ped, false)
  else
  	Smoke(PackageObject)
	end
end

function Notify(message, option) -- There are 4 options : success, info, warn, error
	SendNUIMessage({
        type = "notify",
       	message = message,
       	option = option,
    })
	end

RegisterNetEvent("methjob_notify")
AddEventHandler("methjob_notify", function(message, option)
	Notify(message, option)
end)


RegisterNetEvent("methjob_start")
AddEventHandler("methjob_start", function(PackageObject)
	if not cooking then
	ped = GetPlayerPed(-1)
	cooking = true
  	StartCooking(PackageObject)
  else
  	ESX.ShowNotification("~r~You're already cooking man!")
  end
end)

RegisterNetEvent("methjob_place")
AddEventHandler("methjob_place", function(source)
	if not cooking then
	local ped = GetPlayerPed(-1)
  		local pos = GetEntityCoords(ped)
  		local vector = GetEntityForwardVector(ped)
  		heading = GetEntityHeading(ped)
		local PackageObject = CreateObject(GetHashKey("prop_ven_market_table1"), pos.x + (vector.x), pos.y + (vector.y), pos.z-1.0, true)
		SetEntityHeading(PackageObject, heading)
		if(vector.x<0.0) then
		AttachEntityToEntity(PackageObject, ped, GetPedBoneIndex(ped,  37193), -1.5*vector.x, 0.0, -1.0, 180.0, 180.0, 90.0, 1, 1, 0, 1, 0, 1)
	else 
		AttachEntityToEntity(PackageObject, ped, GetPedBoneIndex(ped,  37193), 1.5* vector.x, 0.0, -1.0, 180.0, 180.0, 90.0, 1, 1, 0, 1, 0, 1)
	end
	TriggerServerEvent("DeleteTable")
	setting = true
	while setting do
		Citizen.Wait(0)
	ESX.Game.Utils.DrawText3D(GetEntityCoords(GetPlayerPed(-1)), "[E] Place table, [N] Put in Backpack", 0.4)
	if(IsControlJustPressed(0,38)) then
	DetachEntity(PackageObject, 1, 1)
	PlaceObjectOnGroundProperly(PackageObject)
	FreezeEntityPosition(PackageObject, true)
	setting = false
	setted = true
	break
		elseif IsControlJustPressed(0,306) then
			DetachEntity(PackageObject, 1, 1)
			DeleteObject(PackageObject)
			setting = false
			TriggerServerEvent("AddTable")
		break
	end
end
local pos2 = GetEntityCoords(PackageObject)
	while setted do
		Citizen.Wait(0)
		pos = GetEntityCoords(ped)
		local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z, true)
			if(distance<5) then
		ESX.Game.Utils.DrawText3D(GetEntityCoords(PackageObject), "Press [E] to cook", 0.7)
		if(IsControlJustPressed(0,38)) then
				setted = false
				TriggerEvent("methjob_start", PackageObject)
				break
			end
		end
	end
end
end)

function StartCooking(PackageObject)
		Notify("Cooking starts right now!", "info")
			FreezeEntityPosition(ped, true)
			local count = Config.count.count
			check = false
			local amount = math.random(Config.amount.Methamount)
			local xp = math.random(30)
			local dead = IsEntityDead(GetPlayerPed(-1))
	while cooking and not dead do
		Wait(15000)
		local random = math.random(#options)
		local WanterAnswer = options[random]["Names"]
			for i,v in ipairs(options) do
				if options[i]["Names"] == WanterAnswer then
					local random1 = math.random(#options[i]["Warnings"])
     		 Notify((options[i]["Warnings"][random1]), "warn")
    		end
    	end
		Answering = true
		SetDisplay(true, WanterAnswer, PackageObject)
		Wait(Config.time.time)
		if Answering then
			 Notify("You didn't get on time! You're table is gone", "error")
			 DeleteObject(PackageObject)
			 SetDisplay(false)
			 FreezeEntityPosition(ped, false)
			 cooking = false
			 break
        end
				if(check == true) then
			break
		end
		count = count-1
		if count<1 then
			DeleteObject(PackageObject)
			TriggerServerEvent("Update", xp, amount)
			cooking = false
			FreezeEntityPosition(ped, false)
			break
			return
		end
	end
end


function Smoke(obj)
	pos = GetEntityCoords(obj)
		SetPtfxAssetNextCall("core")
  		local smoke = StartParticleFxLoopedAtCoord("exp_grd_flare", pos.x, pos.y, pos.z-1.0, 0.0, 0.0, 0.0, 2.0, false, false, false, false)
		SetParticleFxLoopedAlpha(smoke, 0.5)
		SetParticleFxLoopedColour(smoke, 0.0, 0.0, 0.0, 0)
		Wait(10000)
		StopParticleFxLooped(smoke, 0)
	end

RegisterNUICallback("success", function(data)
    Answering = false
    SetDisplay(false,"null")
    Notify("Great job! Looks like it worked", "success")
    Smoke(data.object)
end)

RegisterNUICallback("error", function(data)
	Answering = false
    SetDisplay(false, "null")
    Notify("Ups! Seems like It didn't work", "error")
    Explode(data.object)
end)

function SetDisplay(bool, Answer, PackageObject)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
        answer = Answer,
        object = PackageObject,
    })
end

RegisterNetEvent("methjob_update")
AddEventHandler("methjob_update", function(percentage, xp)
	ProgressBar(true, percentage, xp)
end)

RegisterNUICallback("destroy", function(data)
		print('Rozjebaned');
end)

function ProgressBar(bool1, percentage, text)
	 display1 = bool1
    SendNUIMessage({
        type = "bar",
        status = bool1,
        percentage = percentage,
        word = "+ " .. text .. "xp",
    })
end



Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)
