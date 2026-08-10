-- IncomeNotification Story
-- Preview the purchase/income/speed notification toast in UI Labs.
-- Uses the shared MallMainUI component module.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MallMainUI = require(ReplicatedStorage:WaitForChild("MallMainUI"))

local NOTIFICATIONS = {
	{ action = "model", value = 1, price = 0,  label = "Model purchase (free)" },
	{ action = "model", value = 5, price = 20, label = "Model purchase ($20)" },
	{ action = "income", value = 15, speed = 3, label = "Income upgrade" },
	{ action = "speed", value = 10, speed = 2, label = "Speed upgrade" },
}

return function(target: Frame)
	local ts = game:GetService("TweenService")

	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(1, 0, 1, 0)
	wrapper.BackgroundTransparency = 1
	wrapper.Parent = target

	local buttonList = Instance.new("UIListLayout")
	buttonList.Padding = UDim.new(0, 8)
	buttonList.HorizontalAlignment = Enum.HorizontalAlignment.Center
	buttonList.VerticalAlignment = Enum.VerticalAlignment.Center
	buttonList.SortOrder = Enum.SortOrder.LayoutOrder
	buttonList.Parent = wrapper

	-- Use shared notification label component
	local nl = MallMainUI.createIncomeNotification(wrapper)

	local fadeTween = nil

	local function showNotification(action: string, value: number, speed: number)
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
		fadeTween.Completed:Connect(function()
			nl.Visible = false
		end)
	end

	for i, notif in ipairs(NOTIFICATIONS) do
		local btn = Instance.new("TextButton")
		btn.Name = "Trigger" .. i
		btn.Size = UDim2.new(0, 180, 0, 32)
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		btn.Text = notif.label
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14
		btn.BorderSizePixel = 0
		btn.LayoutOrder = i
		btn.Parent = wrapper

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = btn

		btn.MouseButton1Click:Connect(function()
			coroutine.wrap(showNotification)(notif.action, notif.value, notif.price or notif.speed)
		end)
	end

	return function()
		wrapper:Destroy()
	end
end
