-- =============================================
-- 🍋 NEVERPASTE BS V2 — NEVERLOSE STYLE
-- by Nevermore / Llimon32
-- Полноценное GUI для BloxStrike, как в Neverlose
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- 🖥️ GUI СОЗДАНИЕ
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
screenGui.Name = "NeverpasteGUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- 📦 ОСНОВНОЕ ОКНО
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 350, 0, 480)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.Parent = mainFrame
corner.CornerRadius = UDim.new(0, 6)

-- 🏷️ ЗАГОЛОВОК
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 32)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
title.Text = "  NEVERPASTE BS v2"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

-- ✨ РАЗДЕЛИТЕЛЬ
local separator = Instance.new("Frame")
separator.Parent = mainFrame
separator.Size = UDim2.new(1, 0, 0, 1)
separator.Position = UDim2.new(0, 0, 0, 32)
separator.BackgroundColor3 = Color3.fromRGB(60, 60, 70)

-- 📋 ВКЛАДКИ
local tabButtons = {}
local tabContents = {}
local currentTab = nil

local tabContainer = Instance.new("Frame")
tabContainer.Parent = mainFrame
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.Position = UDim2.new(0, 0, 0, 33)
tabContainer.BackgroundTransparency = 1
tabContainer.ClipsDescendants = false

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Parent = tabContainer
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.Position = UDim2.new(0, #tabButtons * 82, 0, 0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamSemibold
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    table.insert(tabButtons, btn)

    local content = Instance.new("ScrollingFrame")
    content.Parent = mainFrame
    content.Size = UDim2.new(1, -10, 1, -85)
    content.Position = UDim2.new(0, 5, 0, 65)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
    table.insert(tabContents, content)

    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(tabContents) do v.Visible = false end
        for _, v in pairs(tabButtons) do v.TextColor3 = Color3.fromRGB(200, 200, 200) end
        content.Visible = true
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        currentTab = name
    end)

    return content
end

-- 📌 СОЗДАНИЕ ПЕРЕКЛЮЧАТЕЛЯ
local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1, -10, 0, 30)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.Size = UDim2.new(0, 50, 0, 22)
    toggleBtn.Position = UDim2.new(0.75, 0, 0.5, -11)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(170, 50, 50)
    toggleBtn.BorderSizePixel = 0

    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 85) or Color3.fromRGB(170, 50, 50)
        if callback then callback(state) end
    end)

    return toggleBtn, function() return state end
end

-- 📌 СОЗДАНИЕ СЛАЙДЕРА
local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundTransparency = 1

    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.Size = UDim2.new(0.6, 0, 0.5, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextSize = 14
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.BackgroundTransparency = 1

    local valueLabel = Instance.new("TextLabel")
    valueLabel.Parent = frame
    valueLabel.Size = UDim2.new(0.3, 0, 0.5, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    valueLabel.TextSize = 12
    valueLabel.Font = Enum.Font.Gotham
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.BackgroundTransparency = 1

    local slider = Instance.new("Frame")
    slider.Parent = frame
    slider.Size = UDim2.new(0.9, 0, 0, 4)
    slider.Position = UDim2.new(0.05, 0, 0.7, 0)
    slider.BackgroundColor3 = Color3.fromRGB(60, 60, 70)

    local fill = Instance.new("Frame")
    fill.Parent = slider
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)

    local dragging = false
    local function updateSlider(input)
        local x = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
        local val = min + x * (max - min)
        val = math.round(val)
        fill.Size = UDim2.new(x, 0, 1, 0)
        valueLabel.Text = tostring(val)
        if callback then callback(val) end
    end

    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            updateSlider(input)
        end
    end)

    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            updateSlider(input)
        end
    end)

    return fill, function() return tonumber(valueLabel.Text) end
end

-- ⚙️ СОЗДАНИЕ ВКЛАДОК
local aimTab = createTab("AIM")
local visualTab = createTab("VISUAL")
local miscTab = createTab("MISC")

-- 🎯 НАСТРОЙКИ AIM
local aimSettings = {
    silent = createToggle(aimTab, "Silent Aim", true),
    fov = createSlider(aimTab, "Aim FOV", 0, 180, 90),
    teamCheck = createToggle(aimTab, "Team Check", false),
    noRecoil = createToggle(aimTab, "No Recoil", true),
    noSpread = createToggle(aimTab, "No Spread", true),
}

-- 👁️ НАСТРОЙКИ VISUAL
local visualSettings = {
    esp = createToggle(visualTab, "ESP (Wallhack)", true),
    showHealth = createToggle(visualTab, "Show Health", true),
    skinChanger = createToggle(visualTab, "Skin Changer", true),
}

-- 🛠️ НАСТРОЙКИ MISC
local miscSettings = {
    fovCircle = createToggle(miscTab, "FOV Circle", true),
}

-- ⚙️ ЛОГИКА
local function GetClosestPlayer()
    if not camera then return nil end
    local closest = nil
    local minDist = math.huge
    local fov = aimSettings.fov()

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Head") then
                local headPos, onScreen = camera:WorldToScreenPoint(char.Head.Position)
                if onScreen then
                    local dist = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
                    if dist < minDist and dist < fov then
                        minDist = dist
                        closest = player
                    end
                end
            end
        end
    end
    return closest
end

-- 🎯 ESP (с обновлением)
local espHighlights = {}
local function updateESP()
    local espEnabled = visualSettings.esp()
    for _, player in pairs(Players:GetPlayers()) do
        if player == localPlayer then continue end
        local char = player.Character
        if not char then continue end
        local highlight = espHighlights[player]
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Parent = char
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.OutlineTransparency = 0.5
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Name = "Highlight"
            espHighlights[player] = highlight
        end
        highlight.Enabled = espEnabled
        if visualSettings.showHealth() and player.Character:FindFirstChild("Humanoid") then
            local health = player.Character.Humanoid.Health
            local maxHealth = player.Character.Humanoid.MaxHealth
            highlight.FillColor = Color3.fromRGB(255 * (1 - health/maxHealth), 255 * (health/maxHealth), 0)
        else
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
        end
    end
end

RunService.Heartbeat:Connect(updateESP)

-- 🎯 AIMBOT
local function aimbot()
    if not aimSettings.silent() then return nil end
    local target = GetClosestPlayer()
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then return nil end
    local headPos = target.Character.Head.Position
    local direction = (headPos - camera.CFrame.Position).Unit
    return direction
end

-- 🎯 ПЕРЕХВАТ ВЫСТРЕЛОВ
local function hookShoot()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    if not ReplicatedStorage then return end
    local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
    if not InventoryController then return end
    local OriginalShoot = InventoryController.ShootWeapon

    InventoryController.ShootWeapon = function(Self, Data)
        if Data and Data.Bullets then
            local camera = workspace.CurrentCamera
            if camera then
                local direction = aimbot()
                if direction and aimSettings.noSpread() then
                    for _, Bullet in ipairs(Data.Bullets) do
                        Bullet.Direction = direction
                    end
                end
            end
        end
        return OriginalShoot(Self, Data)
    end
end

-- 🔫 NO RECOIL
local function hookRecoil()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    if not ReplicatedStorage then return end
    local CameraController = require(ReplicatedStorage.Controllers.CameraController)
    if not CameraController then return end
    if aimSettings.noRecoil() then
        CameraController.weaponKick = function() end
        CameraController.setWeaponRecoil = function() end
    end
end

-- 🎨 СКИН-ЧЕЙНДЖЕР
local function skinChanger()
    if not visualSettings.skinChanger() then return end
    local character = localPlayer.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            local weapon = tool:FindFirstChild("Weapon")
            if weapon and weapon:FindFirstChild("Skin") then
                weapon.Skin.Value = "Neon"
            end
        end
    end
end

-- 🔄 ЗАПУСК
hookShoot()
hookRecoil()
RunService.Heartbeat:Connect(skinChanger)

-- 🖌️ FOV КРУГ
local fovCircle = Instance.new("Frame")
fovCircle.Parent = screenGui
fovCircle.Size = UDim2.new(0, aimSettings.fov() * 2, 0, aimSettings.fov() * 2)
fovCircle.Position = UDim2.new(0.5, -aimSettings.fov(), 0.5, -aimSettings.fov())
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.ZIndex = 0

local circle = Instance.new("UICorner")
circle.Parent = fovCircle
circle.CornerRadius = UDim.new(1, 0)

local border = Instance.new("UIStroke")
border.Parent = fovCircle
border.Color = Color3.fromRGB(100, 200, 255)
border.Thickness = 1.5
border.Transparency = 0.5
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

fovCircle.Visible = miscSettings.fovCircle()

-- 🔄 ОБНОВЛЕНИЕ FOV
RunService.Heartbeat:Connect(function()
    local fov = aimSettings.fov()
    fovCircle.Size = UDim2.new(0, fov * 2, 0, fov * 2)
    fovCircle.Position = UDim2.new(0.5, -fov, 0.5, -fov)
end)

print("🍋 NEVERPASTE BS V2 — NEVERLOSE STYLE LOADED! Meow ^_^")