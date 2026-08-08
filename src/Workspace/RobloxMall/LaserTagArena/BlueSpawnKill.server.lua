function onTouch(part) 
	local humanoid = part.Parent:FindFirstChild("Humanoid") 
	if (humanoid ~= nil) then	-- If a Humanoid is the toucher, then
		humanoid.Health = 0	-- set the Humanoid's health to 0.
	end 
end

script.Parent.Touched:connect(onTouch)
