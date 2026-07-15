# Flutter E-Commerce App — Developer Guide(Still Dev)

## Overview

Enterprise e-commerce Flutter app using **Riverpod** state management, **GoRouter** navigation, and **Dio** networking. Features a full design token system with light/dark mode, 11 feature modules, and 20+ screens.

---

## Screenshots
(IPhone - 16 Pro)
| Home | Search | Wishlist | Profile |
|:---:|:---:|:---:|:---:|
| ![Home](screenshots/home.png) | ![Search](screenshots/search.png) | ![Wishlist](screenshots/wishlist.png) | ![Profile](screenshots/profile.png) |

| Login | Register | Forgot Password | Reset Sent | Notifications |
|:---:|:---:|:---:|:---:|:---:|
| ![Login](screenshots/login.png) | ![Register](screenshots/register.png) | ![Forgot](screenshots/forgot.png) | ![Reset Sent](screenshots/forgot_sent.png) | ![Notifications](screenshots/notification.png) |

| Settings | Addresses | Edit Profile |
|:---:|:---:|:---:|
| ![Settings](screenshots/settings.png) | ![Addresses](screenshots/address.png) | ![Edit Profile](screenshots/edit.png) |

| Product Grid | Product List | Product Detail | Orders |
|:---:|:---:|:---:|:---:|
| ![Product Grid](screenshots/product_grid.png) | ![Product List](screenshots/product_list.png) | ![Product Detail](screenshots/product_details.png) | ![Orders](screenshots/orders.png) |

| Cart (filled) | Cart (empty) |
|:---:|:---:|
| ![Cart](screenshots/shopping_cart.png) | ![Cart Empty](screenshots/shopping_cart_empty.png) |

**Tablet**
| Home | Login | Register | Forgot | Profile |
|:---:|:---:|:---:|:---:|:---:|
| ![Home Tablet](screenshots/home_tablet.png) | ![Login Tablet](screenshots/login_tablet.png) | ![Register Tablet](screenshots/register_tablet.png) | ![Forgot Tablet](screenshots/forgot_tablet.png) | ![Profile Tablet](screenshots/profile_tablet.png) |

| Product Grid | Product List | Product Detail | Wishlist | Edit Profile |
|:---:|:---:|:---:|:---:|:---:|
| ![Grid Tablet](screenshots/product_grid_tablet.png) | ![List Tablet](screenshots/product_list_tablet.png) | ![Detail Tablet](screenshots/product_detail_tablet.png) | ![Wishlist Tablet](screenshots/wishlist_tablet.png) | ![Edit Tablet](screenshots/edit_profile_tablet.png) |

| Cart (filled) | Cart (empty) | Orders |
|:---:|:---:|:---:|
| ![Cart Tablet](screenshots/cart_tablet.png) | ![Cart Empty Tablet](screenshots/cart_tablet_empty.png) | ![Orders Tablet](screenshots/order_tablet.png) |

---

## Architecture

```
lib/
├── main.dart                          # Entry point
├── core/
│   ├── config/                        # Environment config, feature flags, constants
│   ├── di/                            # GetIt DI (minimal — uses Riverpod)
│   ├── errors/                        # Failure hierarchy (7 classes)
│   ├── network/                       # Dio setup, API client, connectivity
│   ├── providers/                     # ALL Riverpod providers + notifiers + states
│   ├── router/                        # GoRouter (20+ routes)
│   ├── storage/                       # Hive, SharedPreferences, SecureStorage
│   └── theme/                         # Design tokens + ThemeData builder
├── features/                          # 11 feature modules
│   └── {feature}/presentation/pages/  # One page file per screen
└── shared/
    ├── models/                        # ~40 domain model classes
    └── widgets/                       # Reusable UI components + bottom nav shell
```

---

## Getting Started

### Prerequisites
- Flutter SDK >=3.3.0
- Dart >=3.3.0

### Setup
```bash
cd flutter_ecommerce
dart pub get
flutter create . --platforms=android,ios,web  # Generate platform dirs
flutter run
```

