local module = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")

local CLIENT = RunService:IsClient()
local SERVER = RunService:IsServer()
local soundSetup = nil

local function IsValidSoundId(assetId)
	local success, info = MarketplaceService:GetProductInfoAsync(assetId)
	if success and info and info.AssetTypeId == 3 then
		return true
	end
	return false
end

local function initialSetup()
	if soundSetup then
		return soundSetup.Value
	end
	soundSetup = Instance.new("BoolValue")
	if CLIENT then
		soundSetup.Parent = Players.LocalPlayer
	elseif SERVER then
		soundSetup.Parent = game.ServerStorage
	end
	-- check all sound ids
	for _, sound in pairs(script:GetChildren()) do
		if not sound:IsA("Sound") then continue end
		if not IsValidSoundId(sound.SoundId) then
			warn("Sound " .. soundSetup.Name .. " (" .. sound.SoundId .. ") is invalid!")
			sound:Destroy()
		end
	end
	soundSetup.Value = true
	return soundSetup.Value
end

local function playSound(soundName, listener, volume, speed)
	if volume == nil then volume = 1 end
	if speed == nil then speed = 1 end
	if not listener then
		if CLIENT then
			listener = Players.LocalPlayer
		elseif SERVER then
			listener = game.Workspace.Terrain
		end
	end
	local sound = script:FindFirstChild(soundName)
	if not sound then
		warn("Sound " .. sound .. " not found!")
	end
	-- weight sound volume and speed by the sound's own value and the modifier arguments
	local soundVolume = sound.Volume * volume
	local soundSpeed = sound.PlaybackSpeed * speed
	
end

return module
