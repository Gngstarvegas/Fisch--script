-- Gestion de l'auto-farm
local AutoFarmManager = {}
local DebugManager = require(script.Parent.DebugManager)

function AutoFarmManager:startAutoFarm()
    local debug = DebugManager:new(self.config)
    
    if self.autoFarmActive then
        debug:log("Auto-farm déjà actif.")
        return
    end
    
    self.autoFarmActive = true
    debug:log("🚀 Démarrage de l'auto-farm...")
    
    -- Variables de statistiques
    self.stats = {
        attempts = 0,
        successes = 0,
        startTime = tick()
    }
    
    self.connection = self.services.RunService.Heartbeat:Connect(function()
        if not self.autoFarmActive then return end
        
        local success = self:performFishingAction()
        self.stats.attempts = self.stats.attempts + 1
        if success then
            self.stats.successes = self.stats.successes + 1
        end
        
        -- Log des statistiques toutes les 50 tentatives
        if self.stats.attempts % 50 == 0 then
            self:logStats()
        end
    end)
    
    debug:log("✓ Auto-farm démarré avec succès.")
end

function AutoFarmManager:stopAutoFarm()
    local debug = DebugManager:new(self.config)
    
    if not self.autoFarmActive then
        debug:log("Auto-farm déjà arrêté.")
        return
    end
    
    self.autoFarmActive = false
    
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end
    
    self:logStats()
    debug:log("🛑 Auto-farm arrêté.")
end

function AutoFarmManager:toggleAutoFarm()
    if self.autoFarmActive then
        self:stopAutoFarm()
    else
        self:startAutoFarm()
    end
end

function AutoFarmManager:performFishingAction()
    local debug = DebugManager:new(self.config)
    
    -- Vérifications préalables
    if not self.services.LocalPlayer.Character then
        return false
    end
    
    local humanoid = self.services.LocalPlayer.Character:FindFirstChild("Humanoid")
    if not humanoid then
        return false
    end
    
    -- Ne pas pêcher si le joueur est assis
    if humanoid.Sit then
        return false
    end
    
    -- Recherche de l'événement de pêche
    local eventNames = {
        self.config.AutoFarmSettings.FishingEventName,
        "CollectFish",
        "AutoFish", 
        "Fish",
        "StartFishing",
        "CastRod"
    }
    
    local event = nil
    for _, eventName in ipairs(eventNames) do
        event = self.services.ReplicatedStorage:FindFirstChild(eventName)
        if event then
            break
        end
    end
    
    if not event then
        if not self.eventWarningShown then
            debug:log("⚠️ Aucun événement de pêche trouvé.")
            self.eventWarningShown = true
        end
        return false
    end
    
    -- Tentative d'action de pêche
    local success, errorMsg = pcall(function()
        if event.ClassName == "RemoteFunction" then
            event:InvokeServer()
        elseif event.ClassName == "RemoteEvent" then
            event:FireServer()
        end
    end)
    
    if success then
        -- Délai aléatoire entre les actions
        wait(math.random(self.config.AutoFarmSettings.MinDelay * 100, 
                        self.config.AutoFarmSettings.MaxDelay * 100) / 100)
        return true
    else
        if not self.errorWarningShown then
            debug:log("⚠️ Erreur lors de l'action de pêche: " .. tostring(errorMsg))
            self.errorWarningShown = true
        end
        return false
    end
end

function AutoFarmManager:logStats()
    local debug = DebugManager:new(self.config)
    local elapsedTime = tick() - self.stats.startTime
    local successRate = self.stats.attempts > 0 and (self.stats.successes / self.stats.attempts * 100) or 0
    
    debug:log(string.format("📊 Stats Auto-farm: %d tentatives, %d succès (%.1f%%), Temps: %.1fs", 
        self.stats.attempts, self.stats.successes, successRate, elapsedTime))
end

function AutoFarmManager:getStatus()
    return {
        active = self.autoFarmActive,
        stats = self.stats
    }
end

function AutoFarmManager:new(services, config)
    local obj = {
        services = services,
        config = config,
        autoFarmActive = false,
        connection = nil,
        stats = nil,
        eventWarningShown = false,
        errorWarningShown = false
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

return AutoFarmManager