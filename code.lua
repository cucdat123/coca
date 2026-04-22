local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")
local StarterPlayer = game:GetService("StarterPlayer")
local GuiService = game:GetService("GuiService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")

if not RunService:IsClient() then
	return
end

local env = getgenv and getgenv() or _G
env.cocacolaSession = (env.cocacolaSession or 0) + 1
local SESSION_ID = env.cocacolaSession

local function isCurrentSession()
	return env.cocacolaSession == SESSION_ID
end

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local guiParent = CoreGui

local existingGui = CoreGui:FindFirstChild("cocacola")
if existingGui then
	existingGui:Destroy()
end

local theme = {
	bg = Color3.fromRGB(10, 10, 14),
	panel = Color3.fromRGB(14, 14, 20),
	border = Color3.fromRGB(128, 0, 255),
	text = Color3.fromRGB(215, 215, 225),
	muted = Color3.fromRGB(125, 125, 140),
	input = Color3.fromRGB(8, 8, 12),
	on = Color3.fromRGB(70, 170, 90),
	off = Color3.fromRGB(170, 70, 70),
}

local function make(className, props)
	local instance = Instance.new(className)
	for key, value in pairs(props) do
		instance[key] = value
	end
	return instance
end

local function addStroke(parent, color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness or 1
	stroke.Parent = parent
	return stroke
end

local function createButton(parent, text, position, size)
	local button = make("TextButton", {
		Parent = parent,
		AutoButtonColor = false,
		BackgroundColor3 = theme.input,
		BorderSizePixel = 0,
		Selectable = false,
		Position = position,
		Size = size,
		Font = Enum.Font.Code,
		Text = text,
		TextColor3 = theme.text,
		TextSize = 13,
	})
	addStroke(button, Color3.fromRGB(55, 55, 72), 1)
	return button
end

local function createFeature(parent, title, description, y, buttonText)
	make("TextLabel", {
		Parent = parent,
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 14, 0, y),
		Size = UDim2.new(0, 260, 0, 18),
		Font = Enum.Font.Code,
		Text = title,
		TextColor3 = theme.text,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	local button = createButton(parent, buttonText, UDim2.new(0, 14, 0, y + 26), UDim2.new(0, 168, 0, 28))
	local tickBox = make("TextButton", {
		Parent = parent,
		AutoButtonColor = false,
		BackgroundColor3 = theme.off,
		BorderSizePixel = 0,
		Position = UDim2.new(1, -52, 0, y + 20),
		Size = UDim2.new(0, 32, 0, 32),
		Font = Enum.Font.Code,
		Text = "OFF",
		TextColor3 = theme.text,
		TextSize = 11,
	})
	addStroke(tickBox, Color3.fromRGB(55, 55, 72), 1)

	return button, tickBox
end

local screenGui = make("ScreenGui", {
	Name = "cocacola",
	Parent = guiParent,
	Enabled = true,
	DisplayOrder = 1000,
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local main = make("Frame", {
	Parent = screenGui,
	Active = true,
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = theme.bg,
	BorderSizePixel = 0,
	Position = UDim2.new(0.5, 0, 0.5, 0),
	Size = UDim2.new(0, 400, 0, 470),
})
addStroke(main, theme.border, 1)

make("TextLabel", {
	Parent = main,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 12, 0, 8),
	Size = UDim2.new(1, -48, 0, 18),
	Font = Enum.Font.Code,
	Text = "Coca cola",
	TextColor3 = theme.text,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
})

local closeButton = createButton(main, "X", UDim2.new(1, -34, 0, 8), UDim2.new(0, 22, 0, 18))
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

local boostTopButton = createButton(main, "Boost", UDim2.new(0, 12, 0, 40), UDim2.new(0, 62, 0, 18))
local farmTopButton = createButton(main, "Farm", UDim2.new(0, 80, 0, 40), UDim2.new(0, 58, 0, 18))
local winTopButton = createButton(main, "Win", UDim2.new(0, 144, 0, 40), UDim2.new(0, 44, 0, 18))
local loseTopButton = createButton(main, "Lose", UDim2.new(0, 194, 0, 40), UDim2.new(0, 48, 0, 18))
local configTopButton = createButton(main, "Config", UDim2.new(0, 248, 0, 40), UDim2.new(0, 58, 0, 18))

make("Frame", {
	Parent = main,
	BackgroundColor3 = theme.border,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 8, 0, 36),
	Size = UDim2.new(1, -16, 0, 1),
})

local panel = make("ScrollingFrame", {
	Parent = main,
	Active = true,
	BackgroundColor3 = theme.panel,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 10, 0, 68),
	Size = UDim2.new(1, -20, 1, -78),
	CanvasSize = UDim2.new(0, 0, 0, 640),
	ScrollBarThickness = 6,
	ScrollingDirection = Enum.ScrollingDirection.Y,
})
addStroke(panel, theme.border, 1)

local boostPage = make("Frame", {
	Parent = panel,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 760),
})

local farmPage = make("Frame", {
	Parent = panel,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 760),
	Visible = false,
})

local winPage = make("Frame", {
	Parent = panel,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 760),
	Visible = false,
})

local losePage = make("Frame", {
	Parent = panel,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 760),
	Visible = false,
})

local configPage = make("Frame", {
	Parent = panel,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 760),
	Visible = false,
})

local leftColumn = make("Frame", {
	Parent = boostPage,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 760),
})

local rightColumn = make("Frame", {
	Parent = farmPage,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 760),
})

local winColumn = make("Frame", {
	Parent = winPage,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 760),
})

local loseColumn = make("Frame", {
	Parent = losePage,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(1, 0, 0, 760),
})

make("TextLabel", {
	Parent = leftColumn,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 12),
	Size = UDim2.new(1, -28, 0, 18),
	Font = Enum.Font.Code,
	Text = "Auto Boost",
	TextColor3 = theme.text,
	TextSize = 16,
	TextXAlignment = Enum.TextXAlignment.Left,
})

make("Frame", {
	Parent = leftColumn,
	BackgroundColor3 = theme.border,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 10, 0, 38),
	Size = UDim2.new(1, -20, 0, 1),
})

make("TextLabel", {
	Parent = rightColumn,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 12),
	Size = UDim2.new(1, -28, 0, 18),
	Font = Enum.Font.Code,
	Text = "Auto Farm",
	TextColor3 = theme.text,
	TextSize = 16,
	TextXAlignment = Enum.TextXAlignment.Left,
})

make("Frame", {
	Parent = rightColumn,
	BackgroundColor3 = theme.border,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 10, 0, 38),
	Size = UDim2.new(1, -20, 0, 1),
})

make("TextLabel", {
	Parent = winColumn,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 12),
	Size = UDim2.new(1, -28, 0, 18),
	Font = Enum.Font.Code,
	Text = "Win",
	TextColor3 = theme.text,
	TextSize = 16,
	TextXAlignment = Enum.TextXAlignment.Left,
})

make("Frame", {
	Parent = winColumn,
	BackgroundColor3 = theme.border,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 10, 0, 38),
	Size = UDim2.new(1, -20, 0, 1),
})

make("TextLabel", {
	Parent = loseColumn,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 12),
	Size = UDim2.new(1, -28, 0, 18),
	Font = Enum.Font.Code,
	Text = "Lose",
	TextColor3 = theme.text,
	TextSize = 16,
	TextXAlignment = Enum.TextXAlignment.Left,
})

make("Frame", {
	Parent = loseColumn,
	BackgroundColor3 = theme.border,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 10, 0, 38),
	Size = UDim2.new(1, -20, 0, 1),
})

local function createInput(parent, placeholder, y)
	local box = make("TextBox", {
		Parent = parent,
		BackgroundColor3 = theme.input,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 14, 0, y),
		Size = UDim2.new(1, -28, 0, 28),
		Font = Enum.Font.Code,
		PlaceholderText = placeholder,
		Text = "",
		TextColor3 = theme.text,
		TextSize = 12,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
	})
	addStroke(box, Color3.fromRGB(55, 55, 72), 1)
	return box
end

make("TextLabel", {
	Parent = leftColumn,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 55),
	Size = UDim2.new(0, 260, 0, 18),
	Font = Enum.Font.Code,
	Text = "Config Role",
	TextColor3 = theme.text,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
})

local boostUI = {}
boostUI.roleButton = createButton(leftColumn, "Role: Win", UDim2.new(0, 14, 0, 81), UDim2.new(1, -28, 0, 28))
boostUI.chooseSlotButton, boostUI.chooseSlotTickBox = createFeature(leftColumn, "Auto Choose Slot", "", 130, "Slot: A")
boostUI.inviteButton, boostUI.inviteTickBox = createFeature(leftColumn, "Auto Invite", "", 205, "Targets")
boostUI.inviteNamesBox = createInput(leftColumn, "name1,name2", 263)
boostUI.acceptInviteButton, boostUI.acceptInviteTickBox = createFeature(leftColumn, "Auto Accept Invite", "", 310, "Accept From")
boostUI.acceptInviteNamesBox = createInput(leftColumn, "name1,name2", 368)
boostUI.queueButton, boostUI.queueTickBox = createFeature(leftColumn, "Auto Queue", "", 415, "CASCADE")

local configUI = {}
configUI.activePage = "boost"

make("TextLabel", {
	Parent = configPage,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 12),
	Size = UDim2.new(1, -28, 0, 18),
	Font = Enum.Font.Code,
	Text = "Config",
	TextColor3 = theme.text,
	TextSize = 16,
	TextXAlignment = Enum.TextXAlignment.Left,
})

make("Frame", {
	Parent = configPage,
	BackgroundColor3 = theme.border,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 10, 0, 38),
	Size = UDim2.new(1, -20, 0, 1),
})