---

## State Management (Riverpod)

### Provider Hierarchy

| Provider | Type | Notifier | State |
|---|---|---|---|
| `authStateProvider` | StateNotifier | `AuthNotifier` | `AuthState` |
| `cartProvider` | StateNotifier | `CartNotifier` | `CartState` |
| `wishlistProvider` | StateNotifier | `WishlistNotifier` | `WishlistState` |
| `productsProvider` | StateNotifier | `ProductsNotifier` | `ProductsState` |
| `categoriesProvider` | StateNotifier | `CategoriesNotifier` | `CategoriesState` |
| `searchProvider` | StateNotifier | `SearchNotifier` | `SearchState` |
| `ordersProvider` | StateNotifier | `OrdersNotifier` | `OrdersState` |
| `addressesProvider` | StateNotifier | `AddressesNotifier` | `AddressesState` |
| `paymentMethodsProvider` | StateNotifier | `PaymentMethodsNotifier` | `PaymentMethodsState` |
| `notificationsProvider` | StateNotifier | `NotificationsNotifier` | `NotificationsState` |
| `themeModeProvider` | StateNotifier | `ThemeModeNotifier` | `ThemeMode` |
| `languageProvider` | StateNotifier | `LanguageNotifier` | `Locale` |
| `currencyProvider` | StateNotifier | `CurrencyNotifier` | `String` |

### Derived Providers
- `currentUserProvider` — `UserProfile?` from `authStateProvider`
- `isLoggedInProvider` — `bool` from `authStateProvider.isAuthenticated`
- `cartItemCountProvider` — `int` from `cartProvider.itemCount`
- `cartTotalProvider` — `double` from `cartProvider.total`
- `wishlistCountProvider` — `int` from `wishlistProvider.count`
- `unreadNotificationsCountProvider` — `int` from `notificationsProvider.unreadCount`

### Usage Pattern
```dart
// Read
final user = ref.watch(currentUserProvider);
final cartCount = ref.watch(cartItemCountProvider);

// Listen
ref.listen(authStateProvider, (prev, next) {
  if (next.isAuthenticated) context.go('/');
});

// Mutate
ref.read(cartProvider.notifier).addItem(AddToCartRequest(productId: '123', quantity: 1));
```

---

## Navigation (GoRouter)

### Route Structure

**Shell Routes** (with bottom navigation)
| Path | Page | Tab |
|---|---|---|
| `/` | HomePage | Home |
| `/search` | SearchPage | Search |
| `/cart` | CartPage | Cart |
| `/orders` | OrdersPage | Orders |
| `/profile` | ProfilePage | Profile |

**Nested under `/`**
| Path | Page | Params |
|---|---|---|
| `/category/:id` | CategoryPage | `id` path |
| `/products` | ProductListPage | `category_id`, `search` query |
| `/product/:id` | ProductDetailPage | `id` path |

**Nested under `/cart`**
| Path | Page |
|---|---|
| `/cart/checkout` | CheckoutPage |

**Nested under `/profile`**
| Path | Page |
|---|---|
| `/profile/edit` | EditProfilePage |
| `/profile/addresses` | AddressesPage |
| `/profile/payment-methods` | PaymentMethodsPage |
| `/profile/wishlist` | WishlistPage |
| `/profile/settings` | SettingsPage |
| `/profile/notifications` | NotificationsPage |

**Auth Routes** (no bottom nav)
| Path | Page |
|---|---|
| `/login` | LoginPage |
| `/register` | RegisterPage |
| `/forgot-password` | ForgotPasswordPage |
| `/verify-email` | VerifyEmailPage |

### Navigation Methods
```dart
context.go('/');                    // Push named route
context.push('/product/123');       // Push to stack
context.push('/products?category_id=cat_1&search=shoes');
context.pop();                      // Go back
```

---

## Theme System

### Design Tokens (in `core/theme/app_theme.dart`)

