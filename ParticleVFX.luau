--!strict
-- Small, dependency-free particle helpers. No AI service or MCP connection required.
local Debris = game:GetService("Debris")

export type Options = {
	preset: string?,
	color: Color3?,
	count: number?,
	texture: string?,
}

local ParticleVFX = {}
local presets = {
	Sparks = { color = Color3.fromRGB(255, 190, 70), speed = 14, lifetime = 0.65, size = 0.25 },
	Magic = { color = Color3.fromRGB(150, 90, 255), speed = 6, lifetime = 1.2, size = 0.6 },
	Smoke = { color = Color3.fromRGB(160, 160, 170), speed = 3, lifetime = 2, size = 2 },
}

local function validate(options: Options)
	assert(presets[options.preset or "Sparks"] ~= nil, "Unknown preset: use Sparks, Magic, or Smoke")
	if options.count ~= nil then
		local count = options.count
		assert(count == count and count >= 1 and count <= 200 and count % 1 == 0,
			"count must be an integer from 1 to 200")
	end
	if options.color ~= nil then
		assert(typeof(options.color) == "Color3", "color must be a Color3")
	end
	if options.texture ~= nil then
		assert(type(options.texture) == "string" and #options.texture > 0, "texture must be a non-empty content ID")
	end
end

-- Creates a disabled emitter. The caller owns it and its parent.
function ParticleVFX.createEmitter(parent: Instance, options: Options?): ParticleEmitter
	assert(parent:IsA("Attachment") or parent:IsA("BasePart"), "parent must be an Attachment or BasePart")
	local config = options or {}
	validate(config)
	local preset = presets[config.preset or "Sparks"]
	local emitter = Instance.new("ParticleEmitter")
	emitter.Name = "ToolkitParticles"
	emitter.Enabled = false
	emitter.Rate = 0
	emitter.Texture = config.texture or "rbxasset://textures/particles/sparkles_main.dds"
	emitter.Color = ColorSequence.new(config.color or preset.color)
	emitter.Lifetime = NumberRange.new(preset.lifetime * 0.6, preset.lifetime)
	emitter.Speed = NumberRange.new(preset.speed * 0.5, preset.speed)
	emitter.SpreadAngle = Vector2.new(180, 180)
	emitter.Rotation = NumberRange.new(0, 360)
	emitter.RotSpeed = NumberRange.new(-90, 90)
	emitter.Drag = 2
	emitter.LightEmission = if config.preset == "Smoke" then 0 else 0.7
	emitter.Size = NumberSequence.new({
		NumberSequenceKeypoint.new(0, preset.size),
		NumberSequenceKeypoint.new(1, 0),
	})
	emitter.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0.15),
		NumberSequenceKeypoint.new(1, 1),
	})
	if config.preset == "Smoke" then
		emitter.Texture = config.texture or "rbxasset://textures/particles/smoke_main.dds"
		emitter.Acceleration = Vector3.new(0, 3, 0)
	else
		emitter.Acceleration = Vector3.new(0, -8, 0)
	end
	emitter.Parent = parent
	return emitter
end

-- Returns the temporary anchor, which may also be destroyed early by the caller.
-- parent is optional; custom parents are useful for isolated tests or effect folders.
function ParticleVFX.burst(position: Vector3, options: Options?, parent: Instance?): BasePart
	assert(typeof(position) == "Vector3", "position must be a Vector3")
	local config = options or {}
	validate(config) -- Validate before allocating any instances.
	local anchor = Instance.new("Part")
	anchor.Name = "ToolkitVFXBurst"
	anchor.Size = Vector3.new(0.1, 0.1, 0.1)
	anchor.Position = position
	anchor.Anchored = true
	anchor.Transparency = 1
	anchor.CanCollide = false
	anchor.CanTouch = false
	anchor.CanQuery = false
	local attachment = Instance.new("Attachment")
	attachment.Parent = anchor
	local emitter = ParticleVFX.createEmitter(attachment, config)
	anchor.Parent = parent or workspace
	emitter:Emit(config.count or 40)
	Debris:AddItem(anchor, emitter.Lifetime.Max + 0.25)
	return anchor
end

return ParticleVFX
