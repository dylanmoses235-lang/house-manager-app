import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/appliance.dart';
import 'package:uuid/uuid.dart';

class AppliancesScreen extends StatefulWidget {
  const AppliancesScreen({super.key});

  @override
  State<AppliancesScreen> createState() => _AppliancesScreenState();
}

class _AppliancesScreenState extends State<AppliancesScreen> {
  late Box<Appliance> _applianceBox;
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _openBox();
  }

  Future<void> _openBox() async {
    _applianceBox = await Hive.openBox<Appliance>('appliances');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appliance Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Filter options
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _applianceBox.listenable(),
        builder: (context, Box<Appliance> box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_repair_service_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No appliances added yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  const Text('Track your home appliances and maintenance'),
                ],
              ),
            );
          }

          final appliances = box.values.toList();
          final needsMaintenance = appliances.where((a) => a.needsMaintenance).toList();
          final expiringWarranties = appliances
              .where((a) => a.warrantyExpiry != null && 
                  a.warrantyExpiry!.difference(DateTime.now()).inDays <= 30)
              .toList();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Alerts
              if (needsMaintenance.isNotEmpty || expiringWarranties.isNotEmpty) ...[
                Card(
                  color: Colors.orange[50],
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange[700]),
                            const SizedBox(width: 8),
                            Text(
                              'Attention Needed',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                          ],
                        ),
                        if (needsMaintenance.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text('${needsMaintenance.length} appliance(s) need maintenance'),
                        ],
                        if (expiringWarranties.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text('${expiringWarranties.length} warranty(s) expiring soon'),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Categories
              _buildCategory('Kitchen', appliances.where((a) => a.category == 'kitchen').toList()),
              _buildCategory('Laundry', appliances.where((a) => a.category == 'laundry').toList()),
              _buildCategory('HVAC', appliances.where((a) => a.category == 'hvac').toList()),
              _buildCategory('Other', appliances.where((a) => a.category == 'other').toList()),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddApplianceDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Appliance'),
      ),
    );
  }

  Widget _buildCategory(String title, List<Appliance> appliances) {
    if (appliances.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...appliances.map((appliance) => _buildApplianceCard(appliance)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildApplianceCard(Appliance appliance) {
    final needsAttention = appliance.needsMaintenance ||
        (appliance.warrantyExpiry != null &&
            appliance.warrantyExpiry!.difference(DateTime.now()).inDays <= 30);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: needsAttention ? Colors.orange : Colors.blue,
          child: Icon(
            _getCategoryIcon(appliance.category),
            color: Colors.white,
          ),
        ),
        title: Text(appliance.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (appliance.brand != null) Text(appliance.brand!),
            if (appliance.needsMaintenance)
              Text(
                'Maintenance due in ${appliance.daysUntilMaintenance} days',
                style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
              ),
            if (appliance.warrantyExpiry != null)
              Text(
                'Warranty: ${appliance.isWarrantyValid ? "Valid until ${_formatDate(appliance.warrantyExpiry!)}" : "Expired"}',
                style: TextStyle(
                  color: appliance.isWarrantyValid ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => _showApplianceDetails(appliance),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'kitchen':
        return Icons.kitchen;
      case 'laundry':
        return Icons.local_laundry_service;
      case 'hvac':
        return Icons.ac_unit;
      default:
        return Icons.home_repair_service;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }

  void _showAddApplianceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Appliance'),
        content: const Text('Appliance form would go here with fields for name, brand, model, etc.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // Add appliance logic
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showApplianceDetails(Appliance appliance) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ApplianceDetailScreen(appliance: appliance),
      ),
    );
  }
}

class ApplianceDetailScreen extends StatelessWidget {
  final Appliance appliance;

  const ApplianceDetailScreen({super.key, required this.appliance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appliance.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Edit appliance
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Details would go here
          const Text('Appliance details screen - to be implemented'),
        ],
      ),
    );
  }
}
