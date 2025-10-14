import 'package:demo_app/screen/main_pages/cart_screen.dart';
import 'package:demo_app/screen/main_pages/location_screen.dart';
import 'package:demo_app/screen/main_pages/message.dart';
import 'package:demo_app/screen/main_pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/data/color.dart';
import 'package:demo_app/data/shop.dart';
import 'package:demo_app/data/personal.dart';
import 'maps.dart';
import 'package:demo_app/data/restaurant_data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isDeliveryMode = true;
  final TextEditingController _searchController = TextEditingController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_colour,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopSection(),
              SizedBox(height: 20),
              _buildSearchAndModeSection(),
              SizedBox(height: 24),
              _sectionTitle("Stories"),
              _buildStoriesSection(),
              SizedBox(height: 24),
              _sectionTitle("Offers & Discounts"),
              _buildAdsSection(),
              SizedBox(height: 24),
              _sectionTitle("Services Available", trailing: "View All"),
              _buildServicesSection(),
              SizedBox(height: 24),
              _sectionTitle("Nearby Shops"),
              _buildNearbyShopsSection(),
              SizedBox(height: 24),
              _sectionTitle("Popular Services"),
              _buildPopularServicesSection(),
              SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _sectionTitle(String title, {String? trailing}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: primary_colour_87,
              letterSpacing: -0.5,
            ),
          ),
          if (trailing != null)
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: primary_colour_87,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  trailing,
                  style: TextStyle(
                    fontSize: 12,
                    color: secondary_colour,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => locationScreen(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primary_colour_87, primary_colour_54],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: primary_colour_26,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, $userName",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: secondary_colour,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: secondary_colour_70,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "$user_location",
                        style: TextStyle(
                          fontSize: 14,
                          color: secondary_colour_70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MessagesListPage()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: secondary_colour.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.message_outlined,
                  size: 24,
                  color: secondary_colour,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndModeSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: secondary_colour,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: primary_colour_12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: Icon(
                      Icons.search_outlined,
                      color: primary_colour_54,
                      size: 20,
                    ),
                  ),
                  suffixIcon: Container(
                    padding: EdgeInsets.all(12),
                    child: Icon(Icons.mic, color: primary_colour_54, size: 20),
                  ),
                  hintText: "Shop / Service",
                  hintStyle: TextStyle(
                    color: tertiary_colour[400],
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Container(
            decoration: BoxDecoration(
              color: tertiary_colour[200],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primary_colour_12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _modeButton("Delivery", true),
                _modeButton("Pickup", false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeButton(String text, bool mode) {
    final selected = (mode == isDeliveryMode);
    return GestureDetector(
      onTap: () => setState(() => isDeliveryMode = mode),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? primary_colour_87 : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          boxShadow: selected
              ? [
            BoxShadow(
              color: primary_colour_26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? secondary_colour : primary_colour_54,
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildStoriesSection() {
    return Container(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 20),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [tertiary_colour[300]!, tertiary_colour[200]!],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primary_colour_12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.store_outlined,
                    color: tertiary_colour[600],
                    size: 32,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Shop ${index + 1}",
                  style: TextStyle(
                    fontSize: 13,
                    color: primary_colour_87,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final List<Map<String, dynamic>> navItems = [
      {
        'icon': Icons.home_outlined,
        'selectedIcon': Icons.home,
        'label': 'Home',
      },
      {
        'icon': Icons.location_on_outlined,
        'selectedIcon': Icons.location_on,
        'label': 'Nearby',
      },
      {
        'icon': Icons.shopping_cart_outlined,
        'selectedIcon': Icons.shopping_cart,
        'label': 'Cart',
      },
      {
        'icon': Icons.person_outline,
        'selectedIcon': Icons.person,
        'label': 'Profile',
      },
    ];

    return Container(
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary_colour,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primary_colour.withOpacity(0.15),
            blurRadius: 20,
            offset: Offset(0, -5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Container(
          height: 80,
          child: Row(
            children: navItems.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> item = entry.value;
              bool isSelected = _currentIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                    });

                    //Navigate of app bar
                    if (item['label'] == 'Home') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }

                    if (item['label'] == 'Nearby') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PinCodeInputPage()),
                      );
                    }

                    if (item['label'] == 'Cart') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    }

                    if (item['label'] == 'Profile') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [primary_colour_87, primary_colour_54],
                      )
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          padding: EdgeInsets.all(isSelected ? 8 : 6),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? secondary_colour.withOpacity(0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isSelected ? item['selectedIcon'] : item['icon'],
                            color: isSelected
                                ? tertiary_colour[600]
                                : secondary_colour,
                            size: isSelected ? 26 : 24,
                          ),
                        ),
                        SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: Duration(milliseconds: 200),
                          style: TextStyle(
                            fontSize: isSelected ? 12 : 11,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isSelected
                                ? tertiary_colour[600]
                                : secondary_colour,
                          ),
                          child: Text(item['label']),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildAdsSection() {
    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 20),
        itemCount: 3,
        itemBuilder: (context, index) {
          final colors = [
            [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
            [Color(0xFF3C3C3C), Color(0xFF2A2A2A)],
            [Color(0xFF1A1A1A), Color(0xFF000000)],
          ];

          return Container(
            margin: EdgeInsets.only(right: 16),
            width: 300,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors[index % colors.length],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primary_colour_12,
                  blurRadius: 15,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: secondary_colour.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "LIMITED TIME",
                          style: TextStyle(
                            color: secondary_colour,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    "50% OFF",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: secondary_colour,
                      letterSpacing: -1,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "On your first order from\nselected restaurants",
                    style: TextStyle(
                      color: secondary_colour_70,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: secondary_colour_70,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Valid till ${DateTime.now().add(Duration(days: 7)).day}/${DateTime.now().add(Duration(days: 7)).month}",
                        style: TextStyle(
                          fontSize: 12,
                          color: secondary_colour_70,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildServicesSection() {
    return Container(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.only(left: 20),
        itemCount: serviceCategories.length > 4 ? 4 : serviceCategories.length,
        itemBuilder: (context, index) {
          final service = serviceCategories[index];
          return Container(
            margin: EdgeInsets.only(right: 16),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: secondary_colour,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primary_colour_12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    service['icon'],
                    color: service['color'],
                    size: 32,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  service['name'],
                  style: TextStyle(
                    fontSize: 13,
                    color: primary_colour_87,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNearbyShopsSection() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20),
      itemCount: nearbyShops.length,
      itemBuilder: (context, index) {
        final shop = nearbyShops[index];
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: secondary_colour,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: primary_colour_12,
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [tertiary_colour[200]!, tertiary_colour[100]!],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(shop['icon'], color: primary_colour_87, size: 24),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            shop['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: primary_colour_87,
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: shop['isOpen']
                                  ? Colors.green
                                  : tertiary_colour,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        shop['category'],
                        style: TextStyle(
                          color: tertiary_colour[600],
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.star, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            "${shop['rating']}",
                            style: TextStyle(
                              fontSize: 13,
                              color: primary_colour_87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: tertiary_colour[600],
                          ),
                          SizedBox(width: 2),
                          Text(
                            shop['distance'],
                            style: TextStyle(
                              fontSize: 13,
                              color: tertiary_colour[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: tertiary_colour[400],
                  size: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopularServicesSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: popularServices.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 2.2,
        ),
        itemBuilder: (context, index) {
          final service = popularServices[index];
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: service['gradient'],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primary_colour_26,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: secondary_colour.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      service['icon'],
                      color: secondary_colour,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      service['name'],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: secondary_colour,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// NEW PINCODE INPUT PAGE
class PinCodeInputPage extends StatefulWidget {
  const PinCodeInputPage({super.key});

  @override
  State<PinCodeInputPage> createState() => _PinCodeInputPageState();
}

class _PinCodeInputPageState extends State<PinCodeInputPage> {
  final _pinController = TextEditingController();
  String? error;

  void _submit() {
    final pin = _pinController.text.trim();
    if (pin.isEmpty) {
      setState(() => error = "Please enter a pin code");
      return;
    }
    if (!ServiceData.isValidPinCode(pin)) {
      setState(() => error = "Invalid pin code");
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NearbyPage(pinCode: pin)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade400, Colors.blue.shade800],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.location_city,
                      size: 60,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Find Nearby Services",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _pinController,
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          decoration: InputDecoration(
                            labelText: "Pin Code",
                            prefixIcon: const Icon(Icons.pin_drop),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            counterText: "",
                            errorText: error,
                          ),
                          onChanged: (_) => setState(() => error = null),
                          onSubmitted: (_) => _submit(),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }
}