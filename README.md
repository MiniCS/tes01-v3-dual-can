# Tes-01 V3 — Dual-CAN Bus Bridge with WiFi

Compact (62 × 48 mm, 2-layer) dual-CAN development board: an **STM32F405** running
bare-metal bxCAN paired with a **Seeed XIAO ESP32-S3** WiFi gateway. Power it, join its
WiFi access point, and monitor / log / inject CAN frames from any browser — no ST-Link,
no drivers.

This repository holds the **factory test package**: everything a manufacturer (or you)
needs to verify an assembled board before it ships.

## Hardware at a glance

| | |
|---|---|
| MCU 1 | STM32F405RG @ 168 MHz, bare-metal CMSIS (no HAL) |
| MCU 2 | Seeed XIAO ESP32-S3 (WiFi AP + web dashboard) |
| CAN | 2× SN65HVD230, 500 kbit/s (reconfigurable) |
| Power | 5–16 V DC on J5 (pin 1 = V+, pin 2 = GND) |
| Link | UART 1 Mbaud STM32 ⇄ ESP32; same lines flash the STM32 (AN3155) |
| Size | 62 × 48 mm, 2-layer |

## CAN termination — read this

A CAN bus needs **120 Ω at each physical end**, so a correctly terminated bus measures
about **60 Ω** across CANH–CANL.

- **On the bench** (this board wired to one node with short leads) you **must add
  termination yourself**, otherwise frames reflect and fail. Put a resistor across
  CANH–CANL: ~60 Ω for a short point-to-point link, or 120 Ω at each end for a longer bus.
- **In a vehicle** you do **not** add termination — the car's bus is already terminated
  at both ends. Adding another resistor would overload it.

## What's in here

| File | Purpose |
|------|---------|
| `V3_Test_Procedure.pdf` | Step-by-step factory test (power, WiFi, STM32 health, both CAN channels, program + lock STM32) |
| `TES01_V3_TESTER.bin` | ESP32-S3 WiFi test tool — flash once over USB-C |
| `STM32_V3_firmware.bin` | STM32 test/bridge firmware used during the test |
| `FLASH_ESP32.bat` / `.txt` | Flash the test tool into the XIAO (script or browser flasher) |

## Quick start (manufacturer)

1. Flash `TES01_V3_TESTER.bin` into the XIAO ESP32-S3 once over USB-C — see
   `FLASH_ESP32.txt` (browser flasher, nothing to install) or run `FLASH_ESP32.bat COM7`.
2. Power the board with 5–16 V. Join WiFi **`TES01-V3-TEST`** (password `12345678`) and
   open `http://192.168.4.1`.
3. Follow `V3_Test_Procedure.pdf`: confirm the STM32 is alive, test both CAN transceivers
   (jumper J1 ↔ J2), then program and lock the STM32 firmware.

The WiFi is a **local access point only** — nothing here connects to the internet.

## License

MIT — see `LICENSE`.
