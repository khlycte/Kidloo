--[[
	Kani Chan Hub - Luau UI (Updated + Red Chams ESP + Overhead Spin Lock Target)
	Đặt vào: StarterPlayer > StarterPlayerScripts (LocalScript)
	Phím tắt: RightShift để ẩn/hiện
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

---------------------------------------------------------------------
-- THEME & SIZE
---------------------------------------------------------------------
local THEME = {
	bg      = Color3.fromRGB(16, 16, 24),
	panel   = Color3.fromRGB(26, 26, 38),
	panel2  = Color3.fromRGB(36, 36, 52),
	stroke  = Color3.fromRGB(72, 62, 136),
	accent  = Color3.fromRGB(128, 90, 255),
	accent2 = Color3.fromRGB(0, 200, 255),
	text    = Color3.fromRGB(240, 240, 255),
	textDim = Color3.fromRGB(150, 150, 178),
	off     = Color3.fromRGB(58, 58, 78),
	on      = Color3.fromRGB(55, 195, 130),
}

local FULL_SIZE = UDim2.fromOffset(470, 315)
local MINI_SIZE = UDim2.fromOffset(470, 38)

---------------------------------------------------------------------
-- HELPERS
---------------------------------------------------------------------
local function create(class, props, parent)
	local obj = Instance.new(class)
	for k, v in pairs(props) do
		obj[k] = v
	end
	if parent then
		obj.Parent = parent
	end
	return obj
end

local function corner(obj, radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius or 7) }, obj)
end

local function stroke(obj, color, thickness, transparency)
	return create("UIStroke", {
		Color = color or THEME.stroke,
		Thickness = thickness or 1,
		Transparency = transparency or 0.35,
	}, obj)
end

local function tween(obj, props, t)
	local tw = TweenService:Create(
		obj,
		TweenInfo.new(t or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		props
	)
	tw:Play()
	return tw
end

local function isPress(input)
	return input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
end

local function isMove(input)
	return input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
end

local function getCharParts(plr)
	local char = plr and plr.Character
	if not char then return nil end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	local head = char:FindFirstChild("Head")
	if hum and root and hum.Health > 0 then
		return char, hum, root, head
	end
	return nil
end

local uiLocked = false

local function makeDraggable(handle, target)
	local dragging, dragStart, startPos
	handle.InputBegan:Connect(function(input)
		if uiLocked then return end
		if isPress(input) then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and not uiLocked and isMove(input) then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if isPress(input) then
			dragging = false
		end
	end)
end

---------------------------------------------------------------------
-- SCREEN GUI & TOGGLE BUTTON (👁️)
---------------------------------------------------------------------
local old = playerGui:FindFirstChild("KaniChanHub")
if old then old:Destroy() end

local gui = create("ScreenGui", {
	Name = "KaniChanHub",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local eyeBtn = create("TextButton", {
	Name = "EyeToggle",
	Size = UDim2.fromOffset(38, 38),
	Position = UDim2.new(0, 18, 0.5, -19),
	BackgroundColor3 = THEME.panel,
	Text = "👁️",
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	TextColor3 = THEME.text,
	AutoButtonColor = false,
	ZIndex = 10,
}, gui)
corner(eyeBtn, 19)
stroke(eyeBtn, THEME.accent, 1.4, 0.15)

---------------------------------------------------------------------
-- MAIN WINDOW
---------------------------------------------------------------------
local main = create("Frame", {
	Name = "MainWindow",
	Size = FULL_SIZE,
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = THEME.bg,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Visible = true,
}, gui)
corner(main, 10)
stroke(main, THEME.stroke, 1.4, 0.2)

local top = create("Frame", {
	Size = UDim2.new(1, 0, 0, 38),
	BackgroundColor3 = THEME.panel,
	BorderSizePixel = 0,
}, main)
corner(top, 10)
create("Frame", {
	Size = UDim2.new(1, 0, 0, 10),
	Position = UDim2.new(0, 0, 1, -10),
	BackgroundColor3 = THEME.panel,
	BorderSizePixel = 0,
}, top)

create("TextLabel", {
	Size = UDim2.new(1, -150, 1, 0),
	Position = UDim2.fromOffset(12, 0),
	BackgroundTransparency = 1,
	Text = "Kani Chan Hub",
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	TextColor3 = THEME.text,
	TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local lockUiBtn = create("TextButton", {
	Size = UDim2.fromOffset(64, 24),
	Position = UDim2.new(1, -98, 0.5, -12),
	BackgroundColor3 = THEME.panel2,
	Text = "Lock UI",
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	TextColor3 = THEME.textDim,
	AutoButtonColor = false,
}, top)
corner(lockUiBtn, 6)
stroke(lockUiBtn, THEME.stroke, 1, 0.35)

local miniBtn = create("TextButton", {
	Size = UDim2.fromOffset(24, 24),
	Position = UDim2.new(1, -29, 0.5, -12),
	BackgroundColor3 = THEME.panel2,
	Text = "-",
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	TextColor3 = THEME.text,
	AutoButtonColor = false,
}, top)
corner(miniBtn, 6)
stroke(miniBtn, THEME.stroke, 1, 0.35)

local line = create("Frame", {
	Size = UDim2.new(1, 0, 0, 1.5),
	Position = UDim2.fromOffset(0, 38),
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderSizePixel = 0,
}, main)
create("UIGradient", {
	Color = ColorSequence.new(THEME.accent, THEME.accent2),
}, line)

local sidebar = create("Frame", {
	Size = UDim2.new(0, 108, 1, -66),
	Position = UDim2.fromOffset(8, 45),
	BackgroundColor3 = THEME.panel,
	BorderSizePixel = 0,
}, main)
corner(sidebar, 8)
stroke(sidebar, THEME.stroke, 1, 0.5)
create("UIPadding", {
	PaddingTop = UDim.new(0, 6),
	PaddingBottom = UDim.new(0, 6),
	PaddingLeft = UDim.new(0, 6),
	PaddingRight = UDim.new(0, 6),
}, sidebar)
create("UIListLayout", {
	Padding = UDim.new(0, 5),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, sidebar)

local pages = create("Frame", {
	Size = UDim2.new(1, -128, 1, -66),
	Position = UDim2.fromOffset(122, 45),
	BackgroundTransparency = 1,
}, main)

local statusBar = create("Frame", {
	Size = UDim2.new(1, -16, 0, 18),
	Position = UDim2.new(0, 8, 1, -21),
	BackgroundColor3 = THEME.panel,
	BorderSizePixel = 0,
}, main)
corner(statusBar, 5)
stroke(statusBar, THEME.stroke, 1, 0.6)

local statusLabel = create("TextLabel", {
	Size = UDim2.new(1, -10, 1, 0),
	Position = UDim2.fromOffset(5, 0),
	BackgroundTransparency = 1,
	Text = "Kani Chan xin chào .!",
	Font = Enum.Font.GothamMedium,
	TextSize = 11,
	TextColor3 = THEME.textDim,
	TextXAlignment = Enum.TextXAlignment.Left,
}, statusBar)

local bodyElements = { sidebar, pages, line, statusBar }

makeDraggable(eyeBtn, eyeBtn)
makeDraggable(top, main)

lockUiBtn.MouseButton1Click:Connect(function()
	uiLocked = not uiLocked
	if uiLocked then
		lockUiBtn.Text = "Locked"
		lockUiBtn.BackgroundColor3 = THEME.accent
		lockUiBtn.TextColor3 = Color3.new(1, 1, 1)
	else
		lockUiBtn.Text = "Lock UI"
		lockUiBtn.BackgroundColor3 = THEME.panel2
		lockUiBtn.TextColor3 = THEME.textDim
	end
end)

local minimized = false
miniBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	miniBtn.Text = minimized and "+" or "-"
	for _, item in ipairs(bodyElements) do
		item.Visible = not minimized
	end
	tween(main, { Size = minimized and MINI_SIZE or FULL_SIZE }, 0.22)
end)

local function setMenuOpen(state)
	main.Visible = state
	lockUiBtn.Visible = state
end

eyeBtn.MouseButton1Click:Connect(function()
	setMenuOpen(not main.Visible)
end)

UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.RightShift then
		setMenuOpen(not main.Visible)
	end
end)

---------------------------------------------------------------------
-- TAB SYSTEM & UI BUILDERS
---------------------------------------------------------------------
local currentTab

local function createTab(name)
	local btn = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = THEME.accent,
		BackgroundTransparency = 1,
		Text = name,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = THEME.textDim,
		AutoButtonColor = false,
	}, sidebar)
	corner(btn, 6)

	local page = create("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = THEME.accent,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
	}, pages)
	create("UIListLayout", {
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, page)
	create("UIPadding", {
		PaddingRight = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 4),
	}, page)

	local tab = { button = btn, page = page }
	function tab.select()
		if currentTab then
			currentTab.page.Visible = false
			tween(currentTab.button, { BackgroundTransparency = 1, TextColor3 = THEME.textDim }, 0.15)
		end
		currentTab = tab
		page.Visible = true
		tween(btn, { BackgroundTransparency = 0.2, TextColor3 = Color3.new(1, 1, 1) }, 0.15)
	end

	btn.MouseButton1Click:Connect(tab.select)
	if not currentTab then
		tab.select()
	end
	return page
end

local function sectionTitle(page, text)
	create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Text = text,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = THEME.accent2,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, page)
