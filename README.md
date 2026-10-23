# roblox-ai-development-toolkit

A small open-source starting point for Roblox development with AI-assisted workflows.
The first working feature is a dependency-free Luau particle VFX generator for Roblox Studio.

**Status:** starter project. This repository does not include an AI model, AI API client,
Studio plugin, or MCP integration. You can use an AI coding assistant to help edit the
source, but all included effects run directly in Roblox without an external service.
No API keys, HTTP access, paid packages, or third-party modules are required.

## Included

- `ParticleVFX`: configurable Sparks, Magic, and Smoke particle presets.
- One-shot bursts with invisible, non-colliding anchors and automatic cleanup.
- Optional color, texture, and particle-count overrides.
- A finite, client-side demo and a Studio smoke test.

The Smoke preset is a stylized particle puff, not volumetric smoke. Effects depend on
Roblox rendering quality settings; the default textures are Roblox built-in content paths.
The MIT license applies to this repository's code and documentation, not Roblox assets.

## Install in Roblox Studio (manual, no build tools)

1. Download and extract this repository, then open a Baseplate in Roblox Studio.
2. In Explorer, insert a **ModuleScript** under **ReplicatedStorage**. Name it exactly
   `ParticleVFX` and replace all of its source with `src/ParticleVFX.luau`.
3. Under **StarterPlayer > StarterPlayerScripts**, insert a **LocalScript** named
   `VFXDemo`. Replace its source with `examples/VFXDemo.client.luau`.
4. Press **Play**. Three effects appear about 10 studs in front of your character,
   from left to right: Sparks, Magic, Smoke. They clean themselves up after emission.
5. Stop and press Play again to replay. Remove or disable `VFXDemo` when integrating
   the module into your own game.

Copying file contents into the correct script types is required; placing `.luau`
files in a folder on your computer alone does not install them in Studio.

## Usage

Run this from a LocalScript after installing the module:

```luau
local ParticleVFX = require(game:GetService("ReplicatedStorage"):WaitForChild("ParticleVFX"))

ParticleVFX.burst(Vector3.new(0, 5, 0), {
    preset = "Magic",
    color = Color3.fromRGB(70, 200, 255),
    count = 80,
})
```

For an existing Part or Attachment:

```luau
local emitter = ParticleVFX.createEmitter(workspace:WaitForChild("YourPart"), {
    preset = "Sparks",
})
emitter:Emit(30)
-- Later, when this emitter is no longer needed:
-- emitter:Destroy()
```

Create `YourPart` first, or replace that name with an existing part.

### API

| Function | Behavior |
| --- | --- |
| `createEmitter(parent, options?)` | Returns a disabled ParticleEmitter under a BasePart or Attachment. Caller owns cleanup. Use `Emit(n)` for a burst, or set `Rate` above zero and `Enabled = true` for continuous particles. |
| `burst(position, options?, parent?)` | Emits once at a Vector3 and returns a temporary Part. Defaults to Workspace; an optional container can group effects. Schedules removal after maximum particle lifetime plus 0.25 seconds. Destroy the Part early to cancel. |

| Option | Default | Accepted values |
| --- | --- | --- |
| `preset` | `"Sparks"` | `"Sparks"`, `"Magic"`, `"Smoke"` (case-sensitive) |
| `color` | Preset color | Color3 |
| `count` | `40` | Integer from 1 to 200; used by `burst`, validated by both functions |
| `texture` | Built-in sparkle/smoke texture | Non-empty texture content ID string; custom assets must be accessible to your experience |

Client-side effects are visible only to that client. For multiplayer, trigger local effects
through your own validated game events; this starter does not supply networking or server
authority logic. The per-burst cap does not limit the total number of simultaneous effects.
Keep burst frequency modest and profile on your target devices. Debris may remove older
items early if its service-wide queue is overloaded.

## Tests

After installing the ModuleScript, open **View > Command Bar** in Studio edit mode and
paste `tests/ParticleVFX.spec.luau`. It uses temporary objects outside the game hierarchy
and destroys them afterward. Expected Output: `ParticleVFX tests passed`.

Tests cover presets, overrides, invalid parents and options, count boundaries, burst
properties, no anchor allocation on rejected counts, and timed cleanup. They do not
verify rendered appearance or multiplayer behavior. See `TESTING.md` for the validation
performed on this distribution. Also run the Play demo to visually inspect the result.

If nothing appears, check Output for errors, verify the module and script names and
locations, use Play rather than Run for the LocalScript demo, and raise your graphics
quality. For custom textures, check asset permissions.

## Repository structure

```text
roblox-ai-development-toolkit/
|-- .gitignore
|-- LICENSE
|-- README.md
|-- TESTING.md
|-- examples/
|   `-- VFXDemo.client.luau
|-- src/
|   `-- ParticleVFX.luau
`-- tests/
    `-- ParticleVFX.spec.luau
```

## Publish on GitHub

Replace the bracketed copyright-holder placeholder in `LICENSE` with the actual
owner's name or organization before publication. No owner identity is assumed.
Create an empty GitHub repository named `roblox-ai-development-toolkit`, then upload
the extracted repository contents, including `.gitignore`, at its root. Do not upload
only the ZIP. Suggested repository description:

> Open-source Luau helpers for Roblox Studio, starting with configurable particle VFX and AI-assisted development workflows.

## Contributing

Small, documented improvements are welcome. Include reproduction steps for bugs and
run the Studio tests when changing Luau code. Describe any new dependencies or external
services explicitly. AI-assisted contributions should be reviewed and tested by their
author. Never commit API keys, private place files, or assets you cannot redistribute.

Possible future work includes additional presets, effect pooling, and optional tooling
integrations. These are ideas, not implemented features or delivery commitments.

## References

- [Roblox ParticleEmitter API](https://create.roblox.com/docs/reference/engine/classes/ParticleEmitter)
- [Roblox Debris API](https://create.roblox.com/docs/reference/engine/classes/Debris)

## License

MIT; see [LICENSE](LICENSE). Independent community starter, not affiliated with Roblox.
