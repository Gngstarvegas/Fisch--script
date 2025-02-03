-- Gestion des téléportations
local TeleportManager = {}
local DebugManager = require(script.Parent.DebugManager)

function TeleportManager:teleportTo(locationName)
    local debug = DebugManager:new(self.config)
    local location = self.config.TeleportLocations[locationName]
    if not location then
        debug:log("Emplacement inconnu: " .. locationName)
        return
    end

    if self.services.LocalPlayer.Character then
        local hrp = self.services.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(location)
            debug:log("Téléportation réussie vers: " .. locationName)
        else
            debug:log("Échec de la téléportation: Pas de HumanoidRootPart.")
        end
    else
        debug:log("Échec de la téléportation: Pas de personnage.")
    end
end

function TeleportManager:new(services, config)
    local obj = {
        services = services,
        config = config
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

return TeleportManager
