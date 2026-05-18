import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di.dart';
import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../bloc/food_state.dart';
import '../../domain/entities/food_item.dart';
import 'food_detail_page.dart';

class SearchFoodPage extends StatefulWidget {
  const SearchFoodPage({super.key});

  @override
  State<SearchFoodPage> createState() => _SearchFoodPageState();
}

class _SearchFoodPageState extends State<SearchFoodPage> {
  final _searchCtrl = TextEditingController();
  List<FoodItem> _allItems = [];
  List<FoodItem> _filtered = [];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filter(String query) {
    setState(() {
      _filtered = _allItems
          .where((item) =>
              item.name.toLowerCase().contains(query.toLowerCase()) ||
              item.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FoodBloc>()..add(const LoadFoodItems()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Search Food Items'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<FoodBloc, FoodState>(
          listener: (context, state) {
            if (state is FoodLoaded) {
              setState(() {
                _allItems = state.items;
                _filtered = state.items;
              });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: 'Search by name or description...',
                      prefixIcon: const Icon(Icons.search, color: Colors.green),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchCtrl.clear();
                                _filter('');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                    onChanged: _filter,
                  ),
                ),

                // Results count
                if (state is FoodLoaded)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text(
                          '${_filtered.length} result${_filtered.length == 1 ? '' : 's'} found',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 8),

                // Body
                Expanded(
                  child: state is FoodLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is FoodError
                          ? Center(child: Text('Error: ${state.message}'))
                          : _filtered.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.search_off,
                                          size: 64,
                                          color: Colors.grey.shade400),
                                      const SizedBox(height: 12),
                                      Text(
                                        _searchCtrl.text.isEmpty
                                            ? 'Start typing to search'
                                            : 'No items match your search',
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  itemCount: _filtered.length,
                                  itemBuilder: (context, index) {
                                    final item = _filtered[index];
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      child: ListTile(
                                        leading: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            item.imageUrl,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                              width: 50,
                                              height: 50,
                                              color: Colors.green.shade100,
                                              child: const Icon(Icons.fastfood,
                                                  color: Colors.green),
                                            ),
                                          ),
                                        ),
                                        title: Text(
                                          item.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Text(
                                          item.description,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        trailing: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade50,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'Qty: ${item.quantity}',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.green.shade800,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                FoodDetailPage(itemId: item.id),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
