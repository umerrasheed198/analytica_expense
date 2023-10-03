# analytica_expense
## _Personal expense manager in flutter with firebase_

analytica_expense is a personal expense manager built in a flutter  with firebase as database,
It user firebase email pass auth for authentication and firestore as storage

## Features

- Easy interface
- Daily transaction list
- Monthaly transaction
- Analytics

## Tasks Completed
- User Authentication (Completed)
- Expense Tracking (Partial Completed i.e only adding is working)
- Expense Categories (Completed)
- Dashboard (UI Completed but data is not fetched for Expenses. Chart UI for daily expense is completed) On Dashboard, static data is rendered
- Data Storage (Completed)
- User Interface (Partial Completed i.e. weekly/monthly charts are not completed)
- Code Quality (Completed)
- Documentation (Completed)
## Tech
- Provider Pattern (For State Management)
- Firebase Auth (For Registration & Login)
- Firebase Firestore (For Data Storage)
- Flutter version 3.3.9 (Channel Stable)
- Dart Version 2.18.5
- Android compilesdkversion/targetsdkversion 33
- Android minSdkVersion 19

 
## Installation
analytica_expense requires [Flutter](https://flutter.dev/) v2.0+ to run.

follow this step for quick setup.

```sh
git clone https://github.com/umerrasheed198/analytica_expense.git
cd analytica_expense
flutter doctor
flutter pub get
flutter run
```

- For Firebase, Please setup Android/IOS app on your firebase console, then download google-service.json, and replace it in the project

## Plugins

analytica_expense is currently extended with the following plugins.
Instructions on how to use them in your own application are linked below.

| Plugin |
| ------|
  cupertino_icons: ^1.0.2|
  flutter_icons: ^1.1.0|
  page_transition: ^1.1.7+6|
  animated_bottom_navigation_bar: ^0.2.1||
  fl_chart: ^0.12.2|
  percent_indicator: "^2.1.7+2"||
  firebase_auth: ^1.0.3|
  cloud_firestore: ^1.0.4|
  provider: ^5.0.0|
  firebase_core: ^1.0.3 |
  date_time_picker: ^2.0.0|
  shared_preferences: ^2.0.5|
  firebase_storage: ^8.0.3|
  image_picker: ^0.7.4|
  image_cropper: ^1.4.0 | 
  cached_network_image: ^2.5.0|