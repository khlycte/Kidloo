local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Config = {
    Chams = true,
    HealthESP = true,
    AimAuto = false,
    FOVRadius = 150,
    ShowFOV = true,
    AutoKill = false,
    AutoKillDistance = 5,
    SelectedTarget = "Tất Cả",
    Spin = false,
    SpinSpeed = 20,
    ThirdPerson = false,
    Fly = false,
    FlySpeed = 50
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KICA_HUB"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Transparency = 0.7
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Filled = false
FOVCircle.Radius = Config.FOVRadius

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleButton.Text = "❄️"
ToggleButton.TextSize = 28
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke", ToggleButton)
ToggleStroke.Thickness = 2
ToggleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 260)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

RunService.RenderStepped:Connect(function()
    local hue = (tick() % 5) / 5
    ToggleStroke.Color = Color3.fromHSV(hue, 1, 1)
    
    FOVCircle.Visible = Config.ShowFOV and Config.AimAuto
    FOVCircle.Radius = Config.FOVRadius
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "KICA HUB ❄️"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(0, 90, 1, -35)
TabHolder.Position = UDim2.new(0, 5, 0, 30)
TabHolder.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TabHolder.Parent = MainFrame
Instance.new("UICorner", TabHolder).CornerRadius = UDim.new(0, 6)

local ESPTabBtn = Instance.new("TextButton")
ESPTabBtn.Size = UDim2.new(1, -10, 0, 28)
ESPTabBtn.Position = UDim2.new(0, 5, 0, 5)
ESPTabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
ESPTabBtn.Text = "ESP"
ESPTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPTabBtn.Font = Enum.Font.SourceSansBold
ESPTabBtn.Parent = TabHolder
Instance.new("UICorner", ESPTabBtn).CornerRadius = UDim.new(0, 4)

local AIMTabBtn = Instance.new("TextButton")
AIMTabBtn.Size = UDim2.new(1, -10, 0, 28)
AIMTabBtn.Position = UDim2.new(0, 5, 0, 38)
AIMTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
AIMTabBtn.Text = "AIM"
AIMTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AIMTabBtn.Font = Enum.Font.SourceSansBold
AIMTabBtn.Parent = TabHolder
Instance.new("UICorner", AIMTabBtn).CornerRadius = UDim.new(0, 4)

local SettingTabBtn = Instance.new("TextButton")
SettingTabBtn.Size = UDim2.new(1, -10, 0, 28)
SettingTabBtn.Position = UDim2.new(0, 5, 0, 71)
SettingTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
SettingTabBtn.Text = "Setting"
SettingTabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingTabBtn.Font = Enum.Font.SourceSansBold
SettingTabBtn.Parent = TabHolder
Instance.new("UICorner", SettingTabBtn).CornerRadius = UDim.new(0, 4)

local ESPPage = Instance.new("ScrollingFrame")
ESPPage.Size = UDim2.new(1, -105, 1, -35)
ESPPage.Position = UDim2.new(0, 100, 0, 30)
ESPPage.BackgroundTransparency = 1
ESPPage.Visible = true
ESPPage.CanvasSize = UDim2.new(0, 0, 0, 100)
ESPPage.ScrollBarThickness = 3
ESPPage.Parent = MainFrame

local AIMPage = Instance.new("ScrollingFrame")
AIMPage.Size = UDim2.new(1, -105, 1, -35)
AIMPage.Position = UDim2.new(0, 100, 0, 30)
AIMPage.BackgroundTransparency = 1
AIMPage.Visible = false
AIMPage.CanvasSize = UDim2.new(0, 0, 0, 130)
AIMPage.ScrollBarThickness = 3
AIMPage.Parent = MainFrame

local SettingPage = Instance.new("ScrollingFrame")
SettingPage.Size = UDim2.new(1, -105, 1, -35)
SettingPage.Position = UDim2.new(0, 100, 0, 30)
SettingPage.BackgroundTransparency = 1
SettingPage.Visible = false
SettingPage.CanvasSize = UDim2.new(0, 0, 0, 420)
SettingPage.ScrollBarThickness = 3
SettingPage.Parent = MainFrame

local function switchTab(activeBtn, activePage)
    ESPTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    AIMTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    SettingTabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    
    ESPPage.Visible = false
    AIMPage.Visible = false
    SettingPage.Visible = false
    
    activeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    activePage.Visible = true
end

ESPTabBtn.MouseButton1Click:Connect(function() switchTab(ESPTabBtn, ESPPage) end)
AIMTabBtn.MouseButton1Click:Connect(function() switchTab(AIMTabBtn, AIMPage) end)
SettingTabBtn.MouseButton1Click:Connect(function() switchTab(SettingTabBtn, SettingPage) end)

local function createToggle(parent, text, yPos, defaultState, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -15, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = text .. (defaultState and ": BẬT" or ": TẮT")
    btn.TextColor3 = defaultState and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 13
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    local state = defaultState
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. (state and ": BẬT" or ": TẮT")
        btn.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        callback(state)
    end)
    return btn
end

local function createTextBox(parent, labelText, yPos, defaultValue, callback)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -15, 0, 15)
    lbl.Position = UDim2.new(0, 5, 0, yPos)
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.SourceSans
    lbl.BackgroundTransparency = 1
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -15, 0, 25)
    box.Position = UDim2.new(0, 5, 0, yPos + 18)
    box.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    box.Text = tostring(defaultValue)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.SourceSansBold
    box.TextSize = 13
    box.Parent = parent
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)

    box.FocusLost:Connect(function()
        local val = tonumber(box.Text)
        if val then callback(val) else box.Text = tostring(defaultValue) end
    end)
