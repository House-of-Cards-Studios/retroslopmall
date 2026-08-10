-- Rewards Dialog Story
-- Preview the rewards pop-up dialog in UI Labs.
-- Uses the shared MallMainUI component module.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MallMainUI = require(ReplicatedStorage:WaitForChild("MallMainUI"))

return function(target: Frame)
	local dialog = MallMainUI.createRewardsDialog(target)
	dialog.Position = UDim2.new(0.5, -140, 0.5, -100)
	dialog.Visible = true

	return function()
		dialog:Destroy()
	end
end