configUI.infoLabel = make("TextLabel", {
	Parent = configPage,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 58),
	Size = UDim2.new(1, -28, 0, 40),
	Font = Enum.Font.Code,
	Text = "",
	TextColor3 = theme.muted,
	TextSize = 12,
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
})
configUI.saveButton = createButton(configPage, "Save Config", UDim2.new(0, 14, 0, 112), UDim2.new(1, -28, 0, 28))
configUI.loadButton = createButton(configPage, "Load Config", UDim2.new(0, 14, 0, 147), UDim2.new(1, -28, 0, 28))
configUI.autoloadButton = createButton(configPage, "Set Autoload", UDim2.new(0, 14, 0, 182), UDim2.new(1, -28, 0, 28))
configUI.autoLoadLabel = make("TextLabel", {
	Parent = configPage,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 14, 0, 222),
	Size = UDim2.new(0, 260, 0, 18),
	Font = Enum.Font.Code,
	Text = "Auto Load Config",
	TextColor3 = theme.text,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
})
configUI.autoLoadTickBox = make("TextButton", {
	Parent = configPage,
	AutoButtonColor = false,
	BackgroundColor3 = theme.off,
	BorderSizePixel = 0,
	Position = UDim2.new(1, -52, 0, 216),
	Size = UDim2.new(0, 32, 0, 32),
	Font = Enum.Font.Code,
	Text = "OFF",
	TextColor3 = theme.text,
	TextSize = 11,
})
addStroke(configUI.autoLoadTickBox, Color3.fromRGB(55, 55, 72), 1)

local farmUI = {}
farmUI.farmButton, farmUI.farmTickBox = createFeature(rightColumn, "Auto Farm", "", 55, "Auto Farm")
farmUI.weaponButton, farmUI.weaponTickBox = createFeature(rightColumn, "Auto Weapon", "", 130, "Auto Weapon")
farmUI.shikaiButton, farmUI.shikaiTickBox = createFeature(rightColumn, "Auto Shikai", "", 205, "Auto Shikai")
farmUI.attackButton, farmUI.attackTickBox = createFeature(rightColumn, "Auto Attack", "", 280, "Auto Attack")
farmUI.resetCharacterButton, farmUI.resetCharacterTickBox = createFeature(rightColumn, "Reset Character", "", 355, "Reset")
farmUI.antiAfkButton, farmUI.antiAfkTickBox = createFeature(rightColumn, "Anti AFK", "", 430, "Anti AFK")
farmUI.hopServerButton, farmUI.hopServerTickBox = createFeature(rightColumn, "Hop Server", "", 505, "Hop Server")
farmUI.meditateButton, farmUI.meditateTickBox = createFeature(rightColumn, "Auto Meditate", "", 580, "Meditate")

local winUI = {}
winUI.killButton, winUI.killTickBox = createFeature(winColumn, "Auto Kill", "", 55, "Auto Kill")
winUI.killNameBox = createInput(winColumn, "target username", 113)

local loseUI = {}
loseUI.leaveButton, loseUI.leaveTickBox = createFeature(loseColumn, "Auto Leave", "", 55, "Auto Leave")

local hiddenResetControls = make("Frame", {
	Parent = screenGui,
	Visible = false,
	Size = UDim2.new(0, 0, 0, 0),
})

local hiddenUI = {}
hiddenUI.resetButton = createButton(hiddenResetControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
hiddenUI.resetTickBox = createButton(hiddenResetControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))

local hiddenControls = make("Frame", {
	Parent = screenGui,
	Visible = false,
	Size = UDim2.new(0, 0, 0, 0),
})

hiddenUI.profileNameBox = make("TextBox", {
	Parent = hiddenControls,
	Text = "default",
})

hiddenUI.createConfigButton = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
hiddenUI.createConfigTickBox = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
hiddenUI.loadConfigButton = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
hiddenUI.loadConfigTickBox = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
hiddenUI.setAutoloadButton = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
hiddenUI.setAutoloadTickBox = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
hiddenUI.overwriteConfigButton = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
hiddenUI.overwriteConfigTickBox = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
local autoFarmEnabled = false
local autoWeaponEnabled = false
local autoShikaiEnabled = false
local autoAttackEnabled = false
local autoResetEnabled = false
local autoChooseSlotEnabled = false
local autoInviteEnabled = false
local autoAcceptInviteEnabled = false
local autoQueueEnabled = false
local autoKillEnabled = false
local autoLeaveEnabled = false
local antiAfkEnabled = false
local autoMeditateEnabled = false
local autoLoadConfigEnabled = true
local farmBusy = false
local currentTween
local noclipConnection
local shiftLockConnection
local antiAfkConnection
local currentMission
local waitingForMission = false
local waitingForRespawn = false
local missionRequestAt = 0
local lastQuestAcceptAt = 0
local lastResetAt = 0
local rogueResetConsumed = false
local missionResetArmed = false
local lastFarmRunAt = 0
local lastFarmProgressAt = 0
local lastFarmTarget
local lastFarmTargetHealth = math.huge
local lastFarmTargetProgressAt = 0
local lastRespawnAt = 0
local lastAutoFarmRestartAt = 0
local selectedSlot = "A"
local selectedBoostRole = "win"
local lastSlotChooseAt = 0
local lastInviteOpenAt = 0
local lastInviteScrollAt = 0
local inviteCooldowns = {}
local acceptInviteCooldowns = {}
local PLAYER_TP_MATCH_DISTANCE = 100
local lastWeaponRequestAt = 0
local WEAPON_REQUEST_COOLDOWN = 1
local lastShikaiRequestAt = 0
local SHIKAI_REQUEST_COOLDOWN = 1
local BOARD_REQUEST_COOLDOWN = 20
local MOB_BEHIND_DISTANCE = 5
local RESET_COOLDOWN = 4
local QUEST_LOAD_GRACE = 6
local INVITE_OPEN_COOLDOWN = 2
local INVITE_TARGET_COOLDOWN = 10
local QUEUE_REQUEST_COOLDOWN = 5
local FARM_STUCK_TIMEOUT = 6
local FARM_TARGET_TIMEOUT = 10
local AUTO_FARM_RESTART_COOLDOWN = 3
local MEDITATE_REQUEST_COOLDOWN = 2
local MEDITATE_SAFE_SPOT = Vector3.new(932, 152, 2244)
local HOLLOW_SPAWN_PADDING = Vector3.new(100, 60, 100)
local HOLLOW_SPAWN_RADIUS_PADDING = 140
local PROFILE_ROOT_FOLDER = "cocacola"
local PROFILE_FOLDER = PROFILE_ROOT_FOLDER .. "/config"
local AUTOLOAD_PROFILE_FILE = PROFILE_ROOT_FOLDER .. "/autoload.txt"

local function updateTickBox(tickBox, enabled)
	if enabled then
		tickBox.Text = "ON"
		tickBox.BackgroundColor3 = theme.on
	else
		tickBox.Text = "OFF"
		tickBox.BackgroundColor3 = theme.off
	end
end

local function refreshSelectedSlotLabel()
	boostUI.chooseSlotButton.Text = "Slot: " .. selectedSlot
end

local function refreshSelectedRoleLabel()
	boostUI.roleButton.Text = "Role: " .. (selectedBoostRole == "win" and "Win" or "Lose")
end

local function applyCharacterNoclip(character)
	if not character then
		return
	end

	for _, descendant in ipairs(character:GetDescendants()) do
		if descendant:IsA("BasePart") then
			descendant.CanCollide = false
		end
	end
end

local function disableGuiSelection(root)
	for _, descendant in ipairs(root:GetDescendants()) do
		if descendant:IsA("GuiObject") then
			descendant.Selectable = false
		end
	end
end

local function getCharacter()
	return player.Character or player.CharacterAdded:Wait()
end

local function disableShiftLock()
	pcall(function()
		player.DevEnableMouseLock = false
	end)

	pcall(function()
		player.CameraMode = Enum.CameraMode.Classic
	end)

	pcall(function()
		StarterPlayer.EnableMouseLockOption = false
	end)

	pcall(function()
		UserSettings():GetService("UserGameSettings").RotationType = Enum.RotationType.MovementRelative
	end)

	ContextActionService:UnbindAction("MouseLockSwitchAction")
	ContextActionService:UnbindAction("MouseLockSwitch")
end

local function disablePlayerModuleShiftLock()
	local playerScripts = player:FindFirstChild("PlayerScripts")
	local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
	if not playerModule then
		return
	end

	local ok, module = pcall(require, playerModule)
	if not ok or not module then
		return
	end

	pcall(function()
		if module.GetMouseLockController then
			local controller = module:GetMouseLockController()
			if controller then
				if controller.Disable then
					controller:Disable()
				end
				if controller.SetIsMouseLocked then
					controller:SetIsMouseLocked(false)
				end
				if controller.GetBindableToggleEvent then
					local toggleEvent = controller:GetBindableToggleEvent()
					if toggleEvent and toggleEvent.Fire then
						toggleEvent:Fire(false)
					end
				end
			end
		end
	end)

	pcall(function()
		if module.GetCameras then
			local cameras = module:GetCameras()
			local controller = cameras and (cameras.activeMouseLockController or cameras.mouseLockController)
			if controller then
				if controller.Disable then
					controller:Disable()
				end
				if controller.SetIsMouseLocked then
					controller:SetIsMouseLocked(false)
				end
			end
		end
	end)
end

local function sinkShiftLockAction()
	return Enum.ContextActionResult.Sink
end

local function startShiftLockBlock()
	if shiftLockConnection then
		shiftLockConnection:Disconnect()
	end

	ContextActionService:BindActionAtPriority(
		"CodexBlockShiftLock",
		sinkShiftLockAction,
		false,
		Enum.ContextActionPriority.High.Value,
		Enum.KeyCode.LeftAlt,
		Enum.KeyCode.RightAlt,
		Enum.KeyCode.ButtonL3
	)

	shiftLockConnection = RunService.RenderStepped:Connect(function()
		disableShiftLock()
		disablePlayerModuleShiftLock()
	end)