end

createToggle(ESPPage, "chams red", 5, Config.Chams, function(v) Config.Chams = v end)
createToggle(ESPPage, "ESP Thanh Máu", 40, Config.HealthESP, function(v) Config.HealthESP = v end)

createToggle(AIMPage, "aim auto", 5, Config.AimAuto, function(v) Config.AimAuto = v end)
createToggle(AIMPage, "Hiện FOV", 40, Config.ShowFOV, function(v) Config.ShowFOV = v end)
createTextBox(AIMPage, "Đường kính FOV:", 75, Config.FOVRadius, function(v) Config.FOVRadius = v end)

createToggle(SettingPage, "Auto Kill", 5, Config.AutoKill, function(v) Config.AutoKill = v end)
createTextBox(SettingPage, "Khoảng cách Auto Kill (m):", 40, Config.AutoKillDistance, function(v) Config.AutoKillDistance = v end)

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, -55, 0, 15)
TargetLabel.Position = UDim2.new(0, 5, 0, 85)
TargetLabel.Text = "Chọn Mục tiêu: Tất Cả"
TargetLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
TargetLabel.TextSize = 12
TargetLabel.Font = Enum.Font.SourceSansBold
TargetLabel.BackgroundTransparency = 1
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
TargetLabel.Parent = SettingPage

local RefreshBtn = Instance.new("TextButton")
RefreshBtn.Size = UDim2.new(0, 35, 0, 18)
RefreshBtn.Position = UDim2.new(1, -45, 0, 83)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
RefreshBtn.Text = "🔄"
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.TextSize = 12
RefreshBtn.Parent = SettingPage
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 4)

local TargetListFrame = Instance.new("ScrollingFrame")
TargetListFrame.Size = UDim2.new(1, -15, 0, 80)
TargetListFrame.Position = UDim2.new(0, 5, 0, 105)
TargetListFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TargetListFrame.ScrollBarThickness = 3
TargetListFrame.Parent = SettingPage
Instance.new("UICorner", TargetListFrame).CornerRadius = UDim.new(0, 6)

local TargetUIList = Instance.new("UIListLayout")
TargetUIList.SortOrder = Enum.SortOrder.LayoutOrder
TargetUIList.Padding = UDim.new(0, 2)
TargetUIList.Parent = TargetListFrame
local isRivalsEnemy = function(player)
    if not player or not player:IsA("Player") or player == LocalPlayer then 
        return false 
    end

    local char = player.Character
    if not char then return false end
    
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end

    if LocalPlayer.Team and player.Team then
        if LocalPlayer.Team == player.Team then return false end
    end

    local lTeam = LocalPlayer:FindFirstChild("Team") or LocalPlayer:FindFirstChild("TeamValue") or LocalPlayer:FindFirstChild("Squad")
    local tTeam = player:FindFirstChild("Team") or player:FindFirstChild("TeamValue") or player:FindFirstChild("Squad")
    if lTeam and tTeam and lTeam.Value == tTeam.Value then
        return false
    end

    local lCharTeam = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChild("Team") or LocalPlayer.Character:FindFirstChild("TeamValue"))
    local tCharTeam = char:FindFirstChild("Team") or char:FindFirstChild("TeamValue")
    if lCharTeam and tCharTeam and lCharTeam.Value == tCharTeam.Value then
        return false
    end

    if char:FindFirstChild("ForceField") or char:FindFirstChild("Invulnerable") or char:FindFirstChild("SafeZone") then
        return false
    end

    return true
end

local function renderTargetList()
    for _, child in pairs(TargetListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end

    local targets = {"Tất Cả"}
    for _, p in pairs(Players:GetPlayers()) do
        if isRivalsEnemy(p) then
            table.insert(targets, p.Name)
        end
    end

    TargetListFrame.CanvasSize = UDim2.new(0, 0, 0, #targets * 24)

    for _, name in ipairs(targets) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 22)
        btn.BackgroundColor3 = (Config.SelectedTarget == name) and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(30, 30, 30)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 12
        btn.Parent = TargetListFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)

        btn.MouseButton1Click:Connect(function()
            Config.SelectedTarget = name
            TargetLabel.Text = "Chọn Mục tiêu: " .. name
            renderTargetList()
        end)
    end
