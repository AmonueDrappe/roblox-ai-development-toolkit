--!strict
-- Install as a LocalScript in StarterPlayer > StarterPlayerScripts.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ParticleVFX = require(ReplicatedStorage:WaitForChild("ParticleVFX"))
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart") :: BasePart

-- Three finite bursts, in front of the player; no permanent event connections.
for index, preset in ipairs({ "Sparks", "Magic", "Smoke" }) do
	local position = (root.CFrame * CFrame.new((index - 2) * 5, 1, -10)).Position
	ParticleVFX.burst(position, { preset = preset, count = 60 })
	task.wait(0.4)
end
