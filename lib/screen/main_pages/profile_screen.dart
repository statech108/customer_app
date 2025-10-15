import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/fake_data.dart';
import '../../data/color.dart';
import 'payment_methods_page.dart';
import 'favourites_page.dart';
import 'order_history_page.dart';
import 'language_page.dart';
import 'help_support_page.dart';
import 'about_page.dart';
import 'orders_reviews_credit_page.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'maps.dart';

// ====================
// DATA_MODEL for ProfileScreen
// ====================
class ProfileData extends ChangeNotifier {
  bool _notificationsEnabled = true;
  bool _isDarkMode = false;
  String _language = "English";
  
  final MockDataService _mockDataService = MockDataService();

  bool get notificationsEnabled => _notificationsEnabled;
  bool get isDarkMode => _isDarkMode;
  String get language => _language;

  // Get user data from MockDataService
  User get currentUser => _mockDataService.getCurrentUser();
  
  String get name => currentUser.username;
  String get email => currentUser.email;
  String get phone => currentUser.mobileNumber;

  List<Address> get addresses => currentUser.addresses;
  List<PaymentMethod> get paymentMethods => currentUser.paymentMethods;

  int get reviewCount => currentUser.reviews.length;
  double get averageRating => currentUser.reviews.isNotEmpty 
      ? currentUser.reviews.map((r) => r.rating).reduce((a, b) => a + b) / currentUser.reviews.length
      : 0.0;
  double get creditBalance => currentUser.credits;
  List<Review> get reviews => currentUser.reviews;

  void toggleNotifications(bool value) {
    _notificationsEnabled = value;
    notifyListeners();
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void setLanguage(String newLanguage) {
    _language = newLanguage;
    notifyListeners();
  }

  void updateProfile({required String name, required String email, required String phone}) {
    final User user = currentUser;
    user.username = name;
    user.email = email;
    user.mobileNumber = phone;
    _mockDataService.updateUser(user);
    notifyListeners();
  }
}


// ====================
// Profile Screen (Main Entry Point)
// ====================

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3; // Profile is at index 3
  
  final List<Map<String, dynamic>> _profileMenuItems = <Map<String, dynamic>>[
    {'title': 'Payment Methods', 'icon': Icons.credit_card_outlined, 'hasArrow': true},
    {'title': 'Order History', 'icon': Icons.history_outlined, 'hasArrow': true},
    {'title': 'Favorites', 'icon': Icons.favorite_border_outlined, 'hasArrow': true},
  ];

  // Helper method to dynamically generate settings menu items based on current state
  List<Map<String, dynamic>> _getSettingsMenuItems(ProfileData profileData) {
    return <Map<String, dynamic>>[
      {'title': 'Notifications', 'icon': Icons.notifications_none, 'hasSwitch': true},
      {'title': 'Dark Mode', 'icon': Icons.dark_mode_outlined, 'hasSwitch': true},
      {'title': 'Language', 'icon': Icons.language_outlined, 'subtitle': profileData.language, 'hasArrow': true},
      {'title': 'Help & Support', 'icon': Icons.help_outline, 'hasArrow': true},
      {'title': 'About', 'icon': Icons.info_outline, 'hasArrow': true},
      {'title': 'Logout', 'icon': Icons.logout_outlined, 'color': Colors.redAccent},
    ];
  }

  @override
  Widget build(BuildContext context) {
    final ProfileData profileData = Provider.of<ProfileData>(context);

    // Generate the settings menu items dynamically
    final List<Map<String, dynamic>> currentSettingsMenuItems = _getSettingsMenuItems(profileData);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: Text(
          "My Profile",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildProfileHeader(profileData, context),
            const SizedBox(height: 20),
            _buildQuickActionsGrid(profileData, context), // New quick actions grid
            const SizedBox(height: 20),
            _buildMenuSection("Account", _profileMenuItems, profileData, context),
            const SizedBox(height: 20),
            _buildMenuSection("Settings", currentSettingsMenuItems, profileData, context),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildProfileHeader(ProfileData profileData, BuildContext context) {
    // Determine primary address to display
    Address? primaryAddress;
    String addressText = "Add an address";
    if (profileData.addresses.isNotEmpty) {
      primaryAddress = profileData.addresses.first;
      addressText = "${primaryAddress.houseNumber}, ${primaryAddress.streetName}, ${primaryAddress.city}, ${primaryAddress.state} ${primaryAddress.pinCode}";
    }

    return Container(
      color: Theme.of(context).colorScheme.surface,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.teal,
            ),
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  profileData.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface),
                ),
                const SizedBox(height: 4),
                Text(
                  profileData.phone,
                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  profileData.email,
                  style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (BuildContext context) => MyAddressesPage()),
                    );
                  },
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.location_on_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          addressText,
                          style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.teal),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (BuildContext context) => EditProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid(ProfileData profileData, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildQuickActionItem(
              context,
              icon: Icons.shopping_bag_outlined,
              title: "Orders",
              value: "${profileData.currentUser.orders.length}",
              onTap: () {
                Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => OrderHistoryPage()));
              },
            ),
            VerticalDivider(color: Theme.of(context).colorScheme.outlineVariant, indent: 10, endIndent: 10),
            _buildQuickActionItem(
              context,
              icon: Icons.star_border,
              title: "Reviews",
              value: "${profileData.averageRating.toStringAsFixed(1)} (${profileData.reviewCount})",
              onTap: () {
                Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => OrdersReviewsCreditPage()));
              },
            ),
            VerticalDivider(color: Theme.of(context).colorScheme.outlineVariant, indent: 10, endIndent: 10),
            _buildQuickActionItem(
              context,
              icon: Icons.wallet_giftcard_outlined,
              title: "Credits",
              value: "₹${profileData.creditBalance.toStringAsFixed(2)}",
              onTap: () {
                Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => OrdersReviewsCreditPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(BuildContext context, {required IconData icon, required String title, required String value, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: Colors.teal, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuSection(String title, List<Map<String, dynamic>> items, ProfileData profileData, BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
          Divider(height: 1, indent: 20, endIndent: 20, color: Theme.of(context).colorScheme.outlineVariant),
          ...items.asMap().entries.map<Widget>((MapEntry<int, Map<String, dynamic>> entry) {
            final int index = entry.key;
            final Map<String, dynamic> item = entry.value;
            final bool isLast = index == items.length - 1;
            return _buildMenuItem(item, isLast, profileData, context);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item, bool isLast, ProfileData profileData, BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (item['title'] == 'Payment Methods') {
          Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => PaymentMethodsPage()));
        } else if (item['title'] == 'Order History') {
          Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => OrderHistoryPage()));
        } else if (item['title'] == 'Favorites') {
          Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => FavouritesPage()));
        } else if (item['title'] == 'Help & Support') {
          Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => HelpSupportPage()));
        } else if (item['title'] == 'Language') {
          Navigator.push(context, MaterialPageRoute<String>(builder: (BuildContext context) => LanguagePage())).then((String? selectedLanguage) {
            if (selectedLanguage != null) {
              profileData.setLanguage(selectedLanguage);
            }
          });
        } else if (item['title'] == 'About') {
          Navigator.push(context, MaterialPageRoute<void>(builder: (BuildContext context) => AboutPage()));
        } else if (item['title'] == 'Logout') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Logged out successfully!")),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: !isLast
              ? Border(bottom: BorderSide(color: Theme.of(context).colorScheme.outlineVariant, width: 1))
              : null,
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(item['icon'] as IconData, color: item['color'] as Color? ?? Colors.teal, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item['title'] as String,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: item['color'] as Color? ?? Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (item['subtitle'] != null && (item['subtitle'] as String).isNotEmpty) ...<Widget>[
                    const SizedBox(height: 2),
                    Text(
                      item['subtitle'] as String,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item['hasArrow'] == true)
              Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 16),
            if (item['hasSwitch'] == true)
              Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: item['title'] == 'Notifications'
                      ? profileData.notificationsEnabled
                      : profileData.isDarkMode,
                  onChanged: (bool value) {
                    if (item['title'] == 'Notifications') {
                      profileData.toggleNotifications(value);
                    } else {
                      profileData.toggleDarkMode(value);
                    }
                  },
                  activeColor: Colors.teal,
                  // ignore: deprecated_member_use
                  activeTrackColor: Colors.teal.withOpacity(0.5),
                  inactiveThumbColor: Colors.grey,
                  // ignore: deprecated_member_use
                  inactiveTrackColor: Colors.grey.withOpacity(0.3),
                ),
              ),
          ],
        ),
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }

                    if (item['label'] == 'Nearby') {
                      // Get pincode from fake data (user's address)
                      final MockDataService mockDataService = MockDataService();
                      final User currentUser = mockDataService.getCurrentUser();
                      String pincode = '110001'; // Default pincode
                      
                      // Get pincode from user's first address if available
                      if (currentUser.addresses.isNotEmpty) {
                        pincode = currentUser.addresses.first.pinCode;
                      }
                      
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => NearbyPage(pinCode: pincode)),
                      );
                    }

                    if (item['label'] == 'Cart') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    }

                    if (item['label'] == 'Profile') {
                      // Already on profile page, do nothing
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

}


// ====================
// 1. EDIT PROFILE PAGE
// ====================
class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    final ProfileData profileData = Provider.of<ProfileData>(context, listen: false);
    _nameController = TextEditingController(text: profileData.name);
    _emailController = TextEditingController(text: profileData.email);
    _phoneController = TextEditingController(text: profileData.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ProfileData profileData = Provider.of<ProfileData>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w700),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                profileData.updateProfile(
                  name: _nameController.text,
                  email: _emailController.text,
                  phone: _phoneController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Profile updated successfully!")),
                );
                Navigator.pop(context);
              }
            },
            child: const Text("Save", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              Stack(
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.teal,
                    ),
                    child: const Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Image picker not implemented")),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          shape: BoxShape.circle,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8,
                            )
                          ],
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.teal, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildTextField("Full Name", _nameController, Icons.person_outline, context),
                    const SizedBox(height: 20),
                    _buildTextField("Email", _emailController, Icons.email_outlined, context, keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 20),
                    _buildTextField("Phone", _phoneController, Icons.phone_outlined, context, keyboardType: TextInputType.phone),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const _AddressManagementTile(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, BuildContext context, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      validator: (String? value) => value == null || value.isEmpty ? "$label is required" : null,
    );
  }
}

class _AddressManagementTile extends StatelessWidget {
  const _AddressManagementTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: ListTile(
        leading: const Icon(Icons.location_on_outlined, color: Colors.teal),
        title: Text(
          "Manage Addresses",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        trailing: Icon(Icons.arrow_forward_ios, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (BuildContext context) => MyAddressesPage()),
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
}

// ====================
// 2. MY ADDRESSES PAGE
// ====================
class MyAddressesPage extends StatefulWidget {
  @override
  _MyAddressesPageState createState() => _MyAddressesPageState();
}

class _MyAddressesPageState extends State<MyAddressesPage> {
  @override
  Widget build(BuildContext context) {
    final ProfileData profileData = Provider.of<ProfileData>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("My Addresses", style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w700)),
      ),
      body: profileData.addresses.isEmpty
          ? Center(
        child: Text(
          "No addresses added yet.",
          style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: profileData.addresses.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildAddressCard(profileData.addresses[index], index, profileData, context);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final Address? newAddress = await Navigator.push<Address>(
            context,
            MaterialPageRoute<Address>(builder: (BuildContext context) => AddEditAddressPage()),
          );
          if (newAddress != null) {
            _addAddress(newAddress, profileData);
          }
        },
        backgroundColor: Colors.teal,
        label: const Text("Add Address", style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white)),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildAddressCard(Address address, int index, ProfileData profileData, BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              const Icon(Icons.location_on, color: Colors.teal),
              const SizedBox(width: 8),
              Text(address.tag, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface)),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text("${address.houseNumber}, ${address.streetName}, ${address.city}, ${address.state} ${address.pinCode}", style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 14)),
          const SizedBox(height: 16),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final Address? updatedAddress = await Navigator.push<Address>(
                      context,
                      MaterialPageRoute<Address>(builder: (BuildContext context) => AddEditAddressPage(address: address)),
                    );
                    if (updatedAddress != null) {
                      _updateAddress(index, updatedAddress, profileData);
                    }
                  },
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text("Edit"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.teal,
                    side: const BorderSide(color: Colors.teal),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _removeAddress(index, profileData);
                  },
                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                  label: const Text("Delete", style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.withOpacity(0.3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addAddress(Address address, ProfileData profileData) {
    final User user = profileData.currentUser;
    user.addresses.add(address);
    profileData._mockDataService.updateUser(user);
    setState(() {});
  }

  void _updateAddress(int index, Address updatedAddress, ProfileData profileData) {
    final User user = profileData.currentUser;
    user.addresses[index] = updatedAddress;
    profileData._mockDataService.updateUser(user);
    setState(() {});
  }

  void _removeAddress(int index, ProfileData profileData) {
    final User user = profileData.currentUser;
    user.addresses.removeAt(index);
    profileData._mockDataService.updateUser(user);
    setState(() {});
  }
}

// ====================
// 3. ADD/EDIT ADDRESS PAGE
// ====================
class AddEditAddressPage extends StatefulWidget {
  final Address? address;
  const AddEditAddressPage({super.key, this.address});

  @override
  _AddEditAddressPageState createState() => _AddEditAddressPageState();
}

class _AddEditAddressPageState extends State<AddEditAddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _typeController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipController;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: widget.address?.tag ?? '');
    _streetController = TextEditingController(text: widget.address?.streetName ?? '');
    _cityController = TextEditingController(text: widget.address?.city ?? '');
    _stateController = TextEditingController(text: widget.address?.state ?? '');
    _zipController = TextEditingController(text: widget.address?.pinCode ?? '');
    _isDefault = false; // We don't have isDefault in Address model
  }

  @override
  void dispose() {
    _typeController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.address == null ? "Add Address" : "Edit Address",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTextField("Address Type (Home/Work/Other)", _typeController, Icons.label_outline, context),
                const SizedBox(height: 20),
                _buildTextField("Street Address", _streetController, Icons.home_outlined, context),
                const SizedBox(height: 20),
                _buildTextField("City", _cityController, Icons.location_city_outlined, context),
                const SizedBox(height: 20),
                _buildTextField("State", _stateController, Icons.map_outlined, context),
                const SizedBox(height: 20),
                _buildTextField("ZIP Code", _zipController, Icons.pin_outlined, context, keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final Address newOrUpdatedAddress = Address(
                          houseNumber: _streetController.text,
                          streetName: _streetController.text,
                          city: _cityController.text,
                          state: _stateController.text,
                          pinCode: _zipController.text,
                          tag: _typeController.text,
                        );
                        Navigator.pop(context, newOrUpdatedAddress);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text(
                      widget.address == null ? "Save Address" : "Update Address",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, BuildContext context, {TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surface,
      ),
      validator: (String? value) => value == null || value.isEmpty ? "$label is required" : null,
    );
  }
}