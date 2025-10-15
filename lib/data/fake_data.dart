import 'dart:math';

// lib/models/user_model.dart
class Address {
  String houseNumber;
  String streetName;
  String city;
  String state;
  String pinCode;
  String tag; // e.g., 'Home', 'Office', 'Other'

  Address({
    required this.houseNumber,
    required this.streetName,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.tag,
  });

  Map<String, dynamic> toMap() {
    return {
      'houseNumber': houseNumber,
      'streetName': streetName,
      'city': city,
      'state': state,
      'pinCode': pinCode,
      'tag': tag,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      houseNumber: map['houseNumber'] ?? '',
      streetName: map['streetName'] ?? '',
      city: map['city'] ?? '',
      state: map['state'] ?? '',
      pinCode: map['pinCode'] ?? '',
      tag: map['tag'] ?? '',
    );
  }
}

class PaymentMethod {
  String id;
  String type; // 'Card', 'UPI', 'BankAccount', 'CashOnDelivery'
  String? brand; // For cards: 'Visa', 'Mastercard'
  String? number; // For cards: masked number
  String? expiry; // For cards: expiry date
  String? upiId; // For UPI
  String? bankName; // For bank account
  String? accountHolder; // For bank account
  String? accountNumber; // For bank account
  String? ifscCode; // For bank account
  String? status; // For COD: 'Available'
  String lastFourDigits;
  String cardHolderName;
  bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    this.brand,
    this.number,
    this.expiry,
    this.upiId,
    this.bankName,
    this.accountHolder,
    this.accountNumber,
    this.ifscCode,
    this.status,
    required this.lastFourDigits,
    required this.cardHolderName,
    required this.isDefault,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'brand': brand,
      'number': number,
      'expiry': expiry,
      'upiId': upiId,
      'bankName': bankName,
      'accountHolder': accountHolder,
      'accountNumber': accountNumber,
      'ifscCode': ifscCode,
      'status': status,
      'lastFourDigits': lastFourDigits,
      'cardHolderName': cardHolderName,
      'isDefault': isDefault,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      brand: map['brand'],
      number: map['number'],
      expiry: map['expiry'],
      upiId: map['upiId'],
      bankName: map['bankName'],
      accountHolder: map['accountHolder'],
      accountNumber: map['accountNumber'],
      ifscCode: map['ifscCode'],
      status: map['status'],
      lastFourDigits: map['lastFourDigits'] ?? '',
      cardHolderName: map['cardHolderName'] ?? '',
      isDefault: map['isDefault'] ?? false,
    );
  }
}

class Review {
  String productId;
  String productName;
  double rating; // 1-5
  String reviewText;
  DateTime reviewDate;
  String reviewer; // User who wrote the review

  Review({
    required this.productId,
    required this.productName,
    required this.rating,
    required this.reviewText,
    required this.reviewDate,
    required this.reviewer,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'rating': rating,
      'reviewText': reviewText,
      'reviewDate': reviewDate.toIso8601String(),
      'reviewer': reviewer,
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      reviewText: map['reviewText'] ?? '',
      reviewDate: DateTime.parse(map['reviewDate'] ?? DateTime.now().toIso8601String()),
      reviewer: map['reviewer'] ?? '',
    );
  }
}

class Order {
  String orderId;
  String productName;
  double price;
  int quantity;
  DateTime orderDate;
  String status; // 'pending', 'shipped', 'delivered', 'cancelled'

  Order({
    required this.orderId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.orderDate,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'orderDate': orderDate.toIso8601String(),
      'status': status,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      orderId: map['orderId'] ?? '',
      productName: map['productName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
      orderDate: DateTime.parse(map['orderDate'] ?? DateTime.now().toIso8601String()),
      status: map['status'] ?? 'pending',
    );
  }
}

class User {
  String userId;
  String username;
  String mobileNumber;
  String email;
  List<Address> addresses;
  List<Order> orders;
  List<Review> reviews;
  double credits;
  List<PaymentMethod> paymentMethods;
  List<Order> orderHistory;
  List<String> favourites; // product IDs or names

