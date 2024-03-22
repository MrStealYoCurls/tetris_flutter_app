# Flutter Tetris Game

Welcome to my Flutter Tetris game project! This README provides a detailed guide on setting up the development environment, understanding the architecture and functionality of each Dart script within the project, and how to get the game running on various devices. Whether you're a beginner in Flutter development or simply curious about how a Tetris game comes to life, you're in the right place.

## Table of Contents

- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
- [Project Structure](#project-structure)
- [Game Mechanics](#game-mechanics)
  - [main.dart](#maindart)
  - [game.dart](#gamedart)
  - [block.dart](#blockdart)
  - [next_block.dart](#next_blockdart)
  - [score_bar.dart](#score_bardart)
  - [sub_block.dart](#sub_blockdart)
- [Running the App](#running-the-app)
  - [Android](#android)
  - [iOS](#ios)
  - [Web](#web)
  - [Desktop](#desktop)
- [Dependencies](#dependencies)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Getting Started

### Prerequisites

Before diving into the world of Flutter and Dart, ensure you have the following installed:
- Flutter SDK
- Dart SDK (included with Flutter)
- Visual Studio Code (or any preferred IDE with Flutter support)
- Android Studio or Xcode (for Android or iOS emulation, respectively)

### Installation

1. **Install Flutter**: Follow the official guide at [Flutter Installation](https://flutter.dev/docs/get-started/install) to install Flutter and Dart on your system.

2. **Setup VS Code**: Download and install Visual Studio Code from [here](https://code.visualstudio.com/). Install the Flutter and Dart extension from the VS Code marketplace.

3. **Clone the Repository**:
   ```bash
   git clone https://your-repository-url.git
   cd flutter_tetris_game
   ```

4. **Install Dependencies**:
   Navigate to the project directory and run:
   ```bash
   flutter pub get
   ```

5. **Open and Run Project**: Open the project in VS Code. Use the provided emulation tools to run the app on your device or an emulator.

## Project Structure

Our Tetris game project is divided into six main Dart scripts, each serving a unique role:

- `main.dart`: Initializes the app and sets up the main game structure.
- `game.dart`: Contains the core game mechanics, including the game loop and block management.
- `block.dart`: Defines the block objects and their behaviors.
- `next_block.dart`: Manages the display of the next block.
- `score_bar.dart`: Displays the current score to the player.
- `sub_block.dart`: Represents the smallest unit of a block.

## Game Mechanics

### main.dart

This script is the entry point of the application. It sets up the Flutter environment and the main game widget.

### game.dart

This file is the heart of the Tetris game. It manages game state, block movements, collision detection, and the game loop.

#### Key Components:

- `Game`: The main game widget that initializes the game state and controls the flow of the game.
- `GameState`: Manages the game loop, including block movements, collisions, and score updates.

### block.dart

Defines different types of blocks used in the game and their rotations.

### next_block.dart

Handles the preview of the next block to be played.

### score_bar.dart

Displays the current game score.

### sub_block.dart

Represents the individual squares that make up a block.

## Running the App

### Android

1. Open an Android emulator.
2. Run `flutter run` in the terminal within the project directory.

### iOS

1. Open the iOS simulator (Xcode required).
2. Run `flutter run` in the terminal within the project directory.

### Web

1. Run `flutter run -d chrome` to launch the game in a Chrome browser.

### Desktop

Ensure desktop support is enabled in your Flutter SDK, then run `flutter run -d macos`, `flutter run -d windows`, or `flutter run -d linux` based on your operating system.

## Dependencies

This project uses the following packages:

- `provider`: For state management.
- `hexcolor`: To use hex color codes directly in Flutter.

To install these, ensure your `pubspec.yaml` includes:

```yaml
dependencies:
  flutter:
    sdk: flutter
    provider: ^5.0.0
    hexcolor: ^2.0.5
```

Run `flutter pub get` to install these dependencies.

## Troubleshooting

Encountering issues is a normal part of development. Here are some common problems and their potential solutions:

- **Flutter SDK Not Found**: Ensure Flutter is properly installed on your system. Re-run `flutter doctor` to verify your installation.

- **Dependencies Not Resolving**: Try running `flutter clean` and then `flutter pub get` again. Ensure your internet connection is stable.

- **Emulator Not Starting**: Verify that your Android Studio or Xcode is set up correctly. For Android, open AVD Manager and ensure an emulator is listed and functional. For iOS, check that Xcode can successfully start the iOS Simulator.

- **App Not Updating with Changes**: Make sure to save your files before running `flutter run`. Hot reload (saving your file in VS Code or pressing `r` in the terminal running the app) applies changes more seamlessly.

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.
