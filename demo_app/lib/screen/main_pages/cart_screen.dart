import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [
    {
      'id': '1',
      'name': 'Fresh Vegetables Bundle',
      'shop': 'Bhabhi Grocery',
      'price': 299.00,
      'originalPrice': 399.00,
      'quantity': 2,
      'image': Icons.local_grocery_store,
      'inStock': true,
    },
    {
      'id': '2',
      'name': 'Chicken Biryani',
      'shop': 'Prince Restaurant',
      'price': 249.00,
      'originalPrice': null,
      'quantity': 1,
      'image': Icons.restaurant,
      'inStock': true,
    },
    {
      'id': '3',
      'name': 'Hair Cut & Styling',
      'shop': 'Style Salon',
      'price': 150.00,
      'originalPrice': 200.00,
      'quantity': 1,
      'image': Icons.content_cut,
      'inStock': false,
    },
    {
      'id': '4',
      'name': 'Dry Cleaning Service',
      'shop': 'Quick Laundry',
      'price': 99.00,
      'originalPrice': null,
      'quantity': 3,
      'image': Icons.dry_cleaning,
      'inStock': true,
    },
  ];

  String selectedPaymentMethod = 'card';
  String promoCode = '';
  bool isPromoApplied = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (cartItems.isNotEmpty) ...[
                      _buildCartItems(),
                      SizedBox(height: 20),
                      _buildPromoSection(),
                      SizedBox(height: 20),
                      _buildPaymentMethods(),
                      SizedBox(height: 20),
                      _buildOrderSummary(),
                    ] else
                      _buildEmptyCart(),
                  ],
                ),
              ),
            ),
            if (cartItems.isNotEmpty) _buildCheckoutButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
          Spacer(),
          Column(
            children: [
              Text(
                "My Cart",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.black87,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                "${cartItems.length} items",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              // Clear cart action
              setState(() {
                cartItems.clear();
              });
            },
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.delete_outline,
                color: Colors.red[400],
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: cartItems.asMap().entries.map((entry) {
          int index = entry.key;
          Map<String, dynamic> item = entry.value;
          bool isLast = index == cartItems.length - 1;

          return _buildCartItem(item, isLast);
        }).toList(),
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, bool isLast) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: !isLast
            ? Border(bottom: BorderSide(color: Colors.grey[100]!, width: 1))
            : null,
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: item['inStock']
                    ? [Colors.grey[200]!, Colors.grey[100]!]
                    : [Colors.red[100]!, Colors.red[50]!],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              item['image'],
              color: item['inStock'] ? Colors.black87 : Colors.red[400],
              size: 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item['name'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: item['inStock']
                              ? Colors.black87
                              : Colors.grey[500],
                        ),
                      ),
                    ),
                    if (!item['inStock'])
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          "Out of Stock",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.red[400],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  item['shop'],
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "₹${item['price'].toStringAsFixed(0)}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.teal[600],
                      ),
                    ),
                    if (item['originalPrice'] != null) ...[
                      SizedBox(width: 8),
                      Text(
                        "₹${item['originalPrice'].toStringAsFixed(0)}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                    Spacer(),
                    _buildQuantityControls(item),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(Map<String, dynamic> item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: item['inStock']
                ? () {
                    setState(() {
                      if (item['quantity'] > 1) {
                        item['quantity']--;
                      }
                    });
                  }
                : null,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.remove,
                size: 16,
                color: item['inStock'] && item['quantity'] > 1
                    ? Colors.black87
                    : Colors.grey[400],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              "${item['quantity']}",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
          GestureDetector(
            onTap: item['inStock']
                ? () {
                    setState(() {
                      item['quantity']++;
                    });
                  }
                : null,
            child: Container(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.add,
                size: 16,
                color: item['inStock'] ? Colors.black87 : Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Promo Code",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    promoCode = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Enter promo code",
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isPromoApplied = promoCode.isNotEmpty;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal[600]!, Colors.teal[700]!],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          if (isPromoApplied) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.teal[600], size: 16),
                  SizedBox(width: 8),
                  Text(
                    "Promo code applied! You saved ₹50",
                    style: TextStyle(
                      color: Colors.teal[600],
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final paymentMethods = [
      {'id': 'card', 'title': 'Credit/Debit Card', 'icon': Icons.credit_card},
      {
        'id': 'upi',
        'title': 'UPI Payment',
        'icon': Icons.account_balance_wallet,
      },
      {'id': 'cod', 'title': 'Cash on Delivery', 'icon': Icons.money},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Payment Method",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          ...paymentMethods.map((method) {
            bool isSelected = selectedPaymentMethod == method['id'];
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedPaymentMethod = method['id'] as String;
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.teal[50] : Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.teal[300]! : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      method['icon'] as IconData,
                      color: isSelected ? Colors.teal[600] : Colors.grey[600],
                    ),
                    SizedBox(width: 12),
                    Text(
                      method['title'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.teal[600] : Colors.black87,
                      ),
                    ),
                    Spacer(),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: Colors.teal[600],
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
  }

  Widget _buildOrderSummary() {
    double subtotal = cartItems
        .where((item) => item['inStock'])
        .fold(0.0, (sum, item) => sum + (item['price'] * item['quantity']));
    double deliveryFee = 25.0;
    double discount = isPromoApplied ? 50.0 : 0.0;
    double total = subtotal + deliveryFee - discount;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Summary",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          _buildSummaryRow("Subtotal", "₹${subtotal.toStringAsFixed(0)}"),
          _buildSummaryRow(
            "Delivery Fee",
            "₹${deliveryFee.toStringAsFixed(0)}",
          ),
          if (discount > 0)
            _buildSummaryRow(
              "Discount",
              "-₹${discount.toStringAsFixed(0)}",
              color: Colors.teal[600],
            ),
          Divider(height: 24, color: Colors.grey[200]),
          _buildSummaryRow(
            "Total",
            "₹${total.toStringAsFixed(0)}",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value, {
    Color? color,
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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

  Widget _buildEmptyCart() {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 50,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Add items from nearby shops to get started",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          SizedBox(height: 32),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[600]!, Colors.teal[700]!],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Start Shopping",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton() {
    bool hasValidItems = cartItems.any((item) => item['inStock']);

    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: GestureDetector(
          onTap: hasValidItems
              ? () {
                  // Handle checkout
                }
              : null,
          child: Container(
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: hasValidItems
                  ? LinearGradient(
                      colors: [Colors.teal[600]!, Colors.teal[700]!],
                    )
                  : LinearGradient(
                      colors: [Colors.grey[300]!, Colors.grey[400]!],
                    ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: hasValidItems
                  ? [
                      BoxShadow(
                        color: Colors.teal.withOpacity(0.3),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 22,
                ),
                SizedBox(width: 12),
                Text(
                  "Proceed to Checkout",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
