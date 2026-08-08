bin = script.Parent

function onTouched(part)
	part.BrickColor = script.Parent.BrickColor
	part.Reflectance = script.Parent.Reflectance
	wait(.3)
end

connection = bin.Touched:connect(onTouched)
