import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di.dart';
import '../../domain/entities/food_item.dart';
import '../bloc/food_bloc.dart';
import '../bloc/food_event.dart';
import '../bloc/food_state.dart';

class EditFoodPage extends StatefulWidget {
  final FoodItem item;
  const EditFoodPage({super.key, required this.item});

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _qtyCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.item.name);
    _descCtrl = TextEditingController(text: widget.item.description);
    _qtyCtrl = TextEditingController(text: widget.item.quantity.toString());
  }

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
          title: const Text('Edit Food Item'),
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
                  BlocBuilder<FoodBloc, FoodState>(
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
                          : const Icon(Icons.save),
                      label: Text(
                          state is FoodLoading ? 'Saving...' : 'Save Changes'),
                      onPressed: state is FoodLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context
                                    .read<FoodBloc>()
                                    .add(UpdateFoodItem(FoodItem(
                                      id: widget.item.id,
                                      name: _nameCtrl.text.trim(),
                                      description: _descCtrl.text.trim(),
                                      category: widget.item.category,
                                      quantity: int.parse(_qtyCtrl.text.trim()),
                                      imageUrl: widget.item.imageUrl,
                                    )));
                              }
                            },
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
