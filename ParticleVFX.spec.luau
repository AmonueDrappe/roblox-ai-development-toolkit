--!strict
-- Paste into Studio's Command Bar AFTER installing ParticleVFX in ReplicatedStorage.
-- Uses an unparented folder, leaving the game hierarchy untouched.
local ParticleVFX = require(game:GetService("ReplicatedStorage"):WaitForChild("ParticleVFX"))
local sandbox = Instance.new("Folder")
local function run()
	local part = Instance.new("Part")
	part.Parent = sandbox
	for _, name in ipairs({ "Sparks", "Magic", "Smoke" }) do
		local emitter = ParticleVFX.createEmitter(part, { preset = name })
		assert(emitter:IsA("ParticleEmitter") and emitter.Parent == part)
		assert(not emitter.Enabled and emitter.Rate == 0)
		assert(emitter.Lifetime.Min > 0 and emitter.Lifetime.Max <= 2)
	end
	local custom = ParticleVFX.createEmitter(part, { color = Color3.new(1, 0, 0), texture = "rbxasset://textures/particles/smoke_main.dds" })
	assert(custom.Color.Keypoints[1].Value == Color3.new(1, 0, 0))
	assert(custom.Texture == "rbxasset://textures/particles/smoke_main.dds")
	assert(not pcall(function() ParticleVFX.createEmitter(sandbox) end))
	assert(not pcall(function() ParticleVFX.createEmitter(part, { preset = "Missing" }) end))
	for _, count in ipairs({ 0, -1, 201, 1.5, math.huge, 0 / 0 }) do
		local before = #sandbox:GetChildren()
		assert(not pcall(function() ParticleVFX.burst(Vector3.zero, { count = count }, sandbox) end))
		assert(#sandbox:GetChildren() == before, "Invalid burst leaked an anchor")
	end
	for _, count in ipairs({ 1, 200 }) do
		local boundary = ParticleVFX.burst(Vector3.zero, { count = count }, sandbox)
		boundary:Destroy()
	end
	local burst = ParticleVFX.burst(Vector3.new(1, 2, 3), nil, sandbox)
	assert(burst.Position == Vector3.new(1, 2, 3) and burst.Anchored)
	assert(not burst.CanCollide and not burst.CanTouch and not burst.CanQuery)
	assert(burst.Transparency == 1)
	assert(burst:FindFirstChildOfClass("Attachment") ~= nil)
	task.wait(2)
	assert(burst.Parent == nil, "Debris did not remove the burst")
end
local success, message = pcall(run)
sandbox:Destroy()
assert(success, tostring(message))
print("ParticleVFX tests passed")