  User({
    required this.userId,
    required this.username,
    required this.mobileNumber,
    required this.email,
    required this.addresses,
    required this.orders,
    required this.reviews,
    required this.credits,
    required this.paymentMethods,
    required this.orderHistory,
    required this.favourites,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'mobileNumber': mobileNumber,
      'email': email,
      'addresses': addresses.map((a) => a.toMap()).toList(),
      'orders': orders.map((o) => o.toMap()).toList(),
      'reviews': reviews.map((r) => r.toMap()).toList(),
      'credits': credits,
      'paymentMethods': paymentMethods.map((p) => p.toMap()).toList(),
      'orderHistory': orderHistory.map((o) => o.toMap()).toList(),
      'favourites': favourites,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'] ?? '',
      username: map['username'] ?? '',
      mobileNumber: map['mobileNumber'] ?? '',
      email: map['email'] ?? '',
      addresses: (map['addresses'] as List?)?.map((a) => Address.fromMap(a)).toList() ?? [],
      orders: (map['orders'] as List?)?.map((o) => Order.fromMap(o)).toList() ?? [],
      reviews: (map['reviews'] as List?)?.map((r) => Review.fromMap(r)).toList() ?? [],
      credits: (map['credits'] ?? 0).toDouble(),
      paymentMethods: (map['paymentMethods'] as List?)?.map((p) => PaymentMethod.fromMap(p)).toList() ?? [],
      orderHistory: (map['orderHistory'] as List?)?.map((o) => Order.fromMap(o)).toList() ?? [],
      favourites: List<String>.from(map['favourites'] ?? []),
    );
  }
}

// lib/services/mock_data_service.dart


class MockDataService {
  static final MockDataService _instance = MockDataService._internal();

  factory MockDataService() {
    return _instance;
  }

  MockDataService._internal();

  final List<String> _firstNames = ['Rahul', 'Priya', 'Arjun', 'Neha', 'Vikram', 'Anjali', 'Aditya', 'Divya'];
  final List<String> _lastNames = ['Kumar', 'Singh', 'Patel', 'Sharma', 'Verma', 'Gupta', 'Nair', 'Reddy'];
  final List<String> _productNames = ['Laptop', 'Phone', 'Headphones', 'Tablet', 'Smart Watch', 'Camera', 'Speaker', 'Monitor'];
  final List<String> _cities = ['Delhi', 'Mumbai', 'Bangalore', 'Hyderabad', 'Chennai', 'Pune', 'Jaipur', 'Kolkata'];
  final List<String> _states = ['Delhi', 'Maharashtra', 'Karnataka', 'Telangana', 'Tamil Nadu', 'Gujarat', 'Rajasthan', 'West Bengal'];
  final List<String> _paymentTypes = ['Card', 'UPI', 'BankAccount', 'CashOnDelivery'];
  final List<String> _orderStatus = ['pending', 'shipped', 'delivered', 'cancelled'];
  final List<String> _addressTags = ['Home', 'Office', 'Other'];

  final Random _random = Random();

  List<User> _users = [];

  // Generate a single random user
  User generateRandomUser({String? userId}) {
    final id = userId ?? 'user_${_random.nextInt(100000)}';
    final firstName = _firstNames[_random.nextInt(_firstNames.length)];
    final lastName = _lastNames[_random.nextInt(_lastNames.length)];
    final username = '$firstName $lastName';

    return User(
      userId: id,
      username: username,
      mobileNumber: '+91${_random.nextInt(900000000) + 100000000}',
      email: '${firstName.toLowerCase()}.${lastName.toLowerCase()}@email.com',
      addresses: _generateAddresses(),
      orders: _generateOrders(),
      reviews: _generateReviews(username),
      credits: _random.nextDouble() * 5000,
      paymentMethods: _generatePaymentMethods(username),
      orderHistory: _generateOrderHistory(),
      favourites: _generateFavourites(),
    );
  }

  // Generate multiple users
  List<User> generateMockUsers(int count) {
    _users.clear();
    for (int i = 0; i < count; i++) {
      _users.add(generateRandomUser(userId: 'user_$i'));
    }
    return _users;
  }

  // Get all users
  List<User> getAllUsers() => _users;

  // Get user by ID
  User? getUserById(String userId) {
    try {
      return _users.firstWhere((user) => user.userId == userId);
    } catch (e) {
      return null;
    }
  }

  // Get current user (single user for this app)
  User getCurrentUser() {
    if (_users.isEmpty) {
      _users.add(generateRandomUser(userId: 'current_user'));
    }
    return _users.first;
  }

  // Update user
  void updateUser(User user) {
    final index = _users.indexWhere((u) => u.userId == user.userId);
    if (index != -1) {
      _users[index] = user;
    }
  }

  // Delete user
  void deleteUser(String userId) {
    _users.removeWhere((user) => user.userId == userId);
  }

  // Add address to user
  void addAddress(String userId, Address address) {
    final user = getUserById(userId);
    if (user != null) {
      user.addresses.add(address);
      updateUser(user);
    }
  }

  // Add order to user
  void addOrder(String userId, Order order) {
    final user = getUserById(userId);
    if (user != null) {
      user.orders.add(order);
      user.orderHistory.add(order);
      updateUser(user);
    }
  }

  // Add review to user
  void addReview(String userId, Review review) {
    final user = getUserById(userId);
    if (user != null) {
      user.reviews.add(review);
      updateUser(user);
    }
  }

  // Update credits
  void updateCredits(String userId, double amount) {
    final user = getUserById(userId);
    if (user != null) {
      user.credits += amount;
      updateUser(user);
    }
  }

  // Add to favourites
  void addToFavourites(String userId, String productId) {
    final user = getUserById(userId);
    if (user != null && !user.favourites.contains(productId)) {
      user.favourites.add(productId);
      updateUser(user);
    }
  }

  // Remove from favourites
  void removeFromFavourites(String userId, String productId) {
    final user = getUserById(userId);
    if (user != null) {
      user.favourites.remove(productId);
      updateUser(user);
    }
  }

  // Private helper methods
  List<Address> _generateAddresses() {
    int count = _random.nextInt(3) + 1;
    List<Address> addresses = [];
    for (int i = 0; i < count; i++) {
      addresses.add(
        Address(
          houseNumber: '${_random.nextInt(500) + 1}',
          streetName: 'Street ${String.fromCharCode(65 + _random.nextInt(26))}',
          city: _cities[_random.nextInt(_cities.length)],
          state: _states[_random.nextInt(_states.length)],
          pinCode: '${_random.nextInt(800000) + 100000}',
          tag: _addressTags[_random.nextInt(_addressTags.length)],
        ),
      );
    }
    return addresses;
  }

  List<Order> _generateOrders() {
    int count = _random.nextInt(5) + 1;
    List<Order> orders = [];
    for (int i = 0; i < count; i++) {
      orders.add(
        Order(
          orderId: 'ORD_${_random.nextInt(999999)}',
          productName: _productNames[_random.nextInt(_productNames.length)],
          price: (_random.nextInt(50000) + 1000).toDouble(),
          quantity: _random.nextInt(5) + 1,
          orderDate: DateTime.now().subtract(Duration(days: _random.nextInt(365))),
          status: _orderStatus[_random.nextInt(_orderStatus.length)],
        ),
      );
    }
    return orders;
  }

  List<Review> _generateReviews(String username) {
    int count = _random.nextInt(5) + 2; // At least 2 reviews
    List<Review> reviews = [];
    final List<String> reviewTexts = [
      'Great product! Really happy with my purchase.',
      'Excellent quality and fast delivery.',
      'Good value for money, would recommend.',
      'Amazing product, exceeded my expectations.',
      'Very satisfied with this purchase.',
      'Good product but delivery was a bit slow.',
      'Perfect! Exactly what I was looking for.',
      'Great customer service and product quality.',
    ];
    
    for (int i = 0; i < count; i++) {
      reviews.add(
        Review(
          productId: 'PROD_${_random.nextInt(9999)}',
          productName: _productNames[_random.nextInt(_productNames.length)],
          rating: (_random.nextInt(5) + 1).toDouble(),
          reviewText: reviewTexts[_random.nextInt(reviewTexts.length)],
          reviewDate: DateTime.now().subtract(Duration(days: _random.nextInt(180))),
          reviewer: username,
        ),
      );
    }
    return reviews;
  }

  List<PaymentMethod> _generatePaymentMethods(String username) {
    int count = _random.nextInt(3) + 1;
    List<PaymentMethod> methods = [];
    final List<String> brands = ['Visa', 'Mastercard'];
    
    for (int i = 0; i < count; i++) {
      final String type = _paymentTypes[_random.nextInt(_paymentTypes.length)];
      final String id = 'PAY_${_random.nextInt(100000)}';
      final String lastFour = '${_random.nextInt(9000) + 1000}';
      
      PaymentMethod method;
      
      switch (type) {
        case 'Card':
          method = PaymentMethod(
            id: id,
            type: type,
            brand: brands[_random.nextInt(brands.length)],
            number: '**** **** **** $lastFour',
            expiry: '${_random.nextInt(12) + 1}/${_random.nextInt(10) + 25}',
            lastFourDigits: lastFour,
            cardHolderName: username,
            isDefault: i == 0,
          );
          break;
        case 'UPI':
          method = PaymentMethod(
            id: id,
            type: type,
            upiId: '${username.toLowerCase().replaceAll(' ', '.')}@upi',
            lastFourDigits: lastFour,
            cardHolderName: username,
            isDefault: i == 0,
          );
          break;
        case 'BankAccount':
          method = PaymentMethod(
            id: id,
            type: type,
            bankName: 'HDFC Bank',
            accountHolder: username,
            accountNumber: '**** **** $lastFour',
            ifscCode: 'HDFC0001234',
            lastFourDigits: lastFour,
            cardHolderName: username,
            isDefault: i == 0,
          );
          break;
        case 'CashOnDelivery':
          method = PaymentMethod(
            id: id,
            type: type,
            status: 'Available',
            lastFourDigits: lastFour,
            cardHolderName: username,
            isDefault: i == 0,
          );
          break;
        default:
          method = PaymentMethod(
            id: id,
            type: type,
            lastFourDigits: lastFour,
            cardHolderName: username,
            isDefault: i == 0,
          );
      }
      
      methods.add(method);
    }
    return methods;
  }

  List<Order> _generateOrderHistory() {
    int count = _random.nextInt(15) + 5;
    List<Order> history = [];
    for (int i = 0; i < count; i++) {
      history.add(
        Order(
          orderId: 'ORD_${_random.nextInt(999999)}',
          productName: _productNames[_random.nextInt(_productNames.length)],
          price: (_random.nextInt(50000) + 1000).toDouble(),
          quantity: _random.nextInt(5) + 1,
          orderDate: DateTime.now().subtract(Duration(days: _random.nextInt(730))),
          status: _orderStatus[_random.nextInt(_orderStatus.length)],
        ),
      );
    }
    return history;
  }

  List<String> _generateFavourites() {
    int count = _random.nextInt(5);
    List<String> favourites = [];
    for (int i = 0; i < count; i++) {
      favourites.add('PROD_${_random.nextInt(9999)}');
    }
    return favourites;
  }
}