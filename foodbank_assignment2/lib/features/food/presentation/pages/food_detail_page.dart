import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di.dart';
import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../bloc/food_state.dart';
import 'edit_food_page.dart';

class FoodDetailPage extends StatelessWidget {
  final int itemId;
  const FoodDetailPage({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FoodBloc>()..add(LoadFoodItemById(itemId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food Detail'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: BlocBuilder<FoodBloc, FoodState>(
          builder: (context, state) {
            if (state is FoodLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FoodError) {
              return Center(child: Text(state.message));
            }
            if (state is FoodItemLoaded) {
              final item = state.item;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      item.imageUrl,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 220,
                        color: Colors.green.shade100,
                        child: const Icon(Icons.fastfood,
                            size: 80, color: Colors.green),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Row(children: [
                            const Icon(Icons.category,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(item.category,
                                style: const TextStyle(color: Colors.grey)),
                          ]),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(Icons.inventory_2,
                                size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('Quantity: ${item.quantity}',
                                style: const TextStyle(color: Colors.grey)),
                          ]),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),
                          Text(item.description,
                              style: const TextStyle(height: 1.6)),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit Item'),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditFoodPage(item: item),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
