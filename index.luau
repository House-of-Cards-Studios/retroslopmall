-- this is a lune script!
-- run it with this command in terminal:
-- lune run index.luau
-- check out the documentation at lune-org.github.io

local fs = require("@lune/fs")
local roblox = require("@lune/roblox")

local file = fs.readFile("retroslopmall.rbxlx")
local game = roblox.deserializePlace(file)
local workspace = game:GetService("Workspace")

print("Hello world!")
