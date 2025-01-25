# Tourist Guide

Tourist Guide is a mobile application built using **Flutter and Bloc state management** that serves as a travel and tourism guide. The app allows users to explore various places, save their favorite spots, and interact with a variety of travel-related features. It leverages **SharedPreferences** for local data storage, and various UI components to enhance user experience  and bloc to manage states .It separates business logic from the UI, making the app more scalable, testable, and easier to maintain.

---

## Features

- **Theme Customization**: Toggle between dark and light modes to customize the visual experience. Dark mode is perfect for low-light environments, while light mode ensures clarity during the day. This app can also adapt to device's system settings.
- **User Authentication**: Sign up and login to save your preferences, such as favorite places and profile images.
- **Place Details**: Browse through a list of places, view details, and add them to favorites.
- **Custom Widgets**: Reusable and customizable widgets for a consistent and easy-to-use UI.
- **Data Persistence**: SharedPreferences are used for storing user data and preferences locally.

---

## Tech Stack

- **Flutter**: For building a responsive UI.
- **Dart**: Programming language used for the app logic.
- **Bloc State Management**: State Management used for to managing states and separating business logic from the UI.
- **SharedPreferences**: Local storage for saving user preferences.
- **Material Design**: UI components that follow Material Design guidelines for a consistent and modern design.

---

## Project Structure

### Bloc
- **Blocs**:  Contains the **Bloc** (Business Logic Components) classes responsible for managing the application's state and handling business logic, each **Bloc** listens to specific events and emits corresponding states. 
- **Blocs**: Splash Bloc , Sign Up Bloc , Login Bloc , Settings BlocBloc , Profile Bloc , Edit Profile Bloc , Custom TextField Bloc , Data Blocs

### Core

- **Colors**: Contains color constants used throughout the app.
- **Utils**: Handles interactions with **SharedPreferences** for storing and retrieving user data.

### Data

- **Models**: Defines data models such as `User`, `Place`, and others for easy data handling.
- **Places**: Stores the list of places and other related data.

### UI

- **Widgets**: Custom widgets that used throughout the app for consistency and reusability.
- **Screens**: Various screens in the app such as the login screen, place details screen, and home screen.

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
