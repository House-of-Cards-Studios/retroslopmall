wait()

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Income / purchase / speed upgrade notification (runs immediately)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local incomeEvent = ReplicatedStorage:WaitForChild("IncomeEvent", 10)
if incomeEvent then
	local pg = player:WaitForChild("PlayerGui")
	local ng = Instance.new("ScreenGui")
	ng.Name = "IncomeNotification"
	ng.ResetOnSpawn = false
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
	nl.Visible = false
	nl.Parent = ng
	
	local ts = game:GetService("TweenService")
	local fadeTween = nil
	
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
		if fadeTween then fadeTween:Cancel() end
		task.wait(4)
		fadeTween = ts:Create(nl, TweenInfo.new(1), { TextTransparency = 1 })
		fadeTween:Play()
		fadeTween.Completed:Connect(function() nl.Visible = false end)
	end)
end

local gui = script.Parent
local config = script:WaitForChild("Configuration")

local container = config.Container.Value

local closeButton = config.Buttons.CloseButton.Value
local mallMapButton = config.Buttons.MallMapButton.Value
local rewardsButton = config.Buttons.RewardsButton.Value
local runButton = config.Buttons.RunButton.Value

local rewardsAttention = config.Attentions.RewardsAttention.Value
local closeAttention = config.Attentions.CloseAttention.Value

local cashText = config.Text.Cash.Value
local tycoonNameText = config.Text.TycoonName.Value
local tycoonStatusText = config.Text.TycoonStatus.Value

local closed = false
local closing = false
local TweenService = game:GetService("TweenService")
local tweenTime = 0.5
local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenOpen = TweenService:Create(container, tweenInfo, {Position = UDim2.new(0, 0, 0, 0)})
local tweenClose = TweenService:Create(container, tweenInfo, {Position = UDim2.new(0, -180, 0, 0)})

print(closeButton)
closeButton.MouseButton1Up:Connect(function()
	if closing then return end
	script.Clock:Play()
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
		closeButton.Text = ">>"
	else
		closeButton.Text = "<<"
	end
end)

cashText.Text = "$0"
tycoonNameText.Text = "Loading..."
tycoonStatusText.Text = ""
rewardsAttention.Visible = false
closeAttention.Visible = false
closeButton.Text = "<<"
runButton.Text = "Run"

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
		tycoonNameText.Text = "Welcome to Retroslop Mall!"
		tycoonStatusText.Text = "Claim a store to begin earning!"
	else
		local tycoonProgression = player.TycoonData.TycoonProgression.Value
		local rebirths = player.TycoonData.TycoonStoreData[tycoonName].Rebirths.Value
		tycoonNameText.Text = tycoonName
		tycoonStatusText.Text =  tycoonProgression .. "/21 (" .. rebirths .. " rebirths)"
	end
end

local cashStat = leaderstats:FindFirstChild("Cash")
if cashStat then cashStat.Changed:Connect(updateStatus) end

player.TycoonData.TycoonName.Changed:Connect(updateStatus)

for _, data in pairs(tycoonStoreData:GetChildren()) do
	local tycoonName = data.Name
	local rebirths = data:FindFirstChild("Rebirths")
	rebirths.Changed:Connect(updateStatus)
end

updateStatus()
