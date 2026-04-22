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
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")

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
local guiParent = playerGui

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
	Size = UDim2.new(0, 430, 0, 490),
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
	Position = UDim2.new(0, 10, 0, 48),
	Size = UDim2.new(1, -20, 1, -58),
	CanvasSize = UDim2.new(0, 0, 0, 640),
	ScrollBarThickness = 6,
	ScrollingDirection = Enum.ScrollingDirection.Y,
})
addStroke(panel, theme.border, 1)

local leftColumn = make("Frame", {
	Parent = panel,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0, 0),
	Size = UDim2.new(0.5, -6, 0, 620),
})

local rightColumn = make("Frame", {
	Parent = panel,
	BackgroundTransparency = 1,
	Position = UDim2.new(0.5, 6, 0, 0),
	Size = UDim2.new(0.5, -6, 0, 620),
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

local chooseSlotButton, chooseSlotTickBox = createFeature(leftColumn, "Auto Choose Slot", "", 55, "Slot: A")
local inviteButton, inviteTickBox = createFeature(leftColumn, "Auto Invite", "", 130, "Targets")
local inviteNamesBox = createInput(leftColumn, "name1,name2", 188)
local acceptInviteButton, acceptInviteTickBox = createFeature(leftColumn, "Auto Accept Invite", "", 235, "Accept From")
local acceptInviteNamesBox = createInput(leftColumn, "name1,name2", 293)

local farmButton, farmTickBox = createFeature(rightColumn, "Auto Farm", "", 55, "Auto Farm")
local weaponButton, weaponTickBox = createFeature(rightColumn, "Auto Weapon", "", 130, "Auto Weapon")
local shikaiButton, shikaiTickBox = createFeature(rightColumn, "Auto Shikai", "", 205, "Auto Shikai")
local attackButton, attackTickBox = createFeature(rightColumn, "Auto Attack", "", 280, "Auto Attack")
local resetCharacterButton, resetCharacterTickBox = createFeature(rightColumn, "Reset Character", "", 355, "Reset")
local antiAfkButton, antiAfkTickBox = createFeature(rightColumn, "Anti AFK", "", 430, "Anti AFK")

local hiddenResetControls = make("Frame", {
	Parent = screenGui,
	Visible = false,
	Size = UDim2.new(0, 0, 0, 0),
})

local resetButton = createButton(hiddenResetControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
local resetTickBox = createButton(hiddenResetControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))

local hiddenControls = make("Frame", {
	Parent = screenGui,
	Visible = false,
	Size = UDim2.new(0, 0, 0, 0),
})

local profileNameBox = make("TextBox", {
	Parent = hiddenControls,
	Text = "default",
})

local createConfigButton = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
local createConfigTickBox = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
local loadConfigButton = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
local loadConfigTickBox = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
local setAutoloadButton = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
local setAutoloadTickBox = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
local overwriteConfigButton = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
local overwriteConfigTickBox = createButton(hiddenControls, "", UDim2.new(0, 0, 0, 0), UDim2.new(0, 0, 0, 0))
local autoFarmEnabled = false
local autoWeaponEnabled = false
local autoShikaiEnabled = false
local autoAttackEnabled = false
local autoResetEnabled = false
local autoChooseSlotEnabled = false
local autoInviteEnabled = false
local autoAcceptInviteEnabled = false
local antiAfkEnabled = false
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
local selectedSlot = "A"
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
local LOW_PLAYER_LIMIT = 3
local RESET_COOLDOWN = 4
local QUEST_LOAD_GRACE = 6
local INVITE_OPEN_COOLDOWN = 2
local INVITE_TARGET_COOLDOWN = 10
local HOLLOW_SPAWN_PADDING = Vector3.new(100, 60, 100)
local HOLLOW_SPAWN_RADIUS_PADDING = 140
local PROFILE_FOLDER = "cocacola_profiles"
local AUTOLOAD_PROFILE_FILE = PROFILE_FOLDER .. "/autoload.txt"

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
	chooseSlotButton.Text = "Slot: " .. selectedSlot
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
		waitingForMission = true
		missionRequestAt = tick()
		lastQuestAcceptAt = tick()
		rogueResetConsumed = false
		missionResetArmed = true
		return true
	end

	local fallbackRemote = player:FindFirstChild(closestBoard.Name)
	if fallbackRemote then
		fallbackRemote:FireServer("Yes")
		waitingForMission = true
		missionRequestAt = tick()
		lastQuestAcceptAt = tick()
		rogueResetConsumed = false
		missionResetArmed = true
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

	return true
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

local function runAutoFarm()
	if farmBusy and tick() - lastFarmRunAt > 8 then
		farmBusy = false
	end

	if farmBusy then
		return
	end

	farmBusy = true
	lastFarmRunAt = tick()

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
			missionRequestAt = 0
		else
			farmBusy = false
			return
		end
	end

	local missionAtPlayer = findMissionAtPlayerPosition()
	if missionAtPlayer then
		currentMission = missionAtPlayer
		waitingForMission = false
	end

	local activeMission = getActiveMission()
	if activeMission then
		local hollowSpawn = activeMission:FindFirstChild("HollowSpawn")
		if not hollowSpawn or not hollowSpawn:IsA("BasePart") then
			currentMission = nil
			waitingForMission = false
			farmBusy = false
			return
		end

		local _, mobRoot, mobPosition, aliveMobCount = findNearestMobInSpawn(hollowSpawn)

		if aliveMobCount > 0 then
			if mobRoot then
				playTween(getHRP(), getBehindMobPosition(mobRoot), 120, mobRoot.Position)
			elseif mobPosition then
				playTween(getHRP(), mobPosition - Vector3.new(0, 2, 0), 120, mobPosition)
			else
				playTween(getHRP(), getSpawnFallbackPosition(hollowSpawn), 120, hollowSpawn.Position)
			end
		else
			currentMission = nil
			waitingForMission = false
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
			farmBusy = false
			return
		end

		if hasVisibleMissionTitle() then
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
		farmBusy = false
		return
	end

	if hasVisibleMissionTitle() then
		farmBusy = false
		return
	end

	if not shouldWaitForCurrentQuest() and tick() - missionRequestAt >= BOARD_REQUEST_COOLDOWN then
		runAutoBoard()
	end

	farmBusy = false
end

local function toggleAutoFarm()
	autoFarmEnabled = not autoFarmEnabled
	updateTickBox(farmTickBox, autoFarmEnabled)

	if autoFarmEnabled then
		startShiftLockBlock()
		task.spawn(function()
			while autoFarmEnabled and isCurrentSession() do
				disableShiftLock()
				local ok = pcall(runAutoFarm)
				if not ok then
					farmBusy = false
					stopCurrentTween()
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
	updateTickBox(weaponTickBox, autoWeaponEnabled)

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
	updateTickBox(shikaiTickBox, autoShikaiEnabled)

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
	updateTickBox(attackTickBox, autoAttackEnabled)

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
	updateTickBox(resetTickBox, autoResetEnabled)

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
	return getTargetNamesFromBox(inviteNamesBox)
end

local function getAcceptInviteTargets()
	return getTargetNamesFromBox(acceptInviteNamesBox)
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

local function clickInviteButton(playerEntry)
	local info = playerEntry:FindFirstChild("Information")
	local header = info and info:FindFirstChild("Header")
	local playerName = header and header:FindFirstChild("PlayerName")
	if not playerName or not playerName:IsA("TextLabel") then
		return
	end

	local targetPlayer = Players:FindFirstChild(playerName.Text)
	local teamRemote = ReplicatedStorage:FindFirstChild("Remotes")
		and ReplicatedStorage.Remotes:FindFirstChild("Team")
	if not targetPlayer or not teamRemote then
		return
	end

	teamRemote:FireServer("Invite", targetPlayer)
	task.wait(0.2)
end

local function findInviteEntryByUsername(scroll, username)
	for _, entry in ipairs(scroll:GetChildren()) do
		if entry.Name ~= "UIListLayout" and entry.Name ~= "UIPadding" then
			local info = entry:FindFirstChild("Information")
			local header = info and info:FindFirstChild("Header")
			local playerName = header and header:FindFirstChild("PlayerName")

			if playerName and playerName:IsA("TextLabel") then
				local currentName = normalizeName(playerName.Text)
				if currentName == username then
					return entry
				end
			end
		end
	end

	return nil
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
			local matchedEntry = findInviteEntryByUsername(scroll, username)
			if matchedEntry then
				inviteCooldowns[username] = tick()
				clickInviteButton(matchedEntry)
			else
				advanceInviteScroll(scroll)
			end
		end
	end
end

local function acceptConfiguredInvites()
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

local function runAutoInviteLoop()
	task.spawn(function()
		while autoInviteEnabled and isCurrentSession() do
			pcall(inviteConfiguredPlayers)
			task.wait(0.5)
		end
	end)
end

local function toggleAutoInvite()
	autoInviteEnabled = not autoInviteEnabled
	updateTickBox(inviteTickBox, autoInviteEnabled)

	if autoInviteEnabled then
		runAutoInviteLoop()
	end
end

local function runAutoAcceptInviteLoop()
	task.spawn(function()
		while autoAcceptInviteEnabled and isCurrentSession() do
			pcall(acceptConfiguredInvites)
			task.wait(0.5)
		end
	end)
end

local function toggleAutoAcceptInvite()
	autoAcceptInviteEnabled = not autoAcceptInviteEnabled
	updateTickBox(acceptInviteTickBox, autoAcceptInviteEnabled)

	if autoAcceptInviteEnabled then
		runAutoAcceptInviteLoop()
	end
end

local function applyAntiAfkState()
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

local function toggleAntiAfk()
	antiAfkEnabled = not antiAfkEnabled
	updateTickBox(antiAfkTickBox, antiAfkEnabled)
	applyAntiAfkState()
end

local function getProfileName()
	local rawName = (profileNameBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if rawName == "" then
		rawName = "default"
	end

	return rawName:gsub("[\\/:*?\"<>|]", "_")
end

local function getProfilePath()
	return PROFILE_FOLDER .. "/" .. getProfileName() .. ".json"
end

local function ensureProfileFolder()
	if not makefolder or not isfolder then
		return false
	end

	if not isfolder(PROFILE_FOLDER) then
		makefolder(PROFILE_FOLDER)
	end

	return true
end

local function setToggleState(desiredState, currentState, toggleFn)
	if desiredState == currentState then
		return
	end

	toggleFn()
end

local function saveCurrentProfile()
	if not writefile or not HttpService or not ensureProfileFolder() then
		return
	end

	local payload = {
		selectedSlot = selectedSlot,
		inviteNames = inviteNamesBox.Text,
		acceptInviteNames = acceptInviteNamesBox.Text,
		autoFarmEnabled = autoFarmEnabled,
		autoWeaponEnabled = autoWeaponEnabled,
		autoShikaiEnabled = autoShikaiEnabled,
		autoAttackEnabled = autoAttackEnabled,
		autoResetEnabled = autoResetEnabled,
		autoChooseSlotEnabled = autoChooseSlotEnabled,
		autoInviteEnabled = autoInviteEnabled,
		autoAcceptInviteEnabled = autoAcceptInviteEnabled,
		antiAfkEnabled = antiAfkEnabled,
	}

	writefile(getProfilePath(), HttpService:JSONEncode(payload))
end

local function loadProfile()
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

	if decoded.selectedSlot == "A" or decoded.selectedSlot == "B" or decoded.selectedSlot == "C" then
		selectedSlot = decoded.selectedSlot
		refreshSelectedSlotLabel()
	end

	inviteNamesBox.Text = tostring(decoded.inviteNames or "")
	acceptInviteNamesBox.Text = tostring(decoded.acceptInviteNames or "")

	setToggleState(decoded.autoFarmEnabled == true, autoFarmEnabled, toggleAutoFarm)
	setToggleState(decoded.autoWeaponEnabled == true, autoWeaponEnabled, toggleAutoWeapon)
	setToggleState(decoded.autoShikaiEnabled == true, autoShikaiEnabled, toggleAutoShikai)
	setToggleState(decoded.autoAttackEnabled == true, autoAttackEnabled, toggleAutoAttack)
	setToggleState(decoded.autoResetEnabled == true, autoResetEnabled, toggleAutoReset)
	setToggleState(decoded.autoChooseSlotEnabled == true, autoChooseSlotEnabled, toggleAutoChooseSlot)
	setToggleState(decoded.autoInviteEnabled == true, autoInviteEnabled, toggleAutoInvite)
	setToggleState(decoded.autoAcceptInviteEnabled == true, autoAcceptInviteEnabled, toggleAutoAcceptInvite)
	setToggleState(decoded.antiAfkEnabled == true, antiAfkEnabled, toggleAntiAfk)
end

local function createConfigProfile()
	if not writefile or not isfile or not ensureProfileFolder() then
		return
	end

	local profilePath = getProfilePath()
	if isfile(profilePath) then
		return
	end

	saveCurrentProfile()
end

local function overwriteCurrentProfile()
	saveCurrentProfile()
end

local function setAutoloadProfile()
	if not writefile or not ensureProfileFolder() then
		return
	end

	writefile(AUTOLOAD_PROFILE_FILE, getProfileName())
end

local function loadAutoloadProfile()
	if not readfile or not isfile or not isfile(AUTOLOAD_PROFILE_FILE) then
		return
	end

	local autoloadName = (readfile(AUTOLOAD_PROFILE_FILE) or ""):gsub("^%s+", ""):gsub("%s+$", "")
	if autoloadName == "" then
		return
	end

	profileNameBox.Text = autoloadName
	loadProfile()
end

local function runAutoChooseSlotLoop()
	task.spawn(function()
		while autoChooseSlotEnabled and isCurrentSession() do
			pcall(chooseConfiguredSlot)
			task.wait(0.2)
		end
	end)
end

local function toggleAutoChooseSlot()
	autoChooseSlotEnabled = not autoChooseSlotEnabled
	updateTickBox(chooseSlotTickBox, autoChooseSlotEnabled)

	if autoChooseSlotEnabled then
		runAutoChooseSlotLoop()
	end
end

local function resetCharacterOnce()
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

local function hopLowPlayerServer()
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
					and server.playing <= LOW_PLAYER_LIMIT
					and server.playing < server.maxPlayers then
					if not chosenServer or server.playing < chosenServer.playing then
						chosenServer = server
					end
				end
			end
		end

		cursor = decoded.nextPageCursor
	until chosenServer or not cursor

	if chosenServer then
		TeleportService:TeleportToPlaceInstance(placeId, chosenServer.id, player)
	end
end

farmButton.MouseButton1Click:Connect(toggleAutoFarm)
farmTickBox.MouseButton1Click:Connect(toggleAutoFarm)

weaponButton.MouseButton1Click:Connect(toggleAutoWeapon)
weaponTickBox.MouseButton1Click:Connect(toggleAutoWeapon)

shikaiButton.MouseButton1Click:Connect(toggleAutoShikai)
shikaiTickBox.MouseButton1Click:Connect(toggleAutoShikai)

attackButton.MouseButton1Click:Connect(toggleAutoAttack)
attackTickBox.MouseButton1Click:Connect(toggleAutoAttack)

resetCharacterButton.MouseButton1Click:Connect(resetCharacterOnce)
resetCharacterTickBox.MouseButton1Click:Connect(resetCharacterOnce)

chooseSlotButton.MouseButton1Click:Connect(cycleSelectedSlot)
chooseSlotTickBox.MouseButton1Click:Connect(toggleAutoChooseSlot)

inviteButton.MouseButton1Click:Connect(function()
	inviteNamesBox:CaptureFocus()
end)
inviteTickBox.MouseButton1Click:Connect(toggleAutoInvite)

acceptInviteButton.MouseButton1Click:Connect(function()
	acceptInviteNamesBox:CaptureFocus()
end)
acceptInviteTickBox.MouseButton1Click:Connect(toggleAutoAcceptInvite)

antiAfkButton.MouseButton1Click:Connect(toggleAntiAfk)
antiAfkTickBox.MouseButton1Click:Connect(toggleAntiAfk)

createConfigButton.MouseButton1Click:Connect(createConfigProfile)
createConfigTickBox.MouseButton1Click:Connect(createConfigProfile)
loadConfigButton.MouseButton1Click:Connect(loadProfile)
loadConfigTickBox.MouseButton1Click:Connect(loadProfile)
setAutoloadButton.MouseButton1Click:Connect(setAutoloadProfile)
setAutoloadTickBox.MouseButton1Click:Connect(setAutoloadProfile)
overwriteConfigButton.MouseButton1Click:Connect(overwriteCurrentProfile)
overwriteConfigTickBox.MouseButton1Click:Connect(overwriteCurrentProfile)

updateTickBox(farmTickBox, autoFarmEnabled)
updateTickBox(weaponTickBox, autoWeaponEnabled)
updateTickBox(shikaiTickBox, autoShikaiEnabled)
updateTickBox(attackTickBox, autoAttackEnabled)
updateTickBox(chooseSlotTickBox, autoChooseSlotEnabled)
updateTickBox(inviteTickBox, autoInviteEnabled)
updateTickBox(acceptInviteTickBox, autoAcceptInviteEnabled)
updateTickBox(antiAfkTickBox, antiAfkEnabled)
resetCharacterTickBox.Text = "USE"
resetCharacterTickBox.BackgroundColor3 = theme.input
createConfigTickBox.Text = "USE"
createConfigTickBox.BackgroundColor3 = theme.input
loadConfigTickBox.Text = "USE"
loadConfigTickBox.BackgroundColor3 = theme.input
setAutoloadTickBox.Text = "USE"
setAutoloadTickBox.BackgroundColor3 = theme.input
overwriteConfigTickBox.Text = "USE"
overwriteConfigTickBox.BackgroundColor3 = theme.input
refreshSelectedSlotLabel()

disableGuiSelection(screenGui)
pcall(loadAutoloadProfile)

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
