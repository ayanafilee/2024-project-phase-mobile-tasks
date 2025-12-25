import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/features/product/data/models/product_model.dart';
import 'package:flutter_application_1/features/product/domain/entities/product.dart';

void main() {
  final tProductModel = ProductModel(
    id: '1',
    name: 'Men\'s Boots',
    price: 99.99,
    description: 'Stylish and durable boots for men.',
    imageUrl: 'assets/images/mensboots.jpg',
  );

  test(
    'should be a subclass of Product entity',
    () async {
      // assert
      expect(tProductModel, isA<Product>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON is valid',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap = {
          'id': '1',
          'name': 'Men\'s Boots',
          'price': 99.99,
          'description': 'Stylish and durable boots for men.',
          'imageUrl': 'assets/images/mensboots.jpg',
        };
        // act
        final result = ProductModel.fromJson(jsonMap);
        // assert
        expect(result, tProductModel);
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing the proper data',
      () async {
        // act
        final result = tProductModel.toJson();
        // assert
        final expectedMap = {
          'id': '1',
          'name': 'Men\'s Boots',
          'price': 99.99,
          'description': 'Stylish and durable boots for men.',
          'imageUrl': 'assets/images/mensboots.jpg',
        };
        expect(result, expectedMap);
      },
    );
  });
}
