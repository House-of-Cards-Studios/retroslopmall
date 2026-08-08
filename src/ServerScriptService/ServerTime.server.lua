local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local Objects = ServerStorage:WaitForChild("Objects")
local ServerTime = Objects:FindFirstChild("ServerTime")

local DaysObject = ServerTime:FindFirstChild("Days").Value
local HoursObject = ServerTime:FindFirstChild("Hours").Value
local MinutesObject = ServerTime:FindFirstChild("Minutes").Value
local SecondsObject = ServerTime:FindFirstChild("Seconds").Value

RunService.Heartbeat:Connect(function(dt)
	local serverUptime = workspace.DistributedGameTime
	DaysObject.Name = math.floor(serverUptime / 86400) .. " - Days -"
	HoursObject.Name = math.floor(serverUptime / 3600) .. " - Hours -"
	MinutesObject.Name = math.floor(serverUptime / 60) .. " - Minutes -"
	SecondsObject.Name = math.floor(serverUptime) .. " - Seconds -"
	wait()
end)
