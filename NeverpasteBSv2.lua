-- =============================================
-- 🍋 BLOXSTRIKE CHEAT (ALL-IN-ONE) [IMPROVED]
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
    local localPlayer = Players.LocalPlayer

    local function addHighlight(player)
        if player == localPlayer then return end
        local char = player.Character
        if not char then
            player.CharacterAdded:Connect(function(c)
                task.wait(0.5) -- Ждем, пока загрузится персонаж
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
    end

    for _, player in pairs(Players:GetPlayers()) do
        addHighlight(player)
    end

    Players.PlayerAdded:Connect(addHighlight)
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
                local camera = workspace.CurrentCamera
                if camera then
                    local LookVector = camera.CFrame.LookVector
                    for _, Bullet in ipairs(Data.Bullets) do
                        Bullet.Direction = LookVector
                    end
                end
            end
            return OriginalShoot(Self, Data)
        end
    end
end

-- 🎯 АИМБОТ (Silent Aim)
if Settings.AimBot then
    local Players = game:GetService("Players")
    local localPlayer = Players.LocalPlayer

    local function GetClosestPlayer()
        local closest = nil
        local minDist = math.huge
        local camera = workspace.CurrentCamera
        if not camera then return nil end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= localPlayer then
                local char = player.Character
                if char and char:FindFirstChild("Head") then
                    local headPos, onScreen = camera:WorldToScreenPoint(char.Head.Position)
                    if onScreen then
                        local dist = (Vector2.new(headPos.X, headPos.Y) - Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)).Magnitude
                        if dist < minDist then
                            minDist = dist
                            closest = player
                        end
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
            local camera = workspace.CurrentCamera
            if target and target.Character and target.Character:FindFirstChild("Head") and camera then
                local headPos = target.Character.Head.Position
                local direction = (headPos - camera.CFrame.Position).Unit
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