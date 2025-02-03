-- Gestion des messages de débogage
local DebugManager = {}

function DebugManager:log(message)
    if self.config.DebugMode then
        print("[DEBUG] " .. message)
    end
end

function DebugManager:new(config)
    local obj = { config = config }
    setmetatable(obj, self)
    self.__index = self
    return obj
end

return DebugManager
