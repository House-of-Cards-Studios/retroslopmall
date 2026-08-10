--!strict
-- Lune test runner entry point (referenced by AGENTS.md).
--
-- Discovers every `tests/*.spec.luau` file, runs it, and prints a
-- pass/fail summary. Each spec returns a table of { [name] = testFn };
-- a test passes if it returns without error. Exits non-zero if any
-- test fails so CI can gate on it.
--
-- Usage:   lune run index.luau

local fs = require("@lune/fs")
local process = require("@lune/process")

type SpecTable = { [string]: () -> () }

local TESTS_DIR = "tests"

if not fs.isDir(TESTS_DIR) then
	print(("no `%s/` directory — nothing to run"):format(TESTS_DIR))
	return
end

local specs: { { path: string, name: string } } = {}
for _, entry in fs.readDir(TESTS_DIR) do
	if entry:match("%.spec%.luau$") then
		table.insert(specs, {
			path = TESTS_DIR .. "/" .. entry,
			name = entry,
		})
	end
end
table.sort(specs, function(a, b) return a.name < b.name end)

if #specs == 0 then
	print(("no spec files found in `%s/`"):format(TESTS_DIR))
	return
end

local passed, failed = 0, 0
local failures: { string } = {}

for _, spec in specs do
	print(("── %s"):format(spec.name))
	-- Lune's require is relative to the file requiring; strip the .luau
	-- and pass a path relative to this script.
	local modulePath = "./" .. spec.path:gsub("%.luau$", "")
	local ok, moduleOrErr = pcall(require, modulePath)
	if not ok then
		failed += 1
		local msg = ("[load] %s: %s"):format(spec.name, tostring(moduleOrErr))
		print("  ✗ " .. msg)
		table.insert(failures, msg)
		continue
	end
	local suite = moduleOrErr :: SpecTable
	local names: { string } = {}
	for k in pairs(suite) do table.insert(names, k) end
	table.sort(names)
	for _, testName in names do
		local testFn = suite[testName]
		local okRun, err = pcall(testFn)
		if okRun then
			passed += 1
			print(("  ✓ %s"):format(testName))
		else
			failed += 1
			local msg = ("%s › %s: %s"):format(spec.name, testName, tostring(err))
			print(("  ✗ %s — %s"):format(testName, tostring(err)))
			table.insert(failures, msg)
		end
	end
end

print("")
print(("── %d passed, %d failed"):format(passed, failed))

if failed > 0 then
	print("")
	print("failures:")
	for _, f in failures do print("  • " .. f) end
	process.exit(1)
end
