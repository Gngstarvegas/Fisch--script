-- Gestion de l'auto-farm
local AutoFarmManager = {}
local DebugManager = require(script.Parent.DebugManager)

function AutoFarmManager:startAutoFarm()
    self.autoFarmActive = not self.autoFarmActive
    local debug = DebugManager:new(self.config)
    if self.autoFarmActive then
        debug:log("Démarrage de l'auto-farm.")
        self.connection = self.services.RunService.Stepped:Connect(function()
            if self.services.LocalPlayer.Character and not self.services.LocalPlayer.Character:FindFirstChild("Humanoid").Sit then
                local event = self.services.ReplicatedStorage:FindFirstChild(self.config.AutoFarmSettings.FishingEventName)
                if event then
                    local success = pcall(function() event:InvokeServer() end)
                    if success then
                        debug:log("Action de pêche effectuée.")
                    else
                        debug:log("Échec de l'action de pêche.")
                    end
                else
                    debug:log("AutoFarm en panne: Pas d'event de pêche.")
                end
            end
            wait(math.random(self.config.AutoFarmSettings.MinDelay, self.config.AutoFarmSettings.MaxDelay))
        end)
    else
        debug:log("Arrêt de l'auto-farm.")
        if self.connection then
            self.connection:Disconnect()
        end
    end
end

function AutoFarmManager:new(services, config)
    local obj = {
        services = services,
        config = config,
        autoFarmActive = false,
        connection = nil
    }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

return AutoFarmManager
