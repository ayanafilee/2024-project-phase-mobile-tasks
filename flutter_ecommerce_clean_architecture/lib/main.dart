import 'package:flutter/material.dart';

// ===== CLEAN ARCHITECTURE IMPORTS =====
import 'features/product/domain/entities/product.dart';
import 'features/product/domain/usecases/get_products.dart';
import 'features/product/domain/usecases/insert_product.dart';
import 'features/product/domain/usecases/update_product.dart';
import 'features/product/domain/usecases/delete_product.dart';
import 'features/product/data/repositories/product_repository_impl.dart';

void main() {
  final repository = ProductRepositoryImpl();
  runApp(EcommerceApp(repository: repository));
}

// ===== APP ROOT =====

class EcommerceApp extends StatelessWidget {
  final ProductRepositoryImpl repository;

  const EcommerceApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
              builder: (_) => HomeScreen(repository: repository),
            );

          case '/add_edit':
            final args = settings.arguments as Map<String, dynamic>?;

            return MaterialPageRoute(
              builder: (_) => AddEditProductScreen(
                product: args?['product'],
              ),
            );

          case '/details':
            final product = settings.arguments as Product;
            return MaterialPageRoute(
              builder: (_) => ProductDetailScreen(product: product),
            );

          default:
            return MaterialPageRoute(
              builder: (_) => HomeScreen(repository: repository),
            );
        }
      },
    );
  }
}

// ===== HOME SCREEN =====

class HomeScreen extends StatefulWidget {
  final ProductRepositoryImpl repository;

  const HomeScreen({super.key, required this.repository});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final GetProducts getProducts;
  late final InsertProduct insertProduct;
  late final UpdateProduct updateProduct;
  late final DeleteProduct deleteProduct;

  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    getProducts = GetProducts(widget.repository);
    insertProduct = InsertProduct(widget.repository);
    updateProduct = UpdateProduct(widget.repository);
    deleteProduct = DeleteProduct(widget.repository);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await getProducts();
    setState(() {
      _products = products;
    });
  }


  Future<void> _navigateToAddEdit({Product? product, int? index}) async {
    final result = await Navigator.pushNamed(
      context,
      '/add_edit',
      arguments: {'product': product},
    );

    if (result != null && result is Product) {
      if (index == null) {
        await insertProduct(result);
      } else {
        await updateProduct(result);
      }
      _loadProducts();
    }
  }

  Future<void> _delete(int index) async {
    await deleteProduct(_products[index].id);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My E-commerce Shop')),
      body: _products.isEmpty
          ? const Center(child: Text('No products yet'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (_, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text(product.description),
                  onTap: () =>
                      Navigator.pushNamed(context, '/details', arguments: product),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            _navigateToAddEdit(product: product, index: index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _delete(index),
                      ),
                    ],
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

// ===== ADD / EDIT SCREEN =====

class AddEditProductScreen extends StatefulWidget {
  final Product? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _description;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.product?.name ?? '');
    _description =
        TextEditingController(text: widget.product?.description ?? '');
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? DateTime.now().toString(),
        name: _name.text,
        description: _description.text,
        price: 0,
        imageUrl: '',
      );
      Navigator.pop(context, product);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: const Text('Save'))
            ],
          ),
        ),
      ),
    );
  }
}

// ===== DETAILS SCREEN =====

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(product.description),
      ),
    );
  }
}