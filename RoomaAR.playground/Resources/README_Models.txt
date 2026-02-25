RoomaAR 3D Asset Guide
======================

Add these USDZ files to this Resources directory:
- sofa.usdz
- table.usdz
- chair.usdz
- curtain.usdz
- carpet.usdz

Performance targets (for Swift Student Challenge quality):
1) Keep total ZIP under 25 MB.
2) Prefer lightweight meshes (aim under ~100k triangles per model where possible).
3) Prefer compressed textures and avoid unnecessary 4K maps.
4) Keep materials simple for stable frame rate on iPad.
5) Ensure all assets are local (offline execution, no network dependency).

If a USDZ file is missing, RoomaAR uses procedural fallback geometry so the
experience still runs during development.
