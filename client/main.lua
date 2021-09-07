
ESX              = nil
local PlayerData = {}
local display = false
local display1 = false
local setting = false
talking = false
cooking = false
local setted = false
good = false
Answering = false
check = false
selling = false
onGround = false
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


function loadAnimDict( dict )
    while ( not HasAnimDictLoaded( dict ) ) do
        RequestAnimDict( dict )
        Citizen.Wait( 5 )
    end
end 


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterCommand('random', function(source, args)
    print(Config.SpawnPosition[GetRandomIntInRange(1, #Config.SpawnPosition)])
  
end, false)


Citizen.CreateThread(function()
    RequestModel( GetHashKey( "a_m_y_business_02" ) )
	while not HasModelLoaded("a_m_y_business_02") do
		Wait(1)
	end
    local ped = CreatePed(4, GetHashKey( "a_m_y_business_02" ), Config.DealerPosition[1].x, Config.DealerPosition[1].y, Config.DealerPosition[1].z, 0, false, true)
    FreezeEntityPosition(ped, true)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	TaskStartScenarioInPlace(ped, "WORLD_HUMAN_COP_IDLES", 0, true)
	local pos1 = GetEntityCoords(ped)
	while not talking do
		Wait(3)
		local pos2 = GetEntityCoords(GetPlayerPed(-1))
		local distance = GetDistanceBetweenCoords(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z, true)
		if distance < 5 then
		ESX.Game.Utils.DrawText3D(GetEntityCoords(ped), "[E] Talk with this guy", 0.4)
		if (IsControlJustPressed(0,38)) then
			Notify("What do you want?!", "info")
			talking = true
		end
	end

	while talking do
		Wait(3)
		local pos1 = GetEntityCoords(ped)
		local pos2 = GetEntityCoords(GetPlayerPed(-1))
		local distance = GetDistanceBetweenCoords(pos1.x, pos1.y, pos1.z, pos2.x, pos2.y, pos2.z, true)
		if distance < 5 then
		ESX.Game.Utils.DrawText3D(GetEntityCoords(ped), "[E] Sell Drugs [N] Fuck you Dog!", 0.4)
		if IsControlJustPressed(0,306) then
			Notify("You pissed me off! Get the fuck out of I will kill you!", "info")
			talking = false
			print(talking)
			break
		else if IsControlJustPressed(0,38) and not selling then
			local destination = Config.DeliveryPoints[GetRandomIntInRange(1, #Config.DeliveryPoints)]
			selling = true
			talking = false
			Selling(destination)
			break
		else if IsControlJustPressed(0,38) and selling then
			Notify("I just gave you destination! Go and Sell it!")
			talking = false
			break
				end
			end
		end
	end
end
end
end)

function Selling(destination)
		Notify("Get you ass in the vehicle, and go there!", "success")
			SetNewWaypoint(destination.x, destination.y)
			RequestModel("Burrito3")
			while not HasModelLoaded("Burrito3") do
				Wait(1)
			end
			local vehicle = CreateVehicle("Burrito3", Config.CarSpawnPosition[1].x,  Config.CarSpawnPosition[1].y , Config.CarSpawnPosition[1].z , 1,  true, false)
			SetVehicleOnGroundProperly(vehicle)
			SetVehicleDoorsLocked(vehicle , 1)
			
			while selling do
				Wait(1)
				local pos = GetEntityCoords(GetPlayerPed(-1))
				local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, destination.x, destination.y, destination.z, true)
				if distance < 30 and IsPedInVehicle(GetPlayerPed(-1), vehicle, true) then
					ESX.Game.Utils.DrawText3D(destination, "[E]Deliver Drugs!", 2.0)
					if(IsControlJustPressed(0,38)) then
						selling = false
						Notify("Selling, please wait!", "info")
						Wait(10000)
						TriggerServerEvent("Sell")
						DeleteVehicle(vehicle)
					end
				end
			end
			
end




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

exports("Notify", Notify)

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
  	Notify(" You're already cooking man!","error" )
  end
end)

RegisterNetEvent("methjob_place")
AddEventHandler("methjob_place", function(source)
	loadAnimDict('amb@medic@standing@kneel@base')
	  loadAnimDict('anim@gangops@facility@servers@bodysearch@')
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
		onGround = true
	DetachEntity(PackageObject, 1, 1)
	PlaceObjectOnGroundProperly(PackageObject)
	FreezeEntityPosition(PackageObject, true)
	TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
		TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false)
	Notify("Setting table ...", "info")
	Wait(6000)		
	setting = false
	Notify("Table setted successfuly!", "success")
	ClearPedTasksImmediately(GetPlayerPed(-1))
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
		ESX.Game.Utils.DrawText3D(GetEntityCoords(PackageObject), "Press [E] to cook, Press [N] to hide table", 0.7)
		if(IsControlJustPressed(0,38)) then
				setted = false
				TriggerEvent("methjob_start", PackageObject)
				break
		elseif IsControlJustPressed(0,306) then
			TaskPlayAnim(GetPlayerPed(-1), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
		TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false)
		Notify("Hiding table ...", "info")
		Wait(6000)
		Notify("Table hided sucessfuly!", "success")
		ClearPedTasksImmediately(GetPlayerPed(-1))
			DetachEntity(PackageObject, 1, 1)
			DeleteObject(PackageObject)
			setted = false
			TriggerServerEvent("AddTable")
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
	loadAnimDict('amb@medic@standing@kneel@base')
		TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
    Answering = false
    SetDisplay(false,"null")
    Notify("Great job! Looks like it worked", "success")
    Smoke(data.object)
end)

RegisterNUICallback("error", function(data)
	loadAnimDict('amb@medic@standing@kneel@base')
		TaskPlayAnim(GetPlayerPed(-1), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )
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
