local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local roofState = Instance.new("BoolValue")
roofState.Name = "RoofState"
roofState.Value = true
roofState.Parent = LocalPlayer

local roofContainer = game.Workspace:WaitForChild("RoofContainer")
local roofObject = ReplicatedStorage:WaitForChild("Roof")

local function changeRoofState(state)
	local roofFound = roofContainer:FindFirstChild("Roof")
	if state and not roofFound then
		roofObject:Clone().Parent = roofContainer
	elseif not state and roofFound then
		roofFound:Destroy()
	end
end

roofState.Changed:Connect(changeRoofState)
changeRoofState(roofState.Value)
