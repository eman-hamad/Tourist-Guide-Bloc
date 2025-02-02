# Tourist Guide

# Tourist Guide

Tourist Guide is a mobile application built using **Flutter and Bloc state management** that serves as a travel and tourism guide. The app allows users to explore various places, save their favorite spots, and interact with a variety of travel-related features. It leverages **Firebase Firestore** for real-time data storage, **Firebase Authentication** for secure user authentication, and **SharedPreferences** for local data storage. The app also uses various UI components to enhance user experience and Bloc to manage states, separating business logic from the UI, making the app more scalable, testable, and easier to maintain.

---

## Features

- **Theme Customization**: Toggle between dark and light modes to customize the visual experience. Dark mode is perfect for low-light environments, while light mode ensures clarity during the day. This app can also adapt to the device's system settings.
- **User Authentication**: Secure sign-up and login using **Firebase Authentication** to save user preferences, such as favorite places and profile images.
- **Real-Time Data Sync**: **Firebase Firestore** is used to store and sync user data, favorite places, and place details in real-time.
- **Place Details**: Browse through a list of places, view details, and add them to favorites. Favorite places are synced across devices using Firestore.
- **Custom Widgets**: Reusable and customizable widgets for a consistent and easy-to-use UI.
- **Data Persistence**: **SharedPreferences** are used for storing user data and preferences locally, while **Firestore** handles cloud-based data storage and synchronization.

---

## Tech Stack

- **Flutter**: For building a responsive UI.
- **Dart**: Programming language used for the app logic.
- **Bloc State Management**: State Management used for managing states and separating business logic from the UI.
- **Firebase Firestore**: Real-time NoSQL database for storing and syncing user data and place details.
- **Firebase Authentication**: Secure user authentication for sign-up and login.
- **SharedPreferences**: Local storage for saving user preferences.
- **Material Design**: UI components that follow Material Design guidelines for a consistent and modern design.

---

## Project Structure

### Bloc
- **Blocs**: Contains the **Bloc** (Business Logic Components) classes responsible for managing the application's state and handling business logic. Each **Bloc** listens to specific events and emits corresponding states.
- **Blocs**: Splash Bloc, Sign Up Bloc, Login Bloc, Settings Bloc, Profile Bloc, Edit Profile Bloc, Custom TextField Bloc, Data Blocs.

### Core

- **Colors**: Contains color constants used throughout the app.
- **Utils**: Handles interactions with **SharedPreferences** for storing and retrieving user data.

### Data

- **Models**: Defines data models such as `User`, `Place`, and others for easy data handling. Includes `FSUser`, `FSLandMark`, and `GovernorateModel` for Firestore integration.
- **Places**: Stores the list of places and other related data.
- **Firebase Services**: Contains services for interacting with Firebase Firestore and Authentication, including user sign-up, login, and data retrieval.

### UI

- **Widgets**: Custom widgets used throughout the app for consistency and reusability.
- **Screens**: Various screens in the app such as the login screen, place details screen, and home screen.

---

## Firebase Integration

### Authentication
- **Sign Up**: Users can create an account using their email and password. The app uses **Firebase Authentication** to securely handle user registration.
- **Login**: Users can log in using their registered email and password. Firebase Authentication ensures secure login and session management.
- **Password Reset**: Users can reset their password via email using Firebase's password reset functionality.

### Firestore
- **User Data Storage**: User data, including profile information and favorite places, is stored in **Firestore**. This allows for real-time synchronization across devices.
- **Places Data**: Information about tourist places, including images, descriptions, and ratings, is stored in Firestore. Users can browse and favorite these places.
- **Favorite Places**: Users can add or remove places from their favorites list, which is stored in Firestore and synced across all their devices.

### Real-Time Updates
- **Favorite Places Sync**: When a user adds or removes a place from their favorites, the change is immediately reflected in Firestore and synced across all devices.
- **User Profile Updates**: Any changes to the user's profile, such as updating their name or phone number, are saved in Firestore and updated in real-time.

---

## Getting Started

To get started with the Tourist Guide app, follow these steps:

1. **Clone the Repository**: Clone this repository to your local machine.
2. **Set Up Firebase**: 
   - Create a Firebase project on the [Firebase Console](https://console.firebase.google.com/).
   - Add an Android/iOS app to your Firebase project and follow the setup instructions.
   - Download the `google-services.json` file for Android or `GoogleService-Info.plist` for iOS and place it in the appropriate directory in your Flutter project.
3. **Install Dependencies**: Run `flutter pub get` to install all the required dependencies.
4. **Run the App**: Use `flutter run` to launch the app on your preferred device or emulator.

---

## Screenshots
<p align="center"><img src="https://github.com/user-attachments/assets/27ba7229-4c78-4ba3-8e98-55e5916f8a06"  alt="Splash" height="844" width="431.38"/></p>
<p align="center"><img src="https://github.com/user-attachments/assets/fbb072f4-3c14-481c-a2a1-f68042de7693"  alt="Login" height="844" width="431.38"/></p>
<p align="center"><img src="https://github.com/user-attachments/assets/55756cd4-b2a3-4c75-ab63-6facc1752bb2"  alt="Register" height="844" width="431.38"/></p>
<p align="center"><img src="https://github.com/user-attachments/assets/02476f3f-eb5a-49d2-ae56-404e17e1f946"  alt="Places" height="844" width="431.38"/></p>
<p align="center"><img src="https://github.com/user-attachments/assets/0862f83b-793f-40a9-aaf6-08e905f758de"  alt="governorate" height="844" width="431.38"/></p>
<p align="center"><img src="https://github.com/user-attachments/assets/af692d8c-9ad4-4f21-adee-40f464764b86"  alt="Landmarks" height="844" width="431.38"/></p>
<p align="center"><img src="https://github.com/user-attachments/assets/dd358aec-562e-48e6-85d3-dfdba8bdd09c"  alt="Favorits" height="844" width="431.38"/></p>
<p align="center"><img src="https://github.com/user-attachments/assets/75cc9435-010a-40a7-ac16-db5e8302d786"  alt="Details" height="844" width="431.38"/></p>
<p align="center"><img src="https://github.com/user-attachments/assets/c3d63556-1feb-40af-9333-33968bf70f8c"  alt="Profile" height="844" width="431.38"/></p>
<p align="center"><img src="https://github.com/user-attachments/assets/3d8d7c27-9d62-4ce8-816e-9e4d3de9e65d"  alt="Update Profile" height="844" width="431.38"/></p>

## Video

https://drive.google.com/file/d/1udWxTailp22-omFE5E2vPd4n5jx8x206/view?usp=sharing
