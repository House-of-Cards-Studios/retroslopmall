local ServerStorage = game:GetService("ServerStorage")
local TycoonAssets = ServerStorage:WaitForChild("TycoonAssets")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TycoonMetadata = ReplicatedStorage:WaitForChild("TycoonMetadata")

local Tycoons = game.Workspace:WaitForChild("Tycoons")
local TycoonFactories = Tycoons:WaitForChild("TycoonFactories")
local TycoonFloors = Tycoons:WaitForChild("TycoonFloors")
local TycoonTemplate = Tycoons:WaitForChild("TycoonTemplate")
local PlayerTycoons = Tycoons:WaitForChild("PlayerTycoons")

TycoonFactories.Parent = TycoonAssets
TycoonTemplate.Parent = TycoonAssets

local function setCanCollide(part, canCollide)
	part.CanCollide = canCollide
	part.CanQuery = canCollide
	part.CanTouch = canCollide
	part.AudioCanCollide = canCollide
end

-- Income system constants
local MAX_INCOME_LEVEL = 50
local MAX_SPEED_LEVEL = 5
local INITIAL_SPEED = 6

-- Price to upgrade income from currentLevel to currentLevel+1 (nil = maxed out)
local function getIncomePrice(currentLevel: number): number?
	if currentLevel >= MAX_INCOME_LEVEL then return nil end
	if currentLevel == 0 then return 0 end
	return 50 * currentLevel
end

-- Price to upgrade speed from currentLevel to currentLevel+1 (nil = maxed out)
local function getSpeedPrice(currentLevel: number): number?
	if currentLevel >= MAX_SPEED_LEVEL then return nil end
	if currentLevel == 0 then return 5 end
	return 5 + 5 * currentLevel
end

-- Seconds per tick at a given speed level
local function getSpeedSeconds(level: number): number
	return INITIAL_SPEED - level
end

-- Create or get the remote event for income notifications to the client
local function getIncomeEvent()
	local event = ReplicatedStorage:FindFirstChild("IncomeEvent")
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = "IncomeEvent"
		event.Parent = ReplicatedStorage
	end
	return event
end

-- Create or get the remote event for run toggle
local function getRunEvent()
	local event = ReplicatedStorage:FindFirstChild("RunEvent")
	if not event then
		event = Instance.new("RemoteEvent")
		event.Name = "RunEvent"
		event.Parent = ReplicatedStorage
	end
	return event
end

local tycoonMeta = {}

for _, meta in pairs(TycoonMetadata:GetChildren()) do
	local tycoonName = meta.Name
	tycoonMeta[tycoonName] = {
		["Facade"] = meta:FindFirstChild("Facade").Value,
		["FactoryOffset"] = meta:FindFirstChild("FactoryOffset").Value,
	}
end

local Players = game:GetService("Players")
Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Value = 0
	cash.Parent = leaderstats

	local rebirths = Instance.new("IntValue")
	rebirths.Name = "Rebirths"
	rebirths.Value = 0
	rebirths.Parent = leaderstats

	local save = Instance.new("Configuration")
	save.Name = "SaveData"
	save.Parent = player
	
	local musicVolume = Instance.new("NumberValue")
	musicVolume.Value = 1
	musicVolume.Name = "MusicVolume"
	musicVolume.Parent = save

	local sfxVolume = Instance.new("NumberValue")
	sfxVolume.Value = 1
	sfxVolume.Name = "SFXVolume"
	sfxVolume.Parent = save

	local classicMode = Instance.new("BoolValue")
	classicMode.Value = false
	classicMode.Name = "ClassicMode"
	classicMode.Parent = save

	local tycoon = Instance.new("Configuration")
	tycoon.Name = "TycoonData"
	tycoon.Parent = player

	local tycoonName = Instance.new("StringValue")
	tycoonName.Value = ""
	tycoonName.Name = "TycoonName"
	tycoonName.Parent = tycoon

	local tycoonProgression = Instance.new("IntValue")
	tycoonProgression.Value = 0
	tycoonProgression.Name = "TycoonProgression"
	tycoonProgression.Parent = tycoon

	local tycoonStoreData = Instance.new("Folder")
	tycoonStoreData.Name = "TycoonStoreData"
	tycoonStoreData.Parent = tycoon

	for tycoonName, _ in pairs(tycoonMeta) do
		local tycoonStore = Instance.new("Folder")
		tycoonStore.Name = tycoonName
		tycoonStore.Parent = tycoonStoreData

		local rebirths = Instance.new("IntValue")
		rebirths.Name = "Rebirths"
		rebirths.Value = 0
		rebirths.Parent = tycoonStore
	end