end

RefreshBtn.MouseButton1Click:Connect(renderTargetList)
renderTargetList()

createToggle(SettingPage, "Xoay Nhân Vật (Spin)", 195, Config.Spin, function(v) Config.Spin = v end)
createTextBox(SettingPage, "Tốc độ quay spin:", 230, Config.SpinSpeed, function(v) Config.SpinSpeed = v end)
createToggle(SettingPage, "góc nhìn thứ 3", 273, Config.ThirdPerson, function(v) 
    Config.ThirdPerson = v
    if not v and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetChildren()) do
            if p:IsA("BasePart") then p.LocalTransparencyModifier = 0 end
        end
    end
end)

local flyKeys = {W = 0, S = 0, A = 0, D = 0, Up = 0, Down = 0}

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W = 1 end
    if input.KeyCode == Enum.KeyCode.S then flyKeys.S = -1 end
    if input.KeyCode == Enum.KeyCode.A then flyKeys.A = -1 end
    if input.KeyCode == Enum.KeyCode.D then flyKeys.D = 1 end
    if input.KeyCode == Enum.KeyCode.Space then flyKeys.Up = 1 end
    if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Down = -1 end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
    if input.KeyCode == Enum.KeyCode.W then flyKeys.W = 0 end
    if input.KeyCode == Enum.KeyCode.S then flyKeys.S = 0 end
    if input.KeyCode == Enum.KeyCode.A then flyKeys.A = 0 end
    if input.KeyCode == Enum.KeyCode.D then flyKeys.D = 0 end
    if input.KeyCode == Enum.KeyCode.Space then flyKeys.Up = 0 end
    if input.KeyCode == Enum.KeyCode.LeftShift then flyKeys.Down = 0 end
end)

local bodyGyro, bodyVelocity

local function stopFly()
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    
    if LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
        if root then
            for _, v in pairs(root:GetChildren()) do
                if v.Name == "KicaFlyGyro" or v.Name == "KicaFlyVel" then
                    v:Destroy()
                end
            end
        end
    end
end

local function startFly()
    stopFly()
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not root then return end

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.Name = "KicaFlyGyro"
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = root.CFrame
    bodyGyro.Parent = root

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Name = "KicaFlyVel"
    bodyVelocity.velocity = Vector3.new(0, 0, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = root
end

createToggle(SettingPage, "Bay (Fly)", 313, Config.Fly, function(v)
    Config.Fly = v
    if v then 
        startFly() 
    else 
        stopFly() 
    end
end)

createTextBox(SettingPage, "Tốc độ Fly:", 350, Config.FlySpeed, function(v) Config.FlySpeed = v end)

local function applyRedChams(char)
    local folder = char:FindFirstChild("KicaChamsFolder")
    if not folder then
        folder = Instance.new("Folder")
        folder.Name = "KicaChamsFolder"
        folder.Parent = char
    end

    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            local chamsBox = folder:FindFirstChild(part.Name .. "_Chams")
            if not chamsBox then
                chamsBox = Instance.new("BoxHandleAdornment")
                chamsBox.Name = part.Name .. "_Chams"
                chamsBox.Adornee = part
                chamsBox.AlwaysOnTop = true
                chamsBox.ZIndex = 10
                chamsBox.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
                chamsBox.Color3 = Color3.fromRGB(255, 0, 0)
                chamsBox.Transparency = 0.3
                chamsBox.Parent = folder
            end
            chamsBox.Visible = true
        end
    end
end

local function removeRedChams(char)
    local folder = char:FindFirstChild("KicaChamsFolder")
    if folder then folder:Destroy() end
end

local healthBars = {}

local function createHealthBar(player)
    if healthBars[player] then return end
    local bg = Drawing.new("Square")
    bg.Visible = false
    bg.Color = Color3.fromRGB(0, 0, 0)
    bg.Thickness = 1
    bg.Filled = true
    bg.Transparency = 0.6

    local bar = Drawing.new("Square")
    bar.Visible = false
    bar.Color = Color3.fromRGB(0, 255, 0)
    bar.Thickness = 1
    bar.Filled = true
    bar.Transparency = 1

    healthBars[player] = {BG = bg, Bar = bar}
end

local function removeHealthBar(player)
    if healthBars[player] then
        healthBars[player].BG:Remove()
        healthBars[player].Bar:Remove()
        healthBars[player] = nil
    end
end

for _, p in pairs(Players:GetPlayers()) do createHealthBar(p) end
Players.PlayerAdded:Connect(function(p) createHealthBar(p) renderTargetList() end)
Players.PlayerRemoving:Connect(function(p) removeHealthBar(p) renderTargetList() end)

task.spawn(function()
    while task.wait(0.2) do
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                if Config.Chams and isRivalsEnemy(player) then
                    applyRedChams(player.Character)
                else
                    removeRedChams(player.Character)
                end
            end
        end
    end
end)

local function isVisible(targetPart, char)
    if not targetPart then return false end
    local origin = Camera.CFrame.Position
    local direction = targetPart.Position - origin
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, char}
    
    local result = Workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

