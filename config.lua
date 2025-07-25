-- Configuration optimisée du script Fish Simulator
return {
    -- Mode débogage
    DebugMode = true,
    
    -- Emplacements de téléportation (à adapter selon le jeu)
    TeleportLocations = {
        ["Fishing Zone"] = Vector3.new(0, 5, 0),
        ["Shop"] = Vector3.new(100, 5, 100),
        ["Spawn"] = Vector3.new(-50, 5, -50),
        ["Deep Water"] = Vector3.new(200, 5, 200),
        ["Pier"] = Vector3.new(-100, 5, 50)
    },
    
    -- Liste des cannes à pêche disponibles
    RodList = {
        "Fast Rod", 
        "Carbon Rod", 
        "Magma Rod", 
        "Steady Rod", 
        "Fortune Rod",
        "Basic Rod",
        "Advanced Rod",
        "Master Rod"
    },
    
    -- Paramètres des cannes
    RodSettings = {
        MinDelay = 1,    -- Délai minimum entre les tentatives d'obtention (secondes)
        MaxDelay = 3,    -- Délai maximum entre les tentatives d'obtention (secondes)
        AutoEquip = true -- Équiper automatiquement la meilleure canne
    },
    
    -- Paramètres de l'auto-farm
    AutoFarmSettings = {
        MinDelay = 1.5,           -- Délai minimum entre les actions (secondes)
        MaxDelay = 3.5,           -- Délai maximum entre les actions (secondes)
        FishingEventName = "CollectFish", -- Nom de l'événement de pêche principal
        AutoTeleport = false,     -- Téléportation automatique vers les zones de pêche
        PreferredLocation = "Deep Water", -- Zone de pêche préférée
        StatsInterval = 50        -- Intervalle pour afficher les statistiques
    },
    
    -- Paramètres de l'interface
    UISettings = {
        GuiName = "FishSimulatorGUI",
        WindowTitle = "🎣 Fish Simulator Bot",
        WindowSize = Vector2.new(350, 280),
        ButtonHeight = 35,
        Padding = 10,
        Draggable = true,
        AlwaysOnTop = true
    },
    
    -- Paramètres de sécurité
    SecuritySettings = {
        AntiDetection = true,     -- Activer les mesures anti-détection
        RandomizeDelays = true,   -- Randomiser les délais
        MaxContinuousActions = 100, -- Pause après X actions continues
        PauseAfterMax = 5         -- Durée de pause (secondes)
    },
    
    -- Messages personnalisés
    Messages = {
        Welcome = "🎣 Fish Simulator Bot chargé avec succès!",
        RodSuccess = "✓ Canne obtenue: ",
        RodFailed = "✗ Échec pour la canne: ",
        TeleportSuccess = "✓ Téléporté vers: ",
        TeleportFailed = "✗ Échec de téléportation vers: ",
        AutoFarmStart = "🚀 Auto-farm démarré!",
        AutoFarmStop = "🛑 Auto-farm arrêté!"
    }
}