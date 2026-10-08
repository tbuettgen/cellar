<p align="center"><img src="docs/icon.png" width="128" alt="Cellar icon"></p>

<h1 align="center">Cellar</h1>

<p align="center">Run the Windows build of Excel on an Apple Silicon Mac, in a private Wine bottle.<br>
<a href="https://tbuettgen.github.io/cellar/">Project page</a></p>

---

Cellar reuses the Wine 11 runtime that [Recall](https://github.com/AsherJN/recall) ships for Overwatch.
If Recall runs Overwatch on your Mac, Cellar can use the same runtime for Excel. It sets up a separate
Windows 10 bottle for Office and adds a Mac launcher, so Excel opens from the Dock or from Finder's **Open With** menu.

**Cellar contains no Microsoft software.** Bring your own Office installer and licence.

## Quick start

```bash
git clone https://github.com/tbuettgen/cellar.git
cd cellar
./bin/cellar setup                       # create the bottle (about a minute)
./bin/cellar install ~/Downloads/setup.exe   # run your Office installer: .exe, .iso or .img
./bin/cellar app                         # put Cellar.app in ~/Applications
```

Then open **Cellar** from Launchpad. You can also right-click a spreadsheet and choose **Open With → Cellar**.

### Installing with the Office Deployment Tool

If you have Microsoft 365, get Microsoft's free Office Deployment Tool from microsoft.com. Then use the
bundled job file, which installs 32-bit Excel only:

```bash
./bin/cellar install ~/Downloads/odt/setup.exe config/excel-only.xml
```

Before running it, edit the `Product ID` in [`config/excel-only.xml`](config/excel-only.xml) to match your licence.

## Commands

| Command | What it does |
| --- | --- |
| `cellar setup` | Find a Wine runtime, create the bottle, apply Office and macOS tweaks. Safe to re-run. |
| `cellar install <installer> [job.xml]` | Run an Office `setup.exe`, `.iso`, `.img` or folder; with a `.xml`, run it as an ODT job |
| `cellar run [files…]` | Open Excel, optionally with files |
| `cellar app` | Build `~/Applications/Cellar.app` |
| `cellar display retina\|normal` | Sharp 2× text on Retina screens, or 1× for external monitors |
| `cellar exec <program>` | Run any other Windows program in the bottle |
| `cellar winecfg` | Open Wine's settings for the bottle |
| `cellar stop` | Force-quit everything in the bottle |
| `cellar doctor` | Show what's installed and where |

## What setup does

- **Runtime:** Cellar copies Recall's unpacked runtime from `~/Library/Application Support/Overwatch2Mac`. If that isn't there, it unpacks `runtime.tar.gz` from `Recall.app`. Failing both, it uses any `wine` on your `PATH`.
- **Bottle:** a 64-bit Windows 10 prefix in `~/Library/Application Support/Cellar/prefix`, separate from your Overwatch bottle.
- **Mac feel:**
  - Left ⌘ acts as Ctrl, so ⌘C, ⌘V and ⌘S work.
  - Retina mode runs at 192 DPI.
  - Font smoothing is on.
- **Office tweaks:** hardware acceleration and animations are off, which avoids most of Wine's redraw glitches. The first-run prompt is skipped.

## Will it work?

Office under Wine is hit and miss, and Cellar can't change that. What's known:

- **Best bet:** 32-bit Office or Excel 2016, from an offline installer. CodeWeavers' CrossOver lists Excel 2016 on Mac as *limited functionality*.
- **Harder:** Microsoft 365 through Click-to-Run. CrossOver lists it as *installs, will not run*. Try it anyway, but expect to troubleshoot.
- **64-bit Office** installers usually fail. Pick 32-bit.
- **Rarely works:** macros that call Windows APIs, COM add-ins, and Power Pivot.

If you need full fidelity, the native Excel for Mac, Excel on the web, or a Windows VM is more reliable.

## Removing it

```bash
./bin/cellar stop
rm -rf ~/Library/Application\ Support/Cellar ~/Applications/Cellar.app
```

Your Overwatch install isn't touched.

## Credits

- [Wine](https://www.winehq.org) does the real work.
- [Recall](https://github.com/AsherJN/recall) by Joshua Asher Nelson packages the Wine 11 runtime that Cellar borrows.
- Cellar is an independent project, not affiliated with or endorsed by Microsoft, Blizzard, CodeWeavers or Apple.
  Excel and Microsoft 365 are trademarks of Microsoft.

MIT licensed. See [LICENSE](LICENSE).
