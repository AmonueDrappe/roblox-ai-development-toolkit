# Validation record

Validated on 2026-10-23.

## Passed in Roblox Studio

- The exact `src/ParticleVFX.luau` source compiled and executed through Studio's Luau runtime.
- The included test body ran with that module injected instead of its installation-specific
  `require` line. No ModuleScript was installed or saved in the user's place.
- All three presets created disabled ParticleEmitters under a valid part.
- Custom color and texture overrides matched their inputs.
- An invalid parent and an unknown preset were rejected.
- Counts 0, -1, 201, 1.5, infinity, and NaN were rejected without allocating a burst anchor.
- Boundary counts 1 and 200 were accepted.
- Burst position, transparency, anchoring, collision/touch/query settings, and Attachment
  creation matched expectations.
- Debris removed the default burst after the test's two-second wait.
- Temporary test containers were unparented and destroyed after the test.
- `examples/VFXDemo.client.luau` compiled successfully; it was not executed.

Result returned by Studio: `All isolated ParticleVFX tests passed`.

## Packaging checks

The delivered ZIP was checked for the complete expected file list, `.gitignore`
inclusion, and byte-for-byte equality between archived entries and source files.

## Not verified

- Visual appearance, built-in texture rendering, and the full manual installation flow.
- The LocalScript demo in a Play session, respawning, multiplayer replication, or device performance.
- Standalone static type analysis or linting; no Luau analyzer was available locally.

Run the manual Play demo and the included Studio test after installing. Automated
instance/property checks do not replace visual inspection.
