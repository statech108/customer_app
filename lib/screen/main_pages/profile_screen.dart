import 'package:demo_app/data/color.dart';
import 'package:demo_app/screen/main_pages/home_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isDarkMode = false;
  bool notificationsEnabled = true;
  int _currentIndex = 3;

  final List<Map<String, dynamic>> menuItems = [
    {
      'icon': Icons.person_outline,
      'title': 'Edit Profile',
      'subtitle': 'Update your personal information',
      'hasArrow': true,
    },
    {
      'icon': Icons.location_on_outlined,
      'title': 'My Addresses',
      'subtitle': 'Manage delivery addresses',
      'hasArrow': true,
    },
    {
      'icon': Icons.payment_outlined,
      'title': 'Payment Methods',
      'subtitle': 'Cards, wallets & more',
      'hasArrow': true,
    },
    {
      'icon': Icons.history_outlined,
      'title': 'Order History',
      'subtitle': 'View past orders',
      'hasArrow': true,
    },
    {
      'icon': Icons.favorite_border_outlined,
      'title': 'Favorites',
      'subtitle': 'Your liked items',
      'hasArrow': true,
    },
  ];

  final List<Map<String, dynamic>> settingsItems = [
    {
      'icon': Icons.notifications_outlined,
      'title': 'Notifications',
      'subtitle': 'Push notifications',
      'hasSwitch': true,
    },
    {
      'icon': Icons.dark_mode_outlined,
      'title': 'Dark Mode',
      'subtitle': 'Switch theme',
      'hasSwitch': true,
    },
    {
      'icon': Icons.language_outlined,
      'title': 'Language',
      'subtitle': 'English',
      'hasArrow': true,
    },
    {
      'icon': Icons.help_outline,
      'title': 'Help & Support',
      'subtitle': 'Get assistance',
      'hasArrow': true,
    },
    {
      'icon': Icons.info_outline,
      'title': 'About',
      'subtitle': 'App version 1.0.0',
      'hasArrow': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 20),
              _buildProfileCard(),
              SizedBox(height: 24),
              _buildStatsSection(),
              SizedBox(height: 24),
              _buildMenuSection("Account", menuItems),
              SizedBox(height: 20),
              _buildMenuSection("Settings", settingsItems),
              SizedBox(height: 20),
              _buildLogoutButton(),
              SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
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

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
          Spacer(),
          Text(
            "Profile",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
          Spacer(),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(Icons.edit_outlined, color: Colors.black87, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal[600]!, Colors.teal[800]!],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 3,
              ),
            ),
            child: ClipOval(
              child: Container(
                color: Colors.white.withOpacity(0.1),
                child: Icon(Icons.person, size: 40, color: Colors.white),
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Richa Kumari",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "john.doe@email.com",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Premium Member",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
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
      child: Row(
        children: [
          _buildStatItem("Orders", "24", Colors.black87),
          _buildStatDivider(),
          _buildStatItem("Reviews", "18", Colors.teal[600]!),
          _buildStatDivider(),
          _buildStatItem("Points", "1,250", Colors.black87),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.grey[200],
      margin: EdgeInsets.symmetric(horizontal: 10),
    );
  }

  Widget _buildMenuSection(String title, List<Map<String, dynamic>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
        ),
        Container(
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
            children: items.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> item = entry.value;
              bool isLast = index == items.length - 1;

              return _buildMenuItem(item, isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item, bool isLast) {
    return GestureDetector(
      onTap: item['hasArrow'] == true
          ? () {
              // Handle navigation
            }
          : null,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: !isLast
              ? Border(bottom: BorderSide(color: Colors.grey[100]!, width: 1))
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item['icon'], color: Colors.black87, size: 22),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['title'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  if (item['subtitle'] != null) ...[
                    SizedBox(height: 2),
                    Text(
                      item['subtitle'],
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item['hasArrow'] == true)
              Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 16),
            if (item['hasSwitch'] == true)
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: item['title'] == 'Notifications'
                      ? notificationsEnabled
                      : isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      if (item['title'] == 'Notifications') {
                        notificationsEnabled = value;
                      } else {
                        isDarkMode = value;
                      }
                    });
                  },
                  activeColor: Colors.teal[600],
                  activeTrackColor: Colors.teal[200],
                  inactiveThumbColor: Colors.grey[400],
                  inactiveTrackColor: Colors.grey[200],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          // Handle logout
        },
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.black87, Colors.black54],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 15,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout, color: Colors.white, size: 22),
              SizedBox(width: 12),
              Text(
                "Logout",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
