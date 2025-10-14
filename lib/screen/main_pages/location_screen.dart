import 'package:flutter/material.dart';

// Main Location Selection Page
class locationScreen extends StatefulWidget {
  @override
  _locationScreenState createState() => _locationScreenState();
}

class _locationScreenState extends State<locationScreen> {
  final TextEditingController _searchController = TextEditingController();
  String currentLocation = 'Model Town, Bathinda, Punjab';

  // Sample saved addresses
  List<Map<String, dynamic>> savedAddresses = [
    {
      'id': '1',
      'type': 'Home',
      'address': 'House No. 123, Model Town, Bathinda, Punjab',
      'landmark': 'Near City Hospital',
      'icon': Icons.home,
      'isSelected': true,
    },
    {
      'id': '2',
      'type': 'Work',
      'address': 'Office Complex, Mall Road, Bathinda, Punjab',
      'landmark': 'Opposite to Central Mall',
      'icon': Icons.work,
      'isSelected': false,
    },
    {
      'id': '3',
      'type': 'Other',
      'address': 'Sector 15, Urban Estate, Bathinda, Punjab',
      'landmark': 'Near Gurudwara',
      'icon': Icons.location_on,
      'isSelected': false,
    },
  ];

  // Sample recent searches
  List<String> recentSearches = [
    'Rose Garden, Bathinda',
    'Civil Hospital, Bathinda',
    'Bus Stand, Bathinda',
    'Railway Station, Bathinda',
  ];

  void _selectAddress(String addressId) {
    setState(() {
      for (var address in savedAddresses) {
        address['isSelected'] = address['id'] == addressId;
        if (address['isSelected']) {
          currentLocation = address['address'];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Select Location',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for area, street name...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.teal),
                suffixIcon: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapLocationPage(),
                      ),
                    );
                  },
                  icon: Icon(Icons.my_location, color: Colors.teal),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Current Location Button
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapLocationPage()),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.teal),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.teal.withOpacity(0.1),
                ),
                child: Row(
                  children: [
                    Icon(Icons.my_location, color: Colors.teal),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Use current location',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.teal,
                            ),
                          ),
                          Text(
                            'Enable location for better experience',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.teal.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.teal, size: 16),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          // Saved Addresses
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Saved Addresses',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddAddressPage(),
                              ),
                            );
                          },
                          child: Text(
                            'Add New',
                            style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Address List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemCount: savedAddresses.length,
                    itemBuilder: (context, index) {
                      final address = savedAddresses[index];
                      return _buildAddressTile(address);
                    },
                  ),

                  SizedBox(height: 20),

                  // Recent Searches
                  if (recentSearches.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Recent Searches',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      itemCount: recentSearches.length,
                      itemBuilder: (context, index) {
                        return _buildRecentSearchTile(recentSearches[index]);
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Confirm Button
          Container(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, currentLocation);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Confirm Location',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressTile(Map<String, dynamic> address) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _selectAddress(address['id']),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: address['isSelected'] ? Colors.teal : Colors.grey[300]!,
              width: address['isSelected'] ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: address['isSelected']
                ? Colors.teal.withOpacity(0.1)
                : Colors.white,
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: address['isSelected'] ? Colors.teal : Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  address['icon'],
                  color: address['isSelected']
                      ? Colors.white
                      : Colors.grey[600],
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address['type'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: address['isSelected']
                            ? Colors.teal
                            : Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      address['address'],
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    if (address['landmark'].isNotEmpty) ...[
                      SizedBox(height: 2),
                      Text(
                        address['landmark'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
              if (address['isSelected'])
                Icon(Icons.check_circle, color: Colors.teal),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentSearchTile(String search) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          _searchController.text = search;
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.history, color: Colors.grey[600], size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  search,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Map Location Page
class MapLocationPage extends StatefulWidget {
  @override
  _MapLocationPageState createState() => _MapLocationPageState();
}

class _MapLocationPageState extends State<MapLocationPage> {
  String selectedAddress = 'Model Town, Bathinda, Punjab';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Select on Map',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Map Placeholder
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[200],
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 80, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'Interactive Map View',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Drag to select location',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                // Center Pin
                Center(
                  child: Icon(Icons.location_pin, size: 40, color: Colors.teal),
                ),
              ],
            ),
          ),

          // Current Location Button
          Positioned(
            top: 20,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.white,
              foregroundColor: Colors.teal,
              mini: true,
              child: Icon(Icons.my_location),
            ),
          ),

          // Bottom Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_pin, color: Colors.teal),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Selected Location',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    selectedAddress,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddAddressPage(
                                  prefilledAddress: selectedAddress,
                                ),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.teal,
                            side: BorderSide(color: Colors.teal),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Add Details'),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context, selectedAddress);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('Confirm'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Add Address Page
class AddAddressPage extends StatefulWidget {
  final String? prefilledAddress;

  const AddAddressPage({Key? key, this.prefilledAddress}) : super(key: key);

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final TextEditingController _houseController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String selectedType = 'Home';
  List<String> addressTypes = ['Home', 'Work', 'Other'];

  @override
  void initState() {
    super.initState();
    if (widget.prefilledAddress != null) {
      _areaController.text = widget.prefilledAddress!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Add New Address',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Address Type Selection
            Text(
              'Address Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: addressTypes.map((type) {
                final isSelected = selectedType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedType = type),
                    child: Container(
                      margin: EdgeInsets.only(
                        right: type != addressTypes.last ? 8 : 0,
                      ),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.teal : Colors.white,
                        border: Border.all(
                          color: isSelected ? Colors.teal : Colors.grey[400]!,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            SizedBox(height: 24),

            // Address Fields
            _buildTextField(
              controller: _houseController,
              label: 'House No. / Building Name',
              hint: 'Enter house number or building name',
            ),

            SizedBox(height: 16),

            _buildTextField(
              controller: _areaController,
              label: 'Area / Sector / Locality',
              hint: 'Enter area or locality',
            ),

            SizedBox(height: 16),

            _buildTextField(
              controller: _landmarkController,
              label: 'Landmark (Optional)',
              hint: 'Nearby landmark for easy location',
            ),

            SizedBox(height: 24),

            // Contact Information
            Text(
              'Contact Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12),

            _buildTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter recipient name',
            ),

            SizedBox(height: 16),

            _buildTextField(
              controller: _phoneController,
              label: 'Phone Number',
              hint: 'Enter phone number',
              keyboardType: TextInputType.phone,
            ),

            SizedBox(height: 40),

            // Save Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  // Validate and save address
                  if (_validateForm()) {
                    _saveAddress();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Save Address',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[600]),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool _validateForm() {
    if (_houseController.text.trim().isEmpty ||
        _areaController.text.trim().isEmpty ||
        _nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  void _saveAddress() {
    // Here you would typically save to database
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Address saved successfully!'),
        backgroundColor: Colors.teal,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _houseController.dispose();
    _areaController.dispose();
    _landmarkController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
