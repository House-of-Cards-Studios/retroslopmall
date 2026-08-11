--!strict
local TycoonPricing = require("../src/ServerScriptService/TycoonPricing")

local function assertEq(actual: any, expected: any, msg: string?)
	if actual ~= expected then
		error(
			("%s: expected %s, got %s"):format(
				msg or "assertEq",
				tostring(expected),
				tostring(actual)
			),
			2
		)
	end
end

return {
	["getIncomePrice: level 0 is free"] = function()
		assertEq(TycoonPricing.getIncomePrice(0), 0)
	end,

	["getIncomePrice: level 1 costs $50"] = function()
		assertEq(TycoonPricing.getIncomePrice(1), 50)
	end,

	["getIncomePrice: level 49 costs $2450 (last upgrade)"] = function()
		assertEq(TycoonPricing.getIncomePrice(49), 2450)
	end,

	["getIncomePrice: at MAX_INCOME_LEVEL returns nil"] = function()
		assertEq(TycoonPricing.getIncomePrice(TycoonPricing.MAX_INCOME_LEVEL), nil)
	end,

	["getIncomePrice: past MAX_INCOME_LEVEL returns nil"] = function()
		assertEq(TycoonPricing.getIncomePrice(TycoonPricing.MAX_INCOME_LEVEL + 5), nil)
	end,

	["getSpeedPrice: level 0 costs $5"] = function()
		assertEq(TycoonPricing.getSpeedPrice(0), 5)
	end,

	["getSpeedPrice: level 1 costs $10"] = function()
		assertEq(TycoonPricing.getSpeedPrice(1), 10)
	end,

	["getSpeedPrice: level 4 costs $25 (last upgrade)"] = function()
		assertEq(TycoonPricing.getSpeedPrice(4), 25)
	end,

	["getSpeedPrice: at MAX_SPEED_LEVEL returns nil"] = function()
		assertEq(TycoonPricing.getSpeedPrice(TycoonPricing.MAX_SPEED_LEVEL), nil)
	end,

	["getSpeedSeconds: level 0 is INITIAL_SPEED (6s per tick)"] = function()
		assertEq(TycoonPricing.getSpeedSeconds(0), TycoonPricing.INITIAL_SPEED)
		assertEq(TycoonPricing.getSpeedSeconds(0), 6)
	end,

	["getSpeedSeconds: level 5 is 1s per tick (fastest)"] = function()
		assertEq(TycoonPricing.getSpeedSeconds(5), 1)
	end,

	["constants: MAX_INCOME_LEVEL is 50"] = function()
		assertEq(TycoonPricing.MAX_INCOME_LEVEL, 50)
	end,

	["constants: MAX_SPEED_LEVEL is 5"] = function()
		assertEq(TycoonPricing.MAX_SPEED_LEVEL, 5)
	end,
}
