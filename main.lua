-- main.lua

-- Services nécessaires
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Variables globales
local LocalPlayer = Players.LocalPlayer
local RodsObtained = {}
local TeleportLocations = {
    ["Fishing Zone"] = Vector3.new(0, 0, 0),
    ["Shop"] = Vector3.new(100, 0, 100)
}
local AutoFarmActive = false

-- Fonction pour le débogage
local function debug_print(message)
    print("[DEBUG] " .. message)
end

-- Fonction pour obtenir toutes les cannes
function GetAllRods()
    debug_print("On va choper toutes les cannes, bro.")
    local RodList = {"Fast Rod", "Carbon Rod", "Magma Rod", "Steady Rod", "Fortune Rod"} -- À ajuster selon le jeu
    for _, rodName in ipairs(RodList) do
        local event = ReplicatedStorage:FindFirstChild("GetRod") or ReplicatedStorage:FindFirstChild("GetItem") -- Adapter le nom selon le jeu
        if event then
            local success, _ = pcall(function()
                event:InvokeServer(rodName)
            end)
            if success then
                RodsObtained[rodName] = true
                debug_print("On a chopé: " .. rodName)
            else
                debug_print("Échec pour: " .. rodName)
            end
        else
            warn("Pas moyen de trouver l'event pour les cannes.")
        end
        wait(math.random(1, 3))  -- Time delay pour éviter la détection
    end
    debug_print("Fin de l'obtention des cannes.")
end

-- Fonction pour téléporter le joueur
function TeleportTo(location)
    debug_print("Téléportation vers: " .. tostring(location))
    if LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(location)
            debug_print("Téléportation réussie.")
        else
            debug_print("Échec de la téléportation: Pas de HumanoidRootPart.")
        end
    else
        debug_print("Échec de la téléportation: Pas de personnage.")
    end
end

-- Fonction pour commencer l'auto-farm
function StartAutoFarm()
    AutoFarmActive = not AutoFarmActive
    if AutoFarmActive then
        debug_print("On démarre l'auto-farm, bro.")
        RunService.Stepped:Connect(function()
            if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChild("Humanoid").Sit then
                local event = ReplicatedStorage:FindFirstChild("CollectFish") or ReplicatedStorage:FindFirstChild("AutoFish") -- Adapter selon le jeu
                if event then
                    local success = pcall(function() event:InvokeServer() end)
                    if success then
                        debug_print("Action de pêche effectuée.")
                    else
                        debug_print("Échec de l'action de pêche.")
                    end
                else
                    debug_print("AutoFarm en panne: Pas d'event de pêche.")
                end
            end
            wait(math.random(2, 5))  -- Random wait pour éviter la détection
        end)
    else
        debug_print("On arrête l'auto-farm.")
    end
end

-- Lancer le script principal
debug_print("Lancement du script principal.")
require(script.Parent.gui).CreateGUI()
