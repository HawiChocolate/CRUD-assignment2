import 'package:equatable/equatable.dart';
import '../../domain/entities/food_item.dart';

abstract class FoodEvent extends Equatable {
  const FoodEvent();
  @override
  List<Object?> get props => [];
}

class LoadFoodItems extends FoodEvent {
  const LoadFoodItems();
}

class LoadFoodItemById extends FoodEvent {
  final int id;
  const LoadFoodItemById(this.id);
  @override
  List<Object?> get props => [id];
}

class AddFoodItem extends FoodEvent {
  final FoodItem item;
  const AddFoodItem(this.item);
  @override
  List<Object?> get props => [item];
}

class UpdateFoodItem extends FoodEvent {
  final FoodItem item;
  const UpdateFoodItem(this.item);
  @override
  List<Object?> get props => [item];
}

class DeleteFoodItem extends FoodEvent {
  final int id;
  const DeleteFoodItem(this.id);
  @override
  List<Object?> get props => [id];
}
