// Shared Models - All domain models used across the app


// ==================== AUTH MODELS ====================

class UserProfile {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? phone;
  final String? avatarUrl;
  final bool emailVerified;
  final DateTime createdAt;

  UserProfile({
    required this.id,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.phone,
    this.avatarUrl,
    this.emailVerified = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get fullName => '$firstName $lastName';

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        id: json['id']?.toString() ?? '',
        email: json['email'] ?? '',
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        phone: json['phone'],
        avatarUrl: json['avatar_url'],
        emailVerified: json['email_verified'] ?? false,
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'avatar_url': avatarUrl,
        'email_verified': emailVerified,
      };
}

class AuthResponse {
  final UserProfile user;
  final AuthTokens tokens;

  AuthResponse({required this.user, required this.tokens});

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        user: UserProfile.fromJson(json['user']),
        tokens: AuthTokens.fromJson(json['tokens'] ?? json),
      );
}

class AuthTokens {
  final String accessToken;
  final String refreshToken;

  AuthTokens({required this.accessToken, required this.refreshToken});

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
        accessToken: json['access_token'] ?? json['accessToken'] ?? '',
        refreshToken: json['refresh_token'] ?? json['refreshToken'] ?? '',
      );
}

class TokenResponse {
  final String accessToken;
  final String? refreshToken;

  TokenResponse({required this.accessToken, this.refreshToken});

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        accessToken: json['access_token'] ?? json['accessToken'] ?? '',
        refreshToken: json['refresh_token'] ?? json['refreshToken'],
      );
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RegisterRequest {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  RegisterRequest({required this.email, required this.password, required this.firstName, required this.lastName});

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      };
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => {'refresh_token': refreshToken};
}

class ForgotPasswordRequest {
  final String email;

  ForgotPasswordRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class ResetPasswordRequest {
  final String token;
  final String password;

  ResetPasswordRequest({required this.token, required this.password});

  Map<String, dynamic> toJson() => {'token': token, 'password': password};
}

class VerifyEmailRequest {
  final String token;

  VerifyEmailRequest({required this.token});

  Map<String, dynamic> toJson() => {'token': token};
}

class UpdateProfileRequest {
  final String? firstName;
  final String? lastName;
  final String? phone;

  UpdateProfileRequest({this.firstName, this.lastName, this.phone});

  Map<String, dynamic> toJson() => {
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (phone != null) 'phone': phone,
      };
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequest({required this.currentPassword, required this.newPassword});

  Map<String, dynamic> toJson() => {
        'current_password': currentPassword,
        'new_password': newPassword,
      };
}

// ==================== PRODUCT MODELS ====================

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final List<String> images;
  final double rating;
  final int reviewCount;
  final String? categoryId;
  final String? categoryName;
  final String? brand;
  final bool inStock;
  final int stockQuantity;
  final List<ProductVariant> variants;
  final List<String> features;
  final Map<String, String> specs;
  final String? sku;
  final String? currency;
  final int discountPercent;

