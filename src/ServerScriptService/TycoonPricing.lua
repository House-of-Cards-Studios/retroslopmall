--!strict
-- Pure pricing/progression math for the tycoon income and speed upgrades.
-- Extracted from TycoonSetup so future tests (and any future rebirth
-- multipliers) can exercise the formulas without a live DataModel.

local TycoonPricing = {}

TycoonPricing.MAX_INCOME_LEVEL = 50
TycoonPricing.MAX_SPEED_LEVEL = 5
TycoonPricing.INITIAL_SPEED = 6

-- Price to upgrade income from currentLevel to currentLevel+1.
-- Returns nil when the next level exceeds MAX_INCOME_LEVEL.
function TycoonPricing.getIncomePrice(currentLevel: number): number?
	if currentLevel >= TycoonPricing.MAX_INCOME_LEVEL then return nil end
	if currentLevel == 0 then return 0 end
	return 50 * currentLevel
end

-- Price to upgrade speed from currentLevel to currentLevel+1.
-- Returns nil when the next level exceeds MAX_SPEED_LEVEL.
function TycoonPricing.getSpeedPrice(currentLevel: number): number?
	if currentLevel >= TycoonPricing.MAX_SPEED_LEVEL then return nil end
	if currentLevel == 0 then return 5 end
	return 5 + 5 * currentLevel
end

-- Seconds per income tick at a given speed level.
function TycoonPricing.getSpeedSeconds(level: number): number
	return TycoonPricing.INITIAL_SPEED - level
end

return TycoonPricing
