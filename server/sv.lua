local PlayerPoubelle = {}

    RegisterServerEvent('envi-dumpsterdive:rewards') 
    AddEventHandler('envi-dumpsterdive:rewards', function(luck)
        local _source = source
        local xPlayer  = ESX.GetPlayerFromId(source)
        local common = CFGpooubelle.CommonRewards[math.random(#CFGpooubelle.CommonRewards)]
        local uncommon = CFGpooubelle.UncommonRewards[math.random(#CFGpooubelle.UncommonRewards)]
        local rare = CFGpooubelle.RareRewards[math.random(#CFGpooubelle.RareRewards)]
        local identifier = xPlayer.identifier

        if not PlayerPoubelle[identifier] or os.time() > PlayerPoubelle[identifier] then
            if luck <= 14 then
                local common = CFGpooubelle.CommonRewards[math.random(#CFGpooubelle.CommonRewards)]
                xPlayer.addInventoryItem(common,math.random(1, math.ceil(CFGpooubelle.MaxCommonReward/3)))
                local common = CFGpooubelle.CommonRewards[math.random(#CFGpooubelle.CommonRewards)]
                xPlayer.addInventoryItem(common,math.random(1, math.ceil(CFGpooubelle.MaxCommonReward/3)))
                local common = CFGpooubelle.CommonRewards[math.random(#CFGpooubelle.CommonRewards)]
                xPlayer.addInventoryItem(common,math.random(1, math.ceil(CFGpooubelle.MaxCommonReward/3)))
            elseif luck >= 14 and luck < 20 then
                xPlayer.addInventoryItem(common,math.random(1, math.ceil(CFGpooubelle.MaxCommonReward/2)))
                xPlayer.addInventoryItem(uncommon,math.random(1, CFGpooubelle.MaxUncommonReward))
            elseif luck == 20 then
                xPlayer.addInventoryItem(common,math.random(1, math.ceil(CFGpooubelle.MaxCommonReward/2)))
                xPlayer.addInventoryItem(rare,math.random(1, CFGpooubelle.MaxRareReward))
            end
            PlayerPoubelle[identifier] = os.time() + CFGpooubelle.Cooldown
        else
            -- on cooldown
        end
    end)

RegisterNetEvent("envi-dumpsterdive:Server:SyncEffect", function(pos)
    TriggerClientEvent("envi-dumpsterdive:Client:SyncEffect", -1, pos)
end)

RegisterServerEvent("ESXFramework:garbage:deleteItem")
AddEventHandler("ESXFramework:garbage:deleteItem", function(itemName, itemMetadata, quantity)
    local _source = source

    -- Vérifier si l'objet existe dans l'inventaire du joueur
    local player = ESX.GetPlayerFromId(_source)
    local item = player.getInventoryItem(itemName)

    if item ~= nil and item.count >= quantity then
        -- Supprimer l'objet de l'inventaire du joueur
        player.removeInventoryItem(itemName, 1)

        -- Exemple de notification côté serveur pour indiquer que l'objet a été supprimé
        print(("L'objet %s a été supprimé, quantité : %s"):format(itemName, 1))
    else
        -- Si l'objet n'existe pas ou si la quantité est insuffisante, envoyer une notification au joueur
        TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas suffisamment de cet objet.")
    end
end)

RegisterServerEvent("ESXFramework:garbage:deleteWeapon")
AddEventHandler("ESXFramework:garbage:deleteWeapon", function(weaponIndex)
    local _source = source

    -- Récupérer le joueur qui a déclenché l'événement
    local player = ESX.GetPlayerFromId(_source)

    -- Vérifier si l'index de l'arme est valide
    if weaponIndex and player then
        -- Récupérer les armes du joueur
        local weapons = player.getLoadout()

        -- Vérifier si l'arme existe à l'index donné
        if weapons and weapons[weaponIndex] then
            -- Supprimer l'arme à l'index donné
            local weaponName = weapons[weaponIndex].name
            player.removeWeapon(weaponName)

            -- Exemple de notification côté serveur pour indiquer que l'arme a été supprimée
            print(("L'arme %s a été jetée dans une poubelle"):format(weaponName))
        else
            -- Si l'arme n'existe pas, envoyer une notification au joueur
            TriggerClientEvent('esx:showNotification', _source, "Cette arme n'existe pas.")
        end
    else
        -- Si l'index de l'arme ou le joueur est invalide, envoyer une notification au joueur
        TriggerClientEvent('esx:showNotification', _source, "Une erreur est survenue.")
    end
end)