end

local function sectionHeaderWithRefresh(page, text, onRefresh)
	local holder = create("Frame", {
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
	}, page)

	create("TextLabel", {
		Size = UDim2.new(1, -74, 1, 0),
		BackgroundTransparency = 1,
		Text = text,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = THEME.accent2,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, holder)

	local refBtn = create("TextButton", {
		Size = UDim2.fromOffset(68, 20),
		Position = UDim2.new(1, -68, 0.5, -10),
		BackgroundColor3 = THEME.panel2,
		Text = "↻ Refresh",
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = THEME.text,
		AutoButtonColor = false,
	}, holder)
	corner(refBtn, 5)
	stroke(refBtn, THEME.accent2, 1, 0.4)

	refBtn.MouseButton1Click:Connect(function()
		refBtn.Text = "Đã tải!"
		if onRefresh then
			onRefresh()
		end
		task.delay(0.45, function()
			if refBtn and refBtn.Parent then
				refBtn.Text = "↻ Refresh"
			end
		end)
	end)

	return refBtn
end

local function makeToggleRow(page, labelText, initialState, onChanged)
	local state = initialState or false
	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = THEME.panel,
		BorderSizePixel = 0,
	}, page)
	corner(row, 6)
	stroke(row, THEME.stroke, 1, 0.55)

	create("TextLabel", {
		Size = UDim2.new(1, -56, 1, 0),
		Position = UDim2.fromOffset(10, 0),
		BackgroundTransparency = 1,
		Text = labelText,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = THEME.text,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)

	local sw = create("TextButton", {
		Size = UDim2.fromOffset(38, 20),
		Position = UDim2.new(1, -46, 0.5, -10),
		BackgroundColor3 = state and THEME.on or THEME.off,
		Text = "",
		AutoButtonColor = false,
	}, row)
	corner(sw, 10)

	local knob = create("Frame", {
		Size = UDim2.fromOffset(14, 14),
		Position = state and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
	}, sw)
	corner(knob, 7)

	local function setState(v, silent)
		state = v
		tween(sw, { BackgroundColor3 = state and THEME.on or THEME.off }, 0.15)
		tween(knob, { Position = state and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3) }, 0.15)
		if not silent and onChanged then
			onChanged(state)
		end
	end

	sw.MouseButton1Click:Connect(function()
		setState(not state, false)
	end)

	return {
		Get = function() return state end,
		Set = setState,
	}
