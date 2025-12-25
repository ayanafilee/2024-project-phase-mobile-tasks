import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final List<Product> _products = [
    Product(
      id: '1',
      name: 'Laptop',
      price: 999.99,
      description: 'A high-performance laptop.',
      imageUrl: '',
    ),
    Product(
      id: '2',
      name: 'Smartphone',
      price: 699.99,
      description: 'A smartphone with a great camera.',
      imageUrl: '',
    ),
  ];

  @override
  Future<List<Product>> getProducts() async {
    return _products;
  }

  @override
  Future<void> insertProduct(Product product) async {
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
  Future<void> deleteProduct(String productId) async {
    _products.removeWhere((p) => p.id == productId);
  }

  @override
  Future<Product?> getProduct(String productId) async {
    try {
      return _products.firstWhere((p) => p.id == productId);
    } catch (_) {
      return null;
    }
  }
}
