# IP Changer Script

## Overview

This is a simple, interactive PowerShell script designed to quickly configure the network adapter IP settings on Windows machines. It allows users to:

- Select from available network adapters.
- Set a static IP address, subnet mask (prefix length), default gateway, and DNS servers.
- Revert the adapter back to DHCP automatically.
- Run with administrator privileges to apply network changes.

The script is accompanied by a batch launcher for easy execution with elevated rights and bypasses common execution policy restrictions.

---

## Features

- User-friendly menu interface for network adapter selection and configuration.
- Self-elevation to prompt for administrator rights on script launch.
- Compatible with Windows 10 and 11.
- Minimal dependencies — requires only PowerShell and Windows native commands.
- Portable and easy to share across teams or colleagues.

---

## Usage

1. Ensure you run the script with administrator privileges to apply IP changes.
2. Launch the `RunIPChanger.bat` file (or run the `.ps1` script from an elevated PowerShell prompt).
3. Follow on-screen prompts to select the adapter and enter IP configuration details.
4. Use the menu options to apply static IP, revert to DHCP, or exit.

---

## Installation / Setup

1. Download the repository or clone it to your local machine.
2. Place both `IPChanger.ps1` and `RunIPChanger.bat` in the same folder.
3. Double-click the batch file to run the script with proper admin privileges.
4. (Optional) Adjust execution policy if necessary, or run with the provided batch file which handles policy bypass.

---

## Notes

- Running scripts may prompt Windows Defender SmartScreen or UAC — confirm to proceed.
- Network changes applied by this script may disrupt active network connections momentarily.
- Designed primarily for IT professionals or advanced users who understand network settings.
- Use responsibly in accordance with your organization’s IT policies.

---

## Contributions

Contributions and improvements are welcome! Feel free to fork the repository and submit pull requests.

---

## License & Usage

This project is licensed under the Creative Commons Attribution-NonCommercial 4.0 International License (CC BY-NC 4.0).

You are free to use, modify, and share this software **for non-commercial purposes only**, and you must give appropriate credit to the original author.

Commercial use, selling, licensing, or any for-profit exploitation of this software or derivative works is **not permitted** without explicit permission.

Full license details available at: [CC BY-NC 4.0](https://creativecommons.org/licenses/by-nc/4.0/)

---

## Contact

For questions or support, please contact blackj3015@gmail.com