end

local function makeSliderRow(page, labelText, minVal, maxVal, defaultVal, decimals, onChanged)
	local step = decimals or 0
	local function roundVal(raw)
		local clamped = math.clamp(raw, minVal, maxVal)
		if step <= 0 then
			return math.floor(clamped + 0.5)
		end
		local mult = 10 ^ step
		return math.floor(clamped * mult + 0.5) / mult
	end

	local current = roundVal(defaultVal)

	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = THEME.panel,
		BorderSizePixel = 0,
	}, page)
	corner(row, 6)
	stroke(row, THEME.stroke, 1, 0.55)

	create("TextLabel", {
		Size = UDim2.new(1, -72, 0, 20),
		Position = UDim2.fromOffset(10, 2),
		BackgroundTransparency = 1,
		Text = labelText,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = THEME.text,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, row)

	local valLbl = create("TextLabel", {
		Size = UDim2.fromOffset(58, 20),
		Position = UDim2.new(1, -68, 0, 2),
		BackgroundTransparency = 1,
		Text = tostring(current),
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = THEME.accent2,
		TextXAlignment = Enum.TextXAlignment.Right,
	}, row)

	local bar = create("Frame", {
		Size = UDim2.new(1, -20, 0, 5),
		Position = UDim2.new(0, 10, 0, 30),
		BackgroundColor3 = THEME.off,
		BorderSizePixel = 0,
	}, row)
	corner(bar, 2.5)

	local initRel = (current - minVal) / (maxVal - minVal)
	local fill = create("Frame", {
		Size = UDim2.fromScale(math.clamp(initRel, 0, 1), 1),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
	}, bar)
	corner(fill, 2.5)
	create("UIGradient", {
		Color = ColorSequence.new(THEME.accent, THEME.accent2),
	}, fill)

	local hit = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 22),
		Position = UDim2.new(0, 0, 0, 21),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
	}, row)

	local function applyFromX(xPos)
		local rel = math.clamp((xPos - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
		local v = roundVal(minVal + (maxVal - minVal) * rel)
		local snappedRel = (v - minVal) / (maxVal - minVal)
		current = v
		fill.Size = UDim2.fromScale(math.clamp(snappedRel, 0, 1), 1)
		valLbl.Text = tostring(v)
		if onChanged then
			onChanged(v)
		end
	end

	local sliding = false
	hit.InputBegan:Connect(function(input)
		if isPress(input) then
			sliding = true
			applyFromX(input.Position.X)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if sliding and isMove(input) then
			applyFromX(input.Position.X)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if isPress(input) then
			sliding = false
		end
	end)

	return {
		Get = function() return current end,
	}
end

local function makeActionButton(page, text, accentStyle, onClick)
	local b = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = accentStyle and THEME.accent or THEME.panel2,
		Text = text,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = Color3.new(1, 1, 1),
		AutoButtonColor = false,
	}, page)
	corner(b, 6)
	stroke(b, accentStyle and THEME.accent2 or THEME.stroke, 1, 0.35)

	b.MouseButton1Click:Connect(function()
		if onClick then
			onClick(b)
		end
	end)
	return b
end

---------------------------------------------------------------------
-- SHARED STATE & HELPERS (FLY R6, INVISIBLE, ESP, NOCLIP, CAMERA)
---------------------------------------------------------------------
local speedValue = 16
local speedEnabled = false

local flyEnabled = false
local flySpeed = 70
local flyBodyGyro = nil
local flyBodyVel = nil
local savedR6Shoulders = {}

local invisibleEnabled = false
local savedVisibility = {}

local gravityValue = Workspace.Gravity
local gravityEnabled = false

local jumpValue = 50
local jumpEnabled = false

local aimEnabled = false
local aimSmooth = 0.3
local aimRange = 50

local targetAimEnabled = false
local targetAimSmooth = 0.3
local targetAimRange = 50
local selectedAimTargetName = nil

local selectedTeleTargetName = nil
local lockTargetEnabled = false
local lockTargetDistance = 6
local lockTargetBtn = nil
local tempNoclip = false
local isTeleporting = false

-- ESP State (Red Chams)
local espAllEnabled = false
local espTargetEnabled = false
local selectedEspTargets = {} -- map [plr.Name] = true
local espHighlights = {} -- map [plr] = Highlight

-- Quản lý Red Chams Highlight cho từng người chơi (dùng chung cho ESP & Aimbot Target)
local function getOrCreateChams(plr)
	local hl = espHighlights[plr]
	if not hl or not hl.Parent then
		hl = create("Highlight", {
			Name = "KaniChanChams_" .. plr.Name,
			FillColor = Color3.fromRGB(255, 40, 40),
			OutlineColor = Color3.fromRGB(255, 115, 115),
			FillTransparency = 0.42,
			OutlineTransparency = 0,
			DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
			Enabled = false,
		}, gui)
		espHighlights[plr] = hl
	end
	return hl
end

-- Quản lý Noclip tập trung
local function syncNoclip(speedMoving)
	local needNoclip = tempNoclip or isTeleporting or lockTargetEnabled or flyEnabled or speedMoving
	local char = player.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = not needNoclip
		end
	end
end

local function restoreMyCamera()
	local cam = Workspace.CurrentCamera
	local _, myHum = getCharParts(player)
	if cam and myHum then
		cam.CameraSubject = myHum
		cam.CameraType = Enum.CameraType.Custom
	end
end

