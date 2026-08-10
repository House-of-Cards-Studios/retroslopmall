-- ShopGUI Story
-- Preview the item giver shop panel in UI Labs

local ITEMS = {
	"🍔 Burger", "🎮 Game Cartridge", "⚽ Soccer Ball",
	"🔫 Water Gun", "🌮 Taco", "💄 Lipstick",
	"🎸 Guitar", "🧸 Teddy Bear", "📦 Item 9",
	"📦 Item 10", "📦 Item 11",
}

return function(target: Frame)
	-- Shop panel background
	local shopPanel = Instance.new("TextLabel")
	shopPanel.Name = "ShopPanel"
	shopPanel.Size = UDim2.new(0.5, 0, 0.5, 0)
	shopPanel.Position = UDim2.new(0.25, 0, 0.25, 0)
	shopPanel.BackgroundColor3 = Color3.fromRGB(255, 255, 100)
	shopPanel.BackgroundTransparency = 0
	shopPanel.BorderSizePixel = 1
	shopPanel.BorderColor3 = Color3.fromRGB(27, 42, 53)
	shopPanel.Text = ""
	shopPanel.Parent = target

	-- Shop icon
	local icon = Instance.new("ImageLabel")
	icon.Name = "Icon"
	icon.Size = UDim2.new(0, 48, 0, 48)
	icon.Position = UDim2.new(0, 12, 0, 8)
	icon.BackgroundTransparency = 1
	icon.Image = "rbxassetid://0" -- placeholder
	icon.Parent = shopPanel

	-- Shop title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -70, 0, 24)
	title.Position = UDim2.new(0, 64, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = "Store Items"
	title.TextColor3 = Color3.fromRGB(27, 42, 53)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = shopPanel

	-- Subtitle
	local subtitle = Instance.new("TextLabel")
	subtitle.Name = "Subtitle"
	subtitle.Size = UDim2.new(1, -70, 0, 20)
	subtitle.Position = UDim2.new(0, 64, 0, 34)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = "Buy items from this store!"
	subtitle.TextColor3 = Color3.fromRGB(60, 80, 100)
	subtitle.Font = Enum.Font.Gotham
	subtitle.TextSize = 12
	subtitle.TextXAlignment = Enum.TextXAlignment.Left
	subtitle.Parent = shopPanel

	-- Item grid
	local itemGrid = Instance.new("Frame")
	itemGrid.Name = "ItemGrid"
	itemGrid.Size = UDim2.new(1, -20, 1, -75)
	itemGrid.Position = UDim2.new(0, 10, 0, 65)
	itemGrid.BackgroundTransparency = 1
	itemGrid.Parent = shopPanel

	local gridLayout = Instance.new("UIGridLayout")
	gridLayout.CellSize = UDim2.new(0, 100, 0, 36)
	gridLayout.CellPadding = UDim2.new(0, 6, 0, 6)
	gridLayout.FillDirection = Enum.FillDirection.Horizontal
	gridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	gridLayout.StartCorner = Enum.StartCorner.TopLeft
	gridLayout.Parent = itemGrid

	-- Item buttons
	for i, itemName in ipairs(ITEMS) do
		local itemBtn = Instance.new("TextButton")
		itemBtn.Name = "Item" .. i
		itemBtn.Size = UDim2.new(1, 0, 1, 0)
		itemBtn.BackgroundColor3 = Color3.fromRGB(70, 90, 110)
		itemBtn.Text = itemName
		itemBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		itemBtn.Font = Enum.Font.Gotham
		itemBtn.TextSize = 13
		itemBtn.BorderSizePixel = 0
		itemBtn.Parent = itemGrid

		local itemCorner = Instance.new("UICorner")
		itemCorner.CornerRadius = UDim.new(0, 4)
		itemCorner.Parent = itemBtn

		-- Stub: click does nothing for now
		itemBtn.MouseButton1Click:Connect(function()
			print("Clicked:", itemName)
		end)
	end

	-- Show/Hide toggle button (top-right corner of title bar)
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Name = "ShowHideToggle"
	toggleBtn.Size = UDim2.new(0, 60, 0, 24)
	toggleBtn.Position = UDim2.new(1, -70, 0, 8)
	toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	toggleBtn.Text = "Hide"
	toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.TextSize = 12
	toggleBtn.BorderSizePixel = 0
	toggleBtn.Parent = shopPanel

	local toggleCorner = Instance.new("UICorner")
	toggleCorner.CornerRadius = UDim.new(0, 4)
	toggleCorner.Parent = toggleBtn

	local shopVisible = true
	toggleBtn.MouseButton1Click:Connect(function()
		shopVisible = not shopVisible
		itemGrid.Visible = shopVisible
		toggleBtn.Text = shopVisible and "Hide" or "Show"
		toggleBtn.BackgroundColor3 = shopVisible and Color3.fromRGB(200, 60, 60) or Color3.fromRGB(60, 180, 60)
	end)

	-- Cleanup
	return function()
		shopPanel:Destroy()
	end
end
