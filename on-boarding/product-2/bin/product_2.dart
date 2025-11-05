import 'dart:io';

// Product class representing an individual product
class Product {
  String _name;
  String _description;
  double _price;

  Product(this._name, this._description, this._price);

  // Getters
  String get name => _name;
  String get description => _description;
  double get price => _price;

  // Setters
  set name(String newName) => _name = newName;
  set description(String newDescription) => _description = newDescription;
  set price(double newPrice) {
    if (newPrice >= 0) {
      _price = newPrice;
    } else {
      print("Price cannot be negative!");
    }
  }

  void displayProduct() {
    print("\nName: $_name");
    print("Description: $_description");
    print("Price: \$${_price.toStringAsFixed(2)}");
  }
}

// ProductManager class managing a collection of products
class ProductManager {
  final List<Product> _products = [];

  void addProduct() {
    stdout.write("Enter product name: ");
    String name = stdin.readLineSync() ?? '';

    stdout.write("Enter product description: ");
    String description = stdin.readLineSync() ?? '';

    stdout.write("Enter product price: ");
    double? price = double.tryParse(stdin.readLineSync() ?? '');

    if (price == null || price < 0) {
      print("Invalid price. Product not added.");
      return;
    }

    _products.add(Product(name, description, price));
    print("✅ Product added successfully!");
  }

  void viewAllProducts() {
    if (_products.isEmpty) {
      print("⚠️ No products available.");
      return;
    }

    print("\n📦 All Products:");
    for (int i = 0; i < _products.length; i++) {
      print("\nProduct ${i + 1}:");
      _products[i].displayProduct();
    }
  }

  void viewSingleProduct() {
    if (_products.isEmpty) {
      print("⚠️ No products available.");
      return;
    }

    stdout.write("Enter product index (1-${_products.length}): ");
    int? index = int.tryParse(stdin.readLineSync() ?? '');

    if (index == null || index < 1 || index > _products.length) {
      print("❌ Invalid index.");
      return;
    }

    print("\n🔍 Product Details:");
    _products[index - 1].displayProduct();
  }

  void editProduct() {
    if (_products.isEmpty) {
      print("⚠️ No products available.");
      return;
    }

    stdout.write("Enter product index to edit (1-${_products.length}): ");
    int? index = int.tryParse(stdin.readLineSync() ?? '');

    if (index == null || index < 1 || index > _products.length) {
      print("❌ Invalid index.");
      return;
    }

    Product product = _products[index - 1];

    stdout.write("Enter new name (${product.name}): ");
    String newName = stdin.readLineSync() ?? product.name;

    stdout.write("Enter new description (${product.description}): ");
    String newDescription = stdin.readLineSync() ?? product.description;

    stdout.write("Enter new price (${product.price}): ");
    double? newPrice = double.tryParse(stdin.readLineSync() ?? '');

    if (newPrice == null || newPrice < 0) {
      print("Invalid price. Keeping old price.");
      newPrice = product.price;
    }

    product.name = newName;
    product.description = newDescription;
    product.price = newPrice;

    print("✅ Product updated successfully!");
  }

  void deleteProduct() {
    if (_products.isEmpty) {
      print("⚠️ No products available.");
      return;
    }

    stdout.write("Enter product index to delete (1-${_products.length}): ");
    int? index = int.tryParse(stdin.readLineSync() ?? '');

    if (index == null || index < 1 || index > _products.length) {
      print("❌ Invalid index.");
      return;
    }

    _products.removeAt(index - 1);
    print("🗑️ Product deleted successfully!");
  }
}

void main() {
  ProductManager manager = ProductManager();

  while (true) {
    print('''
=============================
🛒 Simple eCommerce CLI
=============================
1️⃣ Add Product
2️⃣ View All Products
3️⃣ View Single Product
4️⃣ Edit Product
5️⃣ Delete Product
0️⃣ Exit
=============================
''');

    stdout.write("Choose an option: ");
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        manager.addProduct();
        break;
      case '2':
        manager.viewAllProducts();
        break;
      case '3':
        manager.viewSingleProduct();
        break;
      case '4':
        manager.editProduct();
        break;
      case '5':
        manager.deleteProduct();
        break;
      case '0':
        print("👋 Exiting program. Goodbye!");
        exit(0);
      default:
        print("❌ Invalid choice. Please try again.");
    }
  }
}