local function viewTargetCamera(targetPlr)
	local cam = Workspace.CurrentCamera
	local _, tHum = getCharParts(targetPlr)
	if cam and tHum then
		cam.CameraSubject = tHum
		cam.CameraType = Enum.CameraType.Custom
	end
end

local function setR6SupermanPose(char, active)
	if not char then return end
	local torso = char:FindFirstChild("Torso")
	if not torso then return end

	local rShoulder = torso:FindFirstChild("Right Shoulder")
	local lShoulder = torso:FindFirstChild("Left Shoulder")
	local rHip = torso:FindFirstChild("Right Hip")
	local lHip = torso:FindFirstChild("Left Hip")

	if active then
		if rShoulder and rShoulder:IsA("Motor6D") then
			if not savedR6Shoulders.RS then savedR6Shoulders.RS = rShoulder.C0 end
			rShoulder.C0 = savedR6Shoulders.RS * CFrame.Angles(0, 0, math.rad(170))
		end
		if lShoulder and lShoulder:IsA("Motor6D") then
			if not savedR6Shoulders.LS then savedR6Shoulders.LS = lShoulder.C0 end
			lShoulder.C0 = savedR6Shoulders.LS * CFrame.Angles(0, 0, math.rad(-170))
		end
		if rHip and rHip:IsA("Motor6D") then
			if not savedR6Shoulders.RH then savedR6Shoulders.RH = rHip.C0 end
			rHip.C0 = savedR6Shoulders.RH * CFrame.Angles(0, 0, math.rad(-8))
		end
		if lHip and lHip:IsA("Motor6D") then
			if not savedR6Shoulders.LH then savedR6Shoulders.LH = lHip.C0 end
			lHip.C0 = savedR6Shoulders.LH * CFrame.Angles(0, 0, math.rad(8))
		end
	else
		if rShoulder and rShoulder:IsA("Motor6D") and savedR6Shoulders.RS then
			rShoulder.C0 = savedR6Shoulders.RS
		end
		if lShoulder and lShoulder:IsA("Motor6D") and savedR6Shoulders.LS then
			lShoulder.C0 = savedR6Shoulders.LS
		end
		if rHip and rHip:IsA("Motor6D") and savedR6Shoulders.RH then
			rHip.C0 = savedR6Shoulders.RH
		end
		if lHip and lHip:IsA("Motor6D") and savedR6Shoulders.LH then
			lHip.C0 = savedR6Shoulders.LH
		end
		table.clear(savedR6Shoulders)
	end
end

local function stopSupermanFly()
	if flyBodyGyro then
		flyBodyGyro:Destroy()
		flyBodyGyro = nil
	end
	if flyBodyVel then
		flyBodyVel:Destroy()
		flyBodyVel = nil
	end
	local char, hum, root = getCharParts(player)
	if hum then
		hum.PlatformStand = false
	end
	if root then
		local pos = root.Position
		local look = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
		if look.Magnitude < 0.01 then look = Vector3.new(0, 0, -1) end
		root.CFrame = CFrame.lookAt(pos, pos + look)
	end
	setR6SupermanPose(char, false)
	syncNoclip(false)
end

local function startSupermanFly()
	stopSupermanFly()
	local char, hum, root = getCharParts(player)
	if not char or not hum or not root then return end

	hum.PlatformStand = true
	setR6SupermanPose(char, true)

	flyBodyGyro = Instance.new("BodyGyro")
	flyBodyGyro.P = 30000
	flyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	flyBodyGyro.CFrame = root.CFrame
	flyBodyGyro.Parent = root

	flyBodyVel = Instance.new("BodyVelocity")
	flyBodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	flyBodyVel.Velocity = Vector3.zero
	flyBodyVel.Parent = root
end

local function applyInvisible(char, state)
	if not char then return end
	if state then
		table.clear(savedVisibility)
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			savedVisibility[hum] = hum.DisplayDistanceType
			hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
		end
		for _, inst in ipairs(char:GetDescendants()) do
			if inst:IsA("BasePart") then
				savedVisibility[inst] = inst.Transparency
				inst.Transparency = 1
			elseif inst:IsA("Decal") or inst:IsA("Texture") then
				savedVisibility[inst] = inst.Transparency
				inst.Transparency = 1
			end
		end
	else
		for inst, orig in pairs(savedVisibility) do
			if inst and inst.Parent then
				if inst:IsA("Humanoid") then
					inst.DisplayDistanceType = orig
				elseif inst:IsA("BasePart") or inst:IsA("Decal") or inst:IsA("Texture") then
					inst.Transparency = orig
				end
			end
		end
		table.clear(savedVisibility)
	end
end

local function setLockTargetState(state)
	lockTargetEnabled = state
	if lockTargetBtn then
		lockTargetBtn.Text = lockTargetEnabled and "Lock Target: BẬT" or "Lock Target: TẮT"
		lockTargetBtn.BackgroundColor3 = lockTargetEnabled and THEME.on or THEME.panel2
	end
	if lockTargetEnabled and selectedTeleTargetName then
		local targetPlr = Players:FindFirstChild(selectedTeleTargetName)
		if targetPlr then
			viewTargetCamera(targetPlr)
		end
	else
		restoreMyCamera()
		syncNoclip(false)
	end
end

---------------------------------------------------------------------
-- TAB 1: PLAYER (Fly Superman R6, Invisible, Speed, Gravity, JumpPower)
---------------------------------------------------------------------
local tabPlayer = createTab("Player")

sectionTitle(tabPlayer, "SUPERMAN FLY (R6)")
makeSliderRow(tabPlayer, "Fly Speed", 10, 400, 70, 0, function(v)
	flySpeed = v
end)
makeActionButton(tabPlayer, "Superman Fly: TẮT", false, function(btn)
	flyEnabled = not flyEnabled
	btn.Text = flyEnabled and "Superman Fly: BẬT" or "Superman Fly: TẮT"
	btn.BackgroundColor3 = flyEnabled and THEME.on or THEME.panel2
	if flyEnabled then
		startSupermanFly()
	else
		stopSupermanFly()
	end
end)

