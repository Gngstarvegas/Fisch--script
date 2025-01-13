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

-- Fonction pour obtenir toutes les cannes
function GetAllRods()
    local RodList = {"Fast Rod", "Carbon Rod", "Magma Rod", "Steady Rod", "Fortune Rod"} -- À ajuster selon le jeu
    for _, rodName in ipairs(RodList) do
        local event = ReplicatedStorage:FindFirstChild("GetRod") or ReplicatedStorage:FindFirstChild("GetItem") -- Adapter le nom selon le jeu
        if event then
            local success, _ = pcall(function()
                event:InvokeServer(rodName)
            end)
            if success then
                RodsObtained[rodName] = true
                print("Obtained: " .. rodName)
            end
        else
            warn("Could not find event to get rods.")
        end
        wait(math.random(1, 3))  -- Time delay pour éviter la détection
    end
end

-- Fonction pour téléporter le joueur
function TeleportTo(location)
    if LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(location)
        end
    end
end

-- Fonction pour commencer l'auto-farm
function StartAutoFarm()
    AutoFarmActive = not AutoFarmActive
    if AutoFarmActive then
        RunService.Stepped:Connect(function()
            if LocalPlayer.Character and not LocalPlayer.Character:FindFirstChild("Humanoid").Sit then
                local event = ReplicatedStorage:FindFirstChild("CollectFish") or ReplicatedStorage:FindFirstChild("AutoFish") -- Adapter selon le jeu
                if event then
                    pcall(function() event:InvokeServer() end)
                end
            end
            wait(math.random(2, 5))  -- Random wait pour éviter la détection
        end)
    end
end

-- Lancer le script principal
require(script.Parent.gui).CreateGUI()