  Product({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.originalPrice,
    this.images = const [],
    this.rating = 0,
    this.reviewCount = 0,
    this.categoryId,
    this.categoryName,
    this.brand,
    this.inStock = true,
    this.stockQuantity = 0,
    this.variants = const [],
    this.features = const [],
    this.specs = const {},
    this.sku,
    this.currency = 'USD',
    this.discountPercent = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? json['title'] ?? '',
        description: json['description'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        originalPrice: json['original_price']?.toDouble() ?? json['originalPrice']?.toDouble(),
        images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
        rating: (json['rating'] ?? 0).toDouble(),
        reviewCount: json['review_count'] ?? json['reviews'] ?? 0,
        categoryId: json['category_id']?.toString(),
        categoryName: json['category_name'],
        brand: json['brand'],
        inStock: json['in_stock'] ?? json['inStock'] ?? true,
        stockQuantity: json['stock_quantity'] ?? json['stock'] ?? 0,
        variants: (json['variants'] as List?)?.map((e) => ProductVariant.fromJson(e)).toList() ?? [],
        features: (json['features'] as List?)?.map((e) => e.toString()).toList() ?? [],
        specs: json['specs'] != null ? Map<String, String>.from(json['specs']) : {},
        sku: json['sku'],
        currency: json['currency'] ?? 'USD',
        discountPercent: json['discount_percent'] ?? json['discountPercent'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'price': price,
        'original_price': originalPrice,
        'images': images,
        'rating': rating,
        'review_count': reviewCount,
        'category_id': categoryId,
        'category_name': categoryName,
        'brand': brand,
        'in_stock': inStock,
        'stock_quantity': stockQuantity,
        'sku': sku,
        'currency': currency,
      };
}

class ProductVariant {
  final String id;
  final String name;
  final int? color;
  final int stock;

  ProductVariant({required this.id, required this.name, this.color, this.stock = 0});

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        color: json['color'] is int ? json['color'] : null,
        stock: json['stock'] ?? 0,
      );
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final List<String> images;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    this.userName = '',
    this.rating = 5,
    this.comment = '',
    this.images = const [],
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id']?.toString() ?? '',
        userId: json['user_id']?.toString() ?? '',
        userName: json['user_name'] ?? '',
        rating: (json['rating'] ?? 5).toDouble(),
        comment: json['comment'] ?? '',
        images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      );
}

class CreateReviewRequest {
  final double rating;
  final String comment;
  final List<String> images;

  CreateReviewRequest({required this.rating, this.comment = '', this.images = const []});

  Map<String, dynamic> toJson() => {
        'rating': rating,
        'comment': comment,
        if (images.isNotEmpty) 'images': images,
      };
}

// ==================== CATEGORY MODELS ====================

class Category {
  final String id;
  final String name;
  final String? imageUrl;
  final String? parentId;
  final int productCount;
  final int sortOrder;

