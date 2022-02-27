local DrugDealer = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k, v in pairs(Config.dealer) do
			local DealerCoordsped = GetEntityCoords(PlayerPedId())	
			local dist = #(v.DealerCoords - DealerCoordsped)			
			if dist < 11 and DrugDealer == false then
				TriggerEvent('RN-drugs:npc:dealer',v.DealerCoords,v.h)
				ped = true
			end
			if dist >= 10  then
				DrugDealer = false
				DeletePed(DealerPed)
			end
		end
	end
end)

RegisterNetEvent("RN-drugs:send:notification", function(notification)
	SendNotification(notification)
end)

Citizen.CreateThread(function()
for k, v in pairs(Config.dealer) do
	if Config.BtTarget then
		exports['bt-target']:AddCircleZone("RN-drugs:dealer".. k, vector3(v.DealerCoords.x, v.DealerCoords.y, 5.2), 1.00, {
			name="RN-drugs:dealer",
			debugPoly=Config.WeedDrugDealerZoneDebug,
			useZ=true,
		}, {
			options = {
				{
					event = "RN-drugs:drug:dealer",
					icon = Config.WeedDrugDealerIcon,
					label = Config.Languages['drug_dealer'],
				}, 
			},   
			job = {"all"},        
			distance = Config.WeedDealerTargetDistance
		})
		elseif Config.qtarget then
			exports['qtarget']:AddCircleZone("RN-drugs:dealer".. k, vector3(v.DealerCoords.x, v.DealerCoords.y, 5.2), 1.00, {
				name="RN-drugs:dealer",
				debugPoly= Config.WeedDrugDealerZoneDebug,
				useZ=true,
				options = {
					{
						event = "RN-drugs:drug:dealer",
						icon = Config.WeedDrugDealerIcon,
						label = Config.Languages['drug_dealer'], 				                             
					},
				},  
				distance = Config.WeedDealerTargetDistance
			})
		end
	end
end)

RegisterNetEvent('RN-drugs:npc:dealer',function(coords,heading)
	local hash = GetHashKey(Config.DealerPed)
	if not HasModelLoaded(hash) then
		RequestModel(hash)
		Wait(10)
	end
	while not HasModelLoaded(hash) do 
		Wait(10)
	end
    DrugDealer = true
	DealerPed = CreatePed(5, hash, coords, heading, false, false)
	FreezeEntityPosition(DealerPed, true)
    SetBlockingOfNonTemporaryEvents(DealerPed, true)
end)

RegisterNetEvent('RN-drugs:drug:dealer', function()
    for k,v in pairs(Config.Drugs) do
        local Drugs = {}
        table.insert(Drugs, {
            id = k,
            header = v.label,
            txt = '',
            params = {
                event = 'RN-drugs:sell:amount',
                args = {
                    name = v.name,
                    price = v.price
                }
            }
        })
        TriggerEvent('nh-context:sendMenu',Drugs)
    end    
end)

RegisterNetEvent('RN-drugs:sell:amount', function(data)    
    local keyboard = exports["nh-keyboard"]:KeyboardInput({
        header = Config.Languages['input_amount'], 
        rows = {
            {
                id = 0, 
                txt = Config.Languages['amount_sell'],
            }
        }
    })
    if keyboard ~= nil then		
		TriggerServerEvent('RN-drugs:sell',data.name,keyboard[1].input,data.price)
    end   
end)  