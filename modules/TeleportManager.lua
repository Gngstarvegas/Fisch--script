-- Gestion des téléportations
local TeleportManager = {}
local DebugManager = require(script.Parent.DebugManager)

function TeleportManager:teleportTo(locationName)
    local debug = DebugManager:new(self.config)
    
    if not locationName or locationName == "" then
        debug:log("ERREUR: Nom d'emplacement invalide.")
        return false
    end
    
    local location = self.config.TeleportLocations[locationName]
    if not location then
        debug:log("Emplacement inconnu: " .. tostring(locationName))
        self:listAvailableLocations()
        return false
    end
    
    if not self.services.LocalPlayer.Character then
        debug:log("ERREUR: Personnage non disponible.")
        return false
    end
    
    local hrp = self.services.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        debug:log("ERREUR: HumanoidRootPart non trouvé.")
        return false
    end
    
    -- Sauvegarde de la position actuelle
    self.lastPosition = hrp.CFrame
    
    local success, errorMsg = pcall(function()
        hrp.CFrame = CFrame.new(location)
    end)
    
    if success then
        debug:log("✓ Téléportation réussie vers: " .. locationName)
        debug:log("Position: " .. tostring(location))
        return true
    else
        debug:log("✗ Échec de la téléportation: " .. tostring(errorMsg))
        return false
    end
end

function TeleportManager:teleportBack()
    local debug = DebugManager:new(self.config)
    
    if not self.lastPosition then
        debug:log("Aucune position précédente enregistrée.")
        return false
    end
    
    if not self.services.LocalPlayer.Character then
        debug:log("ERREUR: Personnage non disponible.")
        return false
    end
    
    local hrp = self.services.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        debug:log("ERREUR: HumanoidRootPart non trouvé.")
        return false
    end
    
    local success, errorMsg = pcall(function()
        hrp.CFrame = self.lastPosition
    end)
    
    if success then
        debug:log("✓ Retour à la position précédente réussi.")
        return true
    else
        debug:log("✗ Échec du retour: " .. tostring(errorMsg))
        return false
    end
end

function TeleportManager:listAvailableLocations()
    local debug = DebugManager:new(self.config)
    debug:log("Emplacements disponibles:")
    for name, position in pairs(self.config.TeleportLocations) do
        debug:log("  - " .. name .. " : " .. tostring(position))
    end
end

function TeleportManager:addLocation(name, position)
    if not name or not position then
        local debug = DebugManager:new(self.config)
        debug:log("ERREUR: Nom ou position invalide.")
        return false
    end
    
    self.config.TeleportLocations[name] = position
    local debug = DebugManager:new(self.config)
    debug:log("Nouvel emplacement ajouté: " .. name)
    return true
end

function TeleportManager:getCurrentPosition()
    if self.services.LocalPlayer.Character then
        local hrp = self.services.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp.CFrame.Position
        end
    end
    return nil
end

function TeleportManager:new(services, config)
    local obj = {
        services = services,
        config = config,
        lastPosition = nil
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

return TeleportManager