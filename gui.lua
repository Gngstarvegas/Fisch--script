-- gui.lua

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function CreateButton(frame, text, callback)
    local button = Instance.new("TextButton")
    button.Parent = frame
    button.Text = text
    button.Size = UDim2.new(0.3, 0, 0.1, 0)
    button.Position = UDim2.new(0.1, 0, frame.UIListLayout.AbsoluteContentSize.Y, 0)
    button.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
    button.MouseButton1Click:Connect(callback)
    return button
end

function CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishSimulatorGUI"
    ScreenGui.Parent = game.CoreGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = ScreenGui
    MainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    MainFrame.Size = UDim2.new(0, 300, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    MainFrame.Active = true
    MainFrame.Draggable = true

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = MainFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Bouton pour obtenir les cannes
    CreateButton(MainFrame, "Get All Rods", function()
        GetAllRods()
    end)

    -- Bouton pour téléporter
    local teleportButton = CreateButton(MainFrame, "Teleport", function()
        local selectedLocation = next(TeleportLocations) -- Sélection de la première localisation par défaut
        TeleportTo(TeleportLocations[selectedLocation])
    end)

    -- Bouton pour l'auto-farm
    CreateButton(MainFrame, "Toggle Auto-Farm", function()
        StartAutoFarm()
    end)
end

return {CreateGUI = CreateGUI}
