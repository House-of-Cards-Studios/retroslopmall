local ServerStorage = game:GetService("ServerStorage")
local Objects = ServerStorage:WaitForChild("Objects")
local ServerTime = Objects:WaitForChild("ServerTime")

local DaysObject = ServerTime:WaitForChild("Days").Value
local HoursObject = ServerTime:WaitForChild("Hours").Value
local MinutesObject = ServerTime:WaitForChild("Minutes").Value
local SecondsObject = ServerTime:WaitForChild("Seconds").Value

local function updateClock()
	local serverUptime = workspace.DistributedGameTime
	DaysObject.Name = math.floor(serverUptime / 86400) .. " - Days -"
	HoursObject.Name = math.floor(serverUptime / 3600) .. " - Hours -"
	MinutesObject.Name = math.floor(serverUptime / 60) .. " - Minutes -"
	SecondsObject.Name = math.floor(serverUptime) .. " - Seconds -"
end

while true do
	updateClock()
	task.wait(1)
end
