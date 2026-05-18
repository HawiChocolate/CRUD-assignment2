import 'package:equatable/equatable.dart';
import '../../domain/entities/food_item.dart';

abstract class FoodState extends Equatable {
  const FoodState();
  @override
  List<Object?> get props => [];
}

class FoodInitial extends FoodState {
  const FoodInitial();
}

class FoodLoading extends FoodState {
  const FoodLoading();
}

class FoodLoaded extends FoodState {
  final List<FoodItem> items;
  const FoodLoaded(this.items);
  @override
  List<Object?> get props => [items];
}

class FoodItemLoaded extends FoodState {
  final FoodItem item;
  const FoodItemLoaded(this.item);
  @override
  List<Object?> get props => [item];
}

class FoodOperationSuccess extends FoodState {
  final String message;
  const FoodOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class FoodError extends FoodState {
  final String message;
  const FoodError(this.message);
  @override
  List<Object?> get props => [message];
}
