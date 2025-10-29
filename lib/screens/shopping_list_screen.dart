import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/supply_item.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<ShoppingListScreen> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  late Box<SupplyItem> _suppliesBox;
  String _selectedCategory = 'all';
  
  final _categories = {
    'all': {'icon': Icons.list, 'label': 'All'},
    'cleaning': {'icon': Icons.cleaning_services, 'label': 'Cleaning'},
    'pantry': {'icon': Icons.kitchen, 'label': 'Pantry'},
    'pet': {'icon': Icons.pets, 'label': 'Pet'},
    'other': {'icon': Icons.more_horiz, 'label': 'Other'},
  };

  @override
  void initState() {
    super.initState();
    _suppliesBox = Hive.box<SupplyItem>('supplies');
  }

  List<SupplyItem> _getFilteredItems() {
    final items = _suppliesBox.values.toList();
    if (_selectedCategory == 'all') {
      return items;
    }
    return items.where((item) => item.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _getFilteredItems();
    final neededItems = items.where((item) => !item.isPurchased).toList();
    final purchasedItems = items.where((item) => item.isPurchased).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: neededItems.isEmpty && purchasedItems.isEmpty ? null : () => _clearList(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _categories.entries.map((entry) {
                final isSelected = _selectedCategory == entry.key;
                final categoryData = entry.value;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          categoryData['icon'] as IconData,
                          size: 18,
                        ),
                        const SizedBox(width: 4),
                        Text(categoryData['label'] as String),
                      ],
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = entry.key;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Items List
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 80,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items in your list',
                          style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap + to add supplies',
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // Needed Items
                      if (neededItems.isNotEmpty) ...[
                        Row(
                          children: [
                            const Text(
                              '🛒 To Buy',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${neededItems.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...neededItems.map((item) => _buildItemCard(item, false)),
                        const SizedBox(height: 24),
                      ],

                      // Purchased Items
                      if (purchasedItems.isNotEmpty) ...[
                        Row(
                          children: [
                            const Text(
                              '✅ Purchased',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.tertiaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${purchasedItems.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onTertiaryContainer,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ...purchasedItems.map((item) => _buildItemCard(item, true)),
                      ],
                    ],
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }

  Widget _buildItemCard(SupplyItem item, bool isPurchased) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Checkbox(
          value: item.isPurchased,
          onChanged: (value) {
            setState(() {
              item.isPurchased = value ?? false;
              item.save();
            });
          },
        ),
        title: Text(
          item.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: isPurchased ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Row(
          children: [
            Icon(
              _categories[item.category]?['icon'] as IconData? ?? Icons.list,
              size: 14,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(width: 4),
            Text(
              _categories[item.category]?['label'] as String? ?? item.category,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            if (item.quantity > 1) ...[
              const SizedBox(width: 8),
              Text(
                '×${item.quantity}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit_outlined),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete_outline),
                  SizedBox(width: 8),
                  Text('Delete'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == 'edit') {
              _showEditItemDialog(context, item);
            } else if (value == 'delete') {
              _deleteItem(item);
            }
          },
        ),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context) {
    final nameController = TextEditingController();
    final notesController = TextEditingController();
    String selectedCategory = 'cleaning';
    int quantity = 1;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.entries
                      .where((e) => e.key != 'all')
                      .map((e) => DropdownMenuItem(
                            value: e.key,
                            child: Row(
                              children: [
                                Icon(e.value['icon'] as IconData, size: 20),
                                const SizedBox(width: 8),
                                Text(e.value['label'] as String),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Quantity:'),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: quantity > 1
                          ? () {
                              setDialogState(() {
                                quantity--;
                              });
                            }
                          : null,
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setDialogState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final item = SupplyItem(
                    id: const Uuid().v4(),
                    name: nameController.text,
                    category: selectedCategory,
                    quantity: quantity,
                    notes: notesController.text.isEmpty ? null : notesController.text,
                  );
                  _suppliesBox.add(item);
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, SupplyItem item) {
    final nameController = TextEditingController(text: item.name);
    final notesController = TextEditingController(text: item.notes ?? '');
    String selectedCategory = item.category;
    int quantity = item.quantity;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories.entries
                      .where((e) => e.key != 'all')
                      .map((e) => DropdownMenuItem(
                            value: e.key,
                            child: Row(
                              children: [
                                Icon(e.value['icon'] as IconData, size: 20),
                                const SizedBox(width: 8),
                                Text(e.value['label'] as String),
                              ],
                            ),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Quantity:'),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: quantity > 1
                          ? () {
                              setDialogState(() {
                                quantity--;
                              });
                            }
                          : null,
                    ),
                    Text(
                      '$quantity',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () {
                        setDialogState(() {
                          quantity++;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(
                    labelText: 'Notes (optional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  item.name = nameController.text;
                  item.category = selectedCategory;
                  item.quantity = quantity;
                  item.notes = notesController.text.isEmpty ? null : notesController.text;
                  item.save();
                  setState(() {});
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteItem(SupplyItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: Text('Remove "${item.name}" from your shopping list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              item.delete();
              setState(() {});
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _clearList(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear List?'),
        content: const Text('Remove all purchased items from the list?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final purchasedItems = _suppliesBox.values.where((item) => item.isPurchased).toList();
              for (var item in purchasedItems) {
                item.delete();
              }
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
