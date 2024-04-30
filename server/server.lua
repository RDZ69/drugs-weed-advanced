ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterUsableItem('seeds', function(source)
    local _source = source
    TriggerClientEvent('RDZ:SeedsWeed', _source)
end)

RegisterServerEvent('RDZ:shovel')
AddEventHandler('RDZ:shovel', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    -- Vérifier si une pelle est nécessaire pour utiliser les graines
    if Config.seeds.NeedShovelForSeeds then
        -- Vérifier si le joueur possède une pelle
        local hasShovel = xPlayer.getInventoryItem('shovel').count

        if hasShovel > 0 then
            -- Le joueur possède une pelle, retirer les graines de son inventaire
            xPlayer.removeInventoryItem('seeds', 1)
            TriggerClientEvent('RDZ:PlantationSeeds', _source)
        else
            -- Afficher un message au joueur indiquant qu'il a besoin d'une pelle pour utiliser les graines
            TriggerClientEvent('esx:showNotification', _source, "Vous avez besoin d'une pelle pour utiliser cet objet.")
        end
    else
        -- Aucune pelle n'est nécessaire, retirer simplement les graines de l'inventaire du joueur
        xPlayer.removeInventoryItem('seeds', 1)
        TriggerClientEvent('RDZ:PlantationSeeds', _source)
    end
end)

RegisterServerEvent('RDZ:WeedSeeds')
AddEventHandler('RDZ:WeedSeeds', function()
    local _source = source
    local propModel = Config.seeds.Prop

    TriggerClientEvent('RDZ:CircleNeedsWeed', _source) -- Permet de lancer la circle bar

    Citizen.Wait(Config.seeds.Duration)

    local playerPed = GetPlayerPed(_source)
    local playerCoords = GetEntityCoords(playerPed)
    local playerHeading = GetEntityHeading(playerPed)

    -- Convertir l'angle de rotation en radians
    local radians = math.rad(playerHeading)

    -- Calculer le vecteur avant du joueur
    local forwardVector = vector3(math.cos(radians), math.sin(radians), 0)

    -- Créer les nouvelles coordonnées pour le prop 1 mètre devant le joueur
    local propCoords = playerCoords + forwardVector

    -- Créer le prop
    local prop = CreateObject(GetHashKey(propModel), propCoords.x, propCoords.y, propCoords.z - 1, true, true, true)

    -- Geler le prop
    FreezeEntityPosition(prop, true)

    TriggerClientEvent('esx:showNotification', _source, "Vous avez planté la graine. Donnez-lui de l'eau et patientez.")
end)



-- Event 🚰 | Arrosage de la moyenne Weed
RegisterServerEvent('RDZ:nourrireWeed')
AddEventHandler('RDZ:nourrireWeed', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    -- Vérifier si le joueur a de l'eau
    local hasWater = xPlayer.getInventoryItem(Config.SmallWeed.Item).count

    if hasWater > 0 then
        -- Retirer une unité d'eau
        xPlayer.removeInventoryItem(Config.SmallWeed.Item, 1)

        TriggerClientEvent('RDZ:CirclewaterWeed', _source)

        Citizen.Wait(Config.Water.Duration)

        -- Mettre à jour le prop
        local playerPed = GetPlayerPed(_source)
        local playerCoords = GetEntityCoords(playerPed)
        local maxDistance = 2.0 -- Réduisez la distance maximale de recherche

        -- Rechercher les objets dans la zone autour du joueur
        local objects = GetGamePool('CObject')

        -- Parcourir tous les objets pour trouver le prop SmallWeed.Prop et le mettre à jour
        for _, object in ipairs(objects) do
            local objectModel = GetEntityModel(object)
            if objectModel == GetHashKey(Config.SmallWeed.Prop) then
                local objectCoords = GetEntityCoords(object)
                local distance = #(playerCoords - objectCoords) -- Calculer la distance
                if distance < maxDistance then
                    local newX, newY, newZ = objectCoords.x, objectCoords.y, objectCoords.z -- Obtenez les coordonnées de l'ancien prop
                    CreateObject(GetHashKey(Config.MediumWeed.Prop), newX, newY, newZ - 2.5, true, true, true) -- Créez le nouveau prop aux mêmes coordonnées
                    TriggerClientEvent('esx:showNotification', _source, "Le pot de weed a été agrandi.")
                    break -- Sortir de la boucle après avoir trouvé et mis à jour le prop
                end
            end
        end        
    else
        -- Le joueur n'a pas d'eau, donc afficher une notification
        TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ".. Config.SmallWeed.Item .. " sur vous.")
    end
end)

