ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('RDZ:SeedsWeed')
AddEventHandler('RDZ:SeedsWeed', function()
    TriggerServerEvent('RDZ:shovel') -- Besoin d'un pelle pour utilser les graine
end)

RegisterNetEvent('RDZ:PlantationSeeds')
AddEventHandler('RDZ:PlantationSeeds', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    TriggerServerEvent('RDZ:WeedSeeds', playerCoords)  -- Envoie les coordonnées du joueur au serveur
end)

RegisterNetEvent('RDZ:CircleNeedsWeed')
AddEventHandler('RDZ:CircleNeedsWeed', function()
    TriggerEvent("RDZ:Animation:Needs")

    lib.progressCircle({
        duration = Config.seeds.Duration,
        label = Config.seeds.Label,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
        },
    })

    TriggerEvent("RDZ:stopNeeds:Animation")
end)

RegisterNetEvent("RDZ:Animation:Needs")
AddEventHandler("RDZ:Animation:Needs", function()
    FreezeEntityPosition(PlayerPedId(), true) -- Freeze le joueur
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_PLANT", 0, true)
end)

RegisterNetEvent("RDZ:stopNeeds:Animation")
AddEventHandler("RDZ:stopNeeds:Animation", function()
    ClearPedTasks(PlayerPedId())  -- Arrêter l'animation
    FreezeEntityPosition(PlayerPedId(), false)    -- Unfreeze le joueur
end)

Citizen.CreateThread(function()
    local data = {
        {
        event = 'RDZ:waterWeed',
        label = Config.SmallWeed.Label,
        distance = 2.0
        },
    }
exports.ox_target:addModel(Config.SmallWeed.Prop, data)
end)
  
RegisterNetEvent('RDZ:waterWeed')
AddEventHandler('RDZ:waterWeed', function()
  TriggerServerEvent('RDZ:nourrireWeed')
end)
  
Citizen.CreateThread(function()
    local data = {
        {
        event = 'RDZ:waterWeed1',
        label = Config.MediumWeed.Label,
        distance = 2.0
        },
    }
    exports.ox_target:addModel(Config.MediumWeed.Prop, data)
end)

RegisterNetEvent('RDZ:waterWeed1')
AddEventHandler('RDZ:waterWeed1', function()
  TriggerServerEvent('RDZ:nourrireBigWeed')
end)

Citizen.CreateThread(function()
    local data = {
        {
        event = 'RDZ:Rewards:Weed',
        label = Config.BigWeed.Label,
        distance = 2.0
        },
    }
    exports.ox_target:addModel(Config.BigWeed.Prop, data)
end)

RegisterNetEvent('RDZ:Rewards:Weed')
AddEventHandler('RDZ:Rewards:Weed', function()
    TriggerServerEvent('RDZ:WeedBig:Rewards')
end)

RegisterNetEvent('RDZ:CirclewaterWeed')
AddEventHandler('RDZ:CirclewaterWeed', function()
    TriggerEvent("RDZ:Animation:water")

    lib.progressCircle({
        duration = Config.Water.Duration,
        label = Config.Water.Label,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
        },
    })

    TriggerEvent("RDZ:stopwater:Animation")
end)

RegisterNetEvent("RDZ:Animation:water")
AddEventHandler("RDZ:Animation:water", function()
    FreezeEntityPosition(PlayerPedId(), true) -- Freeze le joueur
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_DRINKING", 0, true)
end)


RegisterNetEvent("RDZ:stopwater:Animation")
AddEventHandler("RDZ:stopwater:Animation", function()
    ClearPedTasks(PlayerPedId())  -- Arrêter l'animation
    FreezeEntityPosition(PlayerPedId(), false)    -- Unfreeze le joueur
end)

-- Event pour supprimer le prop côté client
RegisterNetEvent('RDZ:WeedBig:PropDeleted')
AddEventHandler('RDZ:WeedBig:PropDeleted', function(propName)
    local prop = GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 2.0, GetHashKey(propName), false, false, false)
    
    if DoesEntityExist(prop) then
        DeleteEntity(prop)
        print('Vous avez recoltée les 3 feuille : ' .. propName)
    end
end)

RegisterNetEvent('RDZ:CirclewaterRemove')
AddEventHandler('RDZ:CirclewaterRemove', function()
    TriggerEvent("RDZ:Animation:Remove")

    lib.progressCircle({
        duration = Config.Recolte.Duration,
        label = Config.Recolte.Label,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
        },
    })

    TriggerEvent("RDZ:stopRemove:Animation")
end)

RegisterNetEvent("RDZ:Animation:Remove")
AddEventHandler("RDZ:Animation:Remove", function()
    FreezeEntityPosition(PlayerPedId(), true) -- Freeze le joueur
    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_GARDENER_LEAF_BLOWER", 0, true)
end)


