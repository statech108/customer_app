import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Helper function for formatting time (e.g., 7:00 AM)
String _formatTime(int hour) {
  if (hour == 0) return '12:00 AM';
  if (hour == 12) return '12:00 PM';
  if (hour < 12) return '${hour}:00 AM';
  return '${hour - 12}:00 PM';
}

// Helper function to generate all delivery slots from 7 AM to 9 PM
List<String> _generateDeliverySlots() {
  List<String> slots = <String>[];
  for (int i = 7; i <= 20; i++) {
    // From 7 AM (7) to 8 PM (20)
    String startTime = _formatTime(i);
    String endTime = _formatTime(i + 1);
    slots.add('$startTime - $endTime');
  }
  return slots;
}

void main() => runApp(const MyApp());

// Data Model for a cart item
class CartItem {
  final String id;
  final String name;
  final String shop;
  final double price;
  final double? originalPrice;
  final IconData image;
  final bool inStock;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.shop,
    required this.price,
    this.originalPrice,
    required this.quantity,
    required this.image,
    required this.inStock,
  });

  // Factory constructor for converting a Map to CartItem
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'] as String,
      name: map['name'] as String,
      shop: map['shop'] as String,
      price: map['price'] as double,
      originalPrice: map['originalPrice'] as double?,
      quantity: map['quantity'] as int,
      image: map['image'] as IconData,
      inStock: map['inStock'] as bool,
    );
  }

  // Method to convert CartItem to a Map (useful for state updates)
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'shop': shop,
      'price': price,
      'originalPrice': originalPrice,
      'quantity': quantity,
      'image': image,
      'inStock': inStock,
    };
  }
}

// Data Model for the entire cart state
class CartData extends ChangeNotifier {
  // User-requested products.
  final List<CartItem> _cartItems = <CartItem>[
    CartItem(
      id: '1',
      name: 'Handgun (Replica Display Item)',
      shop: 'Hobby & Props',
      price: 4999.00,
      originalPrice: 5999.00,
      quantity: 1,
      image: Icons.security,
      inStock: true,
    ),
    CartItem(
      id: '2',
      name: 'Condom Pack (3 pcs)',
      shop: 'Health Store',
      price: 199.00,
      originalPrice: 220.00, // Added original price for discount display
      quantity: 2,
      image: Icons.healing,
      inStock: true,
    ),
    CartItem(
      id: '3',
      name: 'Sanitary Napkin (10 pcs)',
      shop: 'Personal Care',
      price: 249.00,
      originalPrice: 299.00,
      quantity: 1,
      image: Icons.local_hospital,
      inStock: true,
    ),
    CartItem(
      id: '4',
      name: 'Arti Book (Religious)',
      shop: 'Book Stall',
      price: 149.00,
      originalPrice: 175.00, // Added original price for discount display
      quantity: 1,
      image: Icons.book,
      inStock: true,
    ),
  ];

  static const String deliverNowSlotId = 'DELIVER_NOW'; // Renamed from asapSlotId

  String _selectedPaymentMethod = 'upi'; // Changed default to UPI since card is removed
  String? _selectedDeliverySlot; // New field for selected delivery slot

  // Initialize selected delivery slot in the initializer list
  CartData() : _selectedDeliverySlot = _generateDeliverySlots().first;

  List<CartItem> get cartItems => _cartItems;
  String get selectedPaymentMethod => _selectedPaymentMethod;
  String? get selectedDeliverySlot => _selectedDeliverySlot;

  void incrementQuantity(String itemId) {
    final int index =
    _cartItems.indexWhere((CartItem item) => item.id == itemId);
    if (index != -1 && _cartItems[index].inStock) {
      _cartItems[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String itemId) {
    final int index =
    _cartItems.indexWhere((CartItem item) => item.id == itemId);
    if (index != -1 &&
        _cartItems[index].inStock &&
        _cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      notifyListeners();
    }
  }

  void removeCartItem(String itemId) {
    _cartItems.removeWhere((CartItem item) => item.id == itemId);
    notifyListeners();
  }

  void setSelectedPaymentMethod(String methodId) {
    _selectedPaymentMethod = methodId;
    notifyListeners();
  }

  void setSelectedDeliverySlot(String? slot) {
    _selectedDeliverySlot = slot;
    notifyListeners();
  }

  double get subtotal {
    return _cartItems
        .where((CartItem item) => item.inStock)
        .fold(0.0, (double sum, CartItem item) => sum + (item.price * item.quantity));
  }

  double get deliveryFee {
    if (_selectedDeliverySlot == deliverNowSlotId) { // Use new ID
      return 25.0 + 30.0; // Base fee + Deliver Now fee (30.0 instead of 10.0)
    }
    return 25.0; // Example fixed delivery fee
  }
  double get discount => 0.0; // No promo code, so no discount from here.
  double get total => subtotal + deliveryFee - discount;

  bool get hasValidItems => _cartItems.any((CartItem item) => item.inStock);

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CartData>(
      create: (BuildContext context) => CartData(),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shopping Cart',
          theme: ThemeData(
            primarySwatch: Colors.teal,
            scaffoldBackgroundColor: Colors.grey[50],
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
            ),
          ),
          home: const CartScreen(),
        );
      },
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            const _Header(),
            Expanded(
              child: Consumer<CartData>(
                builder: (BuildContext context, CartData cartData, Widget? child) {
                  if (cartData.cartItems.isEmpty) {
                    return const _EmptyCart();
                  }
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      children: const <Widget>[
                        _CartItemsList(),
                        SizedBox(height: 20),
                        _PaymentMethods(),
                        SizedBox(height: 20),
                        _DeliverySlots(), // NEW DELIVERY SLOTS SECTION
                        SizedBox(height: 20),
                        _OrderSummary(),
                        SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
            Consumer<CartData>(
              builder: (BuildContext context, CartData cartData, Widget? child) {
                return cartData.cartItems.isNotEmpty
                    ? const _CheckoutButton()
                    : const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartData>(
      builder: (BuildContext context, CartData cartData, Widget? child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black87,
                    size: 20,
                  ),
                ),
              ),
              const Spacer(),
              Column(
                children: <Widget>[
                  const Text(
                    "My Cart",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    "${cartData.cartItems.length} items",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const SizedBox(width: 44), // Placeholder for alignment
            ],
          ),
        );
      },
    );
  }
}

class _CartItemsList extends StatelessWidget {
  const _CartItemsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartData>(
      builder: (BuildContext context, CartData cartData, Widget? child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: cartData.cartItems
                .asMap()
                .entries
                .map<Widget>((MapEntry<int, CartItem> entry) {
              final int index = entry.key;
              final CartItem item = entry.value;
              final bool isLast = index == cartData.cartItems.length - 1;

              return _CartItemWidget(item: item, isLast: isLast);
            }).toList(),
          ),
        );
      },
    );
  }
}

class _CartItemWidget extends StatelessWidget {
  const _CartItemWidget({
    Key? key,
    required this.item,
    required this.isLast,
  }) : super(key: key);

  final CartItem item;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartData>(
      builder: (BuildContext context, CartData cartData, Widget? child) {
        return Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: !isLast
                    ? Border(bottom: BorderSide(color: Colors.grey[100]!, width: 1))
                    : null,
                color: Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.topRight,
                    children: <Widget>[
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: item.inStock
                                ? <Color>[Colors.grey[200]!, Colors.grey[100]!]
                                : <Color>[Colors.red[100]!, Colors.red[50]!],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(
                          item.image,
                          color: item.inStock ? Colors.black87 : Colors.red[400],
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color:
                                  item.inStock ? Colors.black87 : Colors.grey[500],
                                ),
                              ),
                            ),
                            if (!item.inStock)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red[50],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  "Out of Stock",
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Shop Name: ${item.shop}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: <Widget>[
                            Text(
                              "₹${item.price.toStringAsFixed(0)}",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Colors.teal[600],
                              ),
                            ),
                            if (item.originalPrice != null) ...<Widget>[
                              const SizedBox(width: 8),
                              Text(
                                "₹${item.originalPrice!.toStringAsFixed(0)}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              if (item.originalPrice! > item.price) ...<Widget>[
                                const SizedBox(width: 8),
                                Text(
                                  "${((item.originalPrice! - item.price) / item.originalPrice! * 100).toStringAsFixed(0)}% OFF",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red[400],
                                  ),
                                ),
                              ],
                            ],
                            const Spacer(),
                            _QuantityControls(item: item),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: () {
                  cartData.removeCartItem(item.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${item.name} removed from cart')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.red[400],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _QuantityControls extends StatelessWidget {
  const _QuantityControls({Key? key, required this.item}) : super(key: key);

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Consumer<CartData>(
      builder: (BuildContext context, CartData cartData, Widget? child) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: item.inStock && item.quantity > 1
                    ? () => cartData.decrementQuantity(item.id)
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.remove,
                    size: 16,
                    color: item.inStock && item.quantity > 1
                        ? Colors.black87
                        : Colors.grey[400],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  "${item.quantity}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
              GestureDetector(
                onTap: item.inStock
                    ? () => cartData.incrementQuantity(item.id)
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: item.inStock ? Colors.black87 : Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// A reusable widget for displaying a selectable tile,
/// used for payment methods and delivery slots.
class _ChoiceTile extends StatelessWidget {
  const
  _ChoiceTile({
    Key? key,
    required this.isSelected,
    required this.onTap,
    required this.child, required this.padding, this.selectedColor, this.unselectedColor, this.selectedBorderColor,
  }) : super(key: key);

  final bool isSelected;
  final VoidCallback onTap;
  final Widget child;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBorderColor;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: isSelected ? (selectedColor ?? Colors.teal[50]) : (unselectedColor ?? Colors.grey[50]),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? (selectedBorderColor ?? Colors.teal[300]!) : Colors.transparent,
            width: 2,
          ),
        ),
        child: child,
      ),
    );
  }
}

class _PaymentMethods extends StatelessWidget {
  const _PaymentMethods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> paymentMethods = <Map<String, dynamic>>[
      {
        'id': 'upi',
        'title': 'UPI Payment',
        'icon': Icons.account_balance_wallet
      },
      {'id': 'cod', 'title': 'Cash on Delivery', 'icon': Icons.money},
    ];

    return Consumer<CartData>(
      builder: (BuildContext context, CartData cartData, Widget? child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Payment Method",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ...paymentMethods.map<Widget>((Map<String, dynamic> method) {
                final String methodId = method['id'] as String;
                final bool isSelected = cartData.selectedPaymentMethod == methodId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ChoiceTile(
                    padding: const EdgeInsets.all(16), // Added required padding
                    isSelected: isSelected,
                    onTap: () => cartData.setSelectedPaymentMethod(methodId),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          method['icon'] as IconData,
                          color:
                          isSelected ? Colors.teal[600] : Colors.grey[600],
                        ),
                        const SizedBox(width: 12),
                        Text(
                          method['title'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color:
                            isSelected ? Colors.teal[600] : Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Colors.teal,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

class _DeliverySlots extends StatefulWidget {
  const _DeliverySlots({Key? key}) : super(key: key);

  @override
  State<_DeliverySlots> createState() => _DeliverySlotsState();
}

class _DeliverySlotsState extends State<_DeliverySlots> {
  bool _showAllSlots = false;
  // Changed _maxInitialSlots from 6 to 5 to aim for approximately 2 rows
  // (e.g., "Deliver Now" + 5 regular slots = 6 total tiles,
  // which can fit into two rows of 3 on typical mobile screens).
  static const int _maxInitialSlots = 5;

  @override
  Widget build(BuildContext context) {
    final List<String> timeDeliverySlots = _generateDeliverySlots();

    // Determine the time slots to display based on _showAllSlots
    final List<String> displayedTimeSlots = _showAllSlots || timeDeliverySlots.length <= _maxInitialSlots
        ? timeDeliverySlots
        : timeDeliverySlots.take(_maxInitialSlots).toList();

    return Consumer<CartData>(
      builder: (BuildContext context, CartData cartData, Widget? child) {
        final bool isDeliverNowSelected = cartData.selectedDeliverySlot == CartData.deliverNowSlotId;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Delivery Slot",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0, // Horizontal space between items
                runSpacing: 8.0, // Vertical space between lines
                children: <Widget>[
                  // Deliver Now Delivery Option
                  _ChoiceTile(
                    padding: const EdgeInsets.all(12), // Added required padding
                    onTap: () => cartData.setSelectedDeliverySlot(CartData.deliverNowSlotId),
                    isSelected: isDeliverNowSelected,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          "Deliver Now", // Changed from "ASAP"
                          style: TextStyle(
                            fontWeight: isDeliverNowSelected ? FontWeight.w600 : FontWeight.w500,
                            color: isDeliverNowSelected ? Colors.teal[600] : Colors.black87,
                          ),
                        ),
                        const Text(
                          "₹30 extra", // Changed from "₹10 extra"
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Regular time slots
                  ...displayedTimeSlots.map<Widget>((String slot) {
                    final bool isSelected = cartData.selectedDeliverySlot == slot;
                    return _ChoiceTile(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Added required padding
                      onTap: () => cartData.setSelectedDeliverySlot(slot),
                      isSelected: isSelected,
                      child: Text(
                        slot,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected ? Colors.teal[600] : Colors.black87,
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
              // Only show "Show More/Less" if there are more slots than initially displayed
              if (timeDeliverySlots.length > _maxInitialSlots) ...<Widget>[
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _showAllSlots = !_showAllSlots;
                      });
                    },
                    child: Text(
                      _showAllSlots ? "Show Less" : "Show More",
                      style: TextStyle(
                        color: Colors.teal[600],
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _OrderSummary extends StatelessWidget {
  const _OrderSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartData>(
      builder: (BuildContext context, CartData cartData, Widget? child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "Order Summary",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              _SummaryRow(
                  label: "Subtotal",
                  value: "₹${cartData.subtotal.toStringAsFixed(0)}"),
              _SummaryRow(
                  label: "Delivery Fee",
                  value: "₹${cartData.deliveryFee.toStringAsFixed(0)}"),
              if (cartData.discount > 0)
                _SummaryRow(
                    label: "Discount",
                    value: "-₹${cartData.discount.toStringAsFixed(0)}",
                    color: Colors.teal[600]),
              Divider(height: 24, color: Colors.grey[200]),
              _SummaryRow(
                  label: "Total",
                  value: "₹${cartData.total.toStringAsFixed(0)}",
                  isTotal: true),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    Key? key,
    required this.label,
    required this.value,
    this.color,
    this.isTotal = false,
  }) : super(key: key);

  final String label;
  final String value;
  final Color? color;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: color ?? (isTotal ? Colors.black87 : Colors.grey[600]),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.w700,
              color: color ?? (isTotal ? Colors.black87 : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}

/// A reusable gradient button widget.
class _GradientActionButton extends StatelessWidget {
  const _GradientActionButton({
    Key? key,
    required this.text,
    this.icon,
    this.onPressed,
    this.isActive = true,
  }) : super(key: key);

  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final List<Color> activeColors = <Color>[Colors.teal[600]!, Colors.teal[700]!];
    final List<Color> inactiveColors = <Color>[Colors.grey[300]!, Colors.grey[400]!];

    return GestureDetector(
      onTap: isActive ? onPressed : null,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: isActive ? LinearGradient(colors: activeColors) : LinearGradient(colors: inactiveColors),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isActive
              ? <BoxShadow>[
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.teal.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (icon != null) ...<Widget>[
              Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 50,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Add items from nearby shops to get started",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 32),
          _GradientActionButton(
            text: "Start Shopping",
            onPressed: () => Navigator.maybePop(context),
          ),
        ],
      ),
    );
  }
}

class _CheckoutButton extends StatelessWidget {
  const _CheckoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartData>(
      builder: (BuildContext context, CartData cartData, Widget? child) {
        final bool hasValidItems = cartData.hasValidItems;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: _GradientActionButton(
              text: "Proceed to Checkout",
              icon: Icons.shopping_bag_outlined,
              isActive: hasValidItems,
              onPressed: hasValidItems
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                    const CheckoutSummaryScreen(),
                  ),
                );
              }
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class CheckoutSummaryScreen extends StatelessWidget {
  const CheckoutSummaryScreen({Key? key}) : super(key: key);

  String _formatPaymentMethod(String methodId) {
    switch (methodId) {
      case 'upi':
        return 'UPI Payment';
      case 'cod':
        return 'Cash on Delivery';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Summary"),
        centerTitle: true,
      ),
      body: Consumer<CartData>(
        builder: (BuildContext context, CartData cartData, Widget? child) {
          if (cartData.cartItems.isEmpty) {
            return const _EmptyCart();
          }
          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: <Widget>[
                    // Items in your Cart
                    _SummaryCard(
                      title: "Items in your Cart",
                      children: cartData.cartItems
                          .where((CartItem item) => item.inStock)
                          .map<Widget>((CartItem item) => _CartItemSummaryRow(
                        item: item,
                      ))
                          .toList(),
                    ),
                    const SizedBox(height: 20),

                    // Payment Method
                    _SummaryCard(
                      title: "Payment Method",
                      children: <Widget>[
                        _SummaryRow(
                          label: "Method",
                          value: _formatPaymentMethod(
                              cartData.selectedPaymentMethod),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // NEW: Delivery Details
                    if (cartData.selectedDeliverySlot != null)
                      _SummaryCard(
                        title: "Delivery Details",
                        children: <Widget>[
                          _SummaryRow(
                            label: "Slot",
                            value: cartData.selectedDeliverySlot!,
                            color: Colors.black87,
                          ),
                          if (cartData.selectedDeliverySlot == CartData.deliverNowSlotId) // Use new ID
                            const _SummaryRow(
                              label: "Deliver Now Fee", // Changed from "ASAP Fee"
                              value: "₹30", // Changed from "₹10"
                              color: Colors.red,
                            ),
                        ],
                      ),
                    const SizedBox(height: 20), // Spacing after delivery details

                    // Order Summary
                    _SummaryCard(
                      title: "Summary",
                      children: <Widget>[
                        _SummaryRow(
                            label: "Subtotal",
                            value: "₹${cartData.subtotal.toStringAsFixed(0)}"),
                        _SummaryRow(
                            label: "Delivery Fee",
                            value: "₹${cartData.deliveryFee.toStringAsFixed(0)}"),
                        if (cartData.discount > 0)
                          _SummaryRow(
                              label: "Discount",
                              value: "-₹${cartData.discount.toStringAsFixed(0)}",
                              color: Colors.teal[600]),
                        Divider(height: 24, color: Colors.grey[200]),
                        _SummaryRow(
                            label: "Total",
                            value: "₹${cartData.total.toStringAsFixed(0)}",
                            isTotal: true),
                      ],
                    ),
                  ],
                ),
              ),
              const _PlaceOrderButton(),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

class _CartItemSummaryRow extends StatelessWidget {
  const _CartItemSummaryRow({
    Key? key,
    required this.item,
  }) : super(key: key);

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Text(
              "${item.name} (x${item.quantity})",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            "₹${(item.price * item.quantity).toStringAsFixed(0)}",
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlaceOrderButton extends StatelessWidget {
  const _PlaceOrderButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: _GradientActionButton(
          text: "Place Order",
          icon: Icons.check_circle_outline,
          onPressed: () {
            // Simulate order placement
            Provider.of<CartData>(context, listen: false).clearCart();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order placed successfully!')),
            );
            // Navigate back to the cart screen (which will now be empty)
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}