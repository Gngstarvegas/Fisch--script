-- Gestion des cannes à pêche
local RodManager = {}
local DebugManager = require(script.Parent.DebugManager)

function RodManager:getAllRods()
    local debug = DebugManager:new(self.config)
    debug:log("Début de l'obtention des cannes.")

    for _, rodName in ipairs(self.config.RodList) do
        local event = self.services.ReplicatedStorage:FindFirstChild("GetRod") or self.services.ReplicatedStorage:FindFirstChild("GetItem")
        if event then
            local success, _ = pcall(function()
                event:InvokeServer(rodName)
            end)
            if success then
                self.rodsObtained[rodName] = true
                debug:log("Canne obtenue: " .. rodName)
            else
                debug:log("Échec pour: " .. rodName)
            end
        else
            warn("Événement pour les cannes introuvable.")
        end
        wait(math.random(1, 3))
    end
    debug:log("Fin de l'obtention des cannes.")
end

function RodManager:new(services, config)
    local obj = {
        services = services,
        config = config,
        rodsObtained = {}
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

return RodManager
