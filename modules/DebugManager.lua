-- Gestionnaire de débogage avancé
local DebugManager = {}

-- Couleurs pour les logs (si supportées)
local LOG_COLORS = {
    INFO = "[INFO]",
    SUCCESS = "[SUCCESS]", 
    WARNING = "[WARNING]",
    ERROR = "[ERROR]",
    DEBUG = "[DEBUG]"
}

function DebugManager:log(message, logType)
    logType = logType or "INFO"
    
    if not self.config.DebugMode and logType == "DEBUG" then
        return
    end
    
    local timestamp = os.date("%H:%M:%S")
    local prefix = LOG_COLORS[logType] or "[LOG]"
    local fullMessage = string.format("[%s] %s %s", timestamp, prefix, tostring(message))
    
    -- Affichage selon le type de log
    if logType == "ERROR" then
        warn(fullMessage)
    else
        print(fullMessage)
    end
    
    -- Enregistrer dans l'historique
    table.insert(self.logHistory, {
        timestamp = timestamp,
        type = logType,
        message = message
    })
    
    -- Limiter l'historique à 100 entrées
    if #self.logHistory > 100 then
        table.remove(self.logHistory, 1)
    end
end

function DebugManager:logSuccess(message)
    self:log(message, "SUCCESS")
end

function DebugManager:logWarning(message)
    self:log(message, "WARNING")
end

function DebugManager:logError(message)
    self:log(message, "ERROR")
end

function DebugManager:logDebug(message)
    self:log(message, "DEBUG")
end

function DebugManager:logStats(title, stats)
    if not self.config.DebugMode then return end
    
    self:log("📊 " .. title)
    for key, value in pairs(stats) do
        self:log(string.format("   %s: %s", key, tostring(value)))
    end
end

function DebugManager:logServiceStatus(services)
    self:log("🔧 Statut des services:")
    for serviceName, service in pairs(services) do
        local status = service and "✓ OK" or "✗ MANQUANT"
        self:log(string.format("   %s: %s", serviceName, status))
    end
end

function DebugManager:getLogHistory()
    return self.logHistory
end

function DebugManager:clearHistory()
    self.logHistory = {}
    self:log("🗑️ Historique des logs effacé")
end

function DebugManager:exportLogs()
    local export = {}
    for _, logEntry in ipairs(self.logHistory) do
        table.insert(export, string.format("[%s] %s: %s", 
            logEntry.timestamp, logEntry.type, logEntry.message))
    end
    return table.concat(export, "\n")
end

function DebugManager:logPerformance(functionName, startTime)
    local endTime = tick()
    local duration = endTime - startTime
    self:logDebug(string.format("⏱️ %s executed in %.3f seconds", functionName, duration))
end

function DebugManager:createPerformanceTimer(functionName)
    local startTime = tick()
    return function()
        self:logPerformance(functionName, startTime)
    end
end

function DebugManager:logMemoryUsage()
    if not self.config.DebugMode then return end
    
    local memoryUsed = collectgarbage("count")
    self:logDebug(string.format("💾 Memory usage: %.2f KB", memoryUsed))
end

function DebugManager:new(config)
    local obj = {
        config = config or { DebugMode = true },
        logHistory = {}
    }
    setmetatable(obj, self)
    self.__index = self
    
    -- Log d'initialisation
    obj:log("🔍 DebugManager initialisé")
    if obj.config.DebugMode then
        obj:log("⚙️ Mode débogage activé")
    end
    
    return obj
end

return DebugManager