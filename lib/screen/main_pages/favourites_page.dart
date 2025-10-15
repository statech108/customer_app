import 'package:flutter/material.dart';
import '../../data/fake_data.dart';

class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  final MockDataService _mockDataService = MockDataService();

  @override
  Widget build(BuildContext context) {
    final User currentUser = _mockDataService.getCurrentUser();
    final List<String> favourites = currentUser.favourites;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Theme.of(context).colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Favorites", style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w700)),
      ),
      body: favourites.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              "No favorite items yet",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Start adding items to your favorites!",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: favourites.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildFavouriteItem(favourites[index], index, context);
        },
      ),
    );
  }

  Widget _buildFavouriteItem(String productId, int index, BuildContext context) {
    // Mock product data based on product ID
    final String productName = _getProductName(productId);
    final double price = _getProductPrice(productId);
    final String imageUrl = _getProductImage(productId);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 40,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  productName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Product ID: $productId",
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "₹${price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              IconButton(
                onPressed: () => _removeFromFavourites(index),
                icon: const Icon(Icons.favorite, color: Colors.red),
                tooltip: "Remove from favorites",
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Added $productName to cart")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getProductName(String productId) {
    final List<String> productNames = [
      'Laptop', 'Phone', 'Headphones', 'Tablet', 'Smart Watch', 
      'Camera', 'Speaker', 'Monitor', 'Keyboard', 'Mouse'
    ];
    final int hash = productId.hashCode;
    return productNames[hash.abs() % productNames.length];
  }

  double _getProductPrice(String productId) {
    final int hash = productId.hashCode;
    return (1000 + (hash.abs() % 50000)).toDouble();
  }

  String _getProductImage(String productId) {
    // In a real app, this would return actual image URLs
    return 'https://via.placeholder.com/150';
  }

  void _removeFromFavourites(int index) {
    final User currentUser = _mockDataService.getCurrentUser();
    currentUser.favourites.removeAt(index);
    _mockDataService.updateUser(currentUser);
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Removed from favorites")),
    );
  }
}
