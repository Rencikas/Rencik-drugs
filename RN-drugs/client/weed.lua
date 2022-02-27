local spawnedWeeds = 0
local weedPlants = {}
local isPickingUp, isProcessing = false, false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		local coords = GetEntityCoords(PlayerPedId())

		if GetDistanceBetweenCoords(coords, Config.WeedZones.WeedField.coords, true) < 50 then
			SpawnWeedPlants()
		end
	end
end)

Citizen.CreateThread(function()
 local WeedProp = {`prop_weed_02`}
  if Config.BtTarget then
  exports['bt-target']:AddTargetModel(WeedProp, {
	options = {
		{
			event = "RN-drugs:pick:weed",
			icon = Config.WeedPickIcon,
			label = Config.Languages['Pick_weed'], 				                             
		},
	},  
	job = {"all"},
	distance = Config.WeedTargetDistance
})
elseif Config.qtarget then
	exports['qtarget']:AddTargetModel(WeedProp, {
		options = {
			{
				event = "RN-drugs:pick:weed",
				icon = Config.WeedPickIcon,
				label = Config.Languages['Pick_weed'], 				                             
			},
		},  
		distance = Config.WeedTargetDistance
      })
    end
end)
Citizen.CreateThread(function()
	for k, v in pairs(Config.WeedProcessing) do
	  if Config.BtTarget then
		exports['bt-target']:AddCircleZone("Rencik-drugs:process:weed".. k, vector3(v.WeedProcessing.x,v.WeedProcessing.y,v.WeedProcessing.z), 1.00, {
			name="Rencik-drugs:process:weed",
			debugPoly= Config.WeedProcessZoneDebug,
			useZ=true,
			}, {
				options = {
					{
						event = "RN-drugs:process:weed",
						icon = Config.WeedProcessIcon,
						label = Config.Languages['Processing_weed'],
					},                  
		
				},   
				job = {"all"},        
				distance = Config.WeedProcessingTargetDistance
			})
		elseif Config.qtarget then
			exports['qtarget']:AddCircleZone("Rencik-drugs:process:weed".. k, vector3(v.WeedProcessing.x,v.WeedProcessing.y,v.WeedProcessing.z), 1.00, {
				name="Rencik-drugs:process:weed",
				debugPoly= Config.WeedProcessZoneDebug,
				useZ=true,
				}, {
					options = {
						{
							event = "RN-drugs:process:weed",
							icon = Config.WeedProcessIcon,
							label = Config.Languages['Processing_weed'],
						},                  
			
					},	       
					distance = Config.WeedProcessingTargetDistance
				})
			end
		end
	end)

RegisterNetEvent('RN-drugs:process:weed', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	for k, v in pairs(Config.WeedProcessing) do
	if GetDistanceBetweenCoords(coords, v.WeedProcessing.x,v.WeedProcessing.y,v.WeedProcessing.z, true) < 1 then
		if not isProcessing then
		     end		
				ESX.TriggerServerCallback('RN-drugs:cannabis_count', function(xCannabis)
					ProcessWeed(xCannabis)
				end)				
			end		
        end
    end)
RegisterNetEvent('RN-drugs:pick:weed', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID
		for i=1, #weedPlants do
			if #(coords - GetEntityCoords(weedPlants[i])) < 3 then
				nearbyObject, nearbyID = weedPlants[i], i
			end
		end
		if nearbyObject and IsPedOnFoot(playerPed) then
			if not isPickingUp then
			   isPickingUp = true 
					TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
					exports.rprogress:Custom({
					   Duration = Config.PickingTime,
						Label = Config.Languages['Picking_weed_progressbar'],                            
						DisableControls = {
							Mouse = false,
							Player = true,
							Vehicle = true
							 }
							})
							Wait(Config.PickingTime)                    
							ClearPedTasksImmediately(playerPed)        
							isPickingUp = false
							ESX.Game.DeleteObject(nearbyObject)
			
							table.remove(weedPlants, nearbyID)
							spawnedWeeds = spawnedWeeds - 1
			
							TriggerServerEvent('RN-drugs:pickedUpCannabis')
						else
							SendNotification(Config.Languages['weed_picking_full']) 
						end 			
					end
				end)

function ProcessWeed(xCannabis)
	isProcessing = true
	SendNotification(Config.Languages['weed_processing_started'])
	exports.rprogress:Custom({
		Duration = Config.ProcessingTime.WeedProcessing,
		Label = Config.Languages['Processing_weed_progressbar'],	
		Animation = {
			scenario = "PROP_HUMAN_PARKING_METER",
			animationDictionary = "idle_a",
		},						
		DisableControls = {
			Mouse = false,
			Player = true,
			Vehicle = true
		}
	})
  TriggerServerEvent('RN-drugs:processCannabis')
	if(xCannabis <= 3) then
		xCannabis = 0
	end
  local timeLeft = (Config.ProcessingTime.WeedProcessing * xCannabis) 
	local playerPed = PlayerPedId()

	while timeLeft > 0 do
		timeLeft = timeLeft - 1
		for k, v in pairs(Config.WeedProcessing) do
		if GetDistanceBetweenCoords(GetEntityCoords(playerPed), v.WeedProcessing.x,v.WeedProcessing.y,v.WeedProcessing.z, false) > 4 then
			SendNotification(Config.Languages['weed_processing_too_far'])
			TriggerServerEvent('RN-drugs:cancelProcessing')
			TriggerServerEvent('RN-drugs:outofbound')
			break
		end
	end
end
	isProcessing = false
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(weedPlants) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnWeedPlants()
	while spawnedWeeds < 25 do
		Citizen.Wait(0)
		local weedCoords = GenerateWeedCoords()

		ESX.Game.SpawnLocalObject('prop_weed_02', weedCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(weedPlants, obj)
			spawnedWeeds = spawnedWeeds + 1
		end)
	end
end

function ValidateWeedCoord(plantCoord)
	if spawnedWeeds > 0 then
		local validate = true

		for k, v in pairs(weedPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.WeedZones.WeedField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateWeedCoords()
	while true do
		Citizen.Wait(1)

		local weedCoordX, weedCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)

		weedCoordX = Config.WeedZones.WeedField.coords.x + modX
		weedCoordY = Config.WeedZones.WeedField.coords.y + modY

		local coordZ = GetCoordZ(weedCoordX, weedCoordY)
		local coord = vector3(weedCoordX, weedCoordY, coordZ)

		if ValidateWeedCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 48.0, 49.0, 50.0, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end

Citizen.CreateThread(function()	
	for i=1, #Config.Blips, 1 do
	  if Config.LocationBlips then
		local blip = AddBlipForCoord(Config.Blips[i].x, Config.Blips[i].y, Config.Blips[i].z)
		SetBlipSprite (blip, Config.Blips[i].id)
		SetBlipDisplay(blip, 4)
		SetBlipColour (blip, Config.Blips[i].color)
		SetBlipScale (blip, Config.Blips[i].scale)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Blips[i].name)
		EndTextCommandSetBlipName(blip)
	  end
   end
end)

