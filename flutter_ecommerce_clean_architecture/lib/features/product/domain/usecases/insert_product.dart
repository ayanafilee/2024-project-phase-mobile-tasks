import '../entities/product.dart';
import '../repositories/product_repository.dart';

class InsertProduct {
  final ProductRepository repository;

  InsertProduct(this.repository);

  Future<void> call(Product product) async {
    return repository.insertProduct(product);
  }
}
