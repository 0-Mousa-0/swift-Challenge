#!/usr/bin/env python3
"""Generate RoomaAR CGTrader furniture manifest.

This script uses public CGTrader item pages and download pages to gather:
- source page URL
- download page URL
- reported file formats
- free-download file IDs and relative URLs

Actual binary downloads require an authenticated CGTrader session.
"""

from __future__ import annotations

import datetime as dt
import html
import json
import pathlib
import re
import sys
import urllib.error
import urllib.request
from typing import Any


ROOT = pathlib.Path(__file__).resolve().parents[1]
OUTPUT_PATH = ROOT / "RoomaAR" / "Resources" / "CGTraderFurnitureManifest.json"

CGTRADER_ITEMS = [
    {
        "slot": "sofa",
        "targetFileName": "sofa.usdz",
        "pageURL": "https://www.cgtrader.com/free-3d-models/furniture/sofa/loveseats-sofa",
    },
    {
        "slot": "table",
        "targetFileName": "table.usdz",
        "pageURL": "https://www.cgtrader.com/free-3d-models/furniture/table/cc0-table",
    },
    {
        "slot": "chair",
        "targetFileName": "chair.usdz",
        "pageURL": "https://www.cgtrader.com/free-3d-models/furniture/chair/wooden-chair-with-curve-handle-golden-legs",
    },
    {
        "slot": "curtain",
        "targetFileName": "curtain.usdz",
        "pageURL": "https://www.cgtrader.com/free-3d-models/furniture/other/simple-curtain-657b8a8d-b07b-4380-ab86-731fd2861e09",
    },
    {
        "slot": "carpet",
        "targetFileName": "carpet.usdz",
        "pageURL": "https://www.cgtrader.com/free-3d-models/household/other/carpets-43a69c8a-7235-4c6d-aa4c-68789464cdd6",
    },
]


def fetch_html(url: str) -> str:
    request = urllib.request.Request(
        url,
        headers={
            "User-Agent": "Mozilla/5.0 (X11; Linux x86_64) RoomaARManifestBot/1.0",
            "Accept": "text/html,application/xhtml+xml",
        },
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        return response.read().decode("utf-8", errors="replace")


def decode_react_props(document: str, index: int) -> dict[str, Any]:
    matches = re.findall(r'data-react-props="([^"]+)"', document)
    if len(matches) <= index:
        raise ValueError(f"Could not find data-react-props[{index}]")
    return json.loads(html.unescape(matches[index]))


def parse_preview_image(media: dict[str, Any]) -> str | None:
    model = media.get("model") or {}
    image_name = model.get("imageName") or {}
    if isinstance(image_name, dict):
        for key in ("large", "url", "thumb"):
            if key in image_name and isinstance(image_name[key], dict):
                url = image_name[key].get("url")
                if isinstance(url, str):
                    return url
            elif key in image_name and isinstance(image_name[key], str):
                return image_name[key]
    return None


def parse_item(item_url: str, slot: str, target_file_name: str) -> dict[str, Any]:
    item_html = fetch_html(item_url)
    item_props = decode_react_props(item_html, 1)

    pricing = item_props.get("pricingArea") or {}
    details = item_props.get("detailsArea") or {}
    gallery = item_props.get("galleryArea") or {}

    product_id = pricing.get("productId")
    if not product_id:
        raise ValueError(f"Missing productId for {item_url}")

    download_page_url = f"https://www.cgtrader.com/items/{product_id}/download-page"
    download_html = fetch_html(download_page_url)
    download_props = decode_react_props(download_html, 1)
    top_section = download_props.get("topSection") or {}
    file_entries = top_section.get("itemFiles") or []

    free_downloads: list[dict[str, Any]] = []
    for file_entry in file_entries:
        relative_path = file_entry.get("url")
        if not isinstance(relative_path, str):
            continue
        free_downloads.append(
            {
                "fileId": file_entry.get("fileId"),
                "itemId": file_entry.get("itemId"),
                "fileSize": file_entry.get("fileSize"),
                "relativePath": relative_path,
                "absoluteURL": f"https://www.cgtrader.com{relative_path}",
            }
        )

    preview_url = None
    medias = gallery.get("medias") or []
    if medias and isinstance(medias, list):
        preview_url = parse_preview_image(medias[0])

    formats = []
    for group in (details.get("nativeFormats"), details.get("exchangeFormats"), details.get("ungroupedFormats")):
        if not isinstance(group, list):
            continue
        for fmt in group:
            title = fmt.get("title")
            if isinstance(title, str) and title not in formats:
                formats.append(title)

    return {
        "slot": slot,
        "targetFileName": target_file_name,
        "title": pricing.get("title"),
        "cgtraderPageURL": item_url,
        "cgtraderDownloadPageURL": download_page_url,
        "productId": product_id,
        "license": pricing.get("license"),
        "isFree": bool(pricing.get("free")),
        "reportedFormats": formats,
        "previewImageURL": preview_url,
        "freeDownloadFiles": free_downloads,
    }


def main() -> int:
    manifest_items: list[dict[str, Any]] = []
    for entry in CGTRADER_ITEMS:
        try:
            manifest_items.append(
                parse_item(
                    item_url=entry["pageURL"],
                    slot=entry["slot"],
                    target_file_name=entry["targetFileName"],
                )
            )
        except (urllib.error.URLError, ValueError, json.JSONDecodeError) as exc:
            print(f"Failed to parse {entry['pageURL']}: {exc}", file=sys.stderr)
            return 1

    payload = {
        "generatedAtUTC": dt.datetime.now(tz=dt.timezone.utc).isoformat(),
        "source": "https://www.cgtrader.com/free-3d-models",
        "notes": [
            "CGTrader free-download file endpoints require signed-in authentication.",
            "Use the listed download-page URLs in a browser session, then rename files to targetFileName.",
            "Place renamed files under RoomaAR/Resources/Models.",
        ],
        "items": manifest_items,
    }

    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text(json.dumps(payload, indent=2), encoding="utf-8")
    print(f"Wrote {OUTPUT_PATH}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
