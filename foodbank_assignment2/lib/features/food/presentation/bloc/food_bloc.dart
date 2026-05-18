import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/food_repository.dart';
import 'food_event.dart';
import 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodRepository repository;

  FoodBloc({required this.repository}) : super(const FoodInitial()) {
    on<LoadFoodItems>(_onLoadFoodItems);
    on<LoadFoodItemById>(_onLoadFoodItemById);
    on<AddFoodItem>(_onAddFoodItem);
    on<UpdateFoodItem>(_onUpdateFoodItem);
    on<DeleteFoodItem>(_onDeleteFoodItem);
  }

  Future<void> _onLoadFoodItems(
    LoadFoodItems event,
    Emitter<FoodState> emit,
  ) async {
    emit(const FoodLoading());
    try {
      final items = await repository.getFoodItems();
      emit(FoodLoaded(items));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  Future<void> _onLoadFoodItemById(
    LoadFoodItemById event,
    Emitter<FoodState> emit,
  ) async {
    emit(const FoodLoading());
    try {
      final item = await repository.getFoodItemById(event.id);
      emit(FoodItemLoaded(item));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  Future<void> _onAddFoodItem(
    AddFoodItem event,
    Emitter<FoodState> emit,
  ) async {
    emit(const FoodLoading());
    try {
      await repository.addFoodItem(event.item);
      emit(const FoodOperationSuccess('Item added!'));
      final items = await repository.getFoodItems();
      emit(FoodLoaded(items));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  Future<void> _onUpdateFoodItem(
    UpdateFoodItem event,
    Emitter<FoodState> emit,
  ) async {
    emit(const FoodLoading());
    try {
      await repository.updateFoodItem(event.item);
      emit(const FoodOperationSuccess('Item updated!'));
      final items = await repository.getFoodItems();
      emit(FoodLoaded(items));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }

  Future<void> _onDeleteFoodItem(
    DeleteFoodItem event,
    Emitter<FoodState> emit,
  ) async {
    emit(const FoodLoading());
    try {
      await repository.deleteFoodItem(event.id);
      emit(const FoodOperationSuccess('Item deleted!'));
      final items = await repository.getFoodItems();
      emit(FoodLoaded(items));
    } catch (e) {
      emit(FoodError(e.toString()));
    }
  }
}
