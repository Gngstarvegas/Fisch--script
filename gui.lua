-- Interface utilisateur optimisée pour Fisch
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- Variables globales de l'interface
local gui = {}
local mainFrame = nil
local buttons = {}

-- Fonction pour créer un bouton stylisé
local function CreateStyledButton(parent, text, position, size, callback)
    local button = Instance.new("TextButton")
    button.Name = text .. "Button"
    button.Parent = parent
    button.Text = text
    button.Size = size or UDim2.new(0.9, 0, 0, 35)
    button.Position = position
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextScaled = true
    button.Font = Enum.Font.SourceSansSemibold
    button.BorderSizePixel = 2
    button.BorderColor3 = Color3.fromRGB(85, 170, 255)
    
    -- Effets visuels
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button
    
    -- Animation au survol
    button.MouseEnter:Connect(function()
        button:TweenSize(UDim2.new(0.92, 0, 0, 37), "Out", "Quad", 0.2, true)
        button.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    end)
    
    button.MouseLeave:Connect(function()
        button:TweenSize(size or UDim2.new(0.9, 0, 0, 35), "Out", "Quad", 0.2, true)
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end)
    
    -- Connexion du callback
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

-- Fonction pour créer un label d'information
local function CreateInfoLabel(parent, text, position)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.Text = text
    label.Size = UDim2.new(0.9, 0, 0, 20)
    label.Position = position
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    return label
end

-- Fonction pour mettre à jour le statut des boutons
local function UpdateButtonStatus(buttonName, status, color)
    if buttons[buttonName] then
        local originalText = buttons[buttonName].Name:gsub("Button", "")
        buttons[buttonName].Text = originalText .. " " .. status
        buttons[buttonName].BorderColor3 = color or Color3.fromRGB(85, 170, 255)
    end
end

-- Fonction principale pour créer l'interface
function CreateGUI(rodManager, teleportManager, autoFarmManager, config)
    -- Supprimer l'ancienne interface si elle existe
    local existingGui = game.CoreGui:FindFirstChild(config.UISettings.GuiName)
    if existingGui then
        existingGui:Destroy()
    end
    
    -- Création de la ScreenGui principale
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = config.UISettings.GuiName
    screenGui.Parent = game.CoreGui
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    
    -- Frame principale
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderColor3 = Color3.fromRGB(85, 170, 255)
    mainFrame.BorderSizePixel = 2
    mainFrame.Size = UDim2.new(0, config.UISettings.WindowSize.X, 0, config.UISettings.WindowSize.Y)
    mainFrame.Position = UDim2.new(0.5, -config.UISettings.WindowSize.X/2, 0.5, -config.UISettings.WindowSize.Y/2)
    mainFrame.Active = true
    
    if config.UISettings.Draggable then
        mainFrame.Draggable = true
    end
    
    -- Coin arrondi pour la frame principale
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame
    
    -- Titre
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Parent = mainFrame
    titleLabel.Text = config.UISettings.WindowTitle
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.SourceSansBold
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleLabel
    
    -- Variables de position
    local yOffset = 60
    local buttonSpacing = 45
    
    -- Bouton pour obtenir toutes les cannes
    buttons.GetAllRods = CreateStyledButton(mainFrame, "🎣 Obtenir toutes les cannes", 
        UDim2.new(0.05, 0, 0, yOffset), nil, function()
            UpdateButtonStatus("GetAllRods", "⏳", Color3.fromRGB(255, 165, 0))
            rodManager:getAllRods()
            wait(1)
            UpdateButtonStatus("GetAllRods", "✓", Color3.fromRGB(0, 255, 0))
            wait(2)
            UpdateButtonStatus("GetAllRods", "", nil)
        end)
    yOffset = yOffset + buttonSpacing
    
    -- Menu déroulant pour la téléportation
    local teleportFrame = Instance.new("Frame")
    teleportFrame.Parent = mainFrame
    teleportFrame.Size = UDim2.new(0.9, 0, 0, 35)
    teleportFrame.Position = UDim2.new(0.05, 0, 0, yOffset)
    teleportFrame.BackgroundTransparency = 1
    
    -- Bouton de téléportation
    buttons.Teleport = CreateStyledButton(teleportFrame, "🚀 Téléporter vers Zone", 
        UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 1, 0), function()
            local locations = {}
            for name, _ in pairs(config.TeleportLocations) do
                table.insert(locations, name)
            end
            
            if #locations > 0 then
                local selectedLocation = locations[math.random(1, #locations)]
                UpdateButtonStatus("Teleport", "⏳", Color3.fromRGB(255, 165, 0))
                teleportManager:teleportTo(selectedLocation)
                wait(0.5)
                UpdateButtonStatus("Teleport", "✓", Color3.fromRGB(0, 255, 0))
                wait(2)
                UpdateButtonStatus("Teleport", "", nil)
            end
        end)
    yOffset = yOffset + buttonSpacing
    
    -- Bouton pour l'auto-farm
    buttons.AutoFarm = CreateStyledButton(mainFrame, "⚡ Toggle Auto-Farm", 
        UDim2.new(0.05, 0, 0, yOffset), nil, function()
            if autoFarmManager:getStatus().active then
                autoFarmManager:stopAutoFarm()
                UpdateButtonStatus("AutoFarm", "🛑", Color3.fromRGB(255, 0, 0))
            else
                autoFarmManager:startAutoFarm()
                UpdateButtonStatus("AutoFarm", "🚀", Color3.fromRGB(0, 255, 0))
            end
        end)
    yOffset = yOffset + buttonSpacing
    
    -- Bouton de fermeture
    local closeButton = Instance.new("TextButton")
    closeButton.Parent = mainFrame
    closeButton.Text = "✖"
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.SourceSansBold
    closeButton.TextScaled = true
    closeButton.BorderSizePixel = 0
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Label d'information
    CreateInfoLabel(mainFrame, "Statut: ✓ Interface chargée avec succès", 
        UDim2.new(0.05, 0, 0, yOffset))
    
    -- Afficher un message de bienvenue
    if config.Messages and config.Messages.Welcome then
        print(config.Messages.Welcome)
    end
    
    -- Stocker les références pour usage ultérieur
    gui.screenGui = screenGui
    gui.mainFrame = mainFrame
    gui.buttons = buttons
    
    return gui
end

-- Fonction pour détruire l'interface
function DestroyGUI()
    if gui.screenGui then
        gui.screenGui:Destroy()
    end
    gui = {}
    buttons = {}
end

-- Fonction pour basculer la visibilité
function ToggleGUI()
    if gui.mainFrame then
        gui.mainFrame.Visible = not gui.mainFrame.Visible
    end
end

-- Export des fonctions
return {
    CreateGUI = CreateGUI,
    DestroyGUI = DestroyGUI,
    ToggleGUI = ToggleGUI
}