# Custom Tetris with Flutter

![Custom Tetris Logo](https://github.com/GuDevBot/games.custom-tetris/blob/main/assets/images/tetris.png)

A classic Tetris game project, built from scratch with the Flutter framework. This repository documents the development journey, from the core game logic to the implementation of features like audio and scoring.

---

## ✨ Key Features

* **Classic Gameplay:** Movement, rotation, and fitting of pieces (Tetrominoes).
* **Scoring System:** Earn points for landing pieces and get bonuses for clearing multiple lines at once.
* **Immersive Audio:** Continuous background music and sound effects for key actions, like clearing lines and landing pieces.
* **Intuitive Controls:** A user interface with buttons for movement, rotation, and accelerating the piece's fall ("soft drop").
* **Pause & Game Over:** Full functionality to pause/resume the game and a "Game Over" screen at the end.
* **Cross-Platform:** Developed to run on Android, Linux, and Web.

---

## 🚀 Getting Started

To run this project on your local machine, follow the steps below.

### Prerequisites

Before you begin, ensure you have the following installed:

* **Flutter SDK:** [Official installation guide](https://flutter.dev/docs/get-started/install)
* **Git:** To clone the repository.
* A code editor, such as **VS Code** or **Android Studio**.

### ⚙️ Installation and Setup

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/custom-tetris.git](https://github.com/your-username/custom-tetris.git)
    ```

2.  **Navigate to the project directory:**
    ```bash
    cd custom-tetris
    ```

3.  **Install the Flutter dependencies:**
    ```bash
    flutter pub get
    ```

### 🎮 Running the Application

#### For Windows, macOS, Android, and Web

After installing the dependencies, the project should run without any additional configuration.

```bash
# Flutter will show a list of connected devices.
# Choose your preferred device (e.g., Android, Chrome).
flutter run
```

#### Special Setup for Linux

The audio package (`audioplayers`) used in this project requires a system library called **GStreamer** to work on Linux. If you are on a Debian/Ubuntu-based distribution, install the necessary dependencies with the following command:

```bash
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good
```
After the installation, clean the Flutter build cache before running:
```bash
flutter clean
flutter run
```

---

## 🛠️ Tech Stack

* **[Flutter](https://flutter.dev/)**: The main framework for UI and logic development.
* **[Dart](https://dart.dev/)**: The programming language used.
* **[audioplayers](https://pub.dev/packages/audioplayers)**: A package for managing music and sound effects.
* **[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)**: Used to generate the app icons for Android and iOS.
