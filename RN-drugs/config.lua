Config = {}
---- config target system
Config.qtarget = false
Config.BtTarget = true
----- Weed stuff
Config.PickingTime = 3000
Config.ProcessingTime = {WeedProcessing = 2000 * 7}
Config.GiveWeed = math.random(2,4) 
Config.WeedItem = "cannabis"
Config.ProcessedWeedItem = "marijuana"
---- dealer
Config.GiveBlackMoney = true
Config.DealerMaxCanBuy = 30
Config.DealerPed = "csb_car3guy2"
--- Target distance
Config.WeedTargetDistance = 1.5
Config.WeedProcessingTargetDistance = 1.5
Config.WeedDealerTargetDistance = 1.5
---- Icon website https://fontawesome.com/v5.15/icons/user-secret?style=solid
Config.WeedPickIcon = "fas fa-seedling"
Config.WeedProcessIcon = "fas fa-fan"
Config.WeedDrugDealerIcon = "fas fa-user-secret"
--- Target Dev Zone debug
Config.WeedProcessZoneDebug = false
Config.WeedDrugDealerZoneDebug = false
----- toggle blips
Config.LocationBlips = true

----- blip zoones
Config.Blips = {
	{name="Weed Field", color = 25, scale = 1.3, id = 496, x = 2534.1, y = 4817.5, z = 34},  
	{name="Drug Dealer", color = 25, scale = 1.3, id = 467, x = 2329.02, y = 2571.29, z = 46.68}, 
	{name="Weed Processing", color = 25, scale = 1.3, id = 671, x = -1183.4, y = -1556.5, z = 5.1}, 
}
---- drug dealers npc coords
Config.dealer = {
    {DealerCoords = vector3(-1183, -1556.8, 4.1), h = 120.64}  
}
---- items that drug dealer buys
Config.Drugs = {
   {label = 'Marijuana - 50$', name = 'marijuana', price = 50},
   {label = 'Example - 10$', name = 'Example', price = 100}, 
}
 ---- weed Picking spot
 Config.WeedZones = {
	WeedField = {coords = vector3(2534.1, 4817.5, 34), radius = 200.0},
}

 ---- weed Processing spot
Config.WeedProcessing = {
	[1] = {
     WeedProcessing = vector3(2329.02, 2571.29, 46.68),
   }
 }
---- Languages
Config.Languages = {
--- target text
    ['Processing_weed'] = 'Process weed',
    ['Pick_weed'] = 'Pick weed',
    ['drug_dealer'] = 'Drug dealer',
--- progressbar text
    ['Processing_weed_progressbar'] = 'Processing weed...',
    ['Picking_weed_progressbar'] = 'Picking weed...',
	--- Drug Dealer menu text
    ['input_amount'] = 'Add Amount',
    ['amount_sell'] = 'Amount to sell',
---- dealer notifications
	['Done_deal'] = 'You sold your stuff...',
	['you_cant_sell_20'] = 'you cant sell more than 20 items',
	['you_dont_have_enough'] = 'You dont have that amount',
--- processing notifications
	['weed_processing_started'] = 'processing ~g~Cannabis~s~ into ~g~Marijuana~s~...',
	['weed_processingfull'] = 'processing ~r~canceled~s~ due to full inventory!',
	['weed_processing_too_far'] = 'the processing has been ~r~canceled~s~ due to you abandoning the area.',
	['weed_processed'] = 'you\'ve processed ~b~3x~s~ ~g~Cannabis~s~ to ~b~1x~s~ ~g~Marijuana~s~',
	['weed_processingenough'] = 'you must have ~b~3x~s~ ~g~Cannabis~s~ in order to process.',
--- picking notifications
	['weed_picking_full'] = 'you do not have any more inventory space for ~g~Cannabis~s~.',
}
----- add your notification code, or leave it blank ¯\_(ツ)_/¯
function SendNotification(notification)
	ESX.ShowNotification(notification)
end