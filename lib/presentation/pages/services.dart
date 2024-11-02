import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/service_provider.dart';
import 'edit_service_page.dart';
import '../../domain/models/doctor.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isDeleteMode = false;
  Set<String> _selectedServices = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServiceProvider>(
      builder: (context, serviceProvider, child) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) return;
            _handlePop();
          },
          child: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  _isDeleteMode ? Icons.close : Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: _isDeleteMode ? _exitDeleteMode : _handlePop,
              ),
              title: Text(
                'Services',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 200),
                  child: _isDeleteMode
                      ? TextButton.icon(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          label: Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () =>
                              _deleteSelectedServices(serviceProvider),
                        )
                      : IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.black),
                          onPressed: _enterDeleteMode,
                        ),
                ),
              ],
            ),
            body: Column(
              children: [
                // Services count header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ALL SERVICES',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${serviceProvider.services.length} services',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Services list
                Expanded(
                  child: serviceProvider.services.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: serviceProvider.services.length,
                          itemBuilder: (context, index) {
                            return _buildServiceItem(
                                serviceProvider.services[index]);
                          },
                        ),
                ),
              ],
            ),
            floatingActionButton: _isDeleteMode
                ? null
                : ScaleTransition(
                    scale: _animation,
                    child: FloatingActionButton(
                      onPressed: () => _addNewService(serviceProvider),
                      child: Icon(Icons.add),
                      backgroundColor: Colors.blue,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.spa_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No services yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Tap + to add your first service',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(ServiceModel service) {
    return GestureDetector(
      onTap: _isDeleteMode
          ? () => _toggleServiceSelection(service.id)
          : () => _editService(service, context.read<ServiceProvider>()),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Top section with service info and price
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox (only shown in delete mode)
                  if (_isDeleteMode)
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _selectedServices.contains(service.id),
                          onChanged: (bool? value) {
                            _toggleServiceSelection(service.id);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  // Service avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: service.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        service.name[0].toUpperCase(),
                        style: TextStyle(
                          color: service.color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Service details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${service.duration.inHours}h ${service.duration.inMinutes % 60}min',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Price
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      service.formattedPrice,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom section with doctors and arrow
            Container(
              padding: EdgeInsets.fromLTRB(_isDeleteMode ? 100 : 80, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Doctors',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          service.doctors.map((d) => d.name).join('\n'),
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!_isDeleteMode)
                    Container(
                      margin: EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey[400],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePop() async {
    await _controller.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _addNewService(ServiceProvider serviceProvider) async {
    final newService = Service(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: 'New Service',
      duration: Duration(hours: 1),
      price: 0,
      color: Colors.blue,
      doctors: [],
      isDefaultForNewClients: false,
      priceType: 'Fixed price',
    );

    final result = await Navigator.of(context).push<ServiceModel>(
      MaterialPageRoute(
        builder: (context) => EditServicePage(service: newService),
      ),
    );

    if (result != null) {
      serviceProvider.addService(result);
    }
  }

  void _editService(
      ServiceModel service, ServiceProvider serviceProvider) async {
    final updatedService = await Navigator.of(context).push<ServiceModel>(
      MaterialPageRoute(
        builder: (context) => EditServicePage(
          service: Service(
            id: service.id,
            name: service.name,
            duration: service.duration,
            price: service.price,
            color: service.color,
            doctors: service.doctors,
            isDefaultForNewClients: false,
            priceType: 'Fixed price',
          ),
        ),
      ),
    );

    if (updatedService != null) {
      serviceProvider.updateService(updatedService);
    }
  }

  void _enterDeleteMode() {
    setState(() {
      _isDeleteMode = true;
      _selectedServices.clear();
    });
  }

  void _exitDeleteMode() {
    setState(() {
      _isDeleteMode = false;
      _selectedServices.clear();
    });
  }

  void _toggleServiceSelection(String serviceId) {
    setState(() {
      if (_selectedServices.contains(serviceId)) {
        _selectedServices.remove(serviceId);
      } else {
        _selectedServices.add(serviceId);
      }
    });
  }

  void _deleteSelectedServices(ServiceProvider serviceProvider) {
    serviceProvider.deleteServices(_selectedServices.toList());
    _exitDeleteMode();
  }
}
