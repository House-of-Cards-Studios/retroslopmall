-- Rewards Dialog Story
-- Preview the rewards pop-up dialog in UI Labs

return function(target: Frame)
	-- Create the pop-up dialog
	local dialog = Instance.new("Frame")
	dialog.Name = "RewardsDialog"
	dialog.Size = UDim2.new(0, 300, 0, 200)
	dialog.Position = UDim2.new(0.5, -150, 0.5, -100)
	dialog.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	dialog.BorderSizePixel = 0
	dialog.Parent = target

	-- Rounded corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = dialog

	-- Title bar
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 40)
	titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = dialog

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 12)
	titleCorner.Parent = titleBar

	local titleFill = Instance.new("Frame")
	titleFill.Size = UDim2.new(1, 0, 0.5, 0)
	titleFill.Position = UDim2.new(0, 0, 0.5, 0)
	titleFill.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	titleFill.BorderSizePixel = 0
	titleFill.Parent = titleBar

	local titleText = Instance.new("TextLabel")
	titleText.Name = "Title"
	titleText.Size = UDim2.new(1, -50, 1, 0)
	titleText.Position = UDim2.new(0, 15, 0, 0)
	titleText.BackgroundTransparency = 1
	titleText.Text = "Rewards"
	titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleText.Font = Enum.Font.GothamBold
	titleText.TextSize = 18
	titleText.TextXAlignment = Enum.TextXAlignment.Left
	titleText.Parent = titleBar

	-- Close button (X)
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 30, 0, 30)
	closeButton.Position = UDim2.new(1, -35, 0, 5)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	closeButton.Text = "X"
	closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeButton.Font = Enum.Font.GothamBold
	closeButton.TextSize = 16
	closeButton.BorderSizePixel = 0
	closeButton.Parent = titleBar

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 6)
	closeCorner.Parent = closeButton

	-- Body text
	local bodyText = Instance.new("TextLabel")
	bodyText.Name = "BodyText"
	bodyText.Size = UDim2.new(1, -30, 1, -80)
	bodyText.Position = UDim2.new(0, 15, 0, 50)
	bodyText.BackgroundTransparency = 1
	bodyText.Text = "🎁 Coming Soon!\n\nDaily rewards and quests\nwill be available here."
	bodyText.TextColor3 = Color3.fromRGB(200, 200, 200)
	bodyText.Font = Enum.Font.Gotham
	bodyText.TextSize = 16
	bodyText.TextWrapped = true
	bodyText.TextXAlignment = Enum.TextXAlignment.Center
	bodyText.TextYAlignment = Enum.TextYAlignment.Center
	bodyText.Parent = dialog

	-- Close button action
	closeButton.MouseButton1Click:Connect(function()
		dialog.Visible = false
	end)

	-- Cleanup function
	return function()
		dialog:Destroy()
	end
end