end

local function stopShiftLockBlock()
	if shiftLockConnection then
		shiftLockConnection:Disconnect()
		shiftLockConnection = nil
	end

	ContextActionService:UnbindAction("CodexBlockShiftLock")
end

local function getRequestFunction()
	return syn and syn.request
		or http_request
		or request
		or fluxus and fluxus.request
end

local function decodeJson(body)
	if not body or body == "" then
		return nil
	end

	local ok, decoded = pcall(function()
		return HttpService:JSONDecode(body)
	end)

	return ok and decoded or nil
end

local function fetchServerPage(url)
	local okHttpGet, body = pcall(function()
		return game:HttpGet(url)
	end)

	if okHttpGet and body and body ~= "" then
		return decodeJson(body)
	end

	local requestFn = getRequestFunction()
	if not requestFn then
		return nil
	end

	local okRequest, response = pcall(function()
		return requestFn({
			Url = url,
			Method = "GET",
		})
	end)

	if not okRequest or not response then
		return nil
	end

	return decodeJson(response.Body or response.body)
end

local function getHRP()
	return getCharacter():WaitForChild("HumanoidRootPart")
end

local function getPlayerEntity()
	local entitiesFolder = Workspace:FindFirstChild("Entities")
	local character = getCharacter()

	if not entitiesFolder then
		return nil
	end

	return entitiesFolder:FindFirstChild(character.Name)
end

local function getMobPosition(mob)
	local root = mob:FindFirstChild("HumanoidRootPart") or mob:FindFirstChildWhichIsA("BasePart")
	if root then
		return root.Position, root
	end

	local ok, pivot = pcall(function()
		return mob:GetPivot()
	end)
	if ok then
		return pivot.Position, nil
	end

	return nil, nil
end

local function getRightArm()
	local entity = getPlayerEntity()
	return entity and entity:FindFirstChild("Right Arm") or nil
end

local function hasEquippedWeapon()
	local entity = getPlayerEntity()
	local rightArm = getRightArm()
	if not entity or not rightArm then
		return false
	end

	local zanpakuto = entity:FindFirstChild("Zanpakuto", true)
	if zanpakuto and zanpakuto:IsDescendantOf(rightArm) then
		return true
	end

	return false
end

local function stopCurrentTween()
	if currentTween then
		currentTween:Cancel()
		currentTween = nil
	end

	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end
end

local function startNoclip()
	if noclipConnection then
		noclipConnection:Disconnect()
	end

	noclipConnection = RunService.Stepped:Connect(function()
		applyCharacterNoclip(player.Character)
	end)
end

local function playTween(hrp, goalPosition, speed, lookAtPosition)
	stopCurrentTween()
	startNoclip()

	local distance = (hrp.Position - goalPosition).Magnitude
	local tweenTime = math.max(distance / speed, 0.05)
	local goalCFrame = lookAtPosition and CFrame.lookAt(goalPosition, lookAtPosition) or CFrame.new(goalPosition)

	currentTween = TweenService:Create(
		hrp,
		TweenInfo.new(tweenTime, Enum.EasingStyle.Linear),
		{CFrame = goalCFrame}
	)

	local activeTween = currentTween
	currentTween:Play()

	local completed = false
	local completedConnection
	completedConnection = activeTween.Completed:Connect(function()
		completed = true
	end)

	local timeoutAt = tick() + tweenTime + 1
	while not completed and currentTween == activeTween and tick() < timeoutAt do
		task.wait()
	end

	if completedConnection then
		completedConnection:Disconnect()
	end

	if currentTween == activeTween then
		currentTween = nil
	end

	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end
end

local function getMissionBoardRemotes()
	local remotes = {}

	for _, child in ipairs(player:GetChildren()) do
		if child.Name:match("^MissionBoard %d+$") then
			remotes[child] = true
		end
	end

	return remotes
end

local function findNewMissionBoardRemote(beforeRemotes, timeout)
	local startedAt = tick()

	while tick() - startedAt < timeout do
		for _, child in ipairs(player:GetChildren()) do
			if child.Name:match("^MissionBoard %d+$") and not beforeRemotes[child] then
				return child
			end
		end
		task.wait(0.05)
	end

	return nil
end

local function runAutoBoard()
	if tick() - missionRequestAt < BOARD_REQUEST_COOLDOWN then
		return false
	end

	local missionNpcFolder = Workspace:FindFirstChild("NPCs") and Workspace.NPCs:FindFirstChild("MissionNPC")
	local hrp = getHRP()

	if not missionNpcFolder then
		return false
	end

	local closestBoard
	local closestBoardPart
	local closestDistance = math.huge

	for _, missionBoard in ipairs(missionNpcFolder:GetChildren()) do
		if missionBoard:IsA("Model") then
			local board = missionBoard:FindFirstChild("Board")
			local boardPart = board and (board.PrimaryPart or board:FindFirstChildWhichIsA("BasePart", true))

			if boardPart and boardPart:IsA("BasePart") then
				local distance = (hrp.Position - boardPart.Position).Magnitude
				if distance < closestDistance then
					closestDistance = distance
					closestBoard = missionBoard
					closestBoardPart = boardPart
				end
			end
		end
	end

	if not closestBoard or not closestBoardPart then
		return false
	end

	playTween(hrp, closestBoardPart.Position, 80)

	if not autoFarmEnabled then
		return false
	end

	local board = closestBoard:FindFirstChild("Board")
	local union = board and board:FindFirstChild("Union")
	local clickDetector = union and union:FindFirstChild("ClickDetector")

	if not clickDetector then
		return false
	end

	local beforeRemotes = getMissionBoardRemotes()

	fireclickdetector(clickDetector)
	task.wait(0.2)

	local newRemote = findNewMissionBoardRemote(beforeRemotes, 2)
	if newRemote then
		newRemote:FireServer("Yes")
		currentMission = nil
		waitingForMission = true
		waitingForRespawn = false
		missionRequestAt = tick()
		lastQuestAcceptAt = tick()
		rogueResetConsumed = false
		missionResetArmed = true
		markFarmProgress()
		return true
	end

	local fallbackRemote = player:FindFirstChild(closestBoard.Name)
	if fallbackRemote then
		fallbackRemote:FireServer("Yes")
		currentMission = nil
		waitingForMission = true
		waitingForRespawn = false
		missionRequestAt = tick()
		lastQuestAcceptAt = tick()
		rogueResetConsumed = false
		missionResetArmed = true
		markFarmProgress()
		return true
	end

	return false
end

local function isMissionUsable(mission)
	if not mission or not mission.Parent then
		return false
	end

	if mission.Name ~= "Hollow Overflow" then
		return false
	end

	local playerTP = mission:FindFirstChild("PlayerTP")
	local hollowSpawn = mission:FindFirstChild("HollowSpawn")

	return playerTP and playerTP:IsA("BasePart") and hollowSpawn and hollowSpawn:IsA("BasePart")
end

local function findMissionAtPlayerPosition()
	local missionsFolder = Workspace:FindFirstChild("Missions")
	local hrp = getHRP()

	if not missionsFolder then
		return nil
	end

	local matchedMission
	local closestDistance = PLAYER_TP_MATCH_DISTANCE

	for _, mission in ipairs(missionsFolder:GetChildren()) do
		if isMissionUsable(mission) then
			local playerTP = mission:FindFirstChild("PlayerTP")
			local distance = (hrp.Position - playerTP.Position).Magnitude

			if distance <= closestDistance then
				closestDistance = distance
				matchedMission = mission
			end
		end
	end

	return matchedMission
end

local function getMissionTitle()
	local queueUI = playerGui:FindFirstChild("QueueUI")
	local missionHolder = queueUI and queueUI:FindFirstChild("MissionHolder")
	local missionTitle = missionHolder and missionHolder:FindFirstChild("missionTitle")

	if missionTitle and missionTitle:IsA("TextLabel") then
		return missionTitle.Text
	end

	return ""
end

local function shouldResetForMissionTitle()
	if not missionResetArmed then
		return false
	end

	if tick() - lastQuestAcceptAt < QUEST_LOAD_GRACE then
		return false
	end

	local queueUI = playerGui:FindFirstChild("QueueUI")
	local missionHolder = queueUI and queueUI:FindFirstChild("MissionHolder")
	local missionTitleLabel = missionHolder and missionHolder:FindFirstChild("missionTitle")

	if not queueUI or not missionHolder or not missionTitleLabel then
		return false
	end

	if queueUI:IsA("ScreenGui") and not queueUI.Enabled then
		return false
	end

	if missionHolder:IsA("GuiObject") and not missionHolder.Visible then
		return false
	end

	if missionTitleLabel:IsA("GuiObject") and not missionTitleLabel.Visible then
		return false
	end

	local missionTitle = string.lower(getMissionTitle())
	if missionTitle == "" then
		return false
	end

	if missionTitle == "hollow overflow" then
		rogueResetConsumed = false
		missionResetArmed = false
		return false
	end

	return missionTitle == "rogue shinigami"
end

local function hasVisibleMissionTitle()
	local queueUI = playerGui:FindFirstChild("QueueUI")
	local missionHolder = queueUI and queueUI:FindFirstChild("MissionHolder")
	local missionTitle = missionHolder and missionHolder:FindFirstChild("missionTitle")

	if not queueUI or not missionHolder or not missionTitle then
		return false
	end

	if queueUI:IsA("ScreenGui") and not queueUI.Enabled then
		return false
	end

	if missionHolder:IsA("GuiObject") and not missionHolder.Visible then
		return false
	end

	if missionTitle:IsA("GuiObject") and not missionTitle.Visible then
		return false
	end

	return missionTitle.Text ~= nil and missionTitle.Text ~= ""
end

local function hasHollowOverflowMissionTitle()
	return string.lower(getMissionTitle()) == "hollow overflow" and hasVisibleMissionTitle()
end

