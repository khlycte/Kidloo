--[[
	Kani Chan Hub - Luau UI
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

local FULL_SIZE = UDim2.fromOffset(470, 305)
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

-- Topbar
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

-- Nút Lock UI (chỉ hiện khi bật menu)
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

-- Nút thu gọn "-" trùng màu menu
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

-- Sidebar + Content + Status bar
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

create("TextLabel", {
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

-- Kéo thả cả nút 👁️ và menu chính
makeDraggable(eyeBtn, eyeBtn)
makeDraggable(top, main)

local function refreshLockVisual()
	if uiLocked then
		lockUiBtn.Text = "Locked"
		lockUiBtn.BackgroundColor3 = THEME.accent
		lockUiBtn.TextColor3 = Color3.new(1, 1, 1)
	else
		lockUiBtn.Text = "Lock UI"
		lockUiBtn.BackgroundColor3 = THEME.panel2
		lockUiBtn.TextColor3 = THEME.textDim
	end
end

lockUiBtn.MouseButton1Click:Connect(function()
	uiLocked = not uiLocked
	refreshLockVisual()
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
-- SHARED STATE FOR PLAYER / AIMBOT / TELEPORT
---------------------------------------------------------------------
local speedValue = 16
local speedEnabled = false

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
local tempNoclip = false

local chamsHighlight = create("Highlight", {
	Name = "KaniChanAimChams",
	FillColor = Color3.fromRGB(255, 45, 45),
	OutlineColor = Color3.fromRGB(255, 110, 110),
	FillTransparency = 0.4,
	OutlineTransparency = 0,
	DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
	Enabled = false,
}, gui)

---------------------------------------------------------------------
-- TAB 1: PLAYER (Speed TP 1-1000, Gravity, JumpPower + Nút kích hoạt)
---------------------------------------------------------------------
local tabPlayer = createTab("Player")

sectionTitle(tabPlayer, "SPEED (TELEPORT STEP 1 - 1000)")
local speedSlider = makeSliderRow(tabPlayer, "Speed", 1, 1000, 16, 0, function(v)
	speedValue = v
end)
makeActionButton(tabPlayer, "Kích hoạt Speed: TẮT", false, function(btn)
	speedEnabled = not speedEnabled
	btn.Text = speedEnabled and "Kích hoạt Speed: BẬT" or "Kích hoạt Speed: TẮT"
	btn.BackgroundColor3 = speedEnabled and THEME.on or THEME.panel2
end)

sectionTitle(tabPlayer, "GRAVITY")
local gravSlider = makeSliderRow(tabPlayer, "Gravity", 0, 300, math.floor(Workspace.Gravity + 0.5), 0, function(v)
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
local jumpSlider = makeSliderRow(tabPlayer, "JumpPower", 0, 300, 50, 0, function(v)
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
end)

---------------------------------------------------------------------
-- TAB 2: MAIN (Aimbot thường + Aimbot Target riêng + Red Chams)
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

local aimTargetListFrame = create("Frame", {
	Size = UDim2.new(1, 0, 0, 88),
	BackgroundColor3 = THEME.panel,
	BorderSizePixel = 0,
}, tabMain)
corner(aimTargetListFrame, 6)
stroke(aimTargetListFrame, THEME.stroke, 1, 0.55)

local aimTargetScroll = create("ScrollingFrame", {
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

local aimTargetButtons = {}

local function refreshAimTargetVisuals()
	for plrName, b in pairs(aimTargetButtons) do
		local isSel = (plrName == selectedAimTargetName)
		b.BackgroundColor3 = isSel and THEME.accent or THEME.panel2
		b.Text = isSel and ("• " .. plrName) or plrName
	end
end

local function rebuildPlayerLists()
	for _, child in ipairs(aimTargetScroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	table.clear(aimTargetButtons)

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

---------------------------------------------------------------------
-- TAB 3: TELEPORT (Danh sách + Teleport Noclip + Lock Target xoay)
---------------------------------------------------------------------
local tabTeleport = createTab("Teleport")

sectionTitle(tabTeleport, "DANH SÁCH NGƯỜI CHƠI")

local teleListFrame = create("Frame", {
	Size = UDim2.new(1, 0, 0, 96),
	BackgroundColor3 = THEME.panel,
	BorderSizePixel = 0,
}, tabTeleport)
corner(teleListFrame, 6)
stroke(teleListFrame, THEME.stroke, 1, 0.55)

local teleScroll = create("ScrollingFrame", {
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

local teleButtons = {}

local function refreshTeleVisuals()
	for plrName, b in pairs(teleButtons) do
		local isSel = (plrName == selectedTeleTargetName)
		b.BackgroundColor3 = isSel and THEME.accent or THEME.panel2
		b.Text = isSel and ("• " .. plrName) or plrName
	end
end

local function rebuildTeleList()
	for _, child in ipairs(teleScroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	table.clear(teleButtons)

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
			end)
			teleButtons[plr.Name] = b
		end
	end
	refreshTeleVisuals()
end

local function setCharNoclip(state)
	local char = player.Character
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = not state
		end
	end
end

local isTeleporting = false

makeActionButton(tabTeleport, "Teleport", true, function()
	if isTeleporting or not selectedTeleTargetName then return end
	local targetPlr = Players:FindFirstChild(selectedTeleTargetName)
	local _, _, myRoot = getCharParts(player)
	local _, _, targetRoot = getCharParts(targetPlr)
	if not myRoot or not targetRoot then return end

	isTeleporting = true
	tempNoclip = true
	setCharNoclip(true)

	local startPos = myRoot.Position
	local destPos = targetRoot.Position + Vector3.new(0, 0, 3)
	local dist = (destPos - startPos).Magnitude
	local steps = math.clamp(math.ceil(dist / 25), 2, 18)

	for i = 1, steps do
		local _, _, curRoot = getCharParts(player)
		local _, _, liveTargetRoot = getCharParts(targetPlr)
		if not curRoot or not liveTargetRoot then break end
		local goal = liveTargetRoot.Position + Vector3.new(0, 0, 3)
		local alpha = i / steps
		curRoot.CFrame = CFrame.lookAt(startPos:Lerp(goal, alpha), liveTargetRoot.Position)
		RunService.Heartbeat:Wait()
	end

	local _, _, finalRoot = getCharParts(player)
	local _, _, finalTarget = getCharParts(targetPlr)
	if finalRoot and finalTarget then
		finalRoot.CFrame = CFrame.lookAt(finalTarget.Position + Vector3.new(0, 0, 3), finalTarget.Position)
	end

	tempNoclip = false
	setCharNoclip(false)
	isTeleporting = false
end)

sectionTitle(tabTeleport, "LOCK TARGET (XOAY VÒNG QUANH SIÊU NHANH)")
makeActionButton(tabTeleport, "Lock Target: TẮT", false, function(btn)
	if not lockTargetEnabled and not selectedTeleTargetName then return end
	lockTargetEnabled = not lockTargetEnabled
	btn.Text = lockTargetEnabled and "Lock Target: BẬT" or "Lock Target: TẮT"
	btn.BackgroundColor3 = lockTargetEnabled and THEME.on or THEME.panel2
	if not lockTargetEnabled and not isTeleporting then
		setCharNoclip(false)
	end
end)

Players.PlayerAdded:Connect(function()
	rebuildPlayerLists()
	rebuildTeleList()
end)
Players.PlayerRemoving:Connect(function(plr)
	if plr.Name == selectedAimTargetName then
		selectedAimTargetName = nil
	end
	if plr.Name == selectedTeleTargetName then
		selectedTeleTargetName = nil
		lockTargetEnabled = false
	end
	rebuildPlayerLists()
	rebuildTeleList()
end)

rebuildPlayerLists()
rebuildTeleList()

---------------------------------------------------------------------
-- RUNTIME LOOP: SPEED TP, AIMBOT, RED CHAMS, LOCK TARGET
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
	if not camera then return end
	local camPos = camera.CFrame.Position
	local desired = CFrame.lookAt(camPos, worldPos)
	local factor = math.clamp(smooth, 0.1, 1)
	camera.CFrame = camera.CFrame:Lerp(desired, factor)
end

RunService.RenderStepped:Connect(function(dt)
	local _, hum, myRoot = getCharParts(player)

	-- 1. Speed kiểu teleport (bước dịch chuyển theo hướng di chuyển)
	if speedEnabled and hum and myRoot then
		local moveDir = hum.MoveDirection
		if moveDir.Magnitude > 0.01 then
			local stepDist = (speedValue / 10) * dt * 28
			local nextPos = myRoot.Position + moveDir.Unit * stepDist
			setCharNoclip(true)
			myRoot.CFrame = CFrame.new(nextPos, nextPos + moveDir.Unit)
		elseif not tempNoclip and not lockTargetEnabled and not isTeleporting then
			setCharNoclip(false)
		end
	elseif not tempNoclip and not lockTargetEnabled and not isTeleporting then
		setCharNoclip(false)
	end

	-- 2. Lock Target xoay vòng quanh người chơi siêu nhanh
	if lockTargetEnabled and selectedTeleTargetName and myRoot then
		local targetPlr = Players:FindFirstChild(selectedTeleTargetName)
		local _, _, tRoot = getCharParts(targetPlr)
		if tRoot then
			setCharNoclip(true)
			orbitAngle += dt * 36
			local radius = 5.5
			local offset = Vector3.new(math.cos(orbitAngle) * radius, 0.5, math.sin(orbitAngle) * radius)
			local orbitPos = tRoot.Position + offset
			myRoot.CFrame = CFrame.lookAt(orbitPos, tRoot.Position)
		else
			lockTargetEnabled = false
			setCharNoclip(false)
		end
	end

	-- 3. Aimbot Target (chỉ đúng 1 người được chọn + Red Chams)
	local activeChamsChar = nil
	if targetAimEnabled and selectedAimTargetName and myRoot then
		local targetPlr = Players:FindFirstChild(selectedAimTargetName)
		local tChar, _, tRoot, tHead = getCharParts(targetPlr)
		local aimPart = tHead or tRoot
		if aimPart then
			local dist = (aimPart.Position - myRoot.Position).Magnitude
			if dist <= targetAimRange then
				activeChamsChar = tChar
				aimCameraAt(aimPart.Position, targetAimSmooth)
			end
		end
	end

	if activeChamsChar then
		chamsHighlight.Adornee = activeChamsChar
		chamsHighlight.Enabled = true
	else
		chamsHighlight.Adornee = nil
		chamsHighlight.Enabled = false
	end

	-- 4. Aimbot thường (chỉ chạy khi không đang khoá riêng Aimbot Target)
	if aimEnabled and not activeChamsChar and myRoot then
		local closest = getClosestInRange(aimRange, myRoot.Position)
		if closest then
			aimCameraAt(closest.Position, aimSmooth)
		end
	end
end)