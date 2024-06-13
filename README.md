# TrollStore Auto Checker

A SwiftUI application to automatically check for TrollStore support based on the device's iOS version and architecture.

## Features

- Automatically fetches the device's iOS version and architecture.
- Displays whether TrollStore is supported for the given iOS version and architecture.
- Provides links to official websites and installation guides if supported.

## Installation

To run the TrollStore Checker app, you will need Xcode installed on your Mac. Follow the steps below to set up and run the app:

1. **Clone the repository:**

   ```sh
   git clone https://github.com/yourusername/TrollStoreChecker.git
   cd TrollStoreChecker
   ```

2. **Open the project in Xcode:**

   ```sh
   open TrollStoreChecker.xcodeproj
   ```

3. **Run the app:**

   Select your target device or simulator and click the `Run` button in Xcode.

## Usage

Once the app is running, it will:

1. Automatically fetch the device's iOS version and architecture.
2. Display the version type (fixed to "Release") and architecture (fixed to "arm64" or "arm64e").
3. Check for TrollStore support based on the fetched information.
4. Display the support status along with relevant links if TrollStore is supported.

## Support Data

The support data for TrollStore is defined within the app in the `trollStoreSupportData` array. This data includes the supported iOS versions, architectures, and relevant links for installation guides and official websites.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes or improvements.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Credits

- This app is inspired by the need to simplify the process of checking TrollStore support for iOS devices.

## Contact

For any questions or suggestions, feel free to contact me at [speedyfriend433@gmail.com](mailto:speedyfriend433@gmail.com).