local function shouldWaitForCurrentQuest()
	return waitingForMission or hasVisibleMissionTitle()
end

local function findMatchedMissionByPlayerTP()
	local missionsFolder = Workspace:FindFirstChild("Missions")
	local hrp = getHRP()

	if not missionsFolder then
		return nil
	end

	local closestMission
	local closestDistance = math.huge

	for _, mission in ipairs(missionsFolder:GetChildren()) do
		if mission:IsA("Model") and mission.Name == "Hollow Overflow" then
			local playerTP = mission:FindFirstChild("PlayerTP")
			local hollowSpawn = mission:FindFirstChild("HollowSpawn")

			if playerTP and playerTP:IsA("BasePart") and hollowSpawn and hollowSpawn:IsA("BasePart") then
				local distance = (hrp.Position - playerTP.Position).Magnitude
				if distance < closestDistance then
					closestDistance = distance
					closestMission = mission
				end
			end
		end
	end

	return closestMission
end

local function getActiveMission()
	if isMissionUsable(currentMission) then
		return currentMission
	end

	local matchedMission = findMissionAtPlayerPosition() or findMatchedMissionByPlayerTP()
	if isMissionUsable(matchedMission) then
		currentMission = matchedMission
		waitingForMission = false
		return currentMission
	end

	return nil
end

local function isInsideSpawn(spawnPart, worldPosition)
	local localPosition = spawnPart.CFrame:PointToObjectSpace(worldPosition)
	local halfSize = (spawnPart.Size + HOLLOW_SPAWN_PADDING) * 0.5
	local horizontalRadius = math.max(spawnPart.Size.X, spawnPart.Size.Z) * 0.5 + HOLLOW_SPAWN_RADIUS_PADDING
	local horizontalOffset = Vector3.new(
		worldPosition.X - spawnPart.Position.X,
		0,
		worldPosition.Z - spawnPart.Position.Z
	).Magnitude

	return (math.abs(localPosition.X) <= halfSize.X
		and math.abs(localPosition.Y) <= halfSize.Y
		and math.abs(localPosition.Z) <= halfSize.Z)
		or horizontalOffset <= horizontalRadius
end

local function getAliveMobsInSpawn(spawnPart)
	local entitiesFolder = Workspace:FindFirstChild("Entities")
	if not entitiesFolder then
		return {}
	end

	local aliveMobs = {}

	for _, mob in ipairs(entitiesFolder:GetChildren()) do
		if mob:IsA("Model")
			and not Players:GetPlayerFromCharacter(mob)
			and (mob.Name:match("^Fishbone_") or mob.Name:match("^Frisker_")) then

			local humanoid = mob:FindFirstChildWhichIsA("Humanoid")
			local position = getMobPosition(mob)

			if humanoid and humanoid.Health > 0 and position and isInsideSpawn(spawnPart, position) then
				table.insert(aliveMobs, mob)
			end
		end
	end

	return aliveMobs
end

local function findNearestMobInSpawn(spawnPart)
	local hrp = getHRP()
	local aliveMobs = getAliveMobsInSpawn(spawnPart)
	local nearestMob
	local nearestRoot
	local nearestPosition
	local nearestDistance = math.huge

	for _, mob in ipairs(aliveMobs) do
		local position, root = getMobPosition(mob)
		if position then
			local distance = (hrp.Position - position).Magnitude
			if distance < nearestDistance then
				nearestDistance = distance
				nearestMob = mob
				nearestRoot = root
				nearestPosition = position
			end
		end
	end

	return nearestMob, nearestRoot, nearestPosition, #aliveMobs
end

local function getBehindMobPosition(root)
	local behindOffset = root.CFrame.LookVector * -MOB_BEHIND_DISTANCE
	local targetPosition = root.Position + behindOffset
	return Vector3.new(targetPosition.X, root.Position.Y, targetPosition.Z)
end

local function getSpawnFallbackPosition(spawnPart)
	return spawnPart.Position + Vector3.new(0, 3, 0)
end

local function markFarmProgress()
	lastFarmProgressAt = tick()
end

local function enterRespawnRecovery()
	currentMission = nil
	waitingForMission = false
	waitingForRespawn = true
	farmBusy = false
	stopCurrentTween()
end

function recoverAutoFarmStuck()
	stopCurrentTween()
	farmBusy = false

	local character = player.Character
	local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		enterRespawnRecovery()
		return
	end

	local matchedMission = findMissionAtPlayerPosition() or findMatchedMissionByPlayerTP()
	if matchedMission then
		currentMission = matchedMission
		waitingForMission = false
		markFarmProgress()
		return
	end

	currentMission = nil
	waitingForMission = false

	if not hasVisibleMissionTitle() and tick() - missionRequestAt >= BOARD_REQUEST_COOLDOWN then
		runAutoBoard()
	end

	markFarmProgress()
end

function restartAutoFarm()
	if not autoFarmEnabled then
		return
	end

	if tick() - lastAutoFarmRestartAt < AUTO_FARM_RESTART_COOLDOWN then
		return
	end

	lastAutoFarmRestartAt = tick()
	toggleAutoFarm()
	task.wait(0.2)
	toggleAutoFarm()
end

function updateAutoFarmTargetProgress(mob)
	if not mob or not mob.Parent then
		lastFarmTarget = nil
		lastFarmTargetHealth = math.huge
		lastFarmTargetProgressAt = tick()
		return
	end

	local humanoid = mob:FindFirstChildWhichIsA("Humanoid")
	local health = humanoid and humanoid.Health or math.huge

	if lastFarmTarget ~= mob then
		lastFarmTarget = mob
		lastFarmTargetHealth = health
		lastFarmTargetProgressAt = tick()
		return
	end

	if health < lastFarmTargetHealth then
		lastFarmTargetHealth = health
		lastFarmTargetProgressAt = tick()
	end
end

local function runAutoFarm()
	if farmBusy and tick() - lastFarmRunAt > 8 then
		farmBusy = false
	end

	if farmBusy then
		return
	end

	farmBusy = true
	lastFarmRunAt = tick()

	local currentCharacter = player.Character
	local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildWhichIsA("Humanoid")
	if not currentHumanoid or currentHumanoid.Health <= 0 then
		enterRespawnRecovery()
		return
	end

	if shouldResetForMissionTitle() and not rogueResetConsumed and tick() - lastResetAt >= RESET_COOLDOWN then
		currentMission = nil
		waitingForMission = false
		waitingForRespawn = true
		lastResetAt = tick()
		rogueResetConsumed = true
		missionResetArmed = false
		stopCurrentTween()

		local character = getCharacter()
		local humanoid = character:FindFirstChildWhichIsA("Humanoid")
		if humanoid then
			humanoid.Health = 0
		else
			character:BreakJoints()
		end

		farmBusy = false
		return
	end

	if waitingForRespawn then
		local character = player.Character
		local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")

		if humanoid and humanoid.Health > 0 then
			waitingForRespawn = false
			missionResetArmed = false
			currentMission = nil
			waitingForMission = false
			missionRequestAt = 0
			lastRespawnAt = tick()
			markFarmProgress()
		else
			farmBusy = false
			return
		end
	end

	local missionAtPlayer = findMissionAtPlayerPosition()
	if missionAtPlayer then
		currentMission = missionAtPlayer
		waitingForMission = false
		markFarmProgress()
	end

	local activeMission = getActiveMission()
	if activeMission then
		markFarmProgress()
		local hollowSpawn = activeMission:FindFirstChild("HollowSpawn")
		if not hollowSpawn or not hollowSpawn:IsA("BasePart") then
			currentMission = nil
			waitingForMission = false
			farmBusy = false
			return
		end

		local nearestMob, mobRoot, mobPosition, aliveMobCount = findNearestMobInSpawn(hollowSpawn)

		if aliveMobCount > 0 then
			updateAutoFarmTargetProgress(nearestMob)
			if mobRoot then
				markFarmProgress()
				playTween(getHRP(), getBehindMobPosition(mobRoot), 120, mobRoot.Position)
			elseif mobPosition then
				markFarmProgress()
				playTween(getHRP(), mobPosition - Vector3.new(0, 2, 0), 120, mobPosition)
			else
				markFarmProgress()
				playTween(getHRP(), getSpawnFallbackPosition(hollowSpawn), 120, hollowSpawn.Position)
			end
		else
			updateAutoFarmTargetProgress(nil)
			currentMission = nil
			waitingForMission = false
			markFarmProgress()
			runAutoBoard()
		end

		farmBusy = false
		return
	end

	if waitingForMission then
		local waitedMission = findMissionAtPlayerPosition()
		if waitedMission then
			currentMission = waitedMission
			waitingForMission = false
			markFarmProgress()
			farmBusy = false
			return
		end

		local missionTitle = string.lower(getMissionTitle())
		if tick() - lastQuestAcceptAt >= QUEST_LOAD_GRACE and missionTitle ~= "" then
			waitingForMission = false
			markFarmProgress()
			farmBusy = false
			return
		end

		if hasVisibleMissionTitle() and tick() - lastQuestAcceptAt < QUEST_LOAD_GRACE then
			farmBusy = false
			return
		end

		if tick() - missionRequestAt >= BOARD_REQUEST_COOLDOWN then
			waitingForMission = false
		end

		farmBusy = false
		return
	end

	if hasHollowOverflowMissionTitle() then
		currentMission = findMatchedMissionByPlayerTP() or currentMission
		if currentMission then
			markFarmProgress()
		elseif tick() - lastFarmProgressAt >= FARM_STUCK_TIMEOUT and tick() - missionRequestAt >= BOARD_REQUEST_COOLDOWN then
			waitingForMission = false
			currentMission = nil
			markFarmProgress()
			runAutoBoard()
		end
		farmBusy = false
		return
	end

	if hasVisibleMissionTitle() then
		if tick() - lastFarmProgressAt >= FARM_STUCK_TIMEOUT and tick() - missionRequestAt >= BOARD_REQUEST_COOLDOWN then
			waitingForMission = false
			currentMission = nil
			markFarmProgress()
			runAutoBoard()
		end
		farmBusy = false
		return
	end

	if not shouldWaitForCurrentQuest() and tick() - missionRequestAt >= BOARD_REQUEST_COOLDOWN then
		markFarmProgress()
		runAutoBoard()
	end

	farmBusy = false
