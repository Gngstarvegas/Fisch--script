-- Services nécessaires
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Configuration
local config = require(script.Parent.config)

-- Modules
local RodManager = require(script.Parent.modules.RodManager)
local TeleportManager = require(script.Parent.modules.TeleportManager)
local AutoFarmManager = require(script.Parent.modules.AutoFarmManager)
local DebugManager = require(script.Parent.modules.DebugManager)

-- Initialisation des services
local services = {
    Players = Players,
    ReplicatedStorage = ReplicatedStorage,
    RunService = RunService,
    LocalPlayer = Players.LocalPlayer
}

-- Initialisation des managers
local rodManager = RodManager:new(services, config)
local teleportManager = TeleportManager:new(services, config)
local autoFarmManager = AutoFarmManager:new(services, config)
local debugManager = DebugManager:new(config)

-- Lancer le script principal
debugManager:log("Lancement du script principal.")
require(script.Parent.gi).CreateGUI(rodManager, teleportManager, autoFarmManager)