RegisterNetEvent("RDZ:stopRemove:Animation")
AddEventHandler("RDZ:stopRemove:Animation", function()
    ClearPedTasks(PlayerPedId())  -- Arrêter l'animation
    FreezeEntityPosition(PlayerPedId(), false)    -- Unfreeze le joueur
end)

-- traitement Weed -- 

RegisterNetEvent("RDZ:tableposed")
AddEventHandler("RDZ:tableposed", function()
    TriggerServerEvent('RDZ:posedtable')
end)

Citizen.CreateThread(function()
    local data = {
        {
            event = 'RDZ:MenuTraitement',
            icon = "fa-solid fa-cannabis",
            label = Config.TableWeed.Label,
            distance = 2.0
        },
        {
            event = 'RDZ:Recuperetable',
            icon = "fa-solid fa-tablet",
            label = "Récupérer la tablette",
            distance = 2.0
        },
    }
exports.ox_target:addModel(Config.TableWeed.Prop, data)
end)

RegisterNetEvent("RDZ:Recuperetable")
AddEventHandler("RDZ:Recuperetable", function()
    local playerPed = PlayerPedId() -- Obtenez l'ID du joueur
    local playerCoords = GetEntityCoords(playerPed) -- Obtenez les coordonnées du joueur

    TriggerEvent('RDZ:Posetableweed', source)

    Citizen.Wait(2500)

    -- Parcourir tous les objets à proximité
    local nearbyObjects = GetGamePool("CObject")
    local closestObject = 0
    local closestDistance = -1

    for _, object in ipairs(nearbyObjects) do
        local objectCoords = GetEntityCoords(object)
        local distance = #(objectCoords - playerCoords)

        -- Vérifiez si l'objet est Config.TableWeed.Prop et est à moins de 2 mètres
        if IsEntityAnObject(object) and GetEntityModel(object) == GetHashKey(Config.TableWeed.Prop) and distance <= 2.0 then
            if closestDistance == -1 or distance < closestDistance then
                closestObject = object
                closestDistance = distance
            end
        end
    end

    -- Supprimer l'objet le plus proche s'il en existe un
    if closestObject ~= 0 then
        DeleteObject(closestObject)
        TriggerServerEvent('RDZ:givetableweed')
    end
end)

lib.registerContext({
    id = 'RDZ:TraitementMenu',
    title = 'Traitement Weed',
    options = {
        {
            title = 'Traité la weed',
            icon = "fa-solid fa-cannabis",
            event = 'RDZ:TraiteWeed',
            metadata = {
                { label = tostring(Config.TableWeed.Description)},
                { label = tostring(Config.TableWeed.Item), value = tostring(Config.TableWeed.nombre)  },
                { label = tostring(Config.TableWeed.Item2), value = tostring(Config.TableWeed.nombre2) }
            }
        }
    }
})

RegisterNetEvent('RDZ:MenuTraitement')
AddEventHandler('RDZ:MenuTraitement', function()
    lib.showContext('RDZ:TraitementMenu')
end)

RegisterNetEvent("RDZ:TraiteWeed")
AddEventHandler("RDZ:TraiteWeed", function()
    TriggerServerEvent('RDZ:WeedTraite')
end)

-- Pose de la table

RegisterNetEvent('RDZ:Posetableweed')
AddEventHandler('RDZ:Posetableweed', function()
    TriggerEvent("RDZ:Posetableweed:anim")

    lib.progressCircle({
        duration = 2500,
        label = "Pose de la table de weed",
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
        },
    })

    TriggerEvent("RDZ:Posetableweed:Animationremove")
end)

RegisterNetEvent("RDZ:Posetableweed:anim")
AddEventHandler("RDZ:Posetableweed:anim", function()
    FreezeEntityPosition(PlayerPedId(), true) -- Freeze le joueur
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true) -- Commencer l'animation de poser le meuble (baisse)
end)

RegisterNetEvent("RDZ:Posetableweed:Animationremove")
AddEventHandler("RDZ:Posetableweed:Animationremove", function()
    ClearPedTasks(PlayerPedId())  -- Arrêter l'animation
    FreezeEntityPosition(PlayerPedId(), false)    -- Unfreeze le joueur
end)

RegisterNetEvent("RDZ:removetable")
AddEventHandler("RDZ:removetable", function()
    local playerPed = PlayerPedId() -- Obtenez l'ID du joueur
    local playerCoords = GetEntityCoords(playerPed) -- Obtenez les coordonnées du joueur

    -- Parcourir tous les objets à proximité
    local nearbyObjects = GetGamePool("CObject")
    local closestObject = 0
    local closestDistance = -1

    for _, object in ipairs(nearbyObjects) do
        local objectCoords = GetEntityCoords(object)
        local distance = #(objectCoords - playerCoords)

        if IsEntityAnObject(object) and GetEntityModel(object) == GetHashKey(Config.TableWeed.Prop) and distance <= 5.0 then
            if closestDistance == -1 or distance < closestDistance then
                closestObject = object
                closestDistance = distance
            end
        end
    end

    if closestObject ~= 0 then
        local objectCoords = GetEntityCoords(closestObject)
        
        -- Mettre le feu à l'objet avant de le supprimer
        StartScriptFire(objectCoords, 25, true)

        -- Supprimer l'objet
        DeleteObject(closestObject)
    end
end)