  Category({
    required this.id,
    required this.name,
    this.imageUrl,
    this.parentId,
    this.productCount = 0,
    this.sortOrder = 0,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        imageUrl: json['image_url'],
        parentId: json['parent_id']?.toString(),
        productCount: json['product_count'] ?? json['products_count'] ?? 0,
        sortOrder: json['sort_order'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_url': imageUrl,
        'parent_id': parentId,
        'product_count': productCount,
      };
}

// ==================== CART MODELS ====================

class CartItem {
  final String id;
  final String productId;
  final String name;
  final String? imageUrl;
  final double price;
  final double? originalPrice;
  int quantity;
  final String? variantName;
  final String? sku;

  CartItem({
    required this.id,
    required this.productId,
    this.name = '',
    this.imageUrl,
    this.price = 0,
    this.originalPrice,
    this.quantity = 1,
    this.variantName,
    this.sku,
  });

  double get total => price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id']?.toString() ?? '',
        productId: json['product_id']?.toString() ?? '',
        name: json['name'] ?? '',
        imageUrl: json['image_url'],
        price: (json['price'] ?? 0).toDouble(),
        originalPrice: json['original_price']?.toDouble(),
        quantity: json['quantity'] ?? 1,
        variantName: json['variant_name'],
        sku: json['sku'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'product_id': productId,
        'name': name,
        'image_url': imageUrl,
        'price': price,
        'original_price': originalPrice,
        'quantity': quantity,
        'variant_name': variantName,
        'sku': sku,
      };
}

class Cart {
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double shipping;
  final double discount;
  final double total;
  final Coupon? appliedCoupon;

  Cart({
    this.items = const [],
    this.subtotal = 0,
    this.tax = 0,
    this.shipping = 0,
    this.discount = 0,
    this.total = 0,
    this.appliedCoupon,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        items: (json['items'] as List?)?.map((e) => CartItem.fromJson(e)).toList() ?? [],
        subtotal: (json['subtotal'] ?? 0).toDouble(),
        tax: (json['tax'] ?? 0).toDouble(),
        shipping: (json['shipping'] ?? 0).toDouble(),
        discount: (json['discount'] ?? 0).toDouble(),
        total: (json['total'] ?? 0).toDouble(),
        appliedCoupon: json['coupon'] != null ? Coupon.fromJson(json['coupon']) : null,
      );
}

class Coupon {
  final String code;
  final double discountPercent;
  final double? maxDiscount;

  Coupon({required this.code, this.discountPercent = 0, this.maxDiscount});

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        code: json['code'] ?? '',
        discountPercent: (json['discount_percent'] ?? 0).toDouble(),
        maxDiscount: json['max_discount']?.toDouble(),
      );
}

class AddToCartRequest {
  final String productId;
  final int quantity;
  final String? variantName;

  AddToCartRequest({required this.productId, this.quantity = 1, this.variantName});

  Map<String, dynamic> toJson() => {
        'product_id': productId,
        'quantity': quantity,
        if (variantName != null) 'variant_name': variantName,
      };
}

class UpdateCartItemRequest {
  final int quantity;

  UpdateCartItemRequest({required this.quantity});

  Map<String, dynamic> toJson() => {'quantity': quantity};
}

class ApplyCouponRequest {
  final String code;

  ApplyCouponRequest({required this.code});

  Map<String, dynamic> toJson() => {'code': code};
}

// ==================== CHECKOUT / ORDER MODELS ====================

class CheckoutRequest {
  final String addressId;
  final String paymentMethodId;
  final String? note;

  CheckoutRequest({required this.addressId, required this.paymentMethodId, this.note});

  Map<String, dynamic> toJson() => {
        'address_id': addressId,
        'payment_method_id': paymentMethodId,
        if (note != null) 'note': note,
      };
}

class CheckoutValidation {
  final bool isValid;
  final List<String> errors;
  final double? estimatedTotal;

  CheckoutValidation({this.isValid = true, this.errors = const [], this.estimatedTotal});

  factory CheckoutValidation.fromJson(Map<String, dynamic> json) => CheckoutValidation(
        isValid: json['is_valid'] ?? true,
        errors: (json['errors'] as List?)?.map((e) => e.toString()).toList() ?? [],
        estimatedTotal: json['estimated_total']?.toDouble(),
      );
}

class CreateOrderRequest {
  final String addressId;
  final String paymentMethodId;
  final String? couponCode;
  final String? note;

  CreateOrderRequest({required this.addressId, required this.paymentMethodId, this.couponCode, this.note});

  Map<String, dynamic> toJson() => {
        'address_id': addressId,
        'payment_method_id': paymentMethodId,
        if (couponCode != null) 'coupon_code': couponCode,
        if (note != null) 'note': note,
      };
}

class Order {
  final String id;
  final String orderNumber;
  final List<CartItem> items;
  final double subtotal;
  final double tax;
  final double shipping;
  final double discount;
  final double total;
  final String status;
  final String? paymentStatus;
  final Address? shippingAddress;
  final PaymentMethod? paymentMethod;
  final String? trackingNumber;
  final DateTime createdAt;
  final DateTime? deliveredAt;

  Order({
    required this.id,
    this.orderNumber = '',
    this.items = const [],
    this.subtotal = 0,
    this.tax = 0,
    this.shipping = 0,
    this.discount = 0,
    this.total = 0,
    this.status = 'pending',
    this.paymentStatus,
    this.shippingAddress,
    this.paymentMethod,
    this.trackingNumber,
    DateTime? createdAt,
    this.deliveredAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json['id']?.toString() ?? '',
        orderNumber: json['order_number'] ?? json['orderNumber'] ?? '',
        items: (json['items'] as List?)?.map((e) => CartItem.fromJson(e)).toList() ?? [],
        subtotal: (json['subtotal'] ?? 0).toDouble(),
        tax: (json['tax'] ?? 0).toDouble(),
        shipping: (json['shipping'] ?? 0).toDouble(),
        discount: (json['discount'] ?? 0).toDouble(),
        total: (json['total'] ?? 0).toDouble(),
        status: json['status'] ?? 'pending',
        paymentStatus: json['payment_status'],
        trackingNumber: json['tracking_number'],
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
        deliveredAt: json['delivered_at'] != null ? DateTime.parse(json['delivered_at']) : null,
      );
}

class OrderTracking {
  final String status;
  final String? description;
  final DateTime? estimatedDelivery;
  final List<TrackingEvent> events;

  OrderTracking({this.status = 'pending', this.description, this.estimatedDelivery, this.events = const []});

  factory OrderTracking.fromJson(Map<String, dynamic> json) => OrderTracking(
        status: json['status'] ?? 'pending',
        description: json['description'],
        estimatedDelivery: json['estimated_delivery'] != null ? DateTime.parse(json['estimated_delivery']) : null,
        events: (json['events'] as List?)?.map((e) => TrackingEvent.fromJson(e)).toList() ?? [],
      );
}

class TrackingEvent {
  final String status;
  final String description;
  final DateTime timestamp;
  final String? location;

  TrackingEvent({required this.status, this.description = '', DateTime? timestamp, this.location})
      : timestamp = timestamp ?? DateTime.now();

  factory TrackingEvent.fromJson(Map<String, dynamic> json) => TrackingEvent(
        status: json['status'] ?? '',
        description: json['description'] ?? '',
        timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
        location: json['location'],
      );
}

class ReturnRequest {
  final String id;
  final String status;
  final String reason;

  ReturnRequest({required this.id, this.status = 'pending', this.reason = ''});

  factory ReturnRequest.fromJson(Map<String, dynamic> json) => ReturnRequest(
        id: json['id']?.toString() ?? '',
        status: json['status'] ?? 'pending',
        reason: json['reason'] ?? '',
      );
}

class CreateReturnRequest {
  final String reason;
  final List<String> itemIds;

  CreateReturnRequest({required this.reason, this.itemIds = const []});

  Map<String, dynamic> toJson() => {
        'reason': reason,
        'item_ids': itemIds,
      };
}

// ==================== PAYMENT MODELS ====================

class PaymentIntent {
  final String id;
  final String clientSecret;
  final double amount;
  final String currency;
  final String status;

  PaymentIntent({
    required this.id,
    this.clientSecret = '',
    this.amount = 0,
    this.currency = 'USD',
    this.status = 'pending',
  });

  factory PaymentIntent.fromJson(Map<String, dynamic> json) => PaymentIntent(
        id: json['id']?.toString() ?? '',
        clientSecret: json['client_secret'] ?? '',
        amount: (json['amount'] ?? 0).toDouble(),
        currency: json['currency'] ?? 'USD',
        status: json['status'] ?? 'pending',
      );
}

class CreatePaymentIntentRequest {
  final double amount;
  final String currency;
  final String? paymentMethodId;

  CreatePaymentIntentRequest({required this.amount, this.currency = 'USD', this.paymentMethodId});

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency,
        if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      };
}

class PaymentConfirmation {
  final String id;
  final String status;
  final String? receiptUrl;

  PaymentConfirmation({required this.id, this.status = 'completed', this.receiptUrl});

  factory PaymentConfirmation.fromJson(Map<String, dynamic> json) => PaymentConfirmation(
        id: json['id']?.toString() ?? '',
        status: json['status'] ?? 'completed',
        receiptUrl: json['receipt_url'],
      );
}

class ConfirmPaymentRequest {
  final String paymentIntentId;
  final String? paymentMethodId;

  ConfirmPaymentRequest({required this.paymentIntentId, this.paymentMethodId});

  Map<String, dynamic> toJson() => {
        'payment_intent_id': paymentIntentId,
        if (paymentMethodId != null) 'payment_method_id': paymentMethodId,
      };
}

class PaymentMethod {
  final String id;
  final String type;
  final String? last4;
  final String? brand;
  final String? expiryMonth;
  final String? expiryYear;
  final bool isDefault;
  final String? holderName;

  PaymentMethod({
    required this.id,
    this.type = 'card',
    this.last4,
    this.brand,
    this.expiryMonth,
    this.expiryYear,
    this.isDefault = false,
    this.holderName,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
        id: json['id']?.toString() ?? '',
        type: json['type'] ?? 'card',
        last4: json['last4'] ?? json['last_four'],
        brand: json['brand'],
        expiryMonth: json['expiry_month']?.toString(),
        expiryYear: json['expiry_year']?.toString(),
        isDefault: json['is_default'] ?? json['isDefault'] ?? false,
        holderName: json['holder_name'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'last4': last4,
        'brand': brand,
        'expiry_month': expiryMonth,
        'expiry_year': expiryYear,
        'is_default': isDefault,
        'holder_name': holderName,
      };
}

class AddPaymentMethodRequest {
  final String type;
  final String? token;
  final String? last4;
  final String? brand;

  AddPaymentMethodRequest({required this.type, this.token, this.last4, this.brand});

  Map<String, dynamic> toJson() => {
        'type': type,
        if (token != null) 'token': token,
        if (last4 != null) 'last4': last4,
        if (brand != null) 'brand': brand,
      };
}

// ==================== ADDRESS MODELS ====================

class Address {
  final String id;
  final String label;
  final String fullName;
  final String street;
  final String? street2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phone;
  final bool isDefault;
  final double? latitude;
  final double? longitude;

  Address({
    required this.id,
    this.label = 'Home',
    this.fullName = '',
    this.street = '',
    this.street2,
    this.city = '',
    this.state = '',
    this.zipCode = '',
    this.country = 'US',
    this.phone,
    this.isDefault = false,
    this.latitude,
    this.longitude,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['id']?.toString() ?? '',
        label: json['label'] ?? 'Home',
        fullName: json['full_name'] ?? '',
        street: json['street'] ?? '',
        street2: json['street2'],
        city: json['city'] ?? '',
        state: json['state'] ?? '',
        zipCode: json['zip_code'] ?? json['zip'] ?? '',
        country: json['country'] ?? 'US',
        phone: json['phone'],
        isDefault: json['is_default'] ?? json['isDefault'] ?? false,
        latitude: json['latitude']?.toDouble(),
        longitude: json['longitude']?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'full_name': fullName,
        'street': street,
        'street2': street2,
        'city': city,
        'state': state,
        'zip_code': zipCode,
        'country': country,
        'phone': phone,
        'is_default': isDefault,
        'latitude': latitude,
        'longitude': longitude,
      };
}

class CreateAddressRequest {
  final String label;
  final String fullName;
  final String street;
  final String? street2;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final String? phone;
  final bool isDefault;

  CreateAddressRequest({
    this.label = 'Home',
    required this.fullName,
    required this.street,
    this.street2,
    required this.city,
    required this.state,
    required this.zipCode,
    this.country = 'US',
    this.phone,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
        'label': label,
        'full_name': fullName,
        'street': street,
        'street2': street2,
        'city': city,
        'state': state,
        'zip_code': zipCode,
        'country': country,
        'phone': phone,
        'is_default': isDefault,
      };
}

class UpdateAddressRequest {
  final String? label;
  final String? fullName;
  final String? street;
  final String? street2;
  final String? city;
  final String? state;
  final String? zipCode;
  final String? country;
  final String? phone;
  final bool? isDefault;

  UpdateAddressRequest({
    this.label,
    this.fullName,
    this.street,
    this.street2,
    this.city,
    this.state,
    this.zipCode,
    this.country,
    this.phone,
    this.isDefault,
  });

  Map<String, dynamic> toJson() => {
        if (label != null) 'label': label,
        if (fullName != null) 'full_name': fullName,
        if (street != null) 'street': street,
        if (street2 != null) 'street2': street2,
        if (city != null) 'city': city,
        if (state != null) 'state': state,
        if (zipCode != null) 'zip_code': zipCode,
        if (country != null) 'country': country,
        if (phone != null) 'phone': phone,
        if (isDefault != null) 'is_default': isDefault,
      };
}

// ==================== WISHLIST MODELS ====================

class Wishlist {
  final List<WishlistItem> items;

  Wishlist({this.items = const []});

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
        items: (json['items'] as List?)?.map((e) => WishlistItem.fromJson(e)).toList() ?? [],
      );
}

class WishlistItem {
  final String id;
  final String productId;
  final String name;
  final double price;
  final double? originalPrice;
  final String? imageUrl;
  final DateTime addedAt;

  WishlistItem({
    required this.id,
    required this.productId,
    this.name = '',
    this.price = 0,
    this.originalPrice,
    this.imageUrl,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  factory WishlistItem.fromJson(Map<String, dynamic> json) => WishlistItem(
        id: json['id']?.toString() ?? '',
        productId: json['product_id']?.toString() ?? '',
        name: json['name'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        originalPrice: json['original_price']?.toDouble(),
        imageUrl: json['image_url'],
        addedAt: json['added_at'] != null ? DateTime.parse(json['added_at']) : null,
      );
}

class AddToWishlistRequest {
  final String productId;

  AddToWishlistRequest({required this.productId});

  Map<String, dynamic> toJson() => {'product_id': productId};
}

// ==================== SEARCH MODELS ====================

class SearchResults {
  final List<Product> products;
  final List<Category> categories;
  final SearchFilters? filters;
  final PaginationMeta meta;

  SearchResults({
    this.products = const [],
    this.categories = const [],
    this.filters,
    PaginationMeta? meta,
  }) : meta = meta ?? PaginationMeta();

  factory SearchResults.fromJson(Map<String, dynamic> json) => SearchResults(
        products: (json['products'] as List?)?.map((e) => Product.fromJson(e)).toList() ?? [],
        categories: (json['categories'] as List?)?.map((e) => Category.fromJson(e)).toList() ?? [],
        filters: json['filters'] != null ? SearchFilters.fromJson(json['filters']) : null,
        meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : PaginationMeta(),
      );
}

class SearchFilters {
  final List<String> brands;
  final List<String> categories;
  final double? minPrice;
  final double? maxPrice;

  SearchFilters({this.brands = const [], this.categories = const [], this.minPrice, this.maxPrice});

  factory SearchFilters.fromJson(Map<String, dynamic> json) => SearchFilters(
        brands: (json['brands'] as List?)?.map((e) => e.toString()).toList() ?? [],
        categories: (json['categories'] as List?)?.map((e) => e.toString()).toList() ?? [],
        minPrice: json['min_price']?.toDouble(),
        maxPrice: json['max_price']?.toDouble(),
      );
}

// ==================== PAGINATION ====================

class PaginationMeta {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int itemsPerPage;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginationMeta({
    this.currentPage = 1,
    this.totalPages = 1,
    this.totalItems = 0,
    this.itemsPerPage = 20,
    this.hasNextPage = false,
    this.hasPreviousPage = false,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) => PaginationMeta(
        currentPage: json['current_page'] ?? json['page'] ?? 1,
        totalPages: json['total_pages'] ?? json['pages'] ?? 1,
        totalItems: json['total_items'] ?? json['total'] ?? 0,
        itemsPerPage: json['items_per_page'] ?? json['limit'] ?? 20,
        hasNextPage: json['has_next_page'] ?? json['hasMore'] ?? false,
        hasPreviousPage: json['has_previous_page'] ?? false,
      );
}

class PaginatedResponse<T> {
  final List<T> data;
  final PaginationMeta meta;

  PaginatedResponse({required this.data, required this.meta});

  factory PaginatedResponse.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return PaginatedResponse(
      data: (json['data'] as List?)?.map((e) => fromJson(e)).toList() ?? [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : PaginationMeta(),
    );
  }
}

// ==================== NOTIFICATION MODELS ====================

class AppNotification {
  final String id;
  final String title;
  final String body;
  final String? type;
  final String? imageUrl;
  final String? actionUrl;
  final bool read;
  final DateTime createdAt;

  AppNotification({
    required this.id,
    this.title = '',
    this.body = '',
    this.type,
    this.imageUrl,
    this.actionUrl,
    this.read = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type,
        'image_url': imageUrl,
        'action_url': actionUrl,
        'read': read,
        'created_at': createdAt.toIso8601String(),
      };

  factory AppNotification.fromJson(Map<String, dynamic> json) => AppNotification(
        id: json['id']?.toString() ?? '',
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        type: json['type'],
        imageUrl: json['image_url'],
        actionUrl: json['action_url'],
        read: json['read'] ?? json['is_read'] ?? false,
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      );

  AppNotification copyWith({bool? read}) => AppNotification(
        id: id,
        title: title,
        body: body,
        type: type,
        imageUrl: imageUrl,
        actionUrl: actionUrl,
        read: read ?? this.read,
        createdAt: createdAt,
      );
}

// ==================== SETTINGS MODELS ====================

class AppSettings {
  final bool enablePushNotifications;
  final bool enableEmailNotifications;
  final bool enableDarkMode;
  final String defaultCurrency;
  final String defaultLanguage;

  AppSettings({
    this.enablePushNotifications = true,
    this.enableEmailNotifications = true,
    this.enableDarkMode = true,
    this.defaultCurrency = 'USD',
    this.defaultLanguage = 'en',
  });

  Map<String, dynamic> toJson() => {
        'push_notifications': enablePushNotifications,
        'email_notifications': enableEmailNotifications,
        'dark_mode': enableDarkMode,
        'default_currency': defaultCurrency,
        'default_language': defaultLanguage,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
        enablePushNotifications: json['push_notifications'] ?? true,
        enableEmailNotifications: json['email_notifications'] ?? true,
        enableDarkMode: json['dark_mode'] ?? true,
        defaultCurrency: json['default_currency'] ?? 'USD',
        defaultLanguage: json['default_language'] ?? 'en',
      );
}

class ShippingOption {
  final String id;
  final String name;
  final String description;
  final double price;
  final String estimatedDays;

  ShippingOption({
    required this.id,
    this.name = '',
    this.description = '',
    this.price = 0,
    this.estimatedDays = '',
  });

  factory ShippingOption.fromJson(Map<String, dynamic> json) => ShippingOption(
        id: json['id']?.toString() ?? '',
        name: json['name'] ?? '',
        description: json['description'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        estimatedDays: json['estimated_days'] ?? '',
      );
}

class AppCurrency {
  final String code;
  final String name;
  final String symbol;
  final double exchangeRate;

  AppCurrency({
    required this.code,
    this.name = '',
    this.symbol = '',
    this.exchangeRate = 1.0,
  });

  factory AppCurrency.fromJson(Map<String, dynamic> json) => AppCurrency(
        code: json['code'] ?? json['currency'] ?? 'USD',
        name: json['name'] ?? '',
        symbol: json['symbol'] ?? '\$',
        exchangeRate: (json['exchange_rate'] ?? 1.0).toDouble(),
      );
}

class AvailablePaymentMethod {
  final String id;
  final String type;
  final String name;
  final String? iconUrl;
  final bool enabled;

  AvailablePaymentMethod({
    required this.id,
    this.type = '',
    this.name = '',
    this.iconUrl,
    this.enabled = true,
  });

  factory AvailablePaymentMethod.fromJson(Map<String, dynamic> json) => AvailablePaymentMethod(
        id: json['id']?.toString() ?? '',
        type: json['type'] ?? '',
        name: json['name'] ?? '',
        iconUrl: json['icon_url'],
        enabled: json['enabled'] ?? true,
      );
}