end

local function toggleAutoFarm()
	autoFarmEnabled = not autoFarmEnabled
	updateTickBox(farmUI.farmTickBox, autoFarmEnabled)

	if autoFarmEnabled then
		startShiftLockBlock()
		markFarmProgress()
		lastFarmTarget = nil
		lastFarmTargetHealth = math.huge
		lastFarmTargetProgressAt = tick()
		task.spawn(function()
			while autoFarmEnabled and isCurrentSession() do
				disableShiftLock()
				local ok = pcall(runAutoFarm)
				if not ok then
					farmBusy = false
					stopCurrentTween()
				elseif lastFarmTarget and tick() - lastFarmTargetProgressAt >= FARM_TARGET_TIMEOUT then
					pcall(recoverAutoFarmStuck)
				else
					local character = player.Character
					local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
					if humanoid
						and humanoid.Health > 0
						and lastRespawnAt > 0
						and tick() - lastRespawnAt >= 10
						and tick() - lastFarmProgressAt >= 10 then
						pcall(restartAutoFarm)
					end
				end
				task.wait(0.15)
			end
		end)
	else
		stopShiftLockBlock()
		stopCurrentTween()
	end
end

local function runWeaponLoop()
	task.spawn(function()
		while autoWeaponEnabled and isCurrentSession() do
			if not hasEquippedWeapon() then
				local character = getCharacter()
				local handler = character:FindFirstChild("CharacterHandler")
				local remotes = handler and handler:FindFirstChild("Remotes")
				local weaponRemote = remotes and remotes:FindFirstChild("Weapon")

				if weaponRemote and tick() - lastWeaponRequestAt >= WEAPON_REQUEST_COOLDOWN then
					lastWeaponRequestAt = tick()
					weaponRemote:FireServer()
				end
			end

			task.wait(0.2)
		end
	end)
end

local function toggleAutoWeapon()
	autoWeaponEnabled = not autoWeaponEnabled
	updateTickBox(farmUI.weaponTickBox, autoWeaponEnabled)

	if autoWeaponEnabled then
		lastWeaponRequestAt = 0
		runWeaponLoop()
	end
end

local function runShikaiLoop()
	task.spawn(function()
		while autoShikaiEnabled and isCurrentSession() do
			local character = getCharacter()
			local handler = character:FindFirstChild("CharacterHandler")
			local remotes = handler and handler:FindFirstChild("Remotes")
			local shikaiRemote = remotes and remotes:FindFirstChild("ReleaseShikai")

			if hasEquippedWeapon() and shikaiRemote and tick() - lastShikaiRequestAt >= SHIKAI_REQUEST_COOLDOWN then
				lastShikaiRequestAt = tick()
				shikaiRemote:FireServer()
			end

			task.wait(0.2)
		end
	end)
end

local function toggleAutoShikai()
	autoShikaiEnabled = not autoShikaiEnabled
	updateTickBox(farmUI.shikaiTickBox, autoShikaiEnabled)

	if autoShikaiEnabled then
		lastShikaiRequestAt = 0
		runShikaiLoop()
	end
end

local function runAttackLoop()
	task.spawn(function()
		while autoAttackEnabled and isCurrentSession() do
			local combatRemote = ReplicatedStorage:FindFirstChild("Remotes")
				and ReplicatedStorage.Remotes:FindFirstChild("ServerCombatHandler")

			if combatRemote then
				combatRemote:FireServer("LightAttack")
			end

			task.wait(0.12)
		end
	end)
end

local function toggleAutoAttack()
	autoAttackEnabled = not autoAttackEnabled
	updateTickBox(farmUI.attackTickBox, autoAttackEnabled)

	if autoAttackEnabled then
		runAttackLoop()
	end
end

local function runAutoResetLoop()
	task.spawn(function()
		while autoResetEnabled and isCurrentSession() do
			if not waitingForRespawn
				and shouldResetForMissionTitle()
				and not rogueResetConsumed
				and tick() - lastResetAt >= RESET_COOLDOWN then
				currentMission = nil
				waitingForMission = false
				waitingForRespawn = true
				lastResetAt = tick()
				rogueResetConsumed = true
				missionResetArmed = false
				stopCurrentTween()

				local character = getCharacter()
				local humanoid = character:FindFirstChildWhichIsA("Humanoid")
				if humanoid then
					humanoid.Health = 0
				else
					character:BreakJoints()
				end
			elseif waitingForRespawn then
				local character = player.Character
				local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")

				if humanoid and humanoid.Health > 0 then
					waitingForRespawn = false
					missionResetArmed = false
					missionRequestAt = 0
				end
			end

			task.wait(0.2)
		end
	end)
end

local function toggleAutoReset()
	autoResetEnabled = not autoResetEnabled
	updateTickBox(hiddenUI.resetTickBox, autoResetEnabled)

	if autoResetEnabled then
		runAutoResetLoop()
	end
end

local function cycleSelectedSlot()
	if selectedSlot == "A" then
		selectedSlot = "B"
	elseif selectedSlot == "B" then
		selectedSlot = "C"
	else
		selectedSlot = "A"
	end

	refreshSelectedSlotLabel()
end

local function sendNavigationKey(keyCode)
	VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
	task.wait(0.08)
	VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
	task.wait(0.12)
end

local function pressEnterOnce()
	if keypress and keyrelease then
		keypress(0x0D)
		task.wait()
		keyrelease(0x0D)
		task.wait(0.12)
	end

	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
	task.wait()
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
	task.wait(0.06)
	VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.KeypadEnter, false, game)
	task.wait()
	VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.KeypadEnter, false, game)
	task.wait(0.12)
end

local function clickScreenCenter()
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end

	local viewport = camera.ViewportSize
	local x = viewport.X / 2
	local y = viewport.Y / 2

	VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
	task.wait(0.05)
	VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
	task.wait(0.1)
end

local function withGuiHidden(callback, restoreDelay)
	local wasEnabled = screenGui.Enabled
	screenGui.Enabled = false
	task.wait(0.1)

	local ok, err = pcall(callback)

	task.wait(restoreDelay or 0.1)
	screenGui.Enabled = wasEnabled

	return ok, err
end

local function chooseConfiguredSlot()
	if tick() - lastSlotChooseAt < 1 then
		return
	end

	local mainMenu = playerGui:FindFirstChild("MainMenu")
	local menu = mainMenu and mainMenu:FindFirstChild("Menu")
	local buttons = menu and menu:FindFirstChild("Buttons")
	local playFocus = buttons and buttons:FindFirstChild("Play")
	if not mainMenu or not menu or not buttons or not playFocus then
		return
	end

	if GuiService.SelectedObject ~= playFocus then
		pcall(function()
			GuiService.SelectedObject = playFocus
		end)
		task.wait(0.2)
	end

	if selectedSlot == "A" then
		lastSlotChooseAt = tick()
		withGuiHidden(function()
			pcall(function()
				GuiService.SelectedObject = playFocus
			end)
			task.wait(0.2)
			sendNavigationKey(Enum.KeyCode.Down)
			sendNavigationKey(Enum.KeyCode.Return)
			sendNavigationKey(Enum.KeyCode.Right)
			sendNavigationKey(Enum.KeyCode.Return)
			sendNavigationKey(Enum.KeyCode.Down)
			sendNavigationKey(Enum.KeyCode.Return)
		end)
	end
end

local function normalizeName(text)
	return string.lower((text or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function getTargetNamesFromBox(textBox)
	local targets = {}
	for entry in string.gmatch(textBox.Text or "", "[^,\r\n;]+") do
		local normalized = normalizeName(entry)
		if normalized ~= "" then
			table.insert(targets, normalized)
		end
	end
	return targets
end

local function getInviteTargets()
	return getTargetNamesFromBox(boostUI.inviteNamesBox)
end

local function getAcceptInviteTargets()
	return getTargetNamesFromBox(boostUI.acceptInviteNamesBox)
end

local function isInviteMenuOpen()
	local menu = playerGui:FindFirstChild("Menu")
	local invitePlayer = menu and menu:FindFirstChild("InvitePlayer")
	if not invitePlayer then
		return false
	end

	if invitePlayer:IsA("GuiObject") then
		return invitePlayer.Visible
	end

	return invitePlayer.Parent ~= nil
end

local function openInviteMenu()
	if tick() - lastInviteOpenAt < INVITE_OPEN_COOLDOWN then
		return
	end

	local menu = playerGui:FindFirstChild("Menu")
	local mainMenu = menu and menu:FindFirstChild("Main")
	local container = mainMenu and mainMenu:FindFirstChild("Container")
	local topbar = container and container:FindFirstChild("Topbar")
	local leaveFocus = topbar and topbar:FindFirstChild("Leave")
	if not leaveFocus then
		return
	end

	lastInviteOpenAt = tick()
	withGuiHidden(function()
		pcall(function()
			GuiService.SelectedObject = leaveFocus
		end)
		task.wait(0.2)
		sendNavigationKey(Enum.KeyCode.Down)
		sendNavigationKey(Enum.KeyCode.Right)
		sendNavigationKey(Enum.KeyCode.Return)
	end)
end

local function advanceInviteScroll(scroll)
	if not scroll or not scroll:IsA("ScrollingFrame") then
		return
	end

	if tick() - lastInviteScrollAt < 0.4 then
		return
	end

	lastInviteScrollAt = tick()

	local maxY = math.max(0, scroll.AbsoluteCanvasSize.Y - scroll.AbsoluteWindowSize.Y)
	local nextY = scroll.CanvasPosition.Y + math.max(120, scroll.AbsoluteWindowSize.Y * 0.6)
	if nextY > maxY then
		nextY = 0
	end

	scroll.CanvasPosition = Vector2.new(scroll.CanvasPosition.X, nextY)
end

local function isInviteEntryLoaded(scroll, username)
	for _, entry in ipairs(scroll:GetChildren()) do
		if entry.Name ~= "UIListLayout" and entry.Name ~= "UIPadding" then
			local info = entry:FindFirstChild("Information")
			local header = info and info:FindFirstChild("Header")
			local playerName = header and header:FindFirstChild("PlayerName")

			if playerName and playerName:IsA("TextLabel") then
				if normalizeName(playerName.Text) == username then
					return true
				end
			end
		end
	end

	return false
end

local function inviteConfiguredPlayers()
	local targets = getInviteTargets()
	if #targets == 0 then
		return
	end

	if not isInviteMenuOpen() then
		openInviteMenu()
		return
	end

	local menu = playerGui:FindFirstChild("Menu")
	local invitePlayer = menu and menu:FindFirstChild("InvitePlayer")
	local container = invitePlayer and invitePlayer:FindFirstChild("Container")
	local content = container and container:FindFirstChild("Content")
	local scroll = content and content:FindFirstChild("Scroll")
	if not scroll then
		return
	end

	for _, username in ipairs(targets) do
		if tick() - (inviteCooldowns[username] or 0) >= INVITE_TARGET_COOLDOWN then
			if not isInviteEntryLoaded(scroll, username) then
				advanceInviteScroll(scroll)
			else
				local targetPlayer

				for _, otherPlayer in ipairs(Players:GetPlayers()) do
					if normalizeName(otherPlayer.Name) == username then
						targetPlayer = otherPlayer
						break
					end
				end

				local teamRemote = ReplicatedStorage:FindFirstChild("Remotes")
					and ReplicatedStorage.Remotes:FindFirstChild("Team")
				if targetPlayer and teamRemote then
					inviteCooldowns[username] = tick()
					teamRemote:FireServer("Invite", targetPlayer)
					task.wait(0.2)
				end
			end
		end
	end
end

function acceptConfiguredInvites()
	local targets = getAcceptInviteTargets()
	if #targets == 0 then
		return
	end

	local teamRemote = ReplicatedStorage:FindFirstChild("Remotes")
		and ReplicatedStorage.Remotes:FindFirstChild("Team")
	if not teamRemote then
		return
	end

	for _, username in ipairs(targets) do
		if tick() - (acceptInviteCooldowns[username] or 0) >= INVITE_TARGET_COOLDOWN then
			local targetPlayer

			for _, otherPlayer in ipairs(Players:GetPlayers()) do
				if normalizeName(otherPlayer.Name) == username then
					targetPlayer = otherPlayer
					break
				end
			end

			if targetPlayer then
				acceptInviteCooldowns[username] = tick()
				teamRemote:FireServer("AcceptInvite", targetPlayer)
				task.wait(0.2)
			end
		end
	end
end

function runAutoInviteLoop()
	task.spawn(function()
		while autoInviteEnabled and isCurrentSession() do
			pcall(inviteConfiguredPlayers)
			task.wait(0.5)
		end
	end)
end

function toggleAutoInvite()
	autoInviteEnabled = not autoInviteEnabled
	updateTickBox(boostUI.inviteTickBox, autoInviteEnabled)

	if autoInviteEnabled then
		runAutoInviteLoop()
	end
end

function runAutoAcceptInviteLoop()
	task.spawn(function()
		while autoAcceptInviteEnabled and isCurrentSession() do
			pcall(acceptConfiguredInvites)
			task.wait(0.5)
		end
	end)
end

function toggleAutoAcceptInvite()
	autoAcceptInviteEnabled = not autoAcceptInviteEnabled
	updateTickBox(boostUI.acceptInviteTickBox, autoAcceptInviteEnabled)

	if autoAcceptInviteEnabled then
		runAutoAcceptInviteLoop()
	end
end

local lastQueueRequestAt = 0

function joinCascadeQueue()
	if tick() - lastQueueRequestAt < QUEUE_REQUEST_COOLDOWN then
		return
	end

	local teamRemote = ReplicatedStorage:FindFirstChild("Remotes")
		and ReplicatedStorage.Remotes:FindFirstChild("Team")
	if not teamRemote then
		return
	end

	lastQueueRequestAt = tick()
	teamRemote:FireServer("JoinQueue", "CASCADE")
end

function runAutoQueueLoop()
	task.spawn(function()
		while autoQueueEnabled and isCurrentSession() do
			pcall(joinCascadeQueue)
			task.wait(1)
		end
	end)
end

function toggleAutoQueue()
	autoQueueEnabled = not autoQueueEnabled
	updateTickBox(boostUI.queueTickBox, autoQueueEnabled)

	if autoQueueEnabled then
		lastQueueRequestAt = 0
		runAutoQueueLoop()
	end
end

function getAutoKillTarget()
	local username = normalizeName(winUI.killNameBox.Text)
	if username == "" then
		return nil
	end

	for _, otherPlayer in ipairs(Players:GetPlayers()) do
		if normalizeName(otherPlayer.Name) == username then
			return otherPlayer
		end
	end

	return nil
end

function runAutoKillLoop()
	task.spawn(function()
		while autoKillEnabled and isCurrentSession() do
			local targetPlayer = getAutoKillTarget()
			local targetCharacter = targetPlayer and targetPlayer.Character
			local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildWhichIsA("Humanoid")
			local targetRoot = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")

			if targetHumanoid and targetHumanoid.Health > 0 and targetRoot then
				playTween(getHRP(), getBehindMobPosition(targetRoot), 120, targetRoot.Position)

				local combatRemote = ReplicatedStorage:FindFirstChild("Remotes")
					and ReplicatedStorage.Remotes:FindFirstChild("ServerCombatHandler")
				if combatRemote then
					combatRemote:FireServer("LightAttack")
				end
			end

			task.wait(0.12)
		end
	end)
end

function toggleAutoKill()
	autoKillEnabled = not autoKillEnabled
	updateTickBox(winUI.killTickBox, autoKillEnabled)

	if autoKillEnabled then
		runAutoKillLoop()
	end
end

function toggleAutoLeave()
	autoLeaveEnabled = not autoLeaveEnabled
	updateTickBox(loseUI.leaveTickBox, autoLeaveEnabled)
end

function applyAntiAfkState()
	if antiAfkConnection then
		antiAfkConnection:Disconnect()
		antiAfkConnection = nil
	end

	if not antiAfkEnabled then
		return
	end

	antiAfkConnection = player.Idled:Connect(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new(0, 0))
	end)
end

function toggleAntiAfk()
	antiAfkEnabled = not antiAfkEnabled
	updateTickBox(farmUI.antiAfkTickBox, antiAfkEnabled)
	applyAntiAfkState()
end

lastMeditateRequestAt = 0
innerWorldNpcKey = ""

function isMeditating()
	local character = player.Character
	local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
	local animator = humanoid and humanoid:FindFirstChildOfClass("Animator")
	local meditateAnimation = ReplicatedStorage:FindFirstChild("Assets")
		and ReplicatedStorage.Assets:FindFirstChild("Animations")
		and ReplicatedStorage.Assets.Animations:FindFirstChild("Meditate")

	if not animator or not meditateAnimation then
		return false
	end

	for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
		if track.Animation == meditateAnimation then
			return true
		end
	end

	return false
end

function getInnerWorldRegion()
	local innerWorldPlots = Workspace:FindFirstChild("InnerWorldPlots")
	local character = player.Character
	if not innerWorldPlots or not character then
		return nil
	end

	local plot = innerWorldPlots:FindFirstChild(character.Name .. "InnerWorld")
	return plot and plot:FindFirstChild("InnerWorldRegion") or nil
end

function isPointInsideRegion(regionPart, worldPosition)
	if not regionPart or not worldPosition then
		return false
	end

	local localPosition = regionPart.CFrame:PointToObjectSpace(worldPosition)
	local halfSize = regionPart.Size * 0.5
	return math.abs(localPosition.X) <= halfSize.X
		and math.abs(localPosition.Y) <= halfSize.Y
		and math.abs(localPosition.Z) <= halfSize.Z
end

function isInInnerWorld()
	local region = getInnerWorldRegion()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	return region and hrp and isPointInsideRegion(region, hrp.Position) or false
end

function getDialogueRemoteSnapshot()
	local snapshot = {}

	for _, child in ipairs(player:GetChildren()) do
		if child:IsA("RemoteEvent") then
			snapshot[child] = true
		end
	end

	return snapshot
end

function findNewDialogueRemote(beforeSnapshot, timeout)
	local startedAt = tick()

	while tick() - startedAt < timeout do
		for _, child in ipairs(player:GetChildren()) do
			if child:IsA("RemoteEvent") and not beforeSnapshot[child] then
				return child
			end
		end
		task.wait(0.05)
	end

	return nil
end

function findNearestShikaiNpc()
	local entitiesFolder = Workspace:FindFirstChild("Entities")
	local region = getInnerWorldRegion()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not entitiesFolder or not region or not hrp then
		return nil, nil
	end

	local nearestNpc
	local nearestRoot
	local nearestDistance = math.huge

	for _, entity in ipairs(entitiesFolder:GetChildren()) do
		if entity:IsA("Model") and entity.Name:match("^ShikaiNPC_") then
			local root = entity:FindFirstChild("HumanoidRootPart")
			local humanoid = entity:FindFirstChildWhichIsA("Humanoid")

			if root and humanoid and humanoid.Health > 0 and isPointInsideRegion(region, root.Position) then
				local distance = (hrp.Position - root.Position).Magnitude
				if distance < nearestDistance then
					nearestDistance = distance
					nearestNpc = entity
					nearestRoot = root
				end
			end
		end
	end

	return nearestNpc, nearestRoot
end

function talkToShikaiNpc(npc, root)
	if not npc or not root or innerWorldNpcKey == npc.Name then
		return
	end

	local clickDetector = root:FindFirstChild("ClickDetector") or root:FindFirstChildWhichIsA("ClickDetector", true)
	if not clickDetector then
		return
	end

	for _ = 1, 5 do
		local beforeSnapshot = getDialogueRemoteSnapshot()
		fireclickdetector(clickDetector)
		task.wait(0.2)

		local dialogueRemote = findNewDialogueRemote(beforeSnapshot, 1.5)
		if dialogueRemote then
			dialogueRemote:FireServer("Yes")
			task.wait(0.08)
		end
	end

	innerWorldNpcKey = npc.Name
end

function gripShikaiNpc()
	local character = getCharacter()
	local handler = character:FindFirstChild("CharacterHandler")
	local remotes = handler and handler:FindFirstChild("Remotes")
	local executeRemote = remotes and remotes:FindFirstChild("Execute")

	if executeRemote then
		executeRemote:FireServer()
	end
end

function runAutoMeditateLoop()
	task.spawn(function()
		while autoMeditateEnabled and isCurrentSession() do
			if isInInnerWorld() then
				local npc, root = findNearestShikaiNpc()
				local humanoid = npc and npc:FindFirstChildWhichIsA("Humanoid")

				if npc and root then
					playTween(getHRP(), getBehindMobPosition(root), 120, root.Position)
					talkToShikaiNpc(npc, root)

					if humanoid and humanoid.Health > 0 then
						local combatRemote = ReplicatedStorage:FindFirstChild("Remotes")
							and ReplicatedStorage.Remotes:FindFirstChild("ServerCombatHandler")
						if combatRemote then
							combatRemote:FireServer("LightAttack")
						end
					elseif humanoid and humanoid.Health <= 0 then
						gripShikaiNpc()
						innerWorldNpcKey = ""
					end
				else
					innerWorldNpcKey = ""
				end
			elseif not isMeditating() and tick() - lastMeditateRequestAt >= MEDITATE_REQUEST_COOLDOWN then
				local character = getCharacter()
				local handler = character:FindFirstChild("CharacterHandler")
				local remotes = handler and handler:FindFirstChild("Remotes")
				local meditateRemote = remotes and remotes:FindFirstChild("Meditate")

				if meditateRemote then
					playTween(getHRP(), MEDITATE_SAFE_SPOT, 120)
					lastMeditateRequestAt = tick()
					meditateRemote:FireServer()
				end
			end

			task.wait(0.5)
		end
	end)
end

function toggleAutoMeditate()
	autoMeditateEnabled = not autoMeditateEnabled
	updateTickBox(farmUI.meditateTickBox, autoMeditateEnabled)

	if autoMeditateEnabled then
		lastMeditateRequestAt = 0
		innerWorldNpcKey = ""
		runAutoMeditateLoop()
	end
end

function getProfileName()
	local rawName = tostring(player.Name or "default")
	return rawName:gsub("[\\/:*?\"<>|]", "_")
end

function getRoleFolderName()
	if selectedBoostRole == "lose" then
		return "lose"
	end

	return "win"
end

function getProfilePath()
	return PROFILE_FOLDER .. "/" .. getRoleFolderName() .. "/" .. getProfileName() .. ".json"
end

function refreshConfigInfoLabel()
	if not configUI or not configUI.infoLabel then
		return
	end

	configUI.infoLabel.Text = string.format(
		"User: %s\nPath: %s",
		getProfileName(),
		getProfilePath()
	)
end

function setActivePage(pageName)
	configUI.activePage = pageName
	boostPage.Visible = pageName == "boost"
	farmPage.Visible = pageName == "farm"
	winPage.Visible = pageName == "win"
	losePage.Visible = pageName == "lose"
	configPage.Visible = pageName == "config"
	boostTopButton.BackgroundColor3 = pageName == "boost" and theme.on or theme.input
	farmTopButton.BackgroundColor3 = pageName == "farm" and theme.on or theme.input
	winTopButton.BackgroundColor3 = pageName == "win" and theme.on or theme.input
	loseTopButton.BackgroundColor3 = pageName == "lose" and theme.on or theme.input
	configTopButton.BackgroundColor3 = pageName == "config" and theme.on or theme.input
end

function ensureProfileFolder()
	if not makefolder or not isfolder then
		return false
	end

	if not isfolder(PROFILE_ROOT_FOLDER) then
		makefolder(PROFILE_ROOT_FOLDER)
	end

	if not isfolder(PROFILE_FOLDER) then
		makefolder(PROFILE_FOLDER)
	end

	local winFolder = PROFILE_FOLDER .. "/win"
	local loseFolder = PROFILE_FOLDER .. "/lose"

	if not isfolder(winFolder) then
		makefolder(winFolder)
	end

	if not isfolder(loseFolder) then
		makefolder(loseFolder)
	end

	return true
end

function setToggleState(desiredState, currentState, toggleFn)
	if desiredState == currentState then
		return
	end

	toggleFn()
end

function saveCurrentProfile()
	if not writefile or not HttpService or not ensureProfileFolder() then
		return
	end

	local payload = {
		selectedBoostRole = selectedBoostRole,
		selectedSlot = selectedSlot,
		inviteNames = boostUI.inviteNamesBox.Text,
		acceptInviteNames = boostUI.acceptInviteNamesBox.Text,
		autoFarmEnabled = autoFarmEnabled,
		autoWeaponEnabled = autoWeaponEnabled,
		autoShikaiEnabled = autoShikaiEnabled,
		autoAttackEnabled = autoAttackEnabled,
		autoResetEnabled = autoResetEnabled,
		autoChooseSlotEnabled = autoChooseSlotEnabled,
		autoInviteEnabled = autoInviteEnabled,
		autoAcceptInviteEnabled = autoAcceptInviteEnabled,
		autoQueueEnabled = autoQueueEnabled,
		autoKillEnabled = autoKillEnabled,
		autoLeaveEnabled = autoLeaveEnabled,
		autoKillTarget = winUI.killNameBox.Text,
		antiAfkEnabled = antiAfkEnabled,
		autoMeditateEnabled = autoMeditateEnabled,
	}

	writefile(getProfilePath(), HttpService:JSONEncode(payload))
	refreshConfigInfoLabel()
end

function loadProfile()
	if not readfile or not isfile then
		return
	end

	local profilePath = getProfilePath()
	if not isfile(profilePath) then
		return
	end

	local decoded = decodeJson(readfile(profilePath))
	if type(decoded) ~= "table" then
		return
	end

	if decoded.selectedBoostRole == "win" or decoded.selectedBoostRole == "lose" then
		selectedBoostRole = decoded.selectedBoostRole
		refreshSelectedRoleLabel()
	end

	if decoded.selectedSlot == "A" or decoded.selectedSlot == "B" or decoded.selectedSlot == "C" then
		selectedSlot = decoded.selectedSlot
		refreshSelectedSlotLabel()
	end

	boostUI.inviteNamesBox.Text = tostring(decoded.inviteNames or "")
	boostUI.acceptInviteNamesBox.Text = tostring(decoded.acceptInviteNames or "")
	winUI.killNameBox.Text = tostring(decoded.autoKillTarget or "")

	setToggleState(decoded.autoFarmEnabled == true, autoFarmEnabled, toggleAutoFarm)
	setToggleState(decoded.autoWeaponEnabled == true, autoWeaponEnabled, toggleAutoWeapon)
	setToggleState(decoded.autoShikaiEnabled == true, autoShikaiEnabled, toggleAutoShikai)
	setToggleState(decoded.autoAttackEnabled == true, autoAttackEnabled, toggleAutoAttack)
	setToggleState(decoded.autoResetEnabled == true, autoResetEnabled, toggleAutoReset)
	setToggleState(decoded.autoChooseSlotEnabled == true, autoChooseSlotEnabled, toggleAutoChooseSlot)
	setToggleState(decoded.autoInviteEnabled == true, autoInviteEnabled, toggleAutoInvite)
	setToggleState(decoded.autoAcceptInviteEnabled == true, autoAcceptInviteEnabled, toggleAutoAcceptInvite)
	setToggleState(decoded.autoQueueEnabled == true, autoQueueEnabled, toggleAutoQueue)
	setToggleState(decoded.autoKillEnabled == true, autoKillEnabled, toggleAutoKill)
	setToggleState(decoded.autoLeaveEnabled == true, autoLeaveEnabled, toggleAutoLeave)
	setToggleState(decoded.antiAfkEnabled == true, antiAfkEnabled, toggleAntiAfk)
	setToggleState(decoded.autoMeditateEnabled == true, autoMeditateEnabled, toggleAutoMeditate)
	refreshConfigInfoLabel()
end

function createConfigProfile()
	saveCurrentProfile()
end

function overwriteCurrentProfile()
	saveCurrentProfile()
end

function setAutoloadProfile()
	if not writefile or not ensureProfileFolder() then
		return
	end

	local payload = {
		enabled = autoLoadConfigEnabled,
		profile = getRoleFolderName() .. "/" .. getProfileName(),
	}

	writefile(AUTOLOAD_PROFILE_FILE, HttpService:JSONEncode(payload))
	refreshConfigInfoLabel()
end

function loadAutoloadProfile()
	if readfile and isfile and isfile(AUTOLOAD_PROFILE_FILE) then
		local decoded = decodeJson(readfile(AUTOLOAD_PROFILE_FILE))
		if type(decoded) == "table" then
			autoLoadConfigEnabled = decoded.enabled == true
			updateTickBox(configUI.autoLoadTickBox, autoLoadConfigEnabled)

			local savedProfile = tostring(decoded.profile or "")
			local savedRole = savedProfile:match("^(win)/") or savedProfile:match("^(lose)/")
			if savedRole == "win" or savedRole == "lose" then
				selectedBoostRole = savedRole
				refreshSelectedRoleLabel()
			end
		else
			local saved = tostring(readfile(AUTOLOAD_PROFILE_FILE) or "")
			local savedRole = saved:match("^(win)/") or saved:match("^(lose)/")
			if savedRole == "win" or savedRole == "lose" then
				selectedBoostRole = savedRole
				refreshSelectedRoleLabel()
			end
		end
	end

	if autoLoadConfigEnabled then
		loadProfile()
	end
end

function cycleSelectedRole()
	if selectedBoostRole == "win" then
		selectedBoostRole = "lose"
	else
		selectedBoostRole = "win"
	end

	refreshSelectedRoleLabel()
	refreshConfigInfoLabel()
end

function toggleAutoLoadConfig()
	autoLoadConfigEnabled = not autoLoadConfigEnabled
	updateTickBox(configUI.autoLoadTickBox, autoLoadConfigEnabled)
	setAutoloadProfile()
end

function runAutoChooseSlotLoop()
	task.spawn(function()
		while autoChooseSlotEnabled and isCurrentSession() do
			pcall(chooseConfiguredSlot)
			task.wait(0.2)
		end
	end)
end

function toggleAutoChooseSlot()
	autoChooseSlotEnabled = not autoChooseSlotEnabled
	updateTickBox(boostUI.chooseSlotTickBox, autoChooseSlotEnabled)

	if autoChooseSlotEnabled then
		runAutoChooseSlotLoop()
	end
end

function resetCharacterOnce()
	currentMission = nil
	waitingForMission = false
	waitingForRespawn = true
	missionResetArmed = false
	missionRequestAt = 0
	stopCurrentTween()

	local character = getCharacter()
	local humanoid = character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		humanoid.Health = 0
	else
		character:BreakJoints()
	end
end

function hopServer()
	local placeId = game.PlaceId
	local currentJobId = game.JobId
	local cursor = nil
	local chosenServer

	repeat
		local url = string.format(
			"https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100%s",
			placeId,
			cursor and ("&cursor=" .. HttpService:UrlEncode(cursor)) or ""
		)

		local decoded = fetchServerPage(url)
		if not decoded then
			break
		end

		if decoded and decoded.data then
			for _, server in ipairs(decoded.data) do
				if server.id ~= currentJobId
					and server.playing < server.maxPlayers then
					chosenServer = server
					break
				end
			end
		end

		cursor = decoded.nextPageCursor
	until chosenServer or not cursor

	if chosenServer then
		TeleportService:TeleportToPlaceInstance(placeId, chosenServer.id, player)
	end
end

pcall(function()
	boostTopButton.MouseButton1Click:Connect(function()
		setActivePage("boost")
	end)
	farmTopButton.MouseButton1Click:Connect(function()
		setActivePage("farm")
	end)
	winTopButton.MouseButton1Click:Connect(function()
		setActivePage("win")
	end)
	loseTopButton.MouseButton1Click:Connect(function()
		setActivePage("lose")
	end)
	configTopButton.MouseButton1Click:Connect(function()
		setActivePage("config")
	end)

	farmUI.farmButton.MouseButton1Click:Connect(toggleAutoFarm)
	farmUI.farmTickBox.MouseButton1Click:Connect(toggleAutoFarm)

	farmUI.weaponButton.MouseButton1Click:Connect(toggleAutoWeapon)
	farmUI.weaponTickBox.MouseButton1Click:Connect(toggleAutoWeapon)

	farmUI.shikaiButton.MouseButton1Click:Connect(toggleAutoShikai)
	farmUI.shikaiTickBox.MouseButton1Click:Connect(toggleAutoShikai)

	farmUI.attackButton.MouseButton1Click:Connect(toggleAutoAttack)
	farmUI.attackTickBox.MouseButton1Click:Connect(toggleAutoAttack)

	farmUI.resetCharacterButton.MouseButton1Click:Connect(resetCharacterOnce)
	farmUI.resetCharacterTickBox.MouseButton1Click:Connect(resetCharacterOnce)

	boostUI.chooseSlotButton.MouseButton1Click:Connect(cycleSelectedSlot)
	boostUI.chooseSlotTickBox.MouseButton1Click:Connect(toggleAutoChooseSlot)

	boostUI.roleButton.MouseButton1Click:Connect(cycleSelectedRole)

	boostUI.inviteButton.MouseButton1Click:Connect(function()
		boostUI.inviteNamesBox:CaptureFocus()
	end)
	boostUI.inviteTickBox.MouseButton1Click:Connect(toggleAutoInvite)

	boostUI.acceptInviteButton.MouseButton1Click:Connect(function()
		boostUI.acceptInviteNamesBox:CaptureFocus()
	end)
	boostUI.acceptInviteTickBox.MouseButton1Click:Connect(toggleAutoAcceptInvite)
	boostUI.queueButton.MouseButton1Click:Connect(toggleAutoQueue)
	boostUI.queueTickBox.MouseButton1Click:Connect(toggleAutoQueue)
	winUI.killButton.MouseButton1Click:Connect(toggleAutoKill)
	winUI.killTickBox.MouseButton1Click:Connect(toggleAutoKill)
	loseUI.leaveButton.MouseButton1Click:Connect(toggleAutoLeave)
	loseUI.leaveTickBox.MouseButton1Click:Connect(toggleAutoLeave)

	farmUI.antiAfkButton.MouseButton1Click:Connect(toggleAntiAfk)
	farmUI.antiAfkTickBox.MouseButton1Click:Connect(toggleAntiAfk)
	farmUI.hopServerButton.MouseButton1Click:Connect(hopServer)
	farmUI.hopServerTickBox.MouseButton1Click:Connect(hopServer)
	farmUI.meditateButton.MouseButton1Click:Connect(toggleAutoMeditate)
	farmUI.meditateTickBox.MouseButton1Click:Connect(toggleAutoMeditate)

	configUI.saveButton.MouseButton1Click:Connect(createConfigProfile)
	configUI.loadButton.MouseButton1Click:Connect(loadProfile)
	configUI.autoloadButton.MouseButton1Click:Connect(setAutoloadProfile)
	configUI.autoLoadTickBox.MouseButton1Click:Connect(toggleAutoLoadConfig)

	hiddenUI.createConfigButton.MouseButton1Click:Connect(createConfigProfile)
	hiddenUI.createConfigTickBox.MouseButton1Click:Connect(createConfigProfile)
	hiddenUI.loadConfigButton.MouseButton1Click:Connect(loadProfile)
	hiddenUI.loadConfigTickBox.MouseButton1Click:Connect(loadProfile)
	hiddenUI.setAutoloadButton.MouseButton1Click:Connect(setAutoloadProfile)
	hiddenUI.setAutoloadTickBox.MouseButton1Click:Connect(setAutoloadProfile)
	hiddenUI.overwriteConfigButton.MouseButton1Click:Connect(overwriteCurrentProfile)
	hiddenUI.overwriteConfigTickBox.MouseButton1Click:Connect(overwriteCurrentProfile)

	updateTickBox(farmUI.farmTickBox, autoFarmEnabled)
	updateTickBox(farmUI.weaponTickBox, autoWeaponEnabled)
	updateTickBox(farmUI.shikaiTickBox, autoShikaiEnabled)
	updateTickBox(farmUI.attackTickBox, autoAttackEnabled)
	updateTickBox(boostUI.chooseSlotTickBox, autoChooseSlotEnabled)
	updateTickBox(boostUI.inviteTickBox, autoInviteEnabled)
	updateTickBox(boostUI.acceptInviteTickBox, autoAcceptInviteEnabled)
	updateTickBox(boostUI.queueTickBox, autoQueueEnabled)
	updateTickBox(winUI.killTickBox, autoKillEnabled)
	updateTickBox(loseUI.leaveTickBox, autoLeaveEnabled)
	updateTickBox(farmUI.antiAfkTickBox, antiAfkEnabled)
	updateTickBox(farmUI.meditateTickBox, autoMeditateEnabled)
	updateTickBox(configUI.autoLoadTickBox, autoLoadConfigEnabled)
	refreshSelectedRoleLabel()
	farmUI.resetCharacterTickBox.Text = "USE"
	farmUI.resetCharacterTickBox.BackgroundColor3 = theme.input
	farmUI.hopServerTickBox.Text = "USE"
	farmUI.hopServerTickBox.BackgroundColor3 = theme.input
	hiddenUI.createConfigTickBox.Text = "USE"
	hiddenUI.createConfigTickBox.BackgroundColor3 = theme.input
	hiddenUI.loadConfigTickBox.Text = "USE"
	hiddenUI.loadConfigTickBox.BackgroundColor3 = theme.input
	hiddenUI.setAutoloadTickBox.Text = "USE"
	hiddenUI.setAutoloadTickBox.BackgroundColor3 = theme.input
	hiddenUI.overwriteConfigTickBox.Text = "USE"
	hiddenUI.overwriteConfigTickBox.BackgroundColor3 = theme.input
	refreshSelectedSlotLabel()
	hiddenUI.profileNameBox.Text = getProfileName()
	pcall(ensureProfileFolder)
	setActivePage("boost")
	refreshConfigInfoLabel()

	disableGuiSelection(screenGui)
	pcall(loadAutoloadProfile)
	refreshConfigInfoLabel()
end)

local dragging = false
local dragStart
local startPosition

main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPosition = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode == Enum.KeyCode.End then
		screenGui.Enabled = not screenGui.Enabled
	end
end)

player.CharacterAdded:Connect(function(character)
	currentMission = nil
	waitingForMission = false
	waitingForRespawn = false
	farmBusy = false
	stopCurrentTween()

	local humanoid = character:FindFirstChildWhichIsA("Humanoid") or character:WaitForChild("Humanoid", 5)
	if humanoid and humanoid.Health > 0 then
		lastRespawnAt = tick()
		markFarmProgress()
	end
end)
