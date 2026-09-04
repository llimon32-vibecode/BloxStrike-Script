-- =============================================
-- 🍋 BLOXSTRIKE CHEAT (ALL-IN-ONE)
-- by Nevermore / Llimon32
-- =============================================

-- 📌 НАСТРОЙКИ
local Settings = {
    AimBot = true,
    SilentAim = true,
    ESP = true,
    NoRecoil = true,
    NoSpread = true,
    SkinChanger = true,
    FOV = 90,
    TeamCheck = false,
    ShowHealth = true,
}

-- 🎯 ESP (враги через стены)
if Settings.ESP then
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local localPlayer = Players.LocalPlayer

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local char = player.Character
            if char then
                local highlight = Instance.new("Highlight")
                highlight.Parent = char
                highlight.FillColor = Color3.new(1, 0, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineColor = Color3.new(1, 1, 1)
                highlight.OutlineTransparency = 0.5
                highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end
        end
    end
end

-- 🔫 NO RECOIL + NO SPREAD
if Settings.NoRecoil or Settings.NoSpread then
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local CameraController = require(ReplicatedStorage.Controllers.CameraController)
    local InventoryController = require(ReplicatedStorage.Controllers.InventoryController)

    if Settings.NoRecoil then
        CameraController.weaponKick = function() end
        CameraController.setWeaponRecoil = function() end
    end

    if Settings.NoSpread then
        local OriginalShoot = InventoryController.ShootWeapon
        InventoryController.ShootWeapon = function(Self, Data)
            if Data and Data.Bullets then
                local LookVector = workspace.CurrentCamera.CFrame.LookVector
                for _, Bullet in ipairs(Data.Bullets) do
                    Bullet.Direction = LookVector
                end
            end
            return OriginalShoot(Self, Data)
        end
    end
end

-- 🎯 АИМБОТ (Silent Aim)
if Settings.AimBot then
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local localPlayer = Players.LocalPlayer

    local function GetClosestPlayer()
        local closest = nil
        local minDist = math.huge
        local camera = workspace.CurrentCamera

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local char = player.Character
                if char and char:FindFirstChild("Head") then
                    local headPos = camera:WorldToScreenPoint(char.Head.Position)
                    local dist = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
                    if dist < minDist then
                        minDist = dist
                        closest = player
                    end
                end
            end
        end
        return closest
    end

    -- Перехват выстрелов
    local InventoryController = require(game:GetService("ReplicatedStorage").Controllers.InventoryController)
    local OriginalShoot = InventoryController.ShootWeapon
    InventoryController.ShootWeapon = function(Self, Data)
        if Settings.SilentAim then
            local target = GetClosestPlayer()
            if target and target.Character and target.Character:FindFirstChild("Head") then
                local headPos = target.Character.Head.Position
                local direction = (headPos - workspace.CurrentCamera.CFrame.Position).Unit
                for _, Bullet in ipairs(Data.Bullets) do
                    Bullet.Direction = direction
                end
            end
        end
        return OriginalShoot(Self, Data)
    end
end

-- 🎨 СКИН-ЧЕЙНДЖЕР
if Settings.SkinChanger then
    local function ChangeSkin()
        -- Пример: меняем скин на пистолет
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        if character then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then
                local weapon = tool:FindFirstChild("Weapon")
                if weapon and weapon:FindFirstChild("Skin") then
                    weapon.Skin.Value = "Neon" -- или другой скин
                end
            end
        end
    end

    game:GetService("RunService").Heartbeat:Connect(ChangeSkin)
end

print("🍋 BLOXSTRIKE CHEAT LOADED! Meow ^_^")