| Class | Purpose | Key Constants |
|---|---|---|
| `AppColors` | 45+ color constants | Brand primary/secondary/accent, surface, text, border, semantic |
| `AppSpacing` | 4px base scale | xs(4) sm(8) md(16) lg(24) xl(32) xxl(48) xxxl(64) |
| `AppRadius` | Border radius | xs(4) sm(8) md(12) lg(16) xl(24) full(9999) |
| `AppSizes` | Component sizes | xs(24) sm(32) md(40) lg(48) xl(56) xxl(64) |
| `AppTypography` | Inter font | 10 sizes × 4 weights |
| `AppShadows` | Elevation | 5 levels |

### ThemeData
```dart
ThemeData light = AppTheme.light();
ThemeData dark  = AppTheme.dark();
```

### Custom Extensions (via `BuildContext`)
```dart
context.customSpacing   // Access spacing tokens
context.customRadius    // Access border radius
context.customSizes     // Access size tokens
context.customShadows   // Access shadow tokens
context.customColors    // Access semantic colors
context.customTextStyles // Access text styles
```

### Usage
```dart
Padding(
  padding: EdgeInsets.all(context.customSpacing.lg),
  child: Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(context.customRadius.md),
      boxShadow: context.customShadows.sm,
    ),
  ),
)
```

---

## API Client

### Base Configuration
- **Base URL**: Defaults to `https://ecommerceship_fast.api` (dev) (still developing not real api)
- **Timeouts**: 30s connect, 30s receive, 30s send
- **Interceptors**: Auth (Bearer token), Logging (debug), Error Handling, Retry (3x max)

### Response Wrapper
```dart
sealed class Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ApiFailure<T>;
  T? get data => ...;
  Failure? get error => ...;
}
```

### Usage
```dart
final result = await apiClient.login(LoginRequest(email: e, password: p));
result.onSuccess((auth) => print('Logged in as ${auth.user.fullName}'));
result.onFailure((err) => showError(err.message));
```

---

## Storage Layer

| Class | Backend | Purpose |
|---|---|---|
| `SecureStorage` | `FlutterSecureStorage` | Auth tokens (access/refresh) |
| `PreferencesStorage` | `SharedPreferences` | User preferences (theme, language, currency, notification settings) |
| `HiveStorage` | `Hive` | Offline cache (products, categories, cart, wishlist, orders, addresses, search history, recently viewed) |

---

## Domain Models (`shared/models/models.dart`)

| Category | Models |
|---|---|
| **Auth** | `UserProfile`, `AuthResponse`, `AuthTokens`, `LoginRequest`, `RegisterRequest`, `ForgotPasswordRequest`, `ResetPasswordRequest`, `VerifyEmailRequest`, `UpdateProfileRequest`, `ChangePasswordRequest` |
| **Products** | `Product`, `ProductVariant`, `Review`, `CreateReviewRequest` |
| **Categories** | `Category` |
| **Cart** | `CartItem`, `Cart`, `Coupon`, `AddToCartRequest`, `UpdateCartItemRequest`, `ApplyCouponRequest` |
| **Orders** | `Order`, `OrderTracking`, `TrackingEvent`, `ReturnRequest`, `CreateReturnRequest`, `CheckoutRequest`, `CheckoutValidation`, `CreateOrderRequest` |
| **Payments** | `PaymentIntent`, `PaymentConfirmation`, `PaymentMethod`, `AddPaymentMethodRequest`, `ConfirmPaymentRequest`, `CreatePaymentIntentRequest` |
| **Addresses** | `Address`, `CreateAddressRequest`, `UpdateAddressRequest` |
| **Wishlist** | `Wishlist`, `WishlistItem`, `AddToWishlistRequest` |
| **Search** | `SearchResults`, `SearchFilters` |
| **Notifications** | `AppNotification` |
| **Settings** | `AppSettings`, `ShippingOption`, `AppCurrency`, `AvailablePaymentMethod` |
| **Pagination** | `PaginationMeta`, `PaginatedResponse<T>` |

---

## Shared Widgets

| Component | File | Props | Description |
|---|---|---|---|
| `PrimaryButton` | ui_components | `label`, `onPressed`, `isLoading`, `size`, `icon`, `isFullWidth` | Filled button, 5 sizes |
| `SecondaryButton` | ui_components | Same as Primary | Outlined button |
| `GhostButton` | ui_components | `label`, `onPressed`, `textColor` | Text-only button |
| `DestructiveButton` | ui_components | Same as Primary | Red error button |
| `AppIconButton` | ui_components | `icon`, `onPressed`, `variant`, `size`, `tooltip` | 4 style variants |
| `AppTextField` | ui_components | `controller`, `label`, `hint`, `prefixIcon`, `validator`, `maxLines` | Full-featured form field |
| `EmptyState` | ui_components | `icon`, `title`, `subtitle`, `actionLabel`, `onAction` | Empty state placeholder |
| `LoadingOverlay` | ui_components | `isLoading`, `child`, `message` | Full-screen loading overlay |
| `ErrorView` | ui_components | `message`, `onRetry` | Error state with retry |
| `MainScaffold` | main_scaffold | `child`, `showBottomNav` | Bottom nav shell |

---

## Environment Configuration

Edit environment via `--dart-define`:
```bash
flutter run --dart-define=ENVIRONMENT=production
```

| Config | File | Dev | Staging | Production |
|---|---|---|---|---|
| API Base URL | `app_config.dart` | `api-dev.example.com` | `api-staging.example.com` | `api.example.com` |
| Logging | `app_config.dart` | Enabled | Enabled | Disabled |
| Analytics | `app_config.dart` | Disabled | Enabled | Enabled |
| Timeouts | `app_config.dart` | 30s | 20s | 15s |

---

## Feature Pages Summary

| Page | Features |
|---|---|
| **Home** | Categories grid, flash sale countdown, new arrivals, best sellers — animated entry |
| **Login** | Form validation, social login buttons, remember-me → calls `authStateProvider` |
| **Register** | Full name, email, password strength indicator, terms acceptance |
| **Product List** | Grid/list toggle, sort bottom sheet, filter sheet, infinite scroll |
| **Product Detail** | Image gallery, variant selector, quantity stepper, specs table, reviews |
| **Cart** | Item quantity adjust, swipe/delete, promo code, order summary → connected to `cartProvider` |
| **Checkout** | 4-step wizard: Address → Shipping → Payment → Review |
| **Orders** | Status filter chips, order cards with contextual actions |
| **Profile** | User stats, menu list, sign out → connected to `authStateProvider` |
| **Search** | Debounced search, suggestions, recent history, popular categories |
| **Settings** | Theme/language/currency selectors, notification toggles, cache management |
| **Addresses** | Address cards, add/edit form, set default, delete confirmation |
| **Payment Methods** | Card list with brand icons, add card form with live preview |

---

## Current Demo Behavior

All notifiers return **mock data** with realistic delays (300-800ms) for demonstration. No backend API required.

### Demo login
- Accepts any email/password
- Sets mock user (`John Doe`)
- Navigates to home

### Demo data flow
- Products: 20 mock products with images from picsum.photos
- Cart: 3 pre-populated items, coupon code support
- Orders: 4 orders with different statuses
- Addresses: 3 addresses
- Payment methods: Visa/Mastercard/PayPal
- Notifications: 5 notifications

---

## Next Steps / Production Readiness
(Have Still Developing parts)
1. **Replace mock data** in notifiers (`core_providers.dart`) with real API calls through `ApiClient` 
2. **Add auth redirect** in `app_router.dart` using `isLoggedInProvider`
3. **Generate platform dirs**: `flutter create . --platforms=android,ios,web`
4. **Run build_runner** for code generation: `dart run build_runner build`
5. **Add tests** in `test/` directory (currently empty)
6. **Configure Firebase** for push notifications
7. **Set up CI/CD** with environment-specific builds