sectionTitle(tabPlayer, "TÀNG HÌNH (INVISIBLE)")
makeActionButton(tabPlayer, "Invisible: TẮT", false, function(btn)
	invisibleEnabled = not invisibleEnabled
	btn.Text = invisibleEnabled and "Invisible: BẬT" or "Invisible: TẮT"
	btn.BackgroundColor3 = invisibleEnabled and THEME.on or THEME.panel2
	applyInvisible(player.Character, invisibleEnabled)
end)

sectionTitle(tabPlayer, "SPEED (TELEPORT STEP 1 - 1000)")
makeSliderRow(tabPlayer, "Speed", 1, 1000, 16, 0, function(v)
	speedValue = v
end)
makeActionButton(tabPlayer, "Kích hoạt Speed: TẮT", false, function(btn)
	speedEnabled = not speedEnabled
	btn.Text = speedEnabled and "Kích hoạt Speed: BẬT" or "Kích hoạt Speed: TẮT"
	btn.BackgroundColor3 = speedEnabled and THEME.on or THEME.panel2
end)

sectionTitle(tabPlayer, "GRAVITY")
makeSliderRow(tabPlayer, "Gravity", 0, 300, math.floor(Workspace.Gravity + 0.5), 0, function(v)
	gravityValue = v
	if gravityEnabled then
		Workspace.Gravity = gravityValue
	end
end)
makeActionButton(tabPlayer, "Kích hoạt Gravity: TẮT", false, function(btn)
	gravityEnabled = not gravityEnabled
	if gravityEnabled then
		Workspace.Gravity = gravityValue
		btn.Text = "Kích hoạt Gravity: BẬT"
		btn.BackgroundColor3 = THEME.on
	else
		Workspace.Gravity = 196.2
		btn.Text = "Kích hoạt Gravity: TẮT"
		btn.BackgroundColor3 = THEME.panel2
	end
end)

sectionTitle(tabPlayer, "JUMP POWER")
makeSliderRow(tabPlayer, "JumpPower", 0, 300, 50, 0, function(v)
	jumpValue = v
	if jumpEnabled then
		local _, hum = getCharParts(player)
		if hum then
			hum.UseJumpPower = true
			hum.JumpPower = jumpValue
		end
	end
end)
makeActionButton(tabPlayer, "Kích hoạt JumpPower: TẮT", false, function(btn)
	jumpEnabled = not jumpEnabled
	btn.Text = jumpEnabled and "Kích hoạt JumpPower: BẬT" or "Kích hoạt JumpPower: TẮT"
	btn.BackgroundColor3 = jumpEnabled and THEME.on or THEME.panel2
	if jumpEnabled then
		local _, hum = getCharParts(player)
		if hum then
			hum.UseJumpPower = true
			hum.JumpPower = jumpValue
		end
	end
end)

player.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid", 5)
	if hum and jumpEnabled then
		hum.UseJumpPower = true
		hum.JumpPower = jumpValue
	end
	if invisibleEnabled then
		task.wait(0.15)
		applyInvisible(char, true)
	end
	if flyEnabled then
		task.wait(0.15)
		startSupermanFly()
	end
	if not lockTargetEnabled then
		restoreMyCamera()
	end
end)

---------------------------------------------------------------------
-- TAB 2: MAIN (Aimbot thường + Aimbot Target riêng + Red Chams + Refresh)
---------------------------------------------------------------------
local tabMain = createTab("Main")

sectionTitle(tabMain, "AIMBOT THƯỜNG")
makeToggleRow(tabMain, "Bật tắt Aimbot", false, function(on)
	aimEnabled = on
end)
makeSliderRow(tabMain, "Smoothing", 0.1, 1, 0.3, 1, function(v)
	aimSmooth = v
end)
makeSliderRow(tabMain, "Range", 0.1, 100, 50, 1, function(v)
	aimRange = v
end)

sectionTitle(tabMain, "AIMBOT TARGET (1 NGƯỜI + RED CHAMS)")
makeToggleRow(tabMain, "Bật tắt Aimbot Target", false, function(on)
	targetAimEnabled = on
end)
makeSliderRow(tabMain, "Target Smoothing", 0.1, 1, 0.3, 1, function(v)
	targetAimSmooth = v
end)
makeSliderRow(tabMain, "Target Range", 0.1, 100, 50, 1, function(v)
	targetAimRange = v
end)

local aimTargetButtons = {}
local aimTargetScroll

local function refreshAimTargetVisuals()
	for plrName, b in pairs(aimTargetButtons) do
		local isSel = (plrName == selectedAimTargetName)
		b.BackgroundColor3 = isSel and THEME.accent or THEME.panel2
		b.Text = isSel and ("• " .. plrName) or plrName
	end
end

local function rebuildAimTargetList()
	if not aimTargetScroll then return end
	for _, child in ipairs(aimTargetScroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	table.clear(aimTargetButtons)

	if selectedAimTargetName and not Players:FindFirstChild(selectedAimTargetName) then
		selectedAimTargetName = nil
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local b = create("TextButton", {
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundColor3 = THEME.panel2,
				Text = plr.Name,
				Font = Enum.Font.GothamMedium,
				TextSize = 11,
				TextColor3 = THEME.text,
				AutoButtonColor = false,
			}, aimTargetScroll)
			corner(b, 5)
			b.MouseButton1Click:Connect(function()
				selectedAimTargetName = plr.Name
				refreshAimTargetVisuals()
			end)
			aimTargetButtons[plr.Name] = b
		end
	end
	refreshAimTargetVisuals()
end

sectionHeaderWithRefresh(tabMain, "CHỌN TARGET AIMBOT", rebuildAimTargetList)

local aimTargetListFrame = create("Frame", {
	Size = UDim2.new(1, 0, 0, 88),
	BackgroundColor3 = THEME.panel,
	BorderSizePixel = 0,
}, tabMain)
corner(aimTargetListFrame, 6)
stroke(aimTargetListFrame, THEME.stroke, 1, 0.55)

aimTargetScroll = create("ScrollingFrame", {
	Size = UDim2.new(1, -6, 1, -6),
	Position = UDim2.fromOffset(3, 3),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 2,
	ScrollBarImageColor3 = THEME.accent2,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, aimTargetListFrame)
create("UIListLayout", {
	Padding = UDim.new(0, 4),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, aimTargetScroll)

---------------------------------------------------------------------
-- TAB 3: ESP (Red Chams All + Chọn nhiều người chơi ESP)
---------------------------------------------------------------------
local tabEsp = createTab("ESP")

sectionTitle(tabEsp, "ESP RED CHAMS")
makeToggleRow(tabEsp, "ESP Tất cả người chơi", false, function(on)
	espAllEnabled = on
end)
makeToggleRow(tabEsp, "ESP Người chơi đã chọn", false, function(on)
	espTargetEnabled = on
end)

local espButtons = {}
local espScroll

local function refreshEspVisuals()
	for plrName, b in pairs(espButtons) do
		local isSel = selectedEspTargets[plrName] == true
		b.BackgroundColor3 = isSel and Color3.fromRGB(190, 45, 55) or THEME.panel2
		b.Text = isSel and ("✓ " .. plrName) or plrName
	end
end

local function rebuildEspList()
	if not espScroll then return end
	for _, child in ipairs(espScroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	table.clear(espButtons)

	for plrName in pairs(selectedEspTargets) do
		if not Players:FindFirstChild(plrName) then
			selectedEspTargets[plrName] = nil
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local b = create("TextButton", {
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundColor3 = THEME.panel2,
				Text = plr.Name,
				Font = Enum.Font.GothamMedium,
				TextSize = 11,
				TextColor3 = THEME.text,
				AutoButtonColor = false,
			}, espScroll)
			corner(b, 5)
			b.MouseButton1Click:Connect(function()
				if selectedEspTargets[plr.Name] then
					selectedEspTargets[plr.Name] = nil
				else
					selectedEspTargets[plr.Name] = true
				end
				refreshEspVisuals()
			end)
			espButtons[plr.Name] = b
		end
	end
	refreshEspVisuals()
end

sectionHeaderWithRefresh(tabEsp, "CHỌN NGƯỜI CHƠI ESP (NHIỀU NGƯỜI)", rebuildEspList)

local espListFrame = create("Frame", {
	Size = UDim2.new(1, 0, 0, 118),
	BackgroundColor3 = THEME.panel,
	BorderSizePixel = 0,
}, tabEsp)
corner(espListFrame, 6)
stroke(espListFrame, THEME.stroke, 1, 0.55)

espScroll = create("ScrollingFrame", {
	Size = UDim2.new(1, -6, 1, -6),
	Position = UDim2.fromOffset(3, 3),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 2,
	ScrollBarImageColor3 = Color3.fromRGB(255, 70, 70),
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, espListFrame)
create("UIListLayout", {
	Padding = UDim.new(0, 4),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, espScroll)

makeActionButton(tabEsp, "Bỏ chọn tất cả ESP", false, function()
	table.clear(selectedEspTargets)
	refreshEspVisuals()
end)

---------------------------------------------------------------------
-- TAB 4: TELEPORT (Bay lên trời đáp xuống + Spin đỉnh đầu Lock Target)
---------------------------------------------------------------------
local tabTeleport = createTab("Teleport")

local teleButtons = {}
local teleScroll

local function refreshTeleVisuals()
	for plrName, b in pairs(teleButtons) do
		local isSel = (plrName == selectedTeleTargetName)
		b.BackgroundColor3 = isSel and THEME.accent or THEME.panel2
		b.Text = isSel and ("• " .. plrName) or plrName
	end
end

local function rebuildTeleList()
	if not teleScroll then return end
	for _, child in ipairs(teleScroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	table.clear(teleButtons)

	if selectedTeleTargetName and not Players:FindFirstChild(selectedTeleTargetName) then
		selectedTeleTargetName = nil
		if lockTargetEnabled then
			setLockTargetState(false)
		end
	end

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local b = create("TextButton", {
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundColor3 = THEME.panel2,
				Text = plr.Name,
				Font = Enum.Font.GothamMedium,
				TextSize = 11,
				TextColor3 = THEME.text,
				AutoButtonColor = false,
			}, teleScroll)
			corner(b, 5)
			b.MouseButton1Click:Connect(function()
				selectedTeleTargetName = plr.Name
				refreshTeleVisuals()
				if lockTargetEnabled then
					viewTargetCamera(plr)
				end
			end)
			teleButtons[plr.Name] = b
		end
	end
	refreshTeleVisuals()
end

sectionHeaderWithRefresh(tabTeleport, "DANH SÁCH NGƯỜI CHƠI", rebuildTeleList)

local teleListFrame = create("Frame", {
	Size = UDim2.new(1, 0, 0, 96),
	BackgroundColor3 = THEME.panel,
	BorderSizePixel = 0,
}, tabTeleport)
corner(teleListFrame, 6)
stroke(teleListFrame, THEME.stroke, 1, 0.55)

teleScroll = create("ScrollingFrame", {
	Size = UDim2.new(1, -6, 1, -6),
	Position = UDim2.fromOffset(3, 3),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 2,
	ScrollBarImageColor3 = THEME.accent,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, teleListFrame)
create("UIListLayout", {
	Padding = UDim.new(0, 4),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, teleScroll)

local function skyDropToTarget(targetPlr)
	if isTeleporting or not targetPlr then return end
	local _, _, myRoot = getCharParts(player)
	local _, _, tRoot = getCharParts(targetPlr)
	if not myRoot or not tRoot then return end

	isTeleporting = true
	tempNoclip = true
	syncNoclip(false)
	statusLabel.Text = "Đang bay tới " .. targetPlr.Name .. "..."

	local startPos = myRoot.Position
	local skyHeight = math.max(startPos.Y, tRoot.Position.Y) + 260

	local upGoal = Vector3.new(startPos.X, skyHeight, startPos.Z)
	for i = 1, 14 do
		local _, _, curRoot = getCharParts(player)
		if not curRoot then break end
		local alpha = i / 14
		local pos = startPos:Lerp(upGoal, alpha)
		curRoot.AssemblyLinearVelocity = Vector3.zero
		curRoot.CFrame = CFrame.lookAt(pos, pos + Vector3.new(0, 1, 0))
		RunService.Heartbeat:Wait()
	end

	local _, _, midRoot = getCharParts(player)
	local _, _, liveTarget2 = getCharParts(targetPlr)
	if midRoot and liveTarget2 then
		local skyStart = midRoot.Position
		local distXZ = (Vector3.new(liveTarget2.Position.X, skyHeight, liveTarget2.Position.Z) - skyStart).Magnitude
		local acrossSteps = math.clamp(math.ceil(distXZ / 35), 10, 26)

		for i = 1, acrossSteps do
			local _, _, curRoot = getCharParts(player)
			local _, _, tLive = getCharParts(targetPlr)
			if not curRoot or not tLive then break end
			local alpha = i / acrossSteps
			local skyGoal = Vector3.new(tLive.Position.X, skyHeight, tLive.Position.Z)
			local pos = skyStart:Lerp(skyGoal, alpha)
			curRoot.AssemblyLinearVelocity = Vector3.zero
			curRoot.CFrame = CFrame.lookAt(pos, Vector3.new(tLive.Position.X, skyHeight, tLive.Position.Z) + Vector3.new(0, -0.2, 0))
			RunService.Heartbeat:Wait()
		end
	end

	local _, _, dropStartRoot = getCharParts(player)
	if dropStartRoot then
		local dropStart = dropStartRoot.Position
		for i = 1, 14 do
			local _, _, curRoot = getCharParts(player)
			local _, _, tLive = getCharParts(targetPlr)
			if not curRoot or not tLive then break end
			local alpha = i / 14
			local backOffset = -tLive.CFrame.LookVector * 2.2
			local landGoal = tLive.Position + backOffset
			local pos = dropStart:Lerp(landGoal, alpha)
			curRoot.AssemblyLinearVelocity = Vector3.zero
			curRoot.CFrame = CFrame.lookAt(pos, tLive.Position)
			RunService.Heartbeat:Wait()
		end
	end

	local _, _, finalRoot = getCharParts(player)
	local _, _, finalTarget = getCharParts(targetPlr)
	if finalRoot and finalTarget then
		finalRoot.AssemblyLinearVelocity = Vector3.zero
		finalRoot.CFrame = CFrame.lookAt(finalTarget.Position - finalTarget.CFrame.LookVector * 2.2, finalTarget.Position)
	end

	tempNoclip = false
	isTeleporting = false
	syncNoclip(false)
	statusLabel.Text = "Đã đáp xuống " .. targetPlr.Name .. "!"
end

makeActionButton(tabTeleport, "Teleport (Bay lên trời đáp xuống)", true, function()
	if not selectedTeleTargetName then return end
	local targetPlr = Players:FindFirstChild(selectedTeleTargetName)
	if targetPlr then
		task.spawn(skyDropToTarget, targetPlr)
	end
end)

sectionTitle(tabTeleport, "LOCK TARGET (SPIN ĐỈNH ĐẦU + VIEW ĐỐI THỦ)")
lockTargetBtn = makeActionButton(tabTeleport, "Lock Target: TẮT", false, function()
	if not lockTargetEnabled and not selectedTeleTargetName then return end
	local nextState = not lockTargetEnabled
	setLockTargetState(nextState)

	if nextState and selectedTeleTargetName then
		local targetPlr = Players:FindFirstChild(selectedTeleTargetName)
		local _, _, myRoot = getCharParts(player)
		local _, _, tRoot = getCharParts(targetPlr)
		if myRoot and tRoot and (myRoot.Position - tRoot.Position).Magnitude > 25 then
			task.spawn(skyDropToTarget, targetPlr)
		end
	end
end)

makeSliderRow(tabTeleport, "Lock Distance", 1, 10, 6, 0, function(v)
	lockTargetDistance = v
end)

Players.PlayerAdded:Connect(function()
	rebuildAimTargetList()
	rebuildEspList()
	rebuildTeleList()
end)

Players.PlayerRemoving:Connect(function(plr)
	if espHighlights[plr] then
		espHighlights[plr]:Destroy()
		espHighlights[plr] = nil
	end
	selectedEspTargets[plr.Name] = nil
	if plr.Name == selectedAimTargetName then
		selectedAimTargetName = nil
	end
	if plr.Name == selectedTeleTargetName then
		selectedTeleTargetName = nil
		if lockTargetEnabled then
			setLockTargetState(false)
		end
	end
	rebuildAimTargetList()
	rebuildEspList()
	rebuildTeleList()
end)

rebuildAimTargetList()
rebuildEspList()
rebuildTeleList()

---------------------------------------------------------------------
-- RUNTIME LOOP: SUPERMAN FLY, SPEED TP, AIMBOT, RED CHAMS ESP, LOCK TARGET
---------------------------------------------------------------------
local orbitAngle = 0

local function getClosestInRange(maxRange, originPos)
	local bestPart = nil
	local bestDist = maxRange
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local _, _, root, head = getCharParts(plr)
			local aimPart = head or root
			if aimPart then
				local d = (aimPart.Position - originPos).Magnitude
				if d <= bestDist then
					bestDist = d
					bestPart = aimPart
				end
			end
		end
	end
	return bestPart
end

local function aimCameraAt(worldPos, smooth)
	local cam = Workspace.CurrentCamera
	if not cam then return end
	local camPos = cam.CFrame.Position
	local desired = CFrame.lookAt(camPos, worldPos)
	local factor = math.clamp(smooth, 0.1, 1)
	cam.CFrame = cam.CFrame:Lerp(desired, factor)
end

RunService.RenderStepped:Connect(function(dt)
	local cam = Workspace.CurrentCamera
	local char, hum, myRoot = getCharParts(player)
	local isSpeedMoving = false

	-- 1. Superman Fly R6
	if flyEnabled and char and hum and myRoot and cam then
		if not flyBodyGyro or not flyBodyVel or not flyBodyGyro.Parent then
			startSupermanFly()
		end
		hum.PlatformStand = true
		setR6SupermanPose(char, true)

		local camCF = cam.CFrame
		local moveVec = Vector3.zero

		if UserInputService:GetFocusedTextBox() == nil then
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec += camCF.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec -= camCF.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec += camCF.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec -= camCF.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
				moveVec -= Vector3.new(0, 1, 0)
			end
		end

		if moveVec.Magnitude == 0 and hum.MoveDirection.Magnitude > 0.05 then
			local flatLook = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
			local forwardAmt = flatLook.Magnitude > 0.01 and hum.MoveDirection:Dot(flatLook.Unit) or 0
			local rightAmt = hum.MoveDirection:Dot(camCF.RightVector)
			moveVec = (camCF.LookVector * forwardAmt) + (camCF.RightVector * rightAmt)
		end

		if moveVec.Magnitude > 0.01 then
			moveVec = moveVec.Unit
			flyBodyVel.Velocity = moveVec * flySpeed
			flyBodyGyro.CFrame = CFrame.lookAt(myRoot.Position, myRoot.Position + moveVec) * CFrame.Angles(math.rad(-90), 0, 0)
		else
			flyBodyVel.Velocity = Vector3.zero
			local hoverLook = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
			if hoverLook.Magnitude < 0.01 then hoverLook = Vector3.new(0, 0, -1) end
			flyBodyGyro.CFrame = CFrame.lookAt(myRoot.Position, myRoot.Position + hoverLook) * CFrame.Angles(math.rad(-20), 0, 0)
		end
	end

	-- 2. Speed kiểu teleport
	if speedEnabled and not flyEnabled and not isTeleporting and hum and myRoot then
		local moveDir = hum.MoveDirection
		if moveDir.Magnitude > 0.01 then
			isSpeedMoving = true
			local stepDist = (speedValue / 10) * dt * 28
			local nextPos = myRoot.Position + moveDir.Unit * stepDist
			myRoot.CFrame = CFrame.new(nextPos, nextPos + moveDir.Unit)
		end
	end

	-- 3. Lock Target bay lên đỉnh đầu + spin tại chỗ + giữ góc view của đối thủ
	if lockTargetEnabled and selectedTeleTargetName and myRoot and not isTeleporting then
		local targetPlr = Players:FindFirstChild(selectedTeleTargetName)
		local _, tHum, tRoot, tHead = getCharParts(targetPlr)
		if tRoot and tHum then
			if cam and cam.CameraSubject ~= tHum then
				cam.CameraSubject = tHum
			end
			orbitAngle += dt * 42
			local basePos = (tHead and tHead.Position) or (tRoot.Position + Vector3.new(0, 2, 0))
			local overheadPos = basePos + Vector3.new(0, lockTargetDistance, 0)
			myRoot.AssemblyLinearVelocity = Vector3.zero
			myRoot.CFrame = CFrame.new(overheadPos) * CFrame.Angles(0, orbitAngle, 0)
		else
			setLockTargetState(false)
		end
	end

	syncNoclip(isSpeedMoving)

	-- 4. Aimbot Target
	local activeAimTargetPlr = nil
	if targetAimEnabled and selectedAimTargetName and myRoot then
		local targetPlr = Players:FindFirstChild(selectedAimTargetName)
		local _, _, tRoot, tHead = getCharParts(targetPlr)
		local aimPart = tHead or tRoot
		if aimPart then
			local dist = (aimPart.Position - myRoot.Position).Magnitude
			if dist <= targetAimRange then
				activeAimTargetPlr = targetPlr
				aimCameraAt(aimPart.Position, targetAimSmooth)
			end
		end
	end

	-- 5. Aimbot thường (chỉ chạy khi không đang khoá riêng Aimbot Target)
	if aimEnabled and not activeAimTargetPlr and myRoot then
		local closest = getClosestInRange(aimRange, myRoot.Position)
		if closest then
			aimCameraAt(closest.Position, aimSmooth)
		end
	end

	-- 6. Cập nhật Red Chams đồng bộ cho cả ESP All, ESP Target và Aimbot Target
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local hl = getOrCreateChams(plr)
			local tChar = plr.Character
			local showByEspAll = espAllEnabled
			local showByEspTarget = espTargetEnabled and (selectedEspTargets[plr.Name] == true)
			local showByAimTarget = (activeAimTargetPlr == plr)

			if tChar and (showByEspAll or showByEspTarget or showByAimTarget) then
				hl.Adornee = tChar
				hl.Enabled = true
			else
				hl.Adornee = nil
				hl.Enabled = false
			end
		end
	end
end)