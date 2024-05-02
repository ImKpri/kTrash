local dumpys = {-387405094,364445978,-515278816,-1340926540,-1831107703,1605769687,388197031,-1790177567,-876149596}

local diving = false
local searching = false
local onCooldown = false


local function LoadPbl(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

if CFGpooubelle.Target == true then
function DrawText3DPBK(coords, text, scale)
    local onScreen,_x,_y=World3dToScreen2d(coords.x,coords.y,coords.z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(scale, scale)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 700
    DrawRect(_x,_y+0.0150, 0.015+ factor, 0.03, 0, 0, 0, 68)
end


local propModels = {
    1437508529, 666561306, -58485588, 218085040, -206690185,
    1143474856, -130812911, 1614656839, 1511880420, 1329570871, -1096777189
}
local props = {
    -387405094, 364445978, -515278816, -1340926540, -1831107703,
    1605769687, 388197031, -1790177567, -876149596
}

local function canInteractWithProp(entity, distance)
    local targetCoords = GetEntityCoords(entity)
    local playerCoords = GetEntityCoords(PlayerPedId())
    return #(targetCoords - playerCoords) < distance
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, propHash in ipairs(props) do
            local prop = GetClosestObjectOfType(playerCoords, 5.0, propHash, false, false, false)
            if prop ~= 0 then
                local distance = #(playerCoords - GetEntityCoords(prop))
                if distance < 2.0 then
                    -- Affiche un message pour informer le joueur qu'il peut interagir avec le prop
                    DrawText3DPBK(GetEntityCoords(prop), "~b~Appuyez sur ~g~E~b~ pour plonger dans la benne", 0.4)

                    -- Vérifie si le joueur appuie sur la touche E et s'il est à proximité du prop
                    if IsControlJustPressed(0, 38) and canInteractWithProp(prop, 2.0) then
                        TriggerEvent('envi-dumpsterdive:goDiving', prop)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        for _, propModel in ipairs(propModels) do
            local prop = GetClosestObjectOfType(playerCoords, 5.0, propModel, false, false, false)
            if prop ~= 0 then
                local distance = #(playerCoords - GetEntityCoords(prop))
                if distance < 2.0 then
                    -- Affiche un message pour informer le joueur qu'il peut interagir avec le prop
                    DrawText3DPBK(GetEntityCoords(prop), "~b~Appuyez sur ~g~E~b~ pour ouvrir le menu", 0.4)

                    -- Vérifie si le joueur appuie sur la touche E et s'il est à proximité du prop
                    if IsControlJustPressed(0, 38) and canInteractWithProp(prop, 2.0) then
                        garbageOpenMenu()
                    end
                end
            end
        end
    end
end)
end

RegisterNetEvent('envi-dumpsterdive:goDiving', function(entity)
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local items_found = false
    if not diving or searching then
        searching = true
        LoadPbl('missexile3')
        TaskPlayAnim(ped, 'missexile3', 'ex03_dingy_search_case_b_michael', 8.0, 8.0, -1, 1, 0, false, false, false)
        RemoveAnimDict('missexile3')
        Wait(math.random(3000, 8000))
        SetPedDesiredHeading(ped, heading)
        Wait(1000)
        LoadPbl('move_crawl')
        searching = false
        diving = true
        TaskPlayAnim(ped, 'move_crawl', 'onfront_fwd', 8.0, 8.0, -1, 1, 0, false, false, false)
        RemoveAnimDict('move_crawl')
        Wait(math.random(2000, 3000))
        FreezeEntityPosition(ped, true)
        Wait(math.random(500, 1500))
        FreezeEntityPosition(ped, false)
        ClearPedTasks(ped)
        if not onCooldown then
            local luck = math.random(1, 20)
            if luck >= 8 then
                if DoesEntityExist(entity) then
                    TriggerServerEvent('envi-dumpsterdive:rewards', luck)
                   onCooldown = true
                    SetTimeout(CFGpooubelle.Cooldown * 1000, function()
                       onCooldown = false
                    end)
                    items_found = true
                else
                     TriggerServerEvent('envi-dumpsterdive:rewards', luck)
                   onCooldown = true
                    SetTimeout(CFGpooubelle.Cooldown * 1000, function()
                       onCooldown = false
                    end)
                    items_found = true
                end
            end
        end
    end
    diving = false
    if not items_found then
    
            ESX.ShowNotification("Rien d'intéressant ici..")
           
            return
        
    end
end)

RegisterNetEvent("envi-dumpsterdive:Client:SyncEffect", function(pos)
    UseParticleFxAssetNextCall("core")
	local ped = PlayerPedId()
	local forward = GetEntityForwardX(ped)
    local dirt = StartNetworkedParticleFxNonLoopedAtCoord("bul_sand_loose_heli", vector3(pos.x + forward*math.random(-1,1), pos.y, pos.z-1.03), 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0)
    Wait(math.random(250,1000))
    UseParticleFxAssetNextCall("core")
    local dust = StartNetworkedParticleFxNonLoopedAtCoord("ent_sht_paper_bails", vector3(pos.x + forward*math.random(-1,1), pos.y, pos.z-1.03), 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0)
end)

CreateThread(function()
	while true do
        local cooldown = 2500

		while diving do
            cooldown = 0
			local ped = PlayerPedId()
			local pos = GetEntityCoords(ped)
			TriggerServerEvent("envi-dumpsterdive:Server:SyncEffect", pos)
            Wait(1500)
		end

        Wait(cooldown)
	end
end)

function currentWeight()
	return GetCurrentWeight()
end



function garbageOpenMenu()
    FreezeEntityPosition(PlayerPedId(), true)
    bloquertouchejojo = true
    ESX.ShowNotification('[~r~INFO~w~] Pour cesser de fouiller dans la poubelle, veuillez retirer vos mains de celle-ci !')
    local menu = RageUI.CreateMenu('Poubelle', "Actions disponibles")
    RageUI.Visible(menu, true)
    while true do
        Citizen.Wait(0)

        RageUI.IsVisible(menu, function()

            ESX.PlayerData = ESX.GetPlayerData()

            RageUI.Separator(("%s / %s"):format(currentWeight(), ESX.PlayerData.maxWeight))
            RageUI.Separator("Objet(s)")

            for _, v in pairs(ESX.PlayerData.inventory) do
                --if not ESX.ContribItem(v.name) then return end
                if v.count > 0 then
                    RageUI.Button(("%s (%s)"):format(v.label, v.count),
                        "Si vous mettez un objet dans une poubelle il disparaitra définitivement",
                        { RightBadge = RageUI.BadgeStyle.Alert }, true, {
                            onSelected = function ()
                                local Confirm = KeyboardInput("Confirmer ?", "Oui / Non", 10)

                                if Confirm == "Oui" then 
                                    TriggerServerEvent("ESXFramework:garbage:deleteItem", v.name, v.metadata, 1)
                                    ExecuteCommand("me jete quelque chose dans une poubelle")
                                    RageUI.CloseAll() -- Fermer le menu après la suppression
                                    Citizen.Wait(500) -- Attendre un court instant
                                    garbageOpenMenu() -- Réouvrir le menu
                                else
                                    ESX.ShowNotification('Tu ne jette rien !')
                                end
                            end
                        }
                    )
                end
            end

            RageUI.Separator("Arme(s)")

            for i = 1, #ESX.PlayerData.loadout, 1 do
                --if not ESX.ContribWeapon(weapon.name) then return end
                local weapon = ESX.PlayerData.loadout[i]

                RageUI.Button(("%s"):format(weapon.label),
                    "Si vous mettez un objet dans une poubelle il disparaitra définitivement",
                    { RightBadge = RageUI.BadgeStyle.Alert }, true,
                    {
                        onSelected = function ()
                            TriggerServerEvent("ESXFramework:garbage:deleteWeapon", i)
                            ExecuteCommand("me jete quelque chose dans une poubelle")
                            RageUI.CloseAll() -- Fermer le menu après la suppression
                            Citizen.Wait(500) -- Attendre un court instant
                            garbageOpenMenu() -- Réouvrir le menu
                        end
                    }
                )
            end
            RageUI.Button("~r~Sortir ses mains de la poubelle", nil, {RightLabel = ">>"}, true , {
                onSelected = function() 
                    
                RageUI.CloseAll()
                FreezeEntityPosition(PlayerPedId(), false)
                bloquertouchejojo = false
                end
            })
        end)

        if not RageUI.Visible(menu) then
            
            break
        end
    end
end

AddEventHandler("esx:garbage:open", garbageOpenMenu)