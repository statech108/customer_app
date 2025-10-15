import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:demo_app/restaurant_data.dart';
import 'package:demo_app/data/color.dart';
import 'package:demo_app/data/fake_data.dart';
import 'home_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class NearbyPage extends StatefulWidget {
  final String pinCode;
  const NearbyPage({super.key, required this.pinCode});

  @override
  State<NearbyPage> createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  final _mapController = MapController();
  final _location = Location();
  final _sheetController = DraggableScrollableController();
  int _currentIndex = 1; // Nearby is at index 1

  late Map<String, List<Map<String, dynamic>>> allServices;
  List<Map<String, dynamic>> displayedServices = [];
  String? selectedCategory;
  List<Map<String, dynamic>> visibleServices = [];

  LocationData? currentLocation;
  bool locationGranted = false;
  bool showSummaryCard = false;

  static const Color primaryTeal = Color(0xFF008080);

  @override
  void initState() {
    super.initState();
    _loadServices();
    _requestLocation();
  }

  void _loadServices() {
    allServices = {
      for (String cat in ServiceData.categories)
        cat: ServiceData.getServices(widget.pinCode, cat)
    };
    selectedCategory = ServiceData.categories.isNotEmpty ? ServiceData.categories.first : null;
    _updateDisplayedServices();
  }

  Future<void> _requestLocation() async {
    try {
      final enabled = await _location.serviceEnabled() || await _location.requestService();
      if (!enabled) return;

      final permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        final newPerm = await _location.requestPermission();
        if (newPerm != PermissionStatus.granted) return;
      }

      setState(() => locationGranted = true);
      currentLocation = await _location.getLocation();

      _location.onLocationChanged.listen((loc) {
        if (mounted) {
          setState(() => currentLocation = loc);
        }
      });
    } catch (e) {
      debugPrint('Location error: $e');
    }
  }

  void _updateDisplayedServices() {
    final cat = selectedCategory;
    final services = cat != null
        ? List<Map<String, dynamic>>.from(allServices[cat] ?? const [])
        : <Map<String, dynamic>>[];
    setState(() => displayedServices = services);
    Future.delayed(const Duration(milliseconds: 100), _updateVisibleServices);
  }

  void _updateVisibleServices() {
    final bounds = _mapController.camera.visibleBounds;
    setState(() {
      visibleServices = displayedServices.where((s) {
        final pos = s["position"] as LatLng;
        return bounds.contains(pos);
      }).toList();
    });
  }

  void _navigateToScreen(int index, String label) {
    setState(() {
      _currentIndex = index;
    });

    switch (label) {
      case 'Home':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false,
        );
        break;
      case 'Nearby':
      // Already on nearby page, do nothing
        break;
      case 'Cart':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CartScreen()),
              (Route<dynamic> route) => false,
        );
        break;
      case 'Profile':
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
              (Route<dynamic> route) => false,
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Stack(
              children: [
                _buildMap(),
                Positioned(
                  right: screenWidth * 0.04,
                  bottom: screenHeight * 0.12,
                  child: _buildMyLocationBtn(),
                ),
                _buildServicesSheet(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + screenHeight * 0.01,
        left: screenWidth * 0.04,
        right: screenWidth * 0.04,
        bottom: screenHeight * 0.015,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                        (Route<dynamic> route) => false,
                  );
                },
              ),
              const Icon(Icons.location_on_rounded, color: primaryTeal, size: 30),
              const SizedBox(width: 1),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Current location',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    Text(
                      ServiceData.getLocationFromPinCode(widget.pinCode),
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SearchPage(services: displayedServices),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Search shops or services...',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          _buildCategoryChips(),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    final displayed = ServiceData.categories.take(4).toList();
    final hasMore = ServiceData.categories.length > 4;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...displayed.map((cat) {
            final helper = CategoryHelper(cat);
            final isSelected = selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategory = cat;
                    _updateDisplayedServices();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryTeal : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        helper.icon,
                        size: 16,
                        color: isSelected ? Colors.white : primaryTeal,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          if (hasMore)
            GestureDetector(
              onTap: () => _showAllCategories(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showAllCategories() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'All Categories',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ServiceData.categories.map((cat) {
                final helper = CategoryHelper(cat);
                final isSelected = selectedCategory == cat;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = cat;
                      _updateDisplayedServices();
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryTeal : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          helper.icon,
                          size: 16,
                          color: isSelected ? Colors.white : primaryTeal,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          cat,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: ServiceData.getCenter(widget.pinCode),
        initialZoom: 13.5,
        onTap: (tapPosition, point) {
          _sheetController.animateTo(
            0.12,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        onMapEvent: (e) {
          if (e is MapEventMove || e is MapEventMoveEnd) {
            _updateVisibleServices();
          }
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
          maxZoom: 20,
        ),
        MarkerLayer(markers: _buildMarkers()),
      ],
    );
  }

  List<Marker> _buildMarkers() {
    final markers = <Marker>[];

    for (final service in displayedServices) {
      final category = _getCategoryForService(service);
      final helper = CategoryHelper(category);
      final iconPath = service["icon"] as String?;
      final position = service["position"] as LatLng;

      markers.add(
        Marker(
          point: position,
          width: 48,
          height: 64,
          child: GestureDetector(
            onTap: () => _showDetail(service, helper),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryTeal, width: 2),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
                  ),
                  child: ClipOval(
                    child: iconPath != null
                        ? Image.asset(
                      iconPath,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(helper.icon, color: primaryTeal, size: 24),
                    )
                        : Icon(helper.icon, color: primaryTeal, size: 24),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (locationGranted && currentLocation != null) {
      markers.add(
        Marker(
          point: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
          width: 40,
          height: 40,
          child: Container(
            decoration: BoxDecoration(
              color: primaryTeal,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 6)],
            ),
            child: const Icon(Icons.my_location, color: Colors.white, size: 16),
          ),
        ),
      );
    }

    return markers;
  }

  String _getCategoryForService(Map<String, dynamic> service) {
    if (service.containsKey("cuisine")) return "Restaurant";
    if (service.containsKey("specialty")) {
      final spec = service["specialty"].toString();
      if (spec.contains("Plumb")) return "Plumber";
      if (spec.contains("Tailor")) return "Tailor";
      return "Mechanic";
    }
    if (service.containsKey("type")) {
      final type = service["type"].toString();
      if (type.contains("Supermarket") || type.contains("Store") || type.contains("Organic")) return "Groceries";
      if (type.contains("Unisex") || type.contains("Men") || type.contains("Women")) return "Saloon";
      if (type.contains("Branded") || type.contains("Local") || type.contains("Farm")) return "Doodhwala";
      return "Groceries";
    }
    return "Restaurant";
  }

  Widget _buildMyLocationBtn() {
    return FloatingActionButton.small(
      onPressed: () {
        if (currentLocation != null) {
          _mapController.move(
            LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            16.0,
          );
        }
      },
      backgroundColor: Colors.white,
      foregroundColor: primaryTeal,
      child: const Icon(Icons.my_location),
    );
  }

  Widget _buildServicesSheet() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.88,
      snap: true,
      snapSizes: const [0.12, 0.4, 0.88],
      shouldCloseOnMinExtent: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(screenWidth * 0.05),
                topRight: Radius.circular(screenWidth * 0.05),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: screenHeight * 0.02,
                  offset: Offset(0, -screenHeight * 0.006),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle - fixed and easy to grab
                GestureDetector(
                  onVerticalDragUpdate: (details) {
                    // Allow swiping from anywhere in the handle area
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: screenWidth * 0.12,
                          height: screenHeight * 0.006,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(screenHeight * 0.003),
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.01),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05,
                            vertical: screenHeight * 0.008,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.storefront,
                                color: primaryTeal,
                                size: screenWidth * 0.05,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Expanded(
                                child: Text(
                                  'Nearby (${displayedServices.length})',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.038,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.grey.shade500,
                                size: screenWidth * 0.05,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(height: 1, thickness: 0.5),
                // Content area
                if (displayedServices.isEmpty)
                  _buildEmptyState()
                else
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.04,
                      vertical: screenHeight * 0.01,
                    ),
                    itemCount: displayedServices.length,
                    itemBuilder: (_, int i) {
                      final s = displayedServices[i];
                      final cat = _getCategoryForService(s);
                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.006,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.035,
                            vertical: screenHeight * 0.008,
                          ),
                          leading: Container(
                            width: screenWidth * 0.1,
                            height: screenWidth * 0.1,
                            decoration: BoxDecoration(
                              color: primaryTeal.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(screenWidth * 0.02),
                            ),
                            child: Icon(
                              Icons.store,
                              color: primaryTeal,
                              size: screenWidth * 0.05,
                            ),
                          ),
                          title: Text(
                            s['name'] as String,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: screenWidth * 0.035,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            '$cat • ${s['distance'] as String}',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: screenWidth * 0.031,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: screenWidth * 0.04,
                          ),
                          onTap: () {
                            _mapController.move(s["position"], 16.0);
                            final helper = CategoryHelper(cat);
                            _showDetail(s, helper);
                          },
                        ),
                      );
                    },
                  ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.08),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store_outlined,
            size: screenWidth * 0.12,
            color: Colors.grey.shade400,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            'No shops in view',
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            'Move the map to see nearby shops',
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Colors.grey.shade500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showDetail(Map<String, dynamic> service, CategoryHelper helper) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => DetailSheet(service: service, helper: helper),
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
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primary_colour,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: primary_colour.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, -5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: SizedBox(
          height: 80,
          child: Row(
            children: navItems.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, dynamic> item = entry.value;
              bool isSelected = _currentIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _navigateToScreen(index, item['label']);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
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
                          duration: const Duration(milliseconds: 200),
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
                        const SizedBox(height: 4),
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 200),
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

class SearchPage extends StatefulWidget {
  final List<Map<String, dynamic>> services;
  const SearchPage({super.key, required this.services});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<Map<String, dynamic>> filtered;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    filtered = widget.services;
  }

  void _filter(String query) {
    final q = query.toLowerCase();
    setState(() {
      filtered = query.isEmpty
          ? widget.services
          : widget.services
          .where((s) =>
      s["name"].toString().toLowerCase().contains(q) ||
          s["address"].toString().toLowerCase().contains(q))
          .toList();
    });
  }

  String _getCategoryForService(Map<String, dynamic> service) {
    if (service.containsKey("cuisine")) return "Restaurant";
    if (service.containsKey("specialty")) {
      final spec = service["specialty"].toString();
      if (spec.contains("Plumb")) return "Plumber";
      if (spec.contains("Tailor")) return "Tailor";
      return "Mechanic";
    }
    if (service.containsKey("type")) {
      final type = service["type"].toString();
      if (type.contains("Supermarket") || type.contains("Store") || type.contains("Organic")) return "Groceries";
      if (type.contains("Unisex") || type.contains("Men") || type.contains("Women")) return "Saloon";
      if (type.contains("Branded") || type.contains("Local") || type.contains("Farm")) return "Doodhwala";
      return "Groceries";
    }
    return "Restaurant";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Services'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: _filter,
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      _filter('');
                    })
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
      body: filtered.isEmpty
          ? const Center(
          child: Text(
            "No services found",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: filtered.length,
        itemBuilder: (_, i) {
          final s = filtered[i];
          final cat = _getCategoryForService(s);
          final iconPath = s["icon"] as String?;

          return InkWell(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
                    (Route<dynamic> route) => false,
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF008080).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: iconPath != null
                          ? Image.asset(
                        iconPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.store,
                          color: Color(0xFF008080),
                          size: 24,
                        ),
                      )
                          : const Icon(
                        Icons.store,
                        color: Color(0xFF008080),
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s["name"],
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${s["rating"]} • $cat',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          s["address"],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class DetailSheet extends StatelessWidget {
  final Map<String, dynamic> service;
  final CategoryHelper helper;

  const DetailSheet({super.key, required this.service, required this.helper});

  Future<void> _openDirections() async {
    final lat = (service["position"] as LatLng).latitude;
    final lng = (service["position"] as LatLng).longitude;
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<void> _makeCall() async {
    final phone = service["phone"] ?? "1234567890";
    final url = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(url)) await launchUrl(url);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconPath = service["icon"] as String?;
    const primaryTeal = Color(0xFF008080);

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryTeal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: iconPath != null
                      ? Image.asset(
                    iconPath,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        Icon(helper.icon, color: primaryTeal, size: 32),
                  )
                      : Icon(helper.icon, color: primaryTeal, size: 32),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service["name"],
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          "${service["rating"]}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.red.shade400, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  service["address"],
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.directions_car, color: primaryTeal, size: 18),
              const SizedBox(width: 8),
              Text(
                service["distance"],
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          if (service["hours"] != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, color: primaryTeal, size: 18),
                const SizedBox(width: 8),
                Text(
                  service["hours"],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _openDirections,
                  icon: const Icon(Icons.directions),
                  label: const Text("Directions"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: primaryTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _makeCall,
                  icon: const Icon(Icons.phone),
                  label: const Text("Call"),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: primaryTeal, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CategoryHelper {
  final String category;

  CategoryHelper(this.category);

  IconData get icon {
    switch (category.toLowerCase()) {
      case 'restaurant':
        return Icons.restaurant;
      case 'groceries':
        return Icons.shopping_basket;
      case 'mechanic':
        return Icons.build;
      case 'saloon':
        return Icons.content_cut;
      case 'plumber':
        return Icons.plumbing;
      case 'doodhwala':
        return Icons.local_drink;
      case 'tailor':
        return Icons.checkroom;
      default:
        return Icons.store;
    }
  }
}