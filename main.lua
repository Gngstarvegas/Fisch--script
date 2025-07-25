-- Script principal Fisch - Version Corrigée et Optimisée
-- Services Roblox nécessaires
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Configuration du script
local config = require(script.Parent.config)

-- Modules (structure corrigée)
local RodManager = require(script.Parent.modules.RodManager)
local TeleportManager = require(script.Parent.modules.TeleportManager)
local AutoFarmManager = require(script.Parent.modules.AutoFarmManager)
local DebugManager = require(script.Parent.modules.DebugManager)

-- Interface utilisateur
local gui = require(script.Parent.gui)

-- Fonction de protection contre les erreurs
local function safeCall(func, errorMsg)
    local success, result = pcall(func)
    if not success then
        warn("ERREUR: " .. errorMsg .. " - " .. tostring(result))
        return false
    end
    return true, result
end

-- Fonction de vérification des services
local function verifyServices()
    local requiredServices = {
        Players = Players,
        ReplicatedStorage = ReplicatedStorage,
        RunService = RunService
    }
    
    for serviceName, service in pairs(requiredServices) do
        if not service then
            error("Service manquant: " .. serviceName)
            return false
        end
    end
    
    if not Players.LocalPlayer then
        error("LocalPlayer non disponible")
        return false
    end
    
    return true
end

-- Fonction principale d'initialisation
local function initializeScript()
    local debugManager = DebugManager:new(config)
    
    -- Vérification des prérequis
    if not verifyServices() then
        error("Échec de la vérification des services")
        return
    end
    
    debugManager:log("🚀 Lancement du script Fisch...")
    debugManager:log("Version: Titanesque Corrigée v2.0")
    
    -- Initialisation des services
    local services = {
        Players = Players,
        ReplicatedStorage = ReplicatedStorage,
        RunService = RunService,
        LocalPlayer = Players.LocalPlayer
    }
    
    debugManager:log("✓ Services initialisés avec succès")
    
    -- Initialisation des managers avec gestion d'erreurs
    local rodManager, teleportManager, autoFarmManager
    
    local success = safeCall(function()
        rodManager = RodManager:new(services, config)
        debugManager:log("✓ RodManager initialisé")
    end, "Initialisation du RodManager")
    
    if not success then return end
    
    success = safeCall(function()
        teleportManager = TeleportManager:new(services, config)
        debugManager:log("✓ TeleportManager initialisé")
    end, "Initialisation du TeleportManager")
    
    if not success then return end
    
    success = safeCall(function()
        autoFarmManager = AutoFarmManager:new(services, config)
        debugManager:log("✓ AutoFarmManager initialisé")
    end, "Initialisation de l'AutoFarmManager")
    
    if not success then return end
    
    -- Attendre que le personnage soit chargé
    if not services.LocalPlayer.Character then
        debugManager:log("⏳ Attente du chargement du personnage...")
        services.LocalPlayer.CharacterAdded:Wait()
    end
    
    debugManager:log("✓ Personnage détecté")
    
    -- Initialisation de l'interface utilisateur
    success = safeCall(function()
        gui.CreateGUI(rodManager, teleportManager, autoFarmManager, config)
        debugManager:log("✓ Interface utilisateur créée avec succès")
    end, "Création de l'interface utilisateur")
    
    if not success then return end
    
    -- Message de succès final
    debugManager:log("🎉 Script Fisch chargé avec succès!")
    debugManager:log("📋 Fonctionnalités disponibles:")
    debugManager:log("   - Obtention automatique des cannes")
    debugManager:log("   - Système de téléportation")
    debugManager:log("   - Auto-farm intelligent")
    debugManager:log("   - Interface graphique complète")
    
    if config.Messages and config.Messages.Welcome then
        print(config.Messages.Welcome)
    end
    
    -- Gestion de la déconnexion propre
    game:GetService("Players").PlayerRemoving:Connect(function(player)
        if player == services.LocalPlayer then
            if autoFarmManager:getStatus().active then
                autoFarmManager:stopAutoFarm()
            end
            debugManager:log("🔌 Script arrêté proprement")
        end
    end)
    
    return {
        rodManager = rodManager,
        teleportManager = teleportManager,
        autoFarmManager = autoFarmManager,
        debugManager = debugManager
    }
end

-- Gestion globale des erreurs
local function globalErrorHandler()
    local success, managers = pcall(initializeScript)
    
    if not success then
        warn("❌ ERREUR CRITIQUE lors du chargement du script:")
        warn(tostring(managers))
        warn("🔧 Vérifiez que vous êtes dans Fisch sur Roblox")
        warn("📋 Vérifiez que tous les modules sont présents")
        return false
    end
    
    return managers
end

-- Lancement du script principal
return globalErrorHandler()