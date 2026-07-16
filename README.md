# Apple TV Pro Control Panel (v4.2.1)

A lightweight, blazing-fast, and robust Windows PowerShell script to wirelessly control multiple Apple TVs over a local network. Built on top of Python's `pyatv` library, this toolkit utilizes a persistent background command stream to achieve instantaneous console-to-device response times.

Developed and maintained by Chainfrogs.

## Features
- **Instant Keyboard Remote Mode:** Control tvOS grid navigation smoothly using your PC's arrow keys, Enter, Backspace (Menu), and Escape with zero interface lag.
- **High-Speed Media Skipping:** Dedicated triggers to instantly skip 10 seconds forward or backward inside active media streams.
- **Hard Hyper Freeze Loop:** An aggressive background loop that forces a pause state every 100ms, completely locking target playback.
- **Active Device Tracking:** Dynamic menu header that displays the custom network name and local IP address of the currently controlled Apple TV.
- **Robust Network Subnet Scanning:** Asynchronous network discovery engine with a graphical progress bar that automatically scans and parses text outputs cleanly, bypassing legacy object parsing bugs.

## Complete Menu Options (1-18)
1. **Pause playback** (Single click pause signal)
2. **Resume playback (Play)** (Single click play signal)
3. **HARD HYPER FREEZE LOOP** (Brutal 100ms lock loop)
4. **Stream audio file (AirPlay Cast)** (Secure HTTPS streaming asset)
5. **Start Screensaver** (Isolated top-level system trigger)
6. **Volume UP (+)** / **Volume DOWN (-)**
8. **Mute / Unmute audio**
9. **Check currently playing (Status)** (In-stream metadata pull)
10. **Go to Home Screen**
11. **Open App Switcher (Double Home)** (Timed dual-pulse execution)
12. **AUTOMATIC APP NAVIGATOR (Macros)** (Pre-configured grid jumps)
13. **INSTANT REMOTE MODE (Arrow Keys)** (Live background stream tunnel)
14. **Skip Forward (10s ->)** / **Skip Backward (<- 10s)**
16. **FORCE HARD REBOOT (Restart device)** (Over-the-network power cycle)
17. **View Project Credits & Update Notes**
18. **Exit / Change Apple TV**

## Prerequisites

This tool requires **Python 3.11 or 3.12** and the `pyatv` package installed on your system.

### 1. Install Python
Download and run the installer from [python.org](https://python.org). 
*⚠️ **CRITICAL:** Ensure you check the box that says **"Add python.exe to PATH"** during setup.*

### 2. Install PyATV Dependencies
Open a standard Windows Command Prompt (`cmd`) or PowerShell window and run:
```cmd
pip install pyatv
```

### 3. Pair Your Apple TV (First Time Only)
To grant your PC control access, run the pairing wizard in your terminal:
```cmd
python -m pyatv.scripts.atvremote wizard
```
*Follow the on-screen prompts and input the 4-digit PIN that appears on your Apple TV screen.*

## How to Run
1. Download `AppleTV_Pro.ps1`.
2. Right-click the file and select **Run with PowerShell**.
3. Select your automatically discovered Apple TV from the list (or type the IP manually if needed).

## License & Liability Disclaimer
Distributed under the **MIT License**. See the `LICENSE` file for the official full text. 

*This software is provided "AS IS", without warranty of any kind. The author (Chainfrogs) holds zero liability for any network disruptions, software errors, or device connectivity drops resulting from the use of this toolkit. Use at your own risk.*
