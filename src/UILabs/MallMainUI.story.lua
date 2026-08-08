-- MallMainUI Story
-- Preview the main HUD panel in UI Labs

return function(target: Frame)
	-- === Container (slide panel) ===
	local container = Instance.new("Frame")
	container.Name = "Container"
	container.Size = UDim2.new(0, 200, 0, 420)
	container.Position = UDim2.new(0, 10, 0.5, -210)
	container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	container.BorderSizePixel = 0
	container.Parent = target

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
	leftList.Padding = UDim.new(0, 8)
	leftList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	leftList.SortOrder = Enum.SortOrder.LayoutOrder
	leftList.Parent = leftPanel

	-- Tycoon name
	local tycoonName = Instance.new("TextLabel")
	tycoonName.Name = "TycoonName"
	tycoonName.Size = UDim2.new(1, 0, 0, 36)
	tycoonName.BackgroundTransparency = 1
	tycoonName.Text = "Toy Shop"
	tycoonName.TextColor3 = Color3.fromRGB(255, 255, 255)
	tycoonName.Font = Enum.Font.GothamBold
	tycoonName.TextSize = 20
	tycoonName.TextXAlignment = Enum.TextXAlignment.Center
	tycoonName.LayoutOrder = 1
	tycoonName.Parent = leftPanel

	-- Progression
	local progression = Instance.new("TextLabel")
	progression.Name = "Progression"
	progression.Size = UDim2.new(1, 0, 0, 24)
	progression.BackgroundTransparency = 1
	progression.Text = "0/21 (0 rebirths)"
	progression.TextColor3 = Color3.fromRGB(180, 180, 180)
	progression.Font = Enum.Font.Gotham
	progression.TextSize = 16
	progression.TextXAlignment = Enum.TextXAlignment.Center
	progression.LayoutOrder = 2
	progression.Parent = leftPanel

	-- Divider
	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.Size = UDim2.new(1, -10, 0, 1)
	divider.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	divider.BorderSizePixel = 0
	divider.LayoutOrder = 3
	divider.Parent = leftPanel

	-- Cash
	local cash = Instance.new("TextLabel")
	cash.Name = "Cash"
	cash.Size = UDim2.new(1, 0, 0, 40)
	cash.BackgroundTransparency = 1
	cash.Text = "$0"
	cash.TextColor3 = Color3.fromRGB(0, 255, 0)
	cash.Font = Enum.Font.GothamBold
	cash.TextSize = 28
	cash.TextXAlignment = Enum.TextXAlignment.Center
	cash.LayoutOrder = 4
	cash.Parent = leftPanel

	-- Income rate
	local income = Instance.new("TextLabel")
	income.Name = "Income"
	income.Size = UDim2.new(1, 0, 0, 24)
	income.BackgroundTransparency = 1
	income.Text = "$0/s"
	income.TextColor3 = Color3.fromRGB(0, 180, 0)
	income.Font = Enum.Font.Gotham
	income.TextSize = 18
	income.TextXAlignment = Enum.TextXAlignment.Center
	income.LayoutOrder = 5
	income.Parent = leftPanel

	-- Divider 2
	local divider2 = Instance.new("Frame")
	divider2.Name = "Divider2"
	divider2.Size = UDim2.new(1, -10, 0, 1)
	divider2.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	divider2.BorderSizePixel = 0
	divider2.LayoutOrder = 6
	divider2.Parent = leftPanel

	-- Rewards button
	local rewardsBtn = Instance.new("TextButton")
	rewardsBtn.Name = "RewardsButton"
	rewardsBtn.Size = UDim2.new(1, -10, 0, 36)
	rewardsBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 180)
	rewardsBtn.Text = "Rewards"
	rewardsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	rewardsBtn.Font = Enum.Font.GothamBold
	rewardsBtn.TextSize = 16
	rewardsBtn.BorderSizePixel = 0
	rewardsBtn.LayoutOrder = 7
	rewardsBtn.Parent = leftPanel

	local rewardsCorner = Instance.new("UICorner")
	rewardsCorner.CornerRadius = UDim.new(0, 6)
	rewardsCorner.Parent = rewardsBtn

	-- === Rewards pop-up dialog ===
	local rewardsDialog = Instance.new("Frame")
	rewardsDialog.Name = "RewardsDialog"
	rewardsDialog.Size = UDim2.new(0, 280, 0, 180)
	rewardsDialog.Position = UDim2.new(0.5, -140, 0.5, -90)
	rewardsDialog.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	rewardsDialog.BorderSizePixel = 0
	rewardsDialog.Visible = false
	rewardsDialog.ZIndex = 10
	rewardsDialog.Parent = target

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
	rdBody.Text = "Coming Soon!\n\nDaily rewards and quests\nwill be available here."
	rdBody.TextColor3 = Color3.fromRGB(200, 200, 200)
	rdBody.Font = Enum.Font.Gotham
	rdBody.TextSize = 16
	rdBody.TextWrapped = true
	rdBody.TextXAlignment = Enum.TextXAlignment.Center
	rdBody.TextYAlignment = Enum.TextYAlignment.Center
	rdBody.Parent = rewardsDialog

	-- Rewards button toggle
	rewardsBtn.MouseButton1Click:Connect(function()
		rewardsDialog.Visible = not rewardsDialog.Visible
	end)

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
	rightList.Padding = UDim.new(0, 10)
	rightList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	rightList.VerticalAlignment = Enum.VerticalAlignment.Center
	rightList.SortOrder = Enum.SortOrder.LayoutOrder
	rightList.Parent = rightPanel

	-- Close button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, 32, 0, 32)
	closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	closeBtn.Text = "<"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 14
	closeBtn.BorderSizePixel = 0
	closeBtn.LayoutOrder = 1
	closeBtn.Parent = rightPanel

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 6)
	closeCorner.Parent = closeBtn

	-- Run/Walk button
	local runBtn = Instance.new("TextButton")
	runBtn.Name = "RunButton"
	runBtn.Size = UDim2.new(0, 40, 0, 50)
	runBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
	runBtn.Text = "Run"
	runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	runBtn.Font = Enum.Font.GothamBold
	runBtn.TextSize = 13
	runBtn.TextWrapped = true
	runBtn.BorderSizePixel = 0
	runBtn.LayoutOrder = 2
	runBtn.Parent = rightPanel

	local runCorner = Instance.new("UICorner")
	runCorner.CornerRadius = UDim.new(0, 6)
	runCorner.Parent = runBtn

	-- Run/Walk toggle
	runBtn.MouseButton1Click:Connect(function()
		if runBtn.Text == "Run" then
			runBtn.Text = "Walk"
			runBtn.BackgroundColor3 = Color3.fromRGB(200, 140, 40)
		else
			runBtn.Text = "Run"
			runBtn.BackgroundColor3 = Color3.fromRGB(60, 100, 200)
		end
	end)

	-- Cleanup
	return function()
		container:Destroy()
		rewardsDialog:Destroy()
	end
end
