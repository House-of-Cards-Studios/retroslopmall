local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local gui = script.Parent

-- =====================================================================
-- Create all UI elements programmatically
-- =====================================================================

-- === Close button (always visible at left edge, outside container) ===
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 32, 0, 32)
closeButton.Position = UDim2.new(0, 0, 0.5, -16)
closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeButton.Text = "<"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.BorderSizePixel = 0
closeButton.ZIndex = 2
closeButton.Parent = gui

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- === Container (slide panel, starts to the right of close button) ===
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(0, 200, 0, 420)
container.Position = UDim2.new(0, 32, 0.5, -210)
container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
container.BorderSizePixel = 0
container.Parent = gui

local containerCorner = Instance.new("UICorner")
containerCorner.CornerRadius = UDim.new(0, 8)
containerCorner.Parent = container

local containerStroke = Instance.new("UIStroke")
containerStroke.Color = Color3.fromRGB(60, 60, 60)
containerStroke.Thickness = 1
containerStroke.Parent = container

-- === Left content area ===
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, 150, 1, -20)
leftPanel.Position = UDim2.new(0, 10, 0, 10)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = container

local leftList = Instance.new("UIListLayout")
leftList.Padding = UDim.new(0, 6)
leftList.HorizontalAlignment = Enum.HorizontalAlignment.Center
leftList.SortOrder = Enum.SortOrder.LayoutOrder
leftList.Parent = leftPanel

-- Tycoon name
local tycoonNameText = Instance.new("TextLabel")
tycoonNameText.Name = "TycoonName"
tycoonNameText.Size = UDim2.new(1, 0, 0, 32)
tycoonNameText.BackgroundTransparency = 1
tycoonNameText.Text = "Loading..."
tycoonNameText.TextColor3 = Color3.fromRGB(255, 255, 255)
tycoonNameText.Font = Enum.Font.GothamBold
tycoonNameText.TextSize = 18
tycoonNameText.TextXAlignment = Enum.TextXAlignment.Center
tycoonNameText.LayoutOrder = 1
tycoonNameText.Parent = leftPanel

-- Progression / status
local tycoonStatusText = Instance.new("TextLabel")
tycoonStatusText.Name = "Status"
tycoonStatusText.Size = UDim2.new(1, 0, 0, 22)
tycoonStatusText.BackgroundTransparency = 1
tycoonStatusText.Text = ""
tycoonStatusText.TextColor3 = Color3.fromRGB(180, 180, 180)
tycoonStatusText.Font = Enum.Font.Gotham
tycoonStatusText.TextSize = 14
tycoonStatusText.TextXAlignment = Enum.TextXAlignment.Center
tycoonStatusText.LayoutOrder = 2
tycoonStatusText.Parent = leftPanel

-- Divider
local divider1 = Instance.new("Frame")
divider1.Size = UDim2.new(1, -10, 0, 1)
divider1.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
divider1.BorderSizePixel = 0
divider1.LayoutOrder = 3
divider1.Parent = leftPanel

-- Cash
local cashText = Instance.new("TextLabel")
cashText.Name = "Cash"
cashText.Size = UDim2.new(1, 0, 0, 38)
cashText.BackgroundTransparency = 1
cashText.Text = "$0"
cashText.TextColor3 = Color3.fromRGB(0, 255, 0)
cashText.Font = Enum.Font.GothamBold
cashText.TextSize = 26
cashText.TextXAlignment = Enum.TextXAlignment.Center
cashText.LayoutOrder = 4
cashText.Parent = leftPanel

-- Income rate
local incomeText = Instance.new("TextLabel")
incomeText.Name = "Income"
incomeText.Size = UDim2.new(1, 0, 0, 22)
incomeText.BackgroundTransparency = 1
incomeText.Text = "$0/s"
incomeText.TextColor3 = Color3.fromRGB(0, 180, 0)
incomeText.Font = Enum.Font.Gotham
incomeText.TextSize = 16
incomeText.TextXAlignment = Enum.TextXAlignment.Center
incomeText.LayoutOrder = 5
incomeText.Parent = leftPanel

-- Divider 2
local divider2 = Instance.new("Frame")
divider2.Size = UDim2.new(1, -10, 0, 1)
divider2.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
divider2.BorderSizePixel = 0
divider2.LayoutOrder = 6
divider2.Parent = leftPanel

-- Rewards button
local rewardsButton = Instance.new("TextButton")
rewardsButton.Name = "RewardsButton"
rewardsButton.Size = UDim2.new(1, -10, 0, 34)
rewardsButton.BackgroundColor3 = Color3.fromRGB(80, 60, 180)
rewardsButton.Text = "Rewards"
rewardsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
rewardsButton.Font = Enum.Font.GothamBold
rewardsButton.TextSize = 15
rewardsButton.BorderSizePixel = 0
rewardsButton.LayoutOrder = 7
rewardsButton.Parent = leftPanel

local rewardsBtnCorner = Instance.new("UICorner")
rewardsBtnCorner.CornerRadius = UDim.new(0, 6)
rewardsBtnCorner.Parent = rewardsButton

-- === Rewards pop-up dialog ===
local rewardsDialog = Instance.new("Frame")
rewardsDialog.Name = "RewardsDialog"
rewardsDialog.Size = UDim2.new(0, 280, 0, 180)
rewardsDialog.Position = UDim2.new(0.5, -140, 0.5, -90)
rewardsDialog.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
rewardsDialog.BorderSizePixel = 0
rewardsDialog.Visible = false
rewardsDialog.ZIndex = 10
rewardsDialog.Parent = gui

local rdCorner = Instance.new("UICorner")
rdCorner.CornerRadius = UDim.new(0, 12)
rdCorner.Parent = rewardsDialog

local rdTitle = Instance.new("Frame")
rdTitle.Size = UDim2.new(1, 0, 0, 36)
rdTitle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
rdTitle.BorderSizePixel = 0
rdTitle.Parent = rewardsDialog

local rdTitleCorner = Instance.new("UICorner")
rdTitleCorner.CornerRadius = UDim.new(0, 12)
rdTitleCorner.Parent = rdTitle

local rdTitleFill = Instance.new("Frame")
rdTitleFill.Size = UDim2.new(1, 0, 0.5, 0)
rdTitleFill.Position = UDim2.new(0, 0, 0.5, 0)
rdTitleFill.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
rdTitleFill.BorderSizePixel = 0
rdTitleFill.Parent = rdTitle

local rdTitleText = Instance.new("TextLabel")
rdTitleText.Size = UDim2.new(1, -50, 1, 0)
rdTitleText.Position = UDim2.new(0, 15, 0, 0)
rdTitleText.BackgroundTransparency = 1
rdTitleText.Text = "Rewards"
rdTitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
rdTitleText.Font = Enum.Font.GothamBold
rdTitleText.TextSize = 16
rdTitleText.TextXAlignment = Enum.TextXAlignment.Left
rdTitleText.Parent = rdTitle

local rdClose = Instance.new("TextButton")
rdClose.Size = UDim2.new(0, 28, 0, 28)
rdClose.Position = UDim2.new(1, -32, 0, 4)
rdClose.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
rdClose.Text = "X"
rdClose.TextColor3 = Color3.fromRGB(255, 255, 255)
rdClose.Font = Enum.Font.GothamBold
rdClose.TextSize = 14
rdClose.BorderSizePixel = 0
rdClose.Parent = rdTitle

local rdCloseCorner = Instance.new("UICorner")
rdCloseCorner.CornerRadius = UDim.new(0, 6)
rdCloseCorner.Parent = rdClose

local rdBody = Instance.new("TextLabel")
rdBody.Size = UDim2.new(1, -30, 1, -66)
rdBody.Position = UDim2.new(0, 15, 0, 46)
rdBody.BackgroundTransparency = 1
rdBody.Text = "🎁 Coming Soon!\n\nDaily rewards and quests\nwill be available here."
rdBody.TextColor3 = Color3.fromRGB(200, 200, 200)
rdBody.Font = Enum.Font.Gotham
rdBody.TextSize = 16
rdBody.TextWrapped = true
rdBody.TextXAlignment = Enum.TextXAlignment.Center
rdBody.TextYAlignment = Enum.TextYAlignment.Center
rdBody.Parent = rewardsDialog

rdClose.MouseButton1Click:Connect(function()
	rewardsDialog.Visible = false
end)

-- === Right sidebar ===
local rightPanel = Instance.new("Frame")
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(0, 40, 1, -20)
rightPanel.Position = UDim2.new(1, -45, 0, 10)
rightPanel.BackgroundTransparency = 1
rightPanel.Parent = container

local rightList = Instance.new("UIListLayout")
rightList.Padding = UDim.new(0, 8)
rightList.HorizontalAlignment = Enum.HorizontalAlignment.Center
rightList.VerticalAlignment = Enum.VerticalAlignment.Center
rightList.SortOrder = Enum.SortOrder.LayoutOrder
rightList.Parent = rightPanel

-- Run/Walk button
local runButton = Instance.new("TextButton")
runButton.Name = "RunButton"
runButton.Size = UDim2.new(0, 40, 0, 50)
runButton.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
runButton.Text = "Run"
runButton.TextColor3 = Color3.fromRGB(255, 255, 255)
runButton.Font = Enum.Font.GothamBold
runButton.TextSize = 13
runButton.TextWrapped = true
runButton.BorderSizePixel = 0
runButton.LayoutOrder = 2
runButton.Parent = rightPanel

local runCorner = Instance.new("UICorner")
runCorner.CornerRadius = UDim.new(0, 6)
runCorner.Parent = runButton

-- =====================================================================
-- Income / purchase notification (separate ScreenGui)
-- =====================================================================
local incomeEvent = ReplicatedStorage:WaitForChild("IncomeEvent", 10)
if incomeEvent then
	local pg = player:WaitForChild("PlayerGui")
	local ng = Instance.new("ScreenGui")
	ng.Name = "IncomeNotification"
	ng.ResetOnSpawn = false
	ng.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ng.DisplayOrder = 99
	ng.Parent = pg

	local nl = Instance.new("TextLabel")
	nl.Size = UDim2.new(0, 300, 0, 40)
	nl.Position = UDim2.new(0.5, -150, 0.65, 0)
	nl.BackgroundTransparency = 0.5
	nl.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	nl.TextColor3 = Color3.fromRGB(255, 255, 100)
	nl.TextStrokeTransparency = 0
	nl.Font = Enum.Font.SourceSansBold
	nl.TextSize = 20
	nl.ZIndex = 99
	nl.Visible = false
	nl.Parent = ng

	local hideThread = nil

	incomeEvent.OnClientEvent:Connect(function(action, value, speed)
		if action == "income" then
			nl.Text = "Income: +$" .. value .. " per " .. speed .. "s"
		elseif action == "speed" then
			nl.Text = "Speed: $" .. value .. " per " .. speed .. "s"
		elseif action == "model" then
			local price = speed
			if price == 0 then
				nl.Text = "Purchased Model " .. value .. " - FREE!"
			else
				nl.Text = "Purchased Model " .. value .. " - $" .. price
			end
		end
		nl.Visible = true
		nl.TextTransparency = 0
		if hideThread then task.cancel(hideThread) end
		hideThread = task.delay(5, function() nl.Visible = false end)
	end)
else
	warn("IncomeEvent not found — notifications disabled")
end

-- =====================================================================
-- Slide animation + close button
-- =====================================================================
local closed = false
local closing = false
local tweenTime = 0.5
local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenOpen = TweenService:Create(container, tweenInfo, {Position = UDim2.new(0, 32, 0.5, -210)})
local tweenClose = TweenService:Create(container, tweenInfo, {Position = UDim2.new(0, -200, 0.5, -210)})

closeButton.MouseButton1Up:Connect(function()
	if closing then return end
	local clock = script:FindFirstChild("Clock")
	if clock then clock:Play() end
	closing = true
	if closed then
		tweenOpen:Play()
	else
		tweenClose:Play()
	end
	wait(tweenTime)
	closing = false
	closed = not closed
	if closed then
		closeButton.Text = ">"
	else
		closeButton.Text = "<"
	end
end)

-- =====================================================================
-- Run/Walk toggle
-- =====================================================================
runButton.MouseButton1Up:Connect(function()
	if runButton.Text == "Run" then
		runButton.Text = "Walk"
		runButton.BackgroundColor3 = Color3.fromRGB(200, 140, 40)
	else
		runButton.Text = "Run"
		runButton.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
	end
	game:GetService("ReplicatedStorage").RunEvent:FireServer()
end)

-- =====================================================================
-- Rewards button
-- =====================================================================
rewardsButton.MouseButton1Up:Connect(function()
	rewardsDialog.Visible = not rewardsDialog.Visible
end)

-- =====================================================================
-- Data display
-- =====================================================================
local leaderstats = player:WaitForChild("leaderstats")
local tycoonStoreData = player.TycoonData:WaitForChild("TycoonStoreData")

local function formatMoney(amount: number): string
	local suffixes = {
		{t = 1e12, s = "T"},
		{t = 1e9,  s = "B"},
		{t = 1e6,  s = "M"},
		{t = 1e3,  s = "K"},
	}

	if amount < 1000 then
		return string.format("$%.0f", amount)
	end

	for _, data in ipairs(suffixes) do
		if amount >= data.t then
			return string.format("$%.1f%s", amount / data.t, data.s)
		end
	end

	return tostring(amount)
end

local function updateStatus()
	local tycoonName = player.TycoonData.TycoonName.Value
	local cash = leaderstats.Cash.Value
	cashText.Text = formatMoney(cash)
	if tycoonName == "" then
		tycoonNameText.Text = "Welcome!"
		tycoonStatusText.Text = "Claim a store!"
	else
		local tycoonProgression = player.TycoonData.TycoonProgression.Value
		local rebirths = player.TycoonData.TycoonStoreData[tycoonName].Rebirths.Value
		tycoonNameText.Text = tycoonName
		tycoonStatusText.Text = tycoonProgression .. "/21 (" .. rebirths .. " rebirths)"
	end
end

updateStatus()

local cashStat = leaderstats:FindFirstChild("Cash")
if cashStat then cashStat.Changed:Connect(updateStatus) end
player.TycoonData.TycoonProgression.Changed:Connect(updateStatus)
player.TycoonData.TycoonName.Changed:Connect(updateStatus)

for _, data in pairs(tycoonStoreData:GetChildren()) do
	local rebirths = data:FindFirstChild("Rebirths")
	if rebirths then
		rebirths.Changed:Connect(updateStatus)
	end
end