local function getValidEnemyPlayer()
    if Config.SelectedTarget ~= "Tất Cả" then
        local selectedP = Players:FindFirstChild(Config.SelectedTarget)
        if selectedP and isRivalsEnemy(selectedP) then
            return selectedP
        end
        return nil
    end

    local closestPlayer = nil
    local shortestDist = Config.FOVRadius
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, player in pairs(Players:GetPlayers()) do
        if isRivalsEnemy(player) and player.Character then
            local char = player.Character
            local head = char:FindFirstChild("Head")
            if head and isVisible(head, char) then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist <= shortestDist then
                        shortestDist = dist
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end

local spinAngle = 0
RunService.RenderStepped:Connect(function()
    if Config.Fly and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
        if root then
            if not bodyGyro or not bodyGyro.Parent then 
                startFly() 
            end
            if bodyGyro and bodyVelocity then
                bodyGyro.cframe = Camera.CFrame
                
                local moveDir = Vector3.new(
                    flyKeys.A + flyKeys.D,
                    flyKeys.Up + flyKeys.Down,
                    -(flyKeys.W + flyKeys.S)
                )
                
                if moveDir.Magnitude > 0 then
                    bodyVelocity.velocity = Camera.CFrame:VectorToWorldSpace(moveDir.Unit) * Config.FlySpeed
                else
                    bodyVelocity.velocity = Vector3.new(0, 0, 0)
                end
            end
        end
    else
        if bodyGyro or bodyVelocity then
            stopFly()
        end
    end

    if Config.Spin and LocalPlayer.Character then
        local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
        if root then
            spinAngle = (spinAngle + Config.SpinSpeed) % 360
            root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(spinAngle), 0)
        end
    end

    local targetEnemy = getValidEnemyPlayer()
    if targetEnemy and targetEnemy.Character then
        local enemyChar = targetEnemy.Character
        local enemyRoot = enemyChar:FindFirstChild("HumanoidRootPart") or enemyChar:FindFirstChild("Torso")
        local enemyHead = enemyChar:FindFirstChild("Head")

        if Config.AutoKill and enemyRoot and LocalPlayer.Character then
            local myRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart") or LocalPlayer.Character:FindFirstChild("Torso")
            if myRoot then
                local spawnPos = enemyRoot.CFrame * CFrame.new(0, -0.5, Config.AutoKillDistance)
                myRoot.CFrame = CFrame.new(spawnPos.Position, enemyRoot.Position)
                if enemyHead then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, enemyHead.Position)
                end
            end
        end

        if Config.AimAuto and enemyHead and not Config.AutoKill then
            local velocity = enemyHead.AssemblyLinearVelocity or Vector3.new(0, 0, 0)
            local predictedPos = enemyHead.Position + (velocity * 0.035)
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, predictedPos)
        end
    end

    for player, hb in pairs(healthBars) do
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))

        if Config.HealthESP and char and hum and root and isRivalsEnemy(player) then
            local rootPos, onScreen = Camera:WorldToViewportPoint(root.Position)
            local headPos = Camera:WorldToViewportPoint(root.Position + Vector3.new(0, 3, 0))
            local legPos = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3.5, 0))

            if onScreen then
                local height = math.abs(headPos.Y - legPos.Y)
                local width = height / 2
                
                local barWidth = 3
                local barHeight = height
                local posX = rootPos.X - (width / 2) - barWidth - 5
                local posY = headPos.Y

                local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                local barColor = healthPercent > 0.5 and Color3.fromRGB(255 * (1 - healthPercent) * 2, 255, 0) or Color3.fromRGB(255, 255 * (healthPercent * 2), 0)

                hb.BG.Size = Vector2.new(barWidth + 2, barHeight + 2)
                hb.BG.Position = Vector2.new(posX - 1, posY - 1)
                hb.BG.Visible = true

                hb.Bar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                hb.Bar.Position = Vector2.new(posX, posY + (barHeight * (1 - healthPercent)))
                hb.Bar.Color = barColor
                hb.Bar.Visible = true
            else
                hb.BG.Visible = false
                hb.Bar.Visible = false
            end
        else
            hb.BG.Visible = false
            hb.Bar.Visible = false
        end
    end
end)