-- Event 🚰 | Arrosage de la Grande Weed
RegisterServerEvent('RDZ:nourrireBigWeed')
AddEventHandler('RDZ:nourrireBigWeed', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    -- Vérifier si le joueur a de l'eau
    local hasWater = xPlayer.getInventoryItem(Config.MediumWeed.Item).count

    if hasWater > 0 then
        -- Retirer une unité d'eau
        xPlayer.removeInventoryItem(Config.MediumWeed.Item, 1)

        TriggerClientEvent('RDZ:CirclewaterWeed', _source)
        
        Citizen.Wait(Config.Water.Duration)

        -- Mettre à jour le prop
        local playerPed = GetPlayerPed(_source)
        local playerCoords = GetEntityCoords(playerPed)
        local maxDistance = 2.0 -- Réduisez la distance maximale de recherche

        -- Rechercher les objets dans la zone autour du joueur
        local objects = GetGamePool('CObject')

        -- Parcourir tous les objets pour trouver le prop SmallWeed.Prop et le mettre à jour
        for _, object in ipairs(objects) do
            local objectModel = GetEntityModel(object)
            if objectModel == GetHashKey(Config.MediumWeed.Prop) then
                local objectCoords = GetEntityCoords(object)
                local distance = #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - vector3(objectCoords.x, objectCoords.y, objectCoords.z))
                if distance < maxDistance then
                    local newX, newY, newZ = objectCoords.x, objectCoords.y, objectCoords.z -- Obtenez les coordonnées de l'ancien prop
                    CreateObject(GetHashKey(Config.BigWeed.Prop), newX, newY, newZ - 2.5, true, true, true) -- Créez le nouveau prop aux mêmes coordonnées
                    DeleteWeedProp()  -- Supprimer le prop précédent
                    TriggerClientEvent('esx:showNotification', _source, "Le pot de weed a été agrandi.")
                    break -- Sortir de la boucle après avoir trouvé et mis à jour le prop
                end
            end
        end
    else
        -- Le joueur n'a pas d'eau, donc afficher une notification
        TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ".. Config.MediumWeed.Item .. " sur vous.")
    end
end)

RegisterServerEvent('RDZ:WeedBig:RemoveProps')
AddEventHandler('RDZ:WeedBig:RemoveProps', function(propName)
    TriggerClientEvent('RDZ:WeedBig:PropDeleted', -1, propName)
end)

-- Event pour récompenser le joueur et supprimer les props
RegisterServerEvent('RDZ:WeedBig:Rewards')
AddEventHandler('RDZ:WeedBig:Rewards', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local minWeedAmount = Config.BigWeed.Weedmin
    local maxWeedAmount = Config.BigWeed.Weedmax

    -- Assurez-vous que minWeedAmount est inférieur à maxWeedAmount
    if minWeedAmount > maxWeedAmount then
        minWeedAmount, maxWeedAmount = maxWeedAmount, minWeedAmount
    end

    -- Assurez-vous que minWeedAmount et maxWeedAmount sont des nombres valides
    minWeedAmount = tonumber(minWeedAmount) or 0
    maxWeedAmount = tonumber(maxWeedAmount) or 1

    local weedAmount = math.random(minWeedAmount, maxWeedAmount)

    TriggerClientEvent('RDZ:CirclewaterRemove', _source)
        
    Citizen.Wait(Config.Recolte.Duration)

    xPlayer.addInventoryItem('weed', weedAmount)

    TriggerClientEvent('esx:showNotification', _source, "Vous avez cueilli une grande plante de weed et obtenu " .. weedAmount .. " unités de weed.")

    -- Noms des props à supprimer
    local propsToRemove = {
        'bkr_prop_weed_01_small_01b',
        'bkr_prop_weed_med_01a',
        'bkr_prop_weed_lrg_01b'
    }

    -- Supprimer les props côté client en utilisant un événement réseau
    for _, propName in ipairs(propsToRemove) do
        TriggerEvent('RDZ:WeedBig:RemoveProps', propName)
    end
end)

-- Table de traitement de pochon de weed 

ESX.RegisterUsableItem('tableweed', function(source)
    local _source = source
    TriggerClientEvent('RDZ:tableposed', _source)
end)

RegisterServerEvent("RDZ:posedtable")
AddEventHandler("RDZ:posedtable", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    TriggerClientEvent('RDZ:Posetableweed', _source)

    Citizen.Wait(2500)

    local playerPed = GetPlayerPed(_source)
    local playerCoords = GetEntityCoords(playerPed) -- Obtenez les coordonnées du joueur

    if xPlayer then
        xPlayer.removeInventoryItem('tableweed', 1) 
    end

    -- Calculer les nouvelles coordonnées pour le prop devant le joueur
    local playerHeading = GetEntityHeading(playerPed) -- Obtenir l'angle de rotation du joueur
    local radians = math.rad(playerHeading) -- Convertir l'angle en radians
    local forwardVector = vector3(math.cos(radians), math.sin(radians), 0) -- Calculer le vecteur avant
    local propCoords = playerCoords + forwardVector * -1.0 -- À 1 mètre devant le joueur

    -- Créez une table devant le joueur
    local tableObject = CreateObject(GetHashKey(Config.TableWeed.Prop), propCoords.x , propCoords.y , propCoords.z - 1.0, true, true, true)

    -- Geler le tableObject
    FreezeEntityPosition(tableObject, true)

    -- Vous pouvez ajuster la notification en fonction de vos besoins
    TriggerClientEvent('esx:showNotification', _source, "Vous avez placé une table pour traiter la weed. Essayez-la donc.")
end)

RegisterServerEvent("RDZ:givetableweed")
AddEventHandler("RDZ:givetableweed", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        xPlayer.addInventoryItem('tableweed', 1) 
    end
end)


RegisterServerEvent("RDZ:WeedTraite")
AddEventHandler("RDZ:WeedTraite", function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if xPlayer then
        local hasItem1 = xPlayer.getInventoryItem(Config.TableWeed.Item)
        local hasItem2 = xPlayer.getInventoryItem(Config.TableWeed.Item2)
        local hasWeed = xPlayer.getInventoryItem('weed')

        -- Vérifier si le joueur possède les articles nécessaires
        if hasItem1.count >= Config.TableWeed.nombre and hasItem2.count >= Config.TableWeed.nombre2 and hasWeed.count >= Config.TableWeed.Weed then
            -- Supprimer les objets de l'inventaire du joueur
            xPlayer.removeInventoryItem(Config.TableWeed.Item, Config.TableWeed.nombre)
            xPlayer.removeInventoryItem(Config.TableWeed.Item2, Config.TableWeed.nombre2)
            xPlayer.removeInventoryItem('weed', Config.TableWeed.Weed)

            -- Ajouter des objets à l'inventaire du joueur
            xPlayer.addInventoryItem('pochon_weed', Config.TableWeed.pochonWeed)

            -- Gérer la chance que le prop soit supprimé
            local chanceRemoveProp = math.random(Config.TableWeed.Minchance, Config.TableWeed.Maxchance) -- Générer un nombre aléatoire entre 1 et 100

            if chanceRemoveProp == 1 then
                -- Supprimer le prop
                TriggerClientEvent('RDZ:removetable', -1) -- Signal pour supprimer le prop
                TriggerClientEvent('esx:showNotification', _source, "La table a été cassée.")
            end

            TriggerClientEvent('esx:showNotification', _source, "Vous avez traité la weed. Voici votre pochon de weed.")
        else
            TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas tous les objets nécessaires pour transformer la weed.")
        end
    end
end)