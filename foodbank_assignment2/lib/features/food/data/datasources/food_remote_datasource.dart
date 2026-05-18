import 'package:dio/dio.dart';
import '../models/food_item_model.dart';

abstract class FoodRemoteDatasource {
  Future<List<FoodItemModel>> getFoodItems();
  Future<FoodItemModel> getFoodItemById(int id);
  Future<FoodItemModel> addFoodItem(FoodItemModel item);
  Future<FoodItemModel> updateFoodItem(FoodItemModel item);
  Future<void> deleteFoodItem(int id);
}

class FoodRemoteDatasourceImpl implements FoodRemoteDatasource {
  final Dio dio;
  FoodRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<FoodItemModel>> getFoodItems() async {
    try {
      final response = await dio.get('/products/category/groceries?limit=30');
      final List<dynamic> products = response.data['products'] ?? [];
      return products.map((e) => FoodItemModel.fromJson(e)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load items: ${e.message}');
    }
  }

  @override
  Future<FoodItemModel> getFoodItemById(int id) async {
    try {
      final response = await dio.get('/products/$id');
      return FoodItemModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to load item: ${e.message}');
    }
  }

  @override
  Future<FoodItemModel> addFoodItem(FoodItemModel item) async {
    try {
      final response = await dio.post('/products/add', data: item.toJson());
      return FoodItemModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to add item: ${e.message}');
    }
  }

  @override
  Future<FoodItemModel> updateFoodItem(FoodItemModel item) async {
    try {
      final response =
          await dio.put('/products/${item.id}', data: item.toJson());
      return FoodItemModel.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception('Failed to update item: ${e.message}');
    }
  }

  @override
  Future<void> deleteFoodItem(int id) async {
    try {
      await dio.delete('/products/$id');
    } on DioException catch (e) {
      throw Exception('Failed to delete item: ${e.message}');
    }
  }
}
