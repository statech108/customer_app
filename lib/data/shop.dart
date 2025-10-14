import 'package:demo_app/data/color.dart';
import 'package:flutter/material.dart';

//Nearby Shops
final List<Map<String, dynamic>> nearbyShops = [
  {
    'name': 'Bhabhi',
    'category': 'Grocery',
    'rating': 4.3,
    'distance': '1.2km',
    'icon': Icons.local_grocery_store,
    'description': 'Near Engineering College',
    'isOpen': true,
  },
  {
    'name': 'Prince',
    'category': 'Restaurant',
    'rating': 4.2,
    'distance': '1.3km',
    'icon': Icons.restaurant,
    'isOpen': true,
  },
  {
    'name': 'College Stationary',
    'category': 'Stationary',
    'rating': 4.9,
    'distance': '200m',
    'icon': Icons.shopping_bag,
    'isOpen': true,
  },
  {
    'name': 'Sneakker',
    'category': 'Restaurant',
    'rating': 4.5,
    'distance': '900m',
    'icon': Icons.fastfood,
    'isOpen': false,
  },
];

//Popular Services
final List<Map<String, dynamic>> popularServices = [
  {
    'name': 'Grocery',
    'icon': Icons.shopping_cart_outlined,
    'gradient': [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
  },
  {
    'name': 'Beauty Products',
    'icon': Icons.face_retouching_natural,
    'gradient': [Color(0xFF3C3C3C), Color(0xFF2A2A2A)],
  },
  {
    'name': 'Salon',
    'icon': Icons.content_cut,
    'gradient': [Color(0xFF2C2C2C), Color(0xFF1A1A1A)],
  },
  {
    'name': 'Tailoring & Laundry',
    'icon': Icons.dry_cleaning,
    'gradient': [Color(0xFF3C3C3C), Color(0xFF2A2A2A)],
  },
];

//Service Available
final List<Map<String, dynamic>> serviceCategories = [
  {
    'name': 'Grocery',
    'icon': Icons.shopping_basket_outlined,
    'color': primary_colour_87,
  },
  {
    'name': 'Tailor',
    'icon': Icons.content_cut_outlined,
    'color': primary_colour_87,
  },
  {'name': 'Salon', 'icon': Icons.face_outlined, 'color': primary_colour_87},
  {
    'name': 'Home Service',
    'icon': Icons.home_repair_service_outlined,
    'color': primary_colour_87,
  },
  {
    'name': 'Laundry',
    'icon': Icons.local_laundry_service_outlined,
    'color': primary_colour_87,
  },
];
