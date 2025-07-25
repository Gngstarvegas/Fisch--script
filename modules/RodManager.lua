-- Gestion des cannes à pêche
local RodManager = {}
local DebugManager = require(script.Parent.DebugManager)

function RodManager:getAllRods()
    local debug = DebugManager:new(self.config)
    debug:log("Début de l'obtention des cannes.")
    
    -- Vérification des services
    if not self.services.ReplicatedStorage then
        debug:log("ERREUR: ReplicatedStorage non disponible.")
        return
    end
    
    local successCount = 0
    local totalRods = #self.config.RodList
    
    for i, rodName in ipairs(self.config.RodList) do
        debug:log(string.format("Tentative d'obtention de la canne %d/%d: %s", i, totalRods, rodName))
        
        -- Recherche de l'événement approprié
        local event = self.services.ReplicatedStorage:FindFirstChild("GetRod") or 
                     self.services.ReplicatedStorage:FindFirstChild("GetItem") or
                     self.services.ReplicatedStorage:FindFirstChild("BuyRod") or
                     self.services.ReplicatedStorage:FindFirstChild("PurchaseRod")
        
        if event then
            local success, errorMsg = pcall(function()
                if event.ClassName == "RemoteFunction" then
                    event:InvokeServer(rodName)
                elseif event.ClassName == "RemoteEvent" then
                    event:FireServer(rodName)
                end
            end)
            
            if success then
                self.rodsObtained[rodName] = true
                successCount = successCount + 1
                debug:log("✓ Canne obtenue avec succès: " .. rodName)
            else
                debug:log("✗ Échec pour " .. rodName .. " - Erreur: " .. tostring(errorMsg))
            end
        else
            debug:log("✗ Aucun événement trouvé pour l'obtention des cannes.")
        end
        
        -- Délai aléatoire pour éviter la détection
        wait(math.random(self.config.RodSettings and self.config.RodSettings.MinDelay or 1, 
                        self.config.RodSettings and self.config.RodSettings.MaxDelay or 3))
    end
    
    debug:log(string.format("Fin de l'obtention des cannes. Succès: %d/%d", successCount, totalRods))
end

function RodManager:equipRod(rodName)
    local debug = DebugManager:new(self.config)
    
    if not self.services.LocalPlayer.Backpack then
        debug:log("ERREUR: Backpack non disponible.")
        return false
    end
    
    local rod = self.services.LocalPlayer.Backpack:FindFirstChild(rodName)
    if rod and rod:IsA("Tool") then
        local humanoid = self.services.LocalPlayer.Character and self.services.LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:EquipTool(rod)
            debug:log("Canne équipée: " .. rodName)
            return true
        end
    end
    
    debug:log("Impossible d'équiper la canne: " .. rodName)
    return false
end

function RodManager:getRodStatus()
    local status = {}
    for rodName, obtained in pairs(self.rodsObtained) do
        status[rodName] = obtained
    end
    return status
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