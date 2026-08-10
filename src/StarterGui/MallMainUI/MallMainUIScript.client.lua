local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local gui = script.Parent

-- =====================================================================
-- Create all UI elements using the shared MallMainUI component module
-- =====================================================================
local MallMainUI = require(ReplicatedStorage:WaitForChild("MallMainUI"))
local hud = MallMainUI.createHUD(gui)

-- Extract local references for behavior binding
local closeButton = hud.closeButton
local container = hud.container
local tycoonNameText = hud.tycoonNameText
local tycoonStatusText = hud.tycoonStatusText
local cashText = hud.cashText
local incomeText = hud.incomeText
local rewardsButton = hud.rewardsButton
local rewardsDialog = hud.rewardsDialog
local runButton = hud.runButton

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
