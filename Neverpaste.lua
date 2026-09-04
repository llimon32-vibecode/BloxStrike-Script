-- =============================================
-- 🍋 NEVERPASTE BS V2 — GUI EDITION
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

-- 📦 ОСНОВНОЕ ОКНО
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 350, 0, 500)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- ✨ ЗАГОЛОВОК
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
title.BackgroundTransparency = 0.1
title.Text = " NEVERPASTE BS v2"
title.TextColor3 = Color3.fromRGB(255, 100, 200)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

-- 📋 ВКЛАДКИ
local tabs = {}
local tabContainer = Instance.new("Frame")
tabContainer.Parent = mainFrame
tabContainer.Size = UDim2.new(1, 0, 0, 30)
tabContainer.Position = UDim2.new(0, 0, 0, 30)
tabContainer.BackgroundTransparency = 1

local tabButtons = {}
local tabContents = {}
local currentTab = nil

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Parent = tabContainer
    btn.Size = UDim2.new(0, 70, 1, 0)
    btn.Position = UDim2.new(0, #tabButtons * 72, 0, 0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 0
    table.insert(tabButtons, btn)

    local content = Instance.new("ScrollingFrame")
    content.Parent = mainFrame
    content.Size = UDim2.new(1, -10, 1, -90)
    content.Position = UDim2.new(0, 5, 0, 65)
    content.BackgroundTransparency = 1
    content.Visible = false
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 4
    table.insert(tabContents, content)

    btn.MouseButton1Click:Connect(function()
        for _, v in pairs(tabContents) do v.Visible = false end
        for _, v in pairs(tabButtons) do v.BackgroundColor3 = Color3.fromRGB(30, 30, 35) end
        content.Visible = true
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
        currentTab = name
    end)

    return content
end

-- 📌 ФУНКЦИЯ СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЯ
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
    toggleBtn.Size = UDim2.new(0, 40, 0, 20)
    toggleBtn.Position = UDim2.new(0.8, 0, 0.5, -10)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
    toggleBtn.BorderSizePixel = 0

    local state = default
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
        if callback then callback(state) end
    end)

    return toggleBtn, function() return state end
end

-- 📌 ФУНКЦИЯ СОЗДАНИЯ СЛАЙДЕРА
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
    fill.BackgroundColor3 = Color3.fromRGB(255, 100, 200)

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

-- 🎯 ВКЛАДКА AIM
local aimSettings = {
    silent = createToggle(aimTab, "Silent Aim", true),
    fov = createSlider(aimTab, "Aim FOV", 0, 180, 90),
    teamCheck = createToggle(aimTab, "Team Check", false),
    noRecoil = createToggle(aimTab, "No Recoil", true),
    noSpread = createToggle(aimTab, "No Spread", true),
}

-- 👁️ ВКЛАДКА VISUAL
local visualSettings = {
    esp = createToggle(visualTab, "ESP (Wallhack)", true),
    showHealth = createToggle(visualTab, "Show Health", true),
    skinChanger = createToggle(visualTab, "Skin Changer", true),
}

-- 🛠️ ВКЛАДКА MISC
local miscSettings = {
    fovCircle = createToggle(miscTab, "FOV Circle", true),
}

-- 🎯 ОСНОВНАЯ ЛОГИКА (с использованием GUI)
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

-- ESP
if visualSettings.esp then
    local function addHighlight(player)
        if player == localPlayer then return end
        local char = player.Character
        if not char then
            player.CharacterAdded:Connect(function(c)
                task.wait(0.5)
                addHighlight(player)
            end)
            return
        end
        if char:FindFirstChild("Highlight") then return end
        local highlight = Instance.new("Highlight")
        highlight.Parent = char
        highlight.FillColor = Color3.new(1, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.new(1, 1, 1)
        highlight.OutlineTransparency = 0.5
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Name = "Highlight"
        highlight.Enabled = visualSettings.esp()
    end

    for _, player in pairs(Players:GetPlayers()) do
        addHighlight(player)
    end

    Players.PlayerAdded:Connect(addHighlight)
end

-- AIMBOT
local function aimbot()
    if not aimSettings.silent() then return end
    local target = GetClosestPlayer()
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then return end

    local headPos = target.Character.Head.Position
    local direction = (headPos - camera.CFrame.Position).Unit
    return direction
end

-- 🎯 ПЕРЕХВАТ ВЫСТРЕЛОВ
local function hookShoot()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)
    local OriginalShoot = InventoryController.ShootWeapon

    InventoryController.ShootWeapon = function(Self, Data)
        if Data and Data.Bullets then
            local camera = workspace.CurrentCamera
            if camera then
                local LookVector = aimbot() or camera.CFrame.LookVector
                if aimSettings.noSpread() then
                    for _, Bullet in ipairs(Data.Bullets) do
                        Bullet.Direction = LookVector
                    end
                end
            end
        end
        return OriginalShoot(Self, Data)
    end
end

-- NO RECOIL
local function hookRecoil()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CameraController = require(ReplicatedStorage.Controllers.CameraController)
    if aimSettings.noRecoil() then
        CameraController.weaponKick = function() end
        CameraController.setWeaponRecoil = function() end
    end
end

-- СКИН-ЧЕЙНДЖЕР
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

-- 🔄 ЗАПУСК ВСЕГО
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
border.Color = Color3.fromRGB(255, 100, 200)
border.Thickness = 1
border.Transparency = 0.5
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

fovCircle.Visible = miscSettings.fovCircle()

-- 🔄 ОБНОВЛЕНИЕ FOV
RunService.Heartbeat:Connect(function()
    local fov = aimSettings.fov()
    fovCircle.Size = UDim2.new(0, fov * 2, 0, fov * 2)
    fovCircle.Position = UDim2.new(0.5, -fov, 0.5, -fov)
end)

print("🍋 NEVERPASTE BS V2 — GUI EDITION LOADED! Meow ^_^")