-- MallMainUI Story
-- Preview the main HUD panel in UI Labs.
-- Uses the shared MallMainUI component module.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MallMainUI = require(ReplicatedStorage:WaitForChild("MallMainUI"))

return function(target: Frame)
	local hud = MallMainUI.createHUD(target)

	-- Remove the close button since it's positioned relative to ScreenGui edges
	if hud.closeButton then
		hud.closeButton:Destroy()
	end

	-- Center the container in the story frame
	hud.container.Position = UDim2.new(0, 10, 0.5, -210)

	-- Set sample data
	hud.tycoonNameText.Text = "Toy Shop"
	hud.tycoonStatusText.Text = "15/21 (3 rebirths)"
	hud.cashText.Text = "$1,250"
	hud.incomeText.Text = "$15/s"

	-- Cleanup
	return function()
		hud.container:Destroy()
	end
end
