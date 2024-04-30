Config = {}

Config.seeds = {
    NeedShovelForSeeds = true, -- Mettez à true si une pelle est nécessaire, sinon mettez à false
    Label = 'plantation de la graine ...',
    Duration = 5000, -- Duration de l'animation & du cirlce Bar
    Prop = 'bkr_prop_weed_01_small_01b', -- Props quand ont utilise une graine sa mets ce props
}

Config.SmallWeed = {
    Label = '💧 Nourrir la plante', -- le label en jeux du target
    Prop = 'bkr_prop_weed_01_small_01b', -- Props de la plantation du Weed ne pas touché si connait pas
    Item = 'water', -- l'item pour nourrire la plante
}

Config.MediumWeed = {
    Label = '💧 Nourrir la plante', -- le label en jeux du target
    Prop = 'bkr_prop_weed_med_01a', -- Props de la plantation du Weed ne pas touché si connait pas
    Item = 'water', -- l'item pour nourrire la plante
}

Config.BigWeed = {
    Label = '🌿 Cueillir les feuilles de Weed', -- le label en jeux du target
    Prop = 'bkr_prop_weed_lrg_01b', -- Props de la plantation du Weed ne pas touché si connait pas
    Weedmin = 25,-- 25 feuille de Weed maximum par plante
    Weedmax = 10, -- 10 feuille de Weed minimum par plante
}

Config.Water = {
    Label = '💧 Asperge la plante avec ' .. Config.SmallWeed.Item .. '' , -- le label du circle Bar
    Duration = 5000,
}

Config.Recolte = {
    Label = 'Rammasage de feuille de Weed en cours' , -- le label du circle Bar
    Duration = 2500, -- Temps de recolte des feuille
}

Config.TableWeed = {
    Label = 'Traité la Weed', -- le label en jeux du target pour visée la table
    Prop = 'bkr_prop_weed_table_01a', -- Props de la plantation du Weed ne pas touché si connait pas

    Description = "Item pour Traité la 🌿",
    Item = 'pochon', -- Item requis pour transformée la weed
    nombre = 1, -- Nombre de Item requis pour transformée la weed
    Item2 = 'water',
    nombre2 = 2,

    Weed = 2, -- Nombre de weed enlever pour avoir traité la weed
    pochonWeed = 1, -- Nombre de Pochon que vous allez recevoir apres avoir transformée la weed en pochon
    
    Minchance = 1, -- 1 Chance sur 3 que la table soit casée a vous de changer la chance (Bon dev les reuf)
    Maxchance = 2, 
}
