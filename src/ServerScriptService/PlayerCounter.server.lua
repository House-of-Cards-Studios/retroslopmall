-- Dynamically updates the player-count display models in front of the mall.
-- The second display counts joins during the current server session; it is not persistent.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local function findModel(partialName: string): Model?
	for _, child in Workspace:GetChildren() do
		if child:IsA("Model") and child.Name:lower():find(partialName:lower(), 1, true) then
			return child
		end
	end
	return nil
end

local onlineModel = findModel("in this server is")
local totalModel = findModel("in this server were")

if not onlineModel then
	warn("PlayerCounter: Could not find 'In this Server is X People online' model")
end
if not totalModel then
	warn("PlayerCounter: Could not find 'In this Server were X people' model")
end

local existingTotalCount = totalModel and totalModel:FindFirstChild("TotalVisitors")
if existingTotalCount then
	existingTotalCount:Destroy()
end

local totalCount: IntValue? = nil
if totalModel then
	totalCount = Instance.new("IntValue")
	totalCount.Name = "TotalVisitors"
	totalCount.Value = #Players:GetPlayers()
	totalCount.Parent = totalModel
end

local function updateDisplay(onlineCount: number?)
	if onlineModel then
		local count = onlineCount or #Players:GetPlayers()
		onlineModel.Name = "In this Server is " .. count .. " People online."
	end
	if totalModel and totalCount then
		totalModel.Name = "In this Server were " .. totalCount.Value .. " people."
	end
end

Players.PlayerAdded:Connect(function(_player)
	if totalCount then
		totalCount.Value += 1
	end
	updateDisplay()
end)

Players.PlayerRemoving:Connect(function(_player)
	-- PlayerRemoving fires while the departing player is still returned by GetPlayers().
	updateDisplay(math.max(#Players:GetPlayers() - 1, 0))
end)

updateDisplay()
