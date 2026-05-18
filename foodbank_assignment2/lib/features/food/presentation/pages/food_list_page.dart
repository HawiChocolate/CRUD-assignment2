import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di.dart';
import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../bloc/food_state.dart';
import '../widgets/food_item_card.dart';
import 'add_food_page.dart';
import 'food_detail_page.dart';
import 'search_food_page.dart';
import 'about_page.dart';

class FoodListPage extends StatelessWidget {
  const FoodListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FoodBloc>()..add(const LoadFoodItems()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food Bank'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Search',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchFoodPage(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'About',
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AboutPage(),
                ),
              ),
            ),
          ],
        ),
        body: BlocConsumer<FoodBloc, FoodState>(
          listener: (context, state) {
            if (state is FoodOperationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            }
            if (state is FoodError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is FoodLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is FoodError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<FoodBloc>().add(const LoadFoodItems()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            if (state is FoodLoaded) {
              if (state.items.isEmpty) {
                return const Center(
                  child: Text('No food items yet. Add one!'),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final item = state.items[index];
                  return FoodItemCard(
                    item: item,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FoodDetailPage(itemId: item.id),
                        ),
                      );
                      if (context.mounted) {
                        context.read<FoodBloc>().add(const LoadFoodItems());
                      }
                    },
                    onDelete: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Delete Item'),
                          content: Text('Delete "${item.name}"?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context.read<FoodBloc>().add(
                                      DeleteFoodItem(item.id),
                                    );
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AddFoodPage(),
                ),
              );
              if (context.mounted) {
                context.read<FoodBloc>().add(const LoadFoodItems());
              }
            },
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
