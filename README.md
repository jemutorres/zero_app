# Zero

## Setup for Development

### Get prerequisites
- **Flutter SDK**:
  1. Download the following installation bundle to get the latest stable release of the Flutter SDK:
  	  > cd ~ && mkdir development
      > wget https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_v1.0.0-stable.tar.xz
  2. Extract the file in the desired location, for example::
      > tar xf ~/development/flutter_linux_v1.0.0-stable.tar.xz
  2. Add the flutter tool to your path:
	  > echo "export PATH=\"\$PATH:$HOME/development/flutter/bin\"" >> ~/.bashrc
	  > source ~/.bashrc

- Run flutter doctor:
  1. Run the following command to see if there are any dependencies you need to install to complete the setup (for verbose output, add the -v flag):
      > flutter doctor

- Install Android Studio:
  1. [Download and install Android Studio](https://developer.android.com/studio).
  2. Start Android Studio, and go through the ‘Android Studio Setup Wizard’. This installs the latest Android SDK, Android SDK Platform-Tools, and Android SDK Build-Tools, which are required by Flutter when developing for Android.

- Install the Flutter and Dart plugins
  1. Start Android Studio.
  2. Open plugin preferences (Preferences > Plugins on macOS, File > Settings > Plugins on Windows & Linux).
  3. Select Browse repositories, select the Flutter plugin and click Install.
  4. Click Yes when prompted to install the Dart plugin.
  5. Click Restart when prompted.
  6. Add Flutter SDK path

- Add Flutter SDK path on Android Studio
  1. Start Android Studio.
  2. Open plugin preferences (Preferences > Languages & Frameworks on macOS, File > Settings > Languages & Frameworks on Windows & Linux).
  3. Select the Flutter and set the flutter SDK path.
  4. Click Ok.

### Set up your Android device
- To prepare to run and test your Flutter app on an Android device, you’ll need an Android device running Android 4.1 (API level 16) or higher.
  1. Enable Developer options and USB debugging on your device.
  2. Windows-only: Install the Google USB Driver
  3. Using a USB cable, plug your phone into your computer. If prompted on your device, authorize your computer to access your device.
  4. In the terminal, run the flutter devices command to verify that Flutter recognizes your connected Android device.
- By default, Flutter uses the version of the Android SDK where your adb tool is based. If you want Flutter to use a different installation of the Android SDK, you must set the ANDROID_HOME environment variable to that installation directory.

- Install adb:
      > sudo apt install adb

### Set up your Android device
- To prepare to run and test your Flutter app on the Android emulator, follow these steps:
  1. Enable VM acceleration on your machine.
  2. Launch Android Studio > Tools > Android > AVD Manager and select Create Virtual Device. (The Android submenu is only present when inside an Android project.)
  3. Choose a device definition and select Next.
  4. Select one or more system images for the Android versions you want to emulate, and select Next. An x86 or x86_64 image is recommended.
  5. Under Emulated Performance, select Hardware - GLES 2.0 to enable hardware acceleration.
  6. Verify the AVD configuration is correct, and select Finish. For details on the above steps, see Managing AVDs.
  7. In Android Virtual Device Manager, click Run in the toolbar. The emulator starts up and displays the default canvas for your selected OS version and device.

