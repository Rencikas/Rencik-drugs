---Thanks haroki for help you dumb fuck :)
local playersProcessingCannabis = {}
local outofbound = true
local alive = true

RegisterServerEvent('RN-drugs:pickedUpCannabis')
AddEventHandler('RN-drugs:pickedUpCannabis', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local weed = Config.GiveWeed
	if xPlayer.canCarryItem(Config.WeedItem, weed) then
		xPlayer.addInventoryItem(Config.WeedItem, weed)
	else
		TriggerClientEvent('RN-drugs:send:notification', source, Config.Languages['weed_picking_full'])
	end
end)

RegisterServerEvent('RN-drugs:outofbound')
AddEventHandler('RN-drugs:outofbound', function()
	outofbound = true
end)

RegisterServerEvent('RN-drugs:quitprocess')
AddEventHandler('RN-drugs:quitprocess', function()
	can = false
end)

ESX.RegisterServerCallback('RN-drugs:cannabis_count', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xCannabis = xPlayer.getInventoryItem(Config.WeedItem).count
	cb(xCannabis)
end)

RegisterServerEvent('RN-drugs:processCannabis')
AddEventHandler('RN-drugs:processCannabis', function()
    if not playersProcessingCannabis[source] then
		local _source = source
		local xPlayer = ESX.GetPlayerFromId(_source)
		local xCannabis = xPlayer.getInventoryItem(Config.WeedItem)
		local can = true
		outofbound = false
		 if xCannabis.count > 3 then	
		  while outofbound == false and can do
			 if playersProcessingCannabis[_source] == nil then
				 playersProcessingCannabis[_source] = ESX.SetTimeout(Config.ProcessingTime.WeedProcessing , function()
					if xCannabis.count > 3 then			
						if xPlayer.canSwapItem(Config.WeedItem, 3, Config.ProcessedWeedItem, 1) then
							xPlayer.removeInventoryItem(Config.WeedItem, 3)
							  xPlayer.addInventoryItem(Config.ProcessedWeedItem, 1)
							 TriggerClientEvent('RN-drugs:send:notification', _source, Config.Languages['weed_processed'])			  
								else
								  can = false					
								   TriggerClientEvent('RN-drugs:send:notification', _source, Config.Languages['weed_processingfull'])		
									TriggerEvent('RN-drugs:cancelProcessing')
								   end
								 else						
								can = false
							TriggerClientEvent('RN-drugs:send:notification', _source, Config.Languages['weed_processingenough'])		
							   TriggerEvent('RN-drugs:cancelProcessing')
								end				        
							   playersProcessingCannabis[_source] = nil
							   end)
							 else
						  Wait(Config.ProcessingTime.WeedProcessing)
					  end	
				  end
			  else
			   TriggerClientEvent('RN-drugs:send:notification', _source, Config.Languages['weed_processingenough'])	
				TriggerEvent('RN-drugs:cancelProcessing')
			   end				
		   else
		   print(('RN-drugs: %s attempted to exploit weed processing!'):format(GetPlayerIdentifiers(source)[1]))
	   end 
  end)

function CancelProcessing(playerId)
	if playersProcessingCannabis[playerId] then
		ESX.ClearTimeout(playersProcessingCannabis[playerId])
		playersProcessingCannabis[playerId] = nil
	end
end

RegisterServerEvent('RN-drugs:cancelProcessing')
AddEventHandler('RN-drugs:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)

RegisterServerEvent("RN-drugs:sell")
AddEventHandler("RN-drugs:sell", function(itemName, amount, price)
    local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem(itemName)
	local location = GetEntityCoords(GetPlayerPed(source))
	local locationItem = Config.Drugs[least]
    local amount = tonumber(amount)
	for k, v in pairs(Config.dealer) do
	    local Dealer = vector3(v.DealerCoords.x, v.DealerCoords.y, v.DealerCoords.z)
	    local dist = #(Dealer - location)
		     if dist < 3 then
	           if amount <= Config.DealerMaxCanBuy then	
		        TriggerClientEvent('RN-drugs:send:notification', source, Config.Languages['Done_deal'])			
	          else
		        TriggerClientEvent('RN-drugs:send:notification', source, Config.Languages['you_cant_sell_20'])	
	        end	
	           if (item.count < amount) then
		        TriggerClientEvent('RN-drugs:send:notification', source, Config.Languages['you_dont_have_enough'])
	       elseif amount <= Config.DealerMaxCanBuy then 	
		     xPlayer.removeInventoryItem(item.name, amount) 	 
		        if Config.GiveBlack then
			       xPlayer.addAccountMoney('black_money', price)
		        else
			      xPlayer.addMoney(price)
		      end
	       end
	    end
     end
 end)