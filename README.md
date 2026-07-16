# Apple-TV-Toolkit

A lightweight, blazing-fast PowerShell script to wirelessly control Apple TVs over a local network from a Windows PC using the Media Remote Protocol (MRP).

## Features
- **Instant Keyboard Remote Mode:** Control tvOS navigation smoothly using your PC's arrow keys, Enter, Backspace, and Escape with 0ms latency.
- **Infinite Freeze Loop:** Continuously forces a pause state to lock video playback on target devices.
- **Full Control Dashboard:** Power off, pause/play, volume steps, mute toggles, and start screensavers from a vertical CLI menu.

## Prerequisites
This script requires **Python 3.11 or 3.12** and the `pyatv` library.

1. Install Python from [python.org](https://python.org). (Make sure to check **"Add python.exe to PATH"** during setup).
2. Open Command Prompt and install the required library:
   ```cmd
   pip install pyatv
   ```
3. Pair your PC with your Apple TV by running the setup wizard:
   ```cmd
   python -m pyatv.scripts.atvremote wizard
   ```
   *Enter the 4-digit PIN that pops up on your TV screen into the terminal.*

## How to Run
1. Download `AppleTV_Pro.ps1`.
2. Right-click the file and select **Run with PowerShell**.
3. Type in your Apple TV's local IP address and press Enter.

## License
Distributed under the **MIT License**. See `LICENSE` for details. (Includes full limitation of liability — use at your own risk).
