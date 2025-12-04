import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ==========================================
// 1. DOMAIN LAYER (Entities & Use Cases)
// ==========================================

// --- ENTITY ---
class Product {
  final String id;
  final String name; 
  final String description;
  final String imageUrl; // Image URL is now a local asset path
  final double price; 

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
  });
}

// --- REPOSITORY INTERFACE (Contract) ---
abstract class ProductRepository {
  Future<List<Product>> getAllProducts();
  Future<Product> getProduct(String id);
  Future<void> createProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}

// --- USE CASES (Callable Classes) ---
class ViewAllProductsUsecase {
  final ProductRepository repository;
  ViewAllProductsUsecase(this.repository);
  Future<List<Product>> call() {
    return repository.getAllProducts();
  }
}

class ViewProductUsecase {
  final ProductRepository repository;
  ViewProductUsecase(this.repository);
  Future<Product> call(String id) {
    return repository.getProduct(id);
  }
}

class CreateProductUsecase {
  final ProductRepository repository;
  CreateProductUsecase(this.repository);
  Future<void> call(Product product) {
    return repository.createProduct(product);
  }
}

class UpdateProductUsecase {
  final ProductRepository repository;
  UpdateProductUsecase(this.repository);
  Future<void> call(Product product) {
    return repository.updateProduct(product);
  }
}

class DeleteProductUsecase {
  final ProductRepository repository;
  DeleteProductUsecase(this.repository);
  Future<void> call(String id) {
    return repository.deleteProduct(id);
  }
}

// ==========================================
// 2. DATA LAYER (Implementation)
// ==========================================

class ProductRepositoryImpl implements ProductRepository {
  // Simulating a database
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Gaming Laptop',
      description: 'High performance gaming laptop with RTX 3060',
      // ⭐️ Using local asset path
      imageUrl: 'assets/images/gaming_laptop.jpg', 
      price: 1200.00,
    ),
    Product(
      id: '2',
      name: 'Smartphone',
      description: 'Latest model with 5G connectivity',
      // ⭐️ Using local asset path
      imageUrl: 'assets/images/smartphone.jpg', 
      price: 899.99,
    ),
    Product(
      id: '3',
      name: 'High-End Monitor',
      description: '4K 144Hz professional gaming monitor',
      // ⭐️ Using local asset path
      imageUrl: 'assets/images/monitor.jpg',
      price: 1599.99, 
    ),
  ];

  @override
  Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _products;
  }

  @override
  Future<Product> getProduct(String id) async {
    // Basic error handling for simulated data
    try {
      return _products.firstWhere((element) => element.id == id);
    } catch (e) {
      throw Exception('Product with ID $id not found.');
    }
  }

  @override
  Future<void> createProduct(Product product) async {
    _products.add(product);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      _products[index] = product;
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
  }
}

// ==========================================
// 3. DEPENDENCY INJECTION (Simple setup)
// ==========================================

final ProductRepository repository = ProductRepositoryImpl();
final ViewAllProductsUsecase viewAllProducts = ViewAllProductsUsecase(repository);
final ViewProductUsecase viewProduct = ViewProductUsecase(repository);
final CreateProductUsecase createProduct = CreateProductUsecase(repository);
final UpdateProductUsecase updateProduct = UpdateProductUsecase(repository);
final DeleteProductUsecase deleteProduct = DeleteProductUsecase(repository);

// ==========================================
// 4. PRESENTATION LAYER (UI)
// ==========================================

void main() {
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce Domain Refactor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case '/add_edit':
            final product = settings.arguments as Product?;
            return _createAnimatedRoute(AddEditProductScreen(product: product));
          case '/details':
            final productId = settings.arguments as String;
            return _createAnimatedRoute(ProductDetailScreen(productId: productId));
          default:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      },
    );
  }

  Route _createAnimatedRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
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
  List<Product> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    final products = await viewAllProducts.call();
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  Future<void> _handleDelete(String id) async {
    await deleteProduct.call(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Deleted')),
      );
    }
    _loadProducts(); 
  }

  Future<void> _navigateToAddEdit({Product? product}) async {
    final result = await Navigator.pushNamed(
      context,
      '/add_edit',
      arguments: product,
    );
    if (result == true) {
      _loadProducts();
    }
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My E-commerce Shop')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
              ? const Center(child: Text("No products yet."))
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final prod = _products[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        // ⭐️ MODIFIED: Using Image.asset for local files
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue.shade100,
                          radius: 20,
                          child: ClipOval(
                            child: Image.asset(
                              prod.imageUrl,
                              fit: BoxFit.cover, 
                              width: 40,
                              height: 40,
                              // Note: Image.asset doesn't need placeholder/error widgets like network images
                            ),
                          ),
                        ),
                        title: Text(prod.name),
                        subtitle: Text(prod.description, maxLines: 1, overflow: TextOverflow.ellipsis),
                        onTap: () {
                          Navigator.pushNamed(context, '/details', arguments: prod.id);
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                _formatPrice(prod.price),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _navigateToAddEdit(product: prod),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _handleDelete(prod.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddEdit(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

// --- SCREEN 2: ADD/EDIT PRODUCT SCREEN ---

class AddEditProductScreen extends StatefulWidget {
  final Product? product;
  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descController = TextEditingController(text: widget.product?.description ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    // ⭐️ Important: If editing, show the current path. For simplicity, we'll keep the image field for the full path.
    _imageController = TextEditingController(text: widget.product?.imageUrl ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      final id = widget.product?.id ?? DateTime.now().millisecondsSinceEpoch.toString();
      final name = _nameController.text;
      final desc = _descController.text;
      final price = double.tryParse(_priceController.text) ?? 0.0;
      if (price < 0) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Price cannot be negative.')));
          return;
        }
      }
      
      // ⭐️ Using a default asset path if the user leaves it blank
      final defaultImage = 'assets/images/default.jpg';
      final image = _imageController.text.isEmpty 
          ? defaultImage 
          : _imageController.text;

      final newProduct = Product(
        id: id,
        name: name,
        description: desc,
        price: price,
        imageUrl: image,
      );

      if (widget.product != null) {
        await updateProduct.call(newProduct);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Updated')));
      } else {
        await createProduct.call(newProduct);
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product Created')));
      }

      if (mounted) Navigator.pop(context, true); 
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Product' : 'Add Product')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name', border: OutlineInputBorder()),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price', border: OutlineInputBorder()),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter a price';
                  if (double.tryParse(value) == null) return 'Please enter a valid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // ⭐️ IMPORTANT: This field now expects an asset path (e.g., assets/images/new_item.png)
              TextFormField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image Asset Path', hintText: 'e.g., assets/images/new_item.jpg', border: OutlineInputBorder()),
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
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});
  
  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
    return formatter.format(price);
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Product>(
      future: viewProduct.call(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(body: Center(child: Text("Error loading product")));
        }

        final product = snapshot.data!;

        return Scaffold(
          appBar: AppBar(title: Text(product.name)),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ⭐️ MODIFIED: Using Image.asset for the main product image
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      product.imageUrl,
                      fit: BoxFit.cover, 
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback in case the asset is not found
                        return const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.red));
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _formatPrice(product.price), 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text("ID: ${product.id}", style: const TextStyle(color: Colors.grey)),
                const Divider(height: 30),
                const Text("Description:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                Text(product.description, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        );
      },
    );
  }
}