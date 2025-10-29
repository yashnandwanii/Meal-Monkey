# Meal Monkey – Food Delivery App

Meal Monkey is a cross-platform food delivery application built with Flutter. It provides users with a seamless experience to browse restaurants, view menus, place orders, track deliveries, and manage their profiles.

## Features

- User authentication (email, phone OTP, Google Sign-In)
- Restaurant and menu browsing
- Cart and order management
- Location-based recommendations (uses geolocator and Google Maps)
- Coupon and discount system
- Payment integration (Razorpay)
- Order tracking and notifications
- Beautiful UI with custom fonts and animations (Lottie)
- Persistent storage (get_storage, shared_preferences)

## Project Structure

```
lib/
  main.dart                # App entry point
  firebase_options.dart    # Firebase config
  common/                  # Shared widgets, styles, constants
  controllers/             # State management (GetX)
  models/                  # Data models (e.g., CouponResponse)
  services/                # API, auth, payment, location
  view/                    # UI screens (auth, menu, cart, profile, etc.)
  routes/                  # App navigation
  utils/                   # Helpers and utilities
assets/
  iimg/                    # Images and icons
  fonts/                   # Custom fonts (Metropolis, Poppins)
  *.json                   # Lottie animations
android/, ios/             # Platform-specific code and configs
test/                      # Widget and unit tests
```

## Getting Started

1. **Install Flutter**: [Flutter Setup Guide](https://docs.flutter.dev/get-started/install)
2. **Clone the repository**:
   ```sh
   git clone <repo-url>
   cd Meal-Monkey-main
   ```
3. **Install dependencies**:
   ```sh
   flutter pub get
   ```
4. **Configure Firebase**:
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the respective folders.
5. **Run the app**:
   ```sh
   flutter run
   ```

## Dependencies

Key packages used:
- `get`, `get_storage` – State management and local storage
- `firebase_core`, `firebase_auth` – Firebase integration
- `google_sign_in`, `google_maps_flutter`, `geolocator` – Location and maps
- `razorpay_flutter`, `fluttertoast` – Payments and notifications
- `lottie`, `shimmer`, `cached_network_image` – UI enhancements

See `pubspec.yaml` for the full list.

## Contribution

Pull requests are welcome! For major changes, please open an issue first to discuss what you would like to change.

## License

This project is for educational/demo purposes. Please check with the repository owner for licensing details.

## Related repositories

This project is part of the Meal Monkey workspace. If you want to explore other repositories used in this project, here are the main ones:

- Delivery Partner App (backend + mobile): https://github.com/yashnandwanii/Delivery-Partner-App
- Meal Monkey Backend (API server): https://github.com/yashnandwanii/Meal-Monkey-Backend
- Restaurant Owner App (Flutter): https://github.com/yashnandwanii/Restaurent-App

If you need direct links to specific folders or help cloning any of these repositories, tell me which one and I can clone or open them for you.