Citizen.CreateThread(function()
    local data = {
        {
            event = 'RDZ:etatsWeed1',
            label = '🩹 Vérifie l\'état de la plante',
            distance = 2.0
        }
    }
    exports.ox_target:addModel(Config.SmallWeed.Prop, data)
end)

RegisterNetEvent('RDZ:etatsWeed1')
AddEventHandler('RDZ:etatsWeed1', function()
    TriggerEvent("RDZ:Animation:Weed")

    lib.progressCircle({
        duration = 2500,
        label = '🩹 verifie l\'etat de la plante',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
    })

    TriggerEvent("RDZ:Weed:StopAnimation")
    TriggerEvent("RDZ:etatmauvais")
end)

RegisterNetEvent("RDZ:Animation:Weed")
AddEventHandler("RDZ:Animation:Weed", function()
    FreezeEntityPosition(PlayerPedId(), true) -- Figé le joueur
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
end)

RegisterNetEvent("RDZ:Weed:StopAnimation")
AddEventHandler("RDZ:Weed:StopAnimation", function()
    ClearPedTasks(PlayerPedId())  -- Arrêter l'animation
    FreezeEntityPosition(PlayerPedId(), false)    -- Unfreeze le joueur
end)

RegisterNetEvent("RDZ:etatmauvais")
AddEventHandler("RDZ:etatmauvais", function()
    lib.notify({
        title = 'État de la plante',
        description = 'La plante va mourir vite, asperge-la !!!',
        type = 'error'
    })
end)


Citizen.CreateThread(function()
    local data = {
        {
        event = 'RDZ:etatsWeed2',
        label = '🩹 Verifie l\'etat du plante',
        distance = 2.0
        },
    }
exports.ox_target:addModel(Config.MediumWeed.Prop, data)
end)

RegisterNetEvent('RDZ:etatsWeed2')
AddEventHandler('RDZ:etatsWeed2', function()
    TriggerEvent("RDZ:Animation:Weed2")

    lib.progressCircle({
        duration = 2500,
        label = '🩹 verifie l\'etat de la plante',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
    })

    TriggerEvent("RDZ:Weed2:StopAnimation")
    TriggerEvent("RDZ:etatsWeed22")
end)

RegisterNetEvent("RDZ:Animation:Weed2")
AddEventHandler("RDZ:Animation:Weed2", function()
    FreezeEntityPosition(PlayerPedId(), true) -- Figé le joueur
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
end)

RegisterNetEvent("RDZ:Weed2:StopAnimation")
AddEventHandler("RDZ:Weed2:StopAnimation", function()
    ClearPedTasks(PlayerPedId())  -- Arrêter l'animation
    FreezeEntityPosition(PlayerPedId(), false)    -- Unfreeze le joueur
end)

RegisterNetEvent('RDZ:etatsWeed22')
AddEventHandler('RDZ:etatsWeed22', function()
    lib.notify({
        title = 'L\'etat de la plante',
        description = 'La plante est en manque d\'eau !',
        type = 'warning'
    })
end)

Citizen.CreateThread(function()
    local data = {
        {
        event = 'RDZ:etatsWeed3',
        label = '🩹 Verifie l\'etat du plante',
        distance = 2.0
        },
    }
exports.ox_target:addModel(Config.BigWeed.Prop, data)
end)

RegisterNetEvent('RDZ:etatsWeed3')
AddEventHandler('RDZ:etatsWeed3', function()
    TriggerEvent("RDZ:Animation:Weed3")

    lib.progressCircle({
        duration = 2500,
        label = '🩹 verifie l\'etat de la plante',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
        },
    })

    TriggerEvent("RDZ:Weed3:StopAnimation")
    TriggerEvent("RDZ:etatsWeed33")
end)

RegisterNetEvent("RDZ:Animation:Weed3")
AddEventHandler("RDZ:Animation:Weed3", function()
    FreezeEntityPosition(PlayerPedId(), true) -- Figé le joueur
    TaskStartScenarioInPlace(PlayerPedId(), "PROP_HUMAN_BUM_BIN", 0, true)
end)

RegisterNetEvent("RDZ:Weed3:StopAnimation")
AddEventHandler("RDZ:Weed3:StopAnimation", function()
    ClearPedTasks(PlayerPedId())  -- Arrêter l'animation
    FreezeEntityPosition(PlayerPedId(), false)    -- Unfreeze le joueur
end)
RegisterNetEvent('RDZ:etatsWeed33')
AddEventHandler('RDZ:etatsWeed33', function()
    lib.notify({
        title = 'L\'etat de la plante',
        description = 'La plante est en tres bonne etat !',
        type = 'success'
    })
end)
