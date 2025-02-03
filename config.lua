-- Configuration du script
return {
    DebugMode = true,
    TeleportLocations = {
        ["Fishing Zone"] = Vector3.new(0, 0, 0),
        ["Shop"] = Vector3.new(100, 0, 100)
    },
    RodList = {"Fast Rod", "Carbon Rod", "Magma Rod", "Steady Rod", "Fortune Rod"},
    AutoFarmSettings = {
        MinDelay = 2,
        MaxDelay = 5,
        FishingEventName = "CollectFish"  -- ou "AutoFish" selon le jeu
    }
}
