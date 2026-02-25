RoomaAR CGTrader Furniture Guide
================================

This project is wired to use furniture sources from:
https://www.cgtrader.com/free-3d-models

Place runtime assets in:
RoomaAR/Resources/Models/

Required runtime names:
- sofa.usdz
- table.usdz
- chair.usdz
- curtain.usdz
- carpet.usdz

How to import from CGTrader:
1) Open RoomaAR/Resources/CGTraderFurnitureManifest.json
2) Use each item's "cgtraderDownloadPageURL" in your browser.
3) Sign in to CGTrader and download the free files for that item.
4) Convert to USDZ if needed (Reality Converter works well for OBJ/FBX/GLTF).
5) Rename output files to the required runtime names above.
6) Put the renamed files into RoomaAR/Resources/Models/

Notes:
- CGTrader free-download endpoints require signed-in authentication.
- If a model is missing, RoomaAR automatically falls back to procedural geometry.
- Keep assets lightweight for stable AR frame rate.
