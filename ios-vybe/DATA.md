# VYBE Data Layer

All app data flows through `VYBEDataStore` (`VYBE/Models/VYBEDataStore.swift`),
which every screen reads via the `Mock` facade (`Mock.artists`, `Mock.allSongs`,
`Mock.anchors`, …).

## Using the canonical dataset

The store automatically loads **`vybe_mock_data.json`** from the app bundle when
present, normalizes it, and points the whole app (lists, discovery engine,
profiles, dashboard) at it. If the file is missing it falls back to the rich
built-in catalog (8 hero artists + ~90 generated underground artists + anchors).

To switch the app onto the canonical data:

1. Copy `vybe_mock_data.json` (from `Assets/VYBE/`) into the iOS target, e.g.
   `ios-vybe/VYBE/Resources/vybe_mock_data.json`.
   Because the project uses an Xcode "synchronized" file group, any file placed
   under `ios-vybe/VYBE/` is bundled automatically — no `.pbxproj` edits needed.
2. Build & run. Confirm it loaded under **Settings → Data source**
   (it will read `canonical vybe_mock_data.json (N artists, M songs)`).

## Expected JSON shape (all fields optional / tolerant)

```jsonc
{
  "artists": [
    {
      "id": "…", "name": "…", "genre": "…",
      "subgenres": ["…"], "moodTags": ["…"], "sonicTags": ["…"],
      "energy": 0, "tempo": 0, "city": "…", "popularityTier": "undiscovered",
      "monthlyListeners": 0, "isRising": true,
      "fanFundedMonthlyUSD": 0, "streamingEquivUSD": 0, "supporters": 0,
      "soundsLike": ["Anchor A", "Anchor B"],
      "bio": "…", "headerColor": "#…",
      "songs": [{ "id": "…", "title": "…", "durationSec": 0, "plays": 0, "moodTags": ["…"] }]
    }
  ],
  "anchors":  [{ "name": "…", "genre": "…", "subgenres": ["…"], "sonicTags": ["…"], "moodTags": ["…"], "energy": 0 }],
  "songs":    [ /* optional: top-level songs if not nested under artists */ ],
  "moods":    ["…"],
  "genres":   ["…"],
  "cities":   ["…"]
}
```

Unknown keys are ignored; missing keys are filled with sensible defaults, so a
partial or evolving dataset will never crash the loader.
