# DuoKitShowcase

A SwiftUI sandbox for the iPhone Duo. It exists to be folded, unfolded, rotated
and flipped in front of an audience while the standard components carry on
doing their job — and to show the iOS 27.1 APIs that only a foldable brings.

- **Deployment target:** iOS 27.1 (Xcode 27.1, Swift 6)
- **Bundle id:** `de.tbo.DuoKitShowcase`
- **Dependencies:** none. All content is static sample data in `Model/SampleData.swift`.

The project uses a *synchronized folder* (Xcode 16+), so every `.swift` file
under `DuoKitShowcase/` is part of the target automatically. Adding a file means
dropping it into the folder — no project edit.

## What each screen demonstrates

| Screen | Components | New in 27.1 |
| --- | --- | --- |
| **Sender** | `NavigationSplitView` master–detail, `List` selection, `ToolbarItemGroup`, `ToolbarOverflowMenu`, `.topBarPinnedTrailing`, `visibilityPriority` | — |
| **Sender › Detail** | Navigation bar items, `ShareLink` | `toolbarVerticalEdge`, `axisBehavior(.verticalPreferred / .horizontalOnly)` |
| **Podcasts** | `NavigationStack` push chain (3 levels), `searchable`, `navigationDestination` | — |
| **Wiedergabe** | Transport controls | `ArrangementView` in both `.split` and `.overlay` style, `splitArrangementLayoutRatio`, `overlayArrangementEdge`, `splitArrangementAxis`, `overlayArrangementZIndex` |
| **Layout-Labor** | Full-bleed `Canvas` | `reservedRegions(kind:options:)` for `.division` and `.occlusion`, `toolbarVerticalBehavior(.disabled)` |
| **Scharnier** | — | `onHingeChange`, `DeviceHinge.angle` / `.status` |
| **Suche** | `Tab(role: .search)` | — |
| *(app shell)* | `TabView` with `.sidebarAdaptable`, `tabBarMinimizeBehavior`, **`tabViewBottomAccessory`** with `tabViewBottomAccessoryPlacement` | — |

The mini player is attached to the `TabView`, not to a tab, so it survives tab
switches and pushes. It renders two layouts: `.expanded` above a full-height tab
bar, `.inline` inside a minimized one.

## The debug overlay

A small ruler chip sits in the upper-left corner. Tapping it opens a live panel
showing size classes, container size, safe-area insets, the system's preferred
vertical-bar edge, hinge angle and status, and the reserved-region counts. It is
read straight from the view tree on every layout pass, so it updates *during* a
fold rather than after it.

The panel is a debug tool: it ignores the safe area and uses a fixed top inset
to clear a large-title navigation bar.

## What needs real hardware

| Feature | Simulator | iPhone Duo |
| --- | --- | --- |
| Tab bar → sidebar, split view collapse | yes (pick a foldable simulator, or an iPad) | yes |
| Bottom accessory, both placements | yes | yes |
| `.division` reserved regions | only on a foldable simulator | yes |
| Hinge angle and status | no — `onHingeChange` never fires without a hinge | yes |
| Vertical bar placement | depends on the simulated device | yes |

Every hinge-dependent screen degrades on purpose: `HingeScreen` shows a
`ContentUnavailableView`, the overlay reads "kein Scharnier", and the layout lab
simply lists zero divisions. Nothing in the app branches on a device name.

## The point worth making on stage

Layout decisions belong to size classes, the available size and reserved
regions. The hinge angle is for interactions and effects — a highlight that
follows the fold, a control that appears once the device is propped up. An app
that picks its column count from the hinge angle is an app that is correct on
exactly one device.

## Build

```bash
open DuoKitShowcase.xcodeproj
# or
xcodebuild -scheme DuoKitShowcase -destination 'platform=iOS Simulator,name=iPhone Duo' build
```

## License

MIT — see [LICENSE](LICENSE).
