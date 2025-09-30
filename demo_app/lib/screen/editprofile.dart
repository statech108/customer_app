import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final _firstNameController = TextEditingController(text: 'John');
  final _lastNameController = TextEditingController(text: 'Doe');
  final _emailController = TextEditingController(text: 'john.doe@example.com');
  final _phoneController = TextEditingController(text: '+1 (555) 123-4567');
  final _locationController = TextEditingController(text: 'San Francisco, CA');
  final _websiteController = TextEditingController(text: 'https://johndoe.dev');
  final _companyController = TextEditingController(text: 'Tech Corp');
  final _jobTitleController = TextEditingController(text: 'Senior Developer');
  final _bioController = TextEditingController(
    text:
        'Passionate developer and designer with a love for creating beautiful, functional experiences.',
  );

  DateTime _selectedDate = DateTime(1990, 1, 15);
  String _profileImageUrl =
      'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-1.2.1&auto=format&fit=crop&w=256&h=256&q=80';

  // Color scheme
  static const Color primaryBlack = Color(0xFF000000);
  static const Color primaryTeal = Color(0xFF14B8A6);
  static const Color lightGray = Color(0xFF1F2937);
  static const Color darkGray = Color(0xFF111827);
  static const Color textGray = Color(0xFF9CA3AF);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    _companyController.dispose();
    _jobTitleController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Handle save logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully!'),
          backgroundColor: primaryTeal,
        ),
      );
    }
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: primaryTeal,
              surface: lightGray,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isMultiline = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: textGray,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: isMultiline ? 4 : 1,
          validator: validator,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: textGray, size: 20),
            filled: true,
            fillColor: primaryBlack,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: lightGray),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: lightGray),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: primaryTeal, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBlack,
      appBar: AppBar(
        backgroundColor: darkGray,
        elevation: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: primaryTeal,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          TextButton.icon(
            onPressed: _saveProfile,
            icon: const Icon(Icons.save, color: primaryTeal, size: 18),
            label: const Text(
              'Save',
              style: TextStyle(color: primaryTeal, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Profile Image Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: darkGray,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: lightGray),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Profile Picture',
                      style: TextStyle(
                        color: primaryTeal,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: primaryTeal,
                          child: CircleAvatar(
                            radius: 56,
                            backgroundImage: NetworkImage(_profileImageUrl),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: primaryTeal,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Handle image change
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: lightGray,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Change Photo'),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'JPG, PNG or GIF. Max size 5MB.',
                      style: TextStyle(color: textGray, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Personal Information Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: darkGray,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: lightGray),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Personal Information',
                      style: TextStyle(
                        color: primaryTeal,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // First Name and Last Name Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _firstNameController,
                            label: 'First Name',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _lastNameController,
                            label: 'Last Name',
                            icon: Icons.person_outline,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Email
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Phone
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),

                    const SizedBox(height: 20),

                    // Location
                    _buildTextField(
                      controller: _locationController,
                      label: 'Location',
                      icon: Icons.location_on_outlined,
                    ),

                    const SizedBox(height: 20),

                    // Birth Date
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Birth Date',
                          style: TextStyle(
                            color: textGray,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: _selectDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: primaryBlack,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: lightGray),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: textGray,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Website
                    _buildTextField(
                      controller: _websiteController,
                      label: 'Website',
                      icon: Icons.language_outlined,
                      keyboardType: TextInputType.url,
                    ),

                    const SizedBox(height: 20),

                    // Company and Job Title Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _companyController,
                            label: 'Company',
                            icon: Icons.business_outlined,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _jobTitleController,
                            label: 'Job Title',
                            icon: Icons.work_outline,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Bio
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTextField(
                          controller: _bioController,
                          label: 'Bio',
                          icon: Icons.description_outlined,
                          isMultiline: true,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_bioController.text.length}/500 characters',
                          style: const TextStyle(color: textGray, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryTeal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