end)

-- Run button: server-side handler to toggle sprint safely
local runEvent = getRunEvent()
local RUN_SPEED = 32
local WALK_SPEED = 16
runEvent.OnServerEvent:Connect(function(player)
	local char = player.Character
	if not char then return end
	local humanoid = char:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		if humanoid.WalkSpeed == WALK_SPEED then
			humanoid.WalkSpeed = RUN_SPEED
		else
			humanoid.WalkSpeed = WALK_SPEED
		end
	end
end)


local function resetTycoon(tycoonName, firstTime)
	local meta = tycoonMeta[tycoonName]
	if not meta then
		warn("No metadata for " .. tycoonName)
		return
	end
	
	local floor = TycoonFloors[tycoonName]
	if not floor then
		warn("No floor for " .. tycoonName)
		return
	end
	local factory = TycoonFactories[tycoonName]
	if not factory then
		warn("No factory for " .. tycoonName)
		return
	end


	local tycoon = PlayerTycoons:FindFirstChild(tycoonName)
	if tycoon then
		tycoon:Destroy()
	end
	tycoon = TycoonTemplate:Clone()
	wait()
	tycoon.Name = tycoonName
	tycoon.Parent = PlayerTycoons
	
	if firstTime then
		factory.Parent = tycoon
		local prim = factory.PrimaryPart:Clone()
		for _, inst in pairs(prim:GetChildren()) do
			inst:Destroy()
		end
		prim.Transparency = 1
		setCanCollide(prim, false)
		prim.Parent = factory
		factory.PrimaryPart = prim
		factory:TranslateBy(-meta.FactoryOffset)
		wait()
	end
		
	local clonedFloor = tycoon:FindFirstChild("Floor")
	clonedFloor.Transparency = 1
	setCanCollide(clonedFloor, false)
	tycoon:PivotTo(floor.CFrame)

	if firstTime then
		-- Extract Model1-Model21 from factory into tycoon, hide below map
		for i = 1, 21 do
			local model = factory:FindFirstChild("Model" .. i)
			if model then
				model.Parent = tycoon
				model:PivotTo(CFrame.new(0, -200, 0))
				for _, p in model:GetDescendants() do
					if p:IsA("BasePart") then
						setCanCollide(p, false)
					end
				end
			end
		end
		factory.Parent = TycoonFactories
	end
	
	local config = tycoon:FindFirstChild("Configuration")
	config.State.Owner.Value = nil
	config.State.OwnerName.Value = ""
	config.State.Cash.Value = 0
	config.State.Income.Value = 0
	config.State.IncomeSpeed.Value = 6
	config.State.TycoonName.Value = tycoonName
	
	local becomeOwner = config.BecomeOwnerDoor.Value
	if not becomeOwner then
		warn("No BecomeOwnerDoor for " .. tycoonName)
		return false
	end
	becomeOwner.Name = "Become " .. tycoonName .. " Owner"
	becomeOwner.Head.Transparency = 0
	setCanCollide(becomeOwner.Head, true)
	
	-- Claim handler: when a player touches the owner door, they claim the store
	becomeOwner.Head.Touched:Connect(function(part)
		local player = Players:GetPlayerFromCharacter(part.Parent)
		if not player then return end
		
		local tycoonData = player:FindFirstChild("TycoonData")
		if not tycoonData then return end
		
		-- Player already owns a store — can't claim another
		if tycoonData.TycoonName.Value ~= "" then
			return
		end
		
		-- Store is already claimed by someone
		if config.State.Owner.Value ~= nil then
			return
		end
		
		-- Claim the store!
		config.State.Owner.Value = player
		config.State.OwnerName.Value = player.Name
		tycoonData.TycoonName.Value = tycoonName
		
		local title = config.StoreTitle.Value
		if title then
			title.Name = player.Name .. "'s store"
		end
		
		-- Hide the owner door now that the store is claimed
		becomeOwner.Head.Transparency = 1
		setCanCollide(becomeOwner.Head, false)
	end)
	
	for _, facade in pairs(config.Facades:GetChildren()) do
		if facade.Name == meta.Facade then
			-- skip
			continue
		end
		local val = facade.Value
		if not val then
			warn("Facade " .. facade.Name .. " in tycoon " .. tycoonName .. " is not set!")
			continue
		end
		for _, part in pairs(val:GetChildren()) do
			part.Transparency = 1
			setCanCollide(part, false)
			wait()
		end
		wait()
	end
	
	local title = config.StoreTitle.Value
	if not title then
		warn("No title for " .. tycoonName)
		return false
	end
	title.Name = "No one's store"
	
	local modelButtons = config.Buttons.PurchaseButtons.ModelButtons
	
	-- Rename pre-modeled buttons (already at correct positions from template)
	for i = 1, 21 do
		local price = 5 * (i - 1)
		local mv = modelButtons:FindFirstChild("Model" .. i)
		if mv and mv.Value then
			mv.Value.Name = "Model " .. i .. " - " .. (price > 0 and "$".. price or "free")
		end
	end
	
	-- Helper: enable touch on ALL parts of a button model
	local function setupButtonTouch(model, handler, noCollide)
		for _, part in model:GetDescendants() do
			if part:IsA("BasePart") then
				part.CanTouch = true
				if not noCollide then
					setCanCollide(part, true)
				end
				part.Touched:Connect(handler)
			end
		end
	end
	
	-- Purchase button handlers: touch to buy the next model upgrade
	for i = 1, 21 do
		local mv = modelButtons:FindFirstChild("Model" .. i)
		if mv and mv.Value then
			local buttonModel = mv.Value
			local price = 5 * (i - 1)
			local isItemGiver = (i == 21)
			
			setupButtonTouch(buttonModel, function(part)
				local player = Players:GetPlayerFromCharacter(part.Parent)
				if not player then return end
				if config.State.Owner.Value ~= player then return end
				
				-- Check if already purchased
				local progression = player.TycoonData.TycoonProgression.Value
				if progression >= i then return end
				if progression ~= i - 1 then return end -- must buy in order
				
				local playerCash = player.leaderstats.Cash
				if playerCash.Value < price then return end
				
				-- Purchase!
				playerCash.Value -= price
				player.TycoonData.TycoonProgression.Value = i
				
				-- Reveal the factory model at the button's position
				local factoryModel = tycoon:FindFirstChild("Model" .. i, true)
				if factoryModel then
					factoryModel:PivotTo(buttonModel:GetPivot())
					for _, p in factoryModel:GetDescendants() do
						if p:IsA("BasePart") then
							setCanCollide(p, true)
						end
					end
				end
				
				-- Model button disappears instantly
				buttonModel:Destroy()
				
				-- Notify client
				local event = getIncomeEvent()
				event:FireClient(player, "model", i, price)
				
				-- Item giver (Model21): show OPEN sign on storefront
				if isItemGiver then
					local title = config.StoreTitle.Value
					if title then
						title.Name = player.Name .. "'s store - OPEN!"
					end
					-- Make the store facade "open"
					for _, facade in config.Facades:GetChildren() do
						local val = facade.Value
						if val then
							for _, p in val:GetChildren() do
								if p:IsA("BasePart") and p.Name:lower():find("closed") then
									p.Transparency = 1
									setCanCollide(p, false)
								elseif p:IsA("BasePart") and p.Name:lower():find("open") then
									p.Transparency = 0
									setCanCollide(p, false)
								end
							end
						end
					end
				end
			end)
		end
	end
	
	-- Initialize income upgrade levels
	local incomeLevel = config.State:FindFirstChild("IncomeLevel")
	if not incomeLevel then
		incomeLevel = Instance.new("IntValue")
		incomeLevel.Name = "IncomeLevel"
		incomeLevel.Value = 0
		incomeLevel.Parent = config.State
	else
		incomeLevel.Value = 0
	end
	
	local speedLevel = config.State:FindFirstChild("SpeedLevel")
	if not speedLevel then
		speedLevel = Instance.new("IntValue")
		speedLevel.Name = "SpeedLevel"
		speedLevel.Value = 0
		speedLevel.Parent = config.State
	else
		speedLevel.Value = 0
	end
	
	-- Get collect button model reference
	local collectButton = config.Buttons:FindFirstChild("CollectButton")
	local collectModel = collectButton and collectButton.Value
	
	-- Income generation loop
	task.spawn(function()
		while tycoon and tycoon.Parent do
			local secs = getSpeedSeconds(speedLevel.Value)
			wait(secs)
			if not tycoon or not tycoon.Parent then break end
			local owner = config.State.Owner.Value
			if owner then
				local income = config.State.Income.Value
				if income > 0 then
					config.State.Cash.Value += income
					if collectModel then
						collectModel.Name = "Collect " .. config.State.Cash.Value .. " Cash"
					end
				end
			end
		end
	end)
	
	-- Collect button: touch to claim accumulated cash (walk-through, no collision)
	if collectButton and collectModel then
		setupButtonTouch(collectModel, function(part)
			local player = Players:GetPlayerFromCharacter(part.Parent)
			if not player then return end
			if config.State.Owner.Value ~= player then return end
			local cash = config.State.Cash.Value
			if cash <= 0 then return end
			config.State.Cash.Value = 0
			player.leaderstats.Cash.Value += cash
			collectModel.Name = "Collect 0 Cash"
		end, true) -- noCollide: players walk through collect button
	else
		warn("Collect button not found for " .. tycoonName)
	end
	
	-- Set up the income upgrade button
	local incomeBtn = config.Buttons.IncomeButtons.UpgradeIncomeButton
	if incomeBtn and incomeBtn.Value then
		local incomeModel = incomeBtn.Value
		local function updateIncomeButton()
			if not tycoon or not tycoon.Parent then return end
			local level = incomeLevel.Value
			local price = getIncomePrice(level)
			if price == nil then
				incomeModel.Name = "Income +" .. level .. " (MAX)"
			elseif price == 0 then
				incomeModel.Name = "Upgrade income - free"
			else
				incomeModel.Name = "Upgrade income - $" .. price
			end
		end
		updateIncomeButton()
		
		setupButtonTouch(incomeModel, function(part)
			local player = Players:GetPlayerFromCharacter(part.Parent)
			if not player then return end
			if config.State.Owner.Value ~= player then return end
			
			local level = incomeLevel.Value
			local price = getIncomePrice(level)
			if price == nil then return end
			
			local playerCash = player.leaderstats.Cash
			if playerCash.Value < price then return end
			
			playerCash.Value -= price
			incomeLevel.Value = level + 1
			config.State.Income.Value = level + 1
			
			local event = getIncomeEvent()
			event:FireClient(player, "income", level + 1, getSpeedSeconds(speedLevel.Value))
			
			task.delay(5, function()
				if tycoon and tycoon.Parent then updateIncomeButton() end
			end)
		end)
	else
		warn("Income button not found for " .. tycoonName)
	end
	
	-- Set up the income speed upgrade button
	local speedBtn = config.Buttons.IncomeButtons.UpgradeIncomeSpeedButton
	if speedBtn and speedBtn.Value then
		local speedModel = speedBtn.Value
		local function updateSpeedButton()
			if not tycoon or not tycoon.Parent then return end
			local level = speedLevel.Value
			local price = getSpeedPrice(level)
			local secs = getSpeedSeconds(level)
			if price == nil then
				speedModel.Name = "Speed " .. secs .. "s (MAX)"
			elseif price == 0 then
				speedModel.Name = "Upgrade income speed - free"
			else
				speedModel.Name = "Upgrade income speed - $" .. price
			end
		end
		updateSpeedButton()
		
		setupButtonTouch(speedModel, function(part)
			local player = Players:GetPlayerFromCharacter(part.Parent)
			if not player then return end
			if config.State.Owner.Value ~= player then return end
			
			local level = speedLevel.Value
			local price = getSpeedPrice(level)
			if price == nil then return end
			
			local playerCash = player.leaderstats.Cash
			if playerCash.Value < price then return end
			
			playerCash.Value -= price
			speedLevel.Value = level + 1
			config.State.IncomeSpeed.Value = getSpeedSeconds(level + 1)
			
			local event = getIncomeEvent()
			event:FireClient(player, "speed", config.State.Income.Value, getSpeedSeconds(level + 1))
			
			task.delay(5, function()
				if tycoon and tycoon.Parent then updateSpeedButton() end
			end)
		end)
	else
		warn("Speed button not found for " .. tycoonName)
	end
	
	return true
end

for tycoonName, _ in pairs(tycoonMeta) do
	if not resetTycoon(tycoonName, true) then
		warn("Error loading " .. tycoonName .. "!")
	end
	wait()
end
