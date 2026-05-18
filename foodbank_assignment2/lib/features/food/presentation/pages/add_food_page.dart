import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di.dart';
import '../../domain/entities/food_item.dart';
import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../bloc/food_state.dart';

class AddFoodPage extends StatefulWidget {
  const AddFoodPage({super.key});

  @override
  State<AddFoodPage> createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _qtyCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FoodBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Food Item'),
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        body: BlocListener<FoodBloc, FoodState>(
          listener: (context, state) {
            if (state is FoodOperationSuccess) {
              Navigator.pop(context);
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
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Food Name *',
                      prefixIcon: Icon(Icons.fastfood),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Please enter a name' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Description *',
                      prefixIcon: Icon(Icons.description),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                    validator: (v) => v == null || v.isEmpty
                        ? 'Please enter a description'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _qtyCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Quantity *',
                      prefixIcon: Icon(Icons.inventory_2),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Please enter quantity';
                      }
                      if (int.tryParse(v) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),
                  Builder(
                    builder: (context) => BlocBuilder<FoodBloc, FoodState>(
                      builder: (context, state) => ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        icon: state is FoodLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.add),
                        label: Text(
                            state is FoodLoading ? 'Adding...' : 'Add Item'),
                        onPressed: state is FoodLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context
                                      .read<FoodBloc>()
                                      .add(AddFoodItem(FoodItem(
                                        id: 0,
                                        name: _nameCtrl.text.trim(),
                                        description: _descCtrl.text.trim(),
                                        category: 'Food Bank Item',
                                        quantity:
                                            int.parse(_qtyCtrl.text.trim()),
                                        imageUrl:
                                            'https://picsum.photos/300/200',
                                      )));
                                }
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
