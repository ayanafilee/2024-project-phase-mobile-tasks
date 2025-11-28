import 'package:flutter/material.dart';

// --- DATA MODEL ---

class Product {
  final String id;
  final String title;
  final String description;

  Product({required this.id, required this.title, required this.description});
}


void main() {
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce Nav Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,      // Requirement 2: Define Named Routes (Home is initial)
      initialRoute: '/',
      
      // Requirement 4: Navigation Animations using onGenerateRoute
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
            
          case '/add_edit':
            // Extract arguments if passed (for edit mode)
            final product = settings.arguments as Product?;
            return _createAnimatedRoute(AddEditProductScreen(product: product));
            
          case '/details':
            // Extract arguments (product to view)
            final product = settings.arguments as Product;
            return _createAnimatedRoute(ProductDetailScreen(product: product));
            
          default:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      },
    );
  }

  // Helper for Requirement 4: Smooth Slide Animation
  Route _createAnimatedRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide from right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}

// --- SCREEN 1: HOME SCREEN (List) ---

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dummy Data
  final List<Product> _products = [
    Product(id: '1', title: 'Laptop', description: 'High performance gaming laptop'),
    Product(id: '2', title: 'Smartphone', description: 'Latest model with 5G'),
  ];

  // Requirement 3: Passing Data (Receiving data back from Add/Edit screen)
  Future<void> _navigateToAddEdit({Product? product, int? index}) async {
    final result = await Navigator.pushNamed(
      context, 
      '/add_edit', 
      arguments: product // Pass existing product if editing
    );

    if (result != null && result is Product) {
      setState(() {
        if (index != null) {
          // Update existing
          _products[index] = result;
        } else {
          // Create new
          _products.add(result);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(index != null ? 'Product Updated' : 'Product Added')),
      );
    }
  }

  // Delete Functionality
  void _deleteProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Deleted')),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My E-commerce Shop')),
      body: _products.isEmpty 
        ? const Center(child: Text("No products yet."))
        : ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final prod = _products[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(prod.title),
                  subtitle: Text(prod.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                  // Requirement 1 & 2: Navigate to Details
                  onTap: () {
                    Navigator.pushNamed(context, '/details', arguments: prod);
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit Button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToAddEdit(product: prod, index: index),
                      ),
                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteProduct(index),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEdit(), // Add new
        child: const Icon(Icons.add),
      ),
    );
  }
}

// --- SCREEN 2: ADD/EDIT PRODUCT SCREEN ---

class AddEditProductScreen extends StatefulWidget {
  final Product? product; // If null, we are adding. If exists, we are editing.

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    // Requirement 3: Pre-fill data if editing
    _titleController = TextEditingController(text: widget.product?.title ?? '');
    _descController = TextEditingController(text: widget.product?.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      // Create updated or new product object
      final newProduct = Product(
        id: widget.product?.id ?? DateTime.now().toString(),
        title: _titleController.text,
        description: _descController.text,
      );

      // Requirement 3 & 5: Pass data back to previous screen and handle navigation
      Navigator.pop(context, newProduct);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Product' : 'Add Product'),
        // Requirement 5: Back button is automatically handled by AppBar
        // calling Navigator.pop(context), ensuring return to Home.
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Product Title', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter a title' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProduct,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  child: Text(isEditing ? 'Update Product' : 'Create Product'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// --- SCREEN 3: PRODUCT DETAILS SCREEN ---

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Icon(Icons.shopping_bag, size: 80, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Text(
              product.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Product ID: ${product.id}",
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 30),
            const Text(
              "Description:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 5),
            Text(
              product.description,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}