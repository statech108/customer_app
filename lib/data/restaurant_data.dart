import 'package:latlong2/latlong.dart';

class ServiceData {
  // Valid pin codes
  static const List<String> validPinCodes = [
    '151001',
    '431001',
    '111000',
    '000111',
  ];

  // Available categories
  static const List<String> categories = [
    'Restaurant',
    'Groceries',
    'Mechanic',
    'Saloon',
    'Plumber',
    'Doodhwala',
    'Tailor',
  ];

  // Check if pin code is valid
  static bool isValidPinCode(String pin) {
    return validPinCodes.contains(pin);
  }

  // Get location name from pin code
  static String getLocationFromPinCode(String pinCode) {
    final locationMap = {
      '151001': 'Bathinda, Punjab, 151001',
      '431001': 'Aurangabad, Maharashtra, 431001',
      '111000': 'New Delhi, Delhi, 111000',
      '000111': 'Bangalore, Karnataka, 000111',
    };
    return locationMap[pinCode] ?? 'Unknown Location, $pinCode';
  }

  // Center of map for each pin code
  static LatLng getCenter(String pin) {
    switch (pin) {
      case '151001':
        return const LatLng(30.2374310, 74.9461900); // Bathinda
      case '431001':
        return const LatLng(19.8540, 76.8012); // Aurangabad
      case '111000':
        return const LatLng(28.6139, 77.2090); // Delhi
      case '000111':
        return const LatLng(12.9716, 77.5946); // Bangalore
      default:
        return const LatLng(28.6139, 77.2090); // Default
    }
  }

  // Get services by category and pin code
  static List<Map<String, dynamic>> getServices(String pin, String category) {
    switch (category.toLowerCase()) {
      case 'restaurant':
        return _getRestaurants(pin);
      case 'groceries':
        return _getGroceries(pin);
      case 'mechanic':
        return _getMechanics(pin);
      case 'saloon':
        return _getSaloons(pin);
      case 'plumber':
        return _getPlumbers(pin);
      case 'doodhwala':
        return _getDoodhwalas(pin);
      case 'tailor':
        return _getTailors(pin);
      default:
        return [];
    }
  }

  // RESTAURANTS
  static List<Map<String, dynamic>> _getRestaurants(String pin) {
    switch (pin) {
      case '151001':
        return [
          {
            "name": "The Spice House",
            "position": const LatLng(30.2380, 74.9470),
            "icon": "lib/assets/restaurant1.png",
            "cuisine": "Indian",
            "rating": 4.5,
            "address": "123 Main Street, Bathinda",
            "distance": "1.2 km",
            "phone": "9876543210",
          },
          {
            "name": "Cafe Delight",
            "position": const LatLng(30.2360, 74.9450),
            "icon": "lib/assets/restaurant1.png",
            "cuisine": "Cafe",
            "rating": 4.2,
            "address": "45 Park Lane, Bathinda",
            "distance": "1.8 km",
            "phone": "9876543211",
          },
          {
            "name": "Dragon House",
            "position": const LatLng(30.2340, 74.9440),
            "icon": "lib/assets/restaurant1.png",
            "cuisine": "Chinese",
            "rating": 4.1,
            "address": "78 Food Street, Bathinda",
            "distance": "2.3 km",
            "phone": "9876543212",
          },
          {
            "name": "Pizza Express",
            "position": const LatLng(30.2370, 74.9480),
            "icon": "lib/assets/restaurant1.png",
            "cuisine": "Italian",
            "rating": 4.4,
            "address": "34 Central Avenue, Bathinda",
            "distance": "3.1 km",
            "phone": "9876543214",
          },
        ];
      case '431001':
        return [
          {
            "name": "Savoury Bites",
            "position": const LatLng(19.8550, 76.8030),
            "icon": "lib/assets/restaurant1.png",
            "cuisine": "Chinese",
            "rating": 4.0,
            "address": "12 River Road, Aurangabad",
            "distance": "1.5 km",
            "phone": "9876543228",
          },
          {
            "name": "Maharaja Thali",
            "position": const LatLng(19.8560, 76.8050),
            "icon": "lib/assets/restaurant1.png",
            "cuisine": "Indian",
            "rating": 4.5,
            "address": "45 Heritage Lane, Aurangabad",
            "distance": "2.5 km",
            "phone": "9876543230",
          },
        ];
      default:
        return [];
    }
  }

  // GROCERIES
  static List<Map<String, dynamic>> _getGroceries(String pin) {
    switch (pin) {
      case '151001':
        return [
          {
            "name": "Fresh Mart",
            "position": const LatLng(30.2385, 74.9465),
            "icon": "lib/assets/grocery1.png",
            "type": "Supermarket",
            "rating": 4.3,
            "address": "156 Mall Road, Bathinda",
            "distance": "0.8 km",
            "phone": "9876543240",
            "hours": "8 AM - 10 PM",
          },
          {
            "name": "Daily Needs Store",
            "position": const LatLng(30.2365, 74.9455),
            "icon": "lib/assets/grocery1.png",
            "type": "General Store",
            "rating": 4.1,
            "address": "89 Model Town, Bathinda",
            "distance": "1.5 km",
            "phone": "9876543241",
            "hours": "7 AM - 9 PM",
          },
          {
            "name": "Big Basket Corner",
            "position": const LatLng(30.2350, 74.9445),
            "icon": "lib/assets/grocery1.png",
            "type": "Supermarket",
            "rating": 4.4,
            "address": "234 Gandhi Nagar, Bathinda",
            "distance": "2.1 km",
            "phone": "9876543242",
            "hours": "8 AM - 11 PM",
          },
          {
            "name": "Green Valley Grocers",
            "position": const LatLng(30.2395, 74.9485),
            "icon": "lib/assets/grocery1.png",
            "type": "Organic Store",
            "rating": 4.6,
            "address": "67 Rose Garden, Bathinda",
            "distance": "1.3 km",
            "phone": "9876543243",
            "hours": "9 AM - 8 PM",
          },
        ];
      case '431001':
        return [
          {
            "name": "Reliance Fresh",
            "position": const LatLng(19.8545, 76.8020),
            "icon": "lib/assets/grocery1.png",
            "type": "Supermarket",
            "rating": 4.2,
            "address": "78 Station Road, Aurangabad",
            "distance": "1.2 km",
            "phone": "9876543244",
            "hours": "8 AM - 10 PM",
          },
        ];
      default:
        return [];
    }
  }

  // MECHANICS
  static List<Map<String, dynamic>> _getMechanics(String pin) {
    switch (pin) {
      case '151001':
        return [
          {
            "name": "Kumar Auto Works",
            "position": const LatLng(30.2355, 74.9475),
            "icon": "lib/assets/mechanic1.png",
            "specialty": "Car & Bike",
            "rating": 4.4,
            "address": "45 Industrial Area, Bathinda",
            "distance": "1.9 km",
            "phone": "9876543250",
            "hours": "9 AM - 7 PM",
          },
          {
            "name": "Speed Motors",
            "position": const LatLng(30.2345, 74.9460),
            "icon": "lib/assets/mechanic1.png",
            "specialty": "Two Wheeler",
            "rating": 4.2,
            "address": "12 Mandi Road, Bathinda",
            "distance": "2.4 km",
            "phone": "9876543251",
            "hours": "8 AM - 8 PM",
          },
          {
            "name": "Expert Car Care",
            "position": const LatLng(30.2390, 74.9490),
            "icon": "lib/assets/mechanic1.png",
            "specialty": "Car Service",
            "rating": 4.5,
            "address": "89 Highway Plaza, Bathinda",
            "distance": "1.6 km",
            "phone": "9876543252",
            "hours": "9 AM - 6 PM",
          },
        ];
      case '431001':
        return [
          {
            "name": "City Auto Repair",
            "position": const LatLng(19.8535, 76.8025),
            "icon": "lib/assets/mechanic1.png",
            "specialty": "All Vehicles",
            "rating": 4.3,
            "address": "23 Workshop Lane, Aurangabad",
            "distance": "1.8 km",
            "phone": "9876543253",
            "hours": "9 AM - 7 PM",
          },
        ];
      default:
        return [];
    }
  }

  // SALOONS
  static List<Map<String, dynamic>> _getSaloons(String pin) {
    switch (pin) {
      case '151001':
        return [
          {
            "name": "Style Studio",
            "position": const LatLng(30.2375, 74.9468),
            "icon": "lib/assets/saloon1.png",
            "type": "Unisex",
            "rating": 4.5,
            "address": "56 Fashion Street, Bathinda",
            "distance": "1.0 km",
            "phone": "9876543260",
            "hours": "10 AM - 8 PM",
          },
          {
            "name": "Gents Corner",
            "position": const LatLng(30.2368, 74.9458),
            "icon": "lib/assets/saloon1.png",
            "type": "Men",
            "rating": 4.2,
            "address": "34 Market Square, Bathinda",
            "distance": "1.4 km",
            "phone": "9876543261",
            "hours": "9 AM - 9 PM",
          },
          {
            "name": "Beauty Parlour & Spa",
            "position": const LatLng(30.2388, 74.9478),
            "icon": "lib/assets/saloon1.png",
            "type": "Women",
            "rating": 4.6,
            "address": "78 Ladies Plaza, Bathinda",
            "distance": "1.2 km",
            "phone": "9876543262",
            "hours": "10 AM - 7 PM",
          },
        ];
      case '431001':
        return [
          {
            "name": "Royal Cuts",
            "position": const LatLng(19.8548, 76.8018),
            "icon": "lib/assets/saloon1.png",
            "type": "Unisex",
            "rating": 4.4,
            "address": "45 City Center, Aurangabad",
            "distance": "1.3 km",
            "phone": "9876543263",
            "hours": "10 AM - 8 PM",
          },
        ];
      default:
        return [];
    }
  }

  // PLUMBERS
  static List<Map<String, dynamic>> _getPlumbers(String pin) {
    switch (pin) {
      case '151001':
        return [
          {
            "name": "Quick Fix Plumbing",
            "position": const LatLng(30.2382, 74.9472),
            "icon": "lib/assets/plumber1.png",
            "specialty": "24/7 Service",
            "rating": 4.4,
            "address": "23 Service Lane, Bathinda",
            "distance": "1.1 km",
            "phone": "9876543270",
            "hours": "24 Hours",
          },
          {
            "name": "Singh Plumbing Works",
            "position": const LatLng(30.2358, 74.9452),
            "icon": "lib/assets/plumber1.png",
            "specialty": "Residential",
            "rating": 4.3,
            "address": "67 Colony Road, Bathinda",
            "distance": "1.7 km",
            "phone": "9876543271",
            "hours": "8 AM - 6 PM",
          },
          {
            "name": "Expert Pipe Solutions",
            "position": const LatLng(30.2392, 74.9482),
            "icon": "lib/assets/plumber1.png",
            "specialty": "Commercial",
            "rating": 4.5,
            "address": "91 Builder Colony, Bathinda",
            "distance": "1.5 km",
            "phone": "9876543272",
            "hours": "9 AM - 7 PM",
          },
        ];
      case '431001':
        return [
          {
            "name": "Fast Plumber Service",
            "position": const LatLng(19.8542, 76.8015),
            "icon": "lib/assets/plumber1.png",
            "specialty": "Emergency",
            "rating": 4.2,
            "address": "34 Service Road, Aurangabad",
            "distance": "1.4 km",
            "phone": "9876543273",
            "hours": "24 Hours",
          },
        ];
      default:
        return [];
    }
  }

  // DOODHWALAS (Milk Vendors)
  static List<Map<String, dynamic>> _getDoodhwalas(String pin) {
    switch (pin) {
      case '151001':
        return [
          {
            "name": "Verka Dairy",
            "position": const LatLng(30.2378, 74.9466),
            "icon": "lib/assets/milk1.png",
            "type": "Branded",
            "rating": 4.6,
            "address": "12 Dairy Farm Road, Bathinda",
            "distance": "1.0 km",
            "phone": "9876543280",
            "hours": "5 AM - 10 AM, 5 PM - 8 PM",
          },
          {
            "name": "Pure Milk Dairy",
            "position": const LatLng(30.2362, 74.9448),
            "icon": "lib/assets/milk1.png",
            "type": "Local",
            "rating": 4.4,
            "address": "45 Village Road, Bathinda",
            "distance": "1.6 km",
            "phone": "9876543281",
            "hours": "6 AM - 9 AM, 6 PM - 8 PM",
          },
          {
            "name": "Fresh Cow Milk",
            "position": const LatLng(30.2395, 74.9488),
            "icon": "lib/assets/milk1.png",
            "type": "Farm Fresh",
            "rating": 4.5,
            "address": "78 Farm House, Bathinda",
            "distance": "1.3 km",
            "phone": "9876543282",
            "hours": "5 AM - 8 AM",
          },
        ];
      case '431001':
        return [
          {
            "name": "Amul Dairy Point",
            "position": const LatLng(19.8546, 76.8022),
            "icon": "lib/assets/milk1.png",
            "type": "Branded",
            "rating": 4.5,
            "address": "56 Main Road, Aurangabad",
            "distance": "1.1 km",
            "phone": "9876543283",
            "hours": "5 AM - 10 AM, 5 PM - 8 PM",
          },
        ];
      default:
        return [];
    }
  }

  // TAILORS
  static List<Map<String, dynamic>> _getTailors(String pin) {
    switch (pin) {
      case '151001':
        return [
          {
            "name": "Royal Tailors",
            "position": const LatLng(30.2372, 74.9463),
            "icon": "lib/assets/tailor1.png",
            "specialty": "Suits & Shirts",
            "rating": 4.5,
            "address": "34 Cloth Market, Bathinda",
            "distance": "1.1 km",
            "phone": "9876543290",
            "hours": "10 AM - 8 PM",
          },
          {
            "name": "Ladies Fashion Boutique",
            "position": const LatLng(30.2366, 74.9456),
            "icon": "lib/assets/tailor1.png",
            "specialty": "Women's Wear",
            "rating": 4.6,
            "address": "67 Designer Plaza, Bathinda",
            "distance": "1.5 km",
            "phone": "9876543291",
            "hours": "11 AM - 7 PM",
          },
          {
            "name": "Quick Stitch",
            "position": const LatLng(30.2387, 74.9477),
            "icon": "lib/assets/tailor1.png",
            "specialty": "Alterations",
            "rating": 4.3,
            "address": "23 Market Lane, Bathinda",
            "distance": "1.2 km",
            "phone": "9876543292",
            "hours": "9 AM - 9 PM",
          },
        ];
      case '431001':
        return [
          {
            "name": "Master Tailor",
            "position": const LatLng(19.8543, 76.8019),
            "icon": "lib/assets/tailor1.png",
            "specialty": "Traditional Wear",
            "rating": 4.4,
            "address": "45 Bazaar Street, Aurangabad",
            "distance": "1.2 km",
            "phone": "9876543293",
            "hours": "10 AM - 8 PM",
          },
        ];
      default:
        return [];
    }
  }
}