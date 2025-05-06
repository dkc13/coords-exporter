# Coordinates Export System for HappinessMP

## Description

This script allows you to export the coordinates of your character or vehicle in the game **HappinessMP**. You can save both **vehicle** and **pedestrian** coordinates, along with the current heading (rotation) in a text file. This can be useful for tracking locations, reviewing gameplay, or sharing coordinates with others.

## Features
- Save coordinates while in a **vehicle** (`InCar`).
- Save coordinates while on **foot** (`OnFoot`).
- Optionally include a **timestamp** for when the coordinates are saved.
- Customize the file path where the coordinates are saved. The default output file, `savedpositions.txt`, is placed in the server's folder.

## Commands

- `/save` - Saves the current coordinates to the file.
- `/save timestamp` - Enables or disables the timestamp.
- `/save path [path_name.txt]` - Changes the file path for saving the coordinates.
- `/save help` - Displays the available commands.

## Example Output

When you use the `/save` command, the exported coordinates will be written to a text file in the following format:

### With Timestamp
```
[15:50:04] OnFoot(0x1CFC648F, -221.79, 428.62, 14.82, 128.97)
[15:50:32] InCar(REBLA, 0x4F48FC4, -214.67, 445.25, 14.34, 180.29)
```

- **Timestamp**: `[HH:MM:SS]` (e.g., `[14:16:32]`)
- **OnFoot**: Coordinates and heading of the pedestrian (player).
  - Format: `OnFoot(0xPedHash, x, y, z, a)`
- **InCar**: Coordinates and heading of the vehicle.
  - Format: `InCar(VehicleName, 0xVehicleHash, x, y, z, a)`

### Without Timestamp (if disabled)
```
OnFoot(0x1CFC648F, -221.79, 428.62, 14.82, 128.97)
InCar(REBLA, 0x4F48FC4, -214.67, 445.25, 14.34, 180.29)
```
## Example Usage

1. Type `/save` to save your current coordinates.
2. Type `/save timestamp` to toggle timestamp on or off.
3. Type `/save path coordinates.txt` to change the save path to `coordinates.txt`.

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.
