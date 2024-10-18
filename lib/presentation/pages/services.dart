import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/service_provider.dart';
import 'edit_service_page.dart';

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
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(_isDeleteMode ? Icons.close : Icons.arrow_back,
                    color: Colors.black),
                onPressed: _isDeleteMode ? _exitDeleteMode : _handlePop,
              ),
              title: Text('Services', style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              elevation: 0,
              actions: [
                IconButton(
                  icon: Icon(
                      _isDeleteMode ? Icons.delete : Icons.delete_outline,
                      color: Colors.black),
                  onPressed: _isDeleteMode
                      ? () => _deleteSelectedServices(serviceProvider)
                      : _enterDeleteMode,
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: serviceProvider.services.length,
              itemBuilder: (context, index) {
                return _buildServiceItem(serviceProvider.services[index]);
              },
            ),
            floatingActionButton: _isDeleteMode
                ? null
                : ScaleTransition(
                    scale: _animation,
                    child: FloatingActionButton(
                      onPressed: () => _addNewService(serviceProvider),
                      child: Icon(Icons.add),
                      backgroundColor: Colors.blue,
                    ),
                  ),
          ),
        );
      },
    );
  }

  void _handlePop() async {
    await _controller.reverse();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildServiceItem(ServiceModel service) {
    return GestureDetector(
      onTap: _isDeleteMode
          ? () => _toggleServiceSelection(service.id)
          : () => _editService(service, context.read<ServiceProvider>()),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFF212121),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: _isDeleteMode
              ? Checkbox(
                  value: _selectedServices.contains(service.id),
                  onChanged: (bool? value) {
                    _toggleServiceSelection(service.id);
                  },
                  activeColor: Colors.blue,
                )
              : Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: service.color,
                    shape: BoxShape.circle,
                  ),
                ),
          title: Text(service.name, style: TextStyle(color: Colors.white)),
          subtitle: Text(
            '${service.duration.inHours}h ${service.duration.inMinutes % 60}min',
            style: TextStyle(color: Colors.grey),
          ),
          trailing: Text(
            '\IQD ${service.price.toStringAsFixed(0)}',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _addNewService(ServiceProvider serviceProvider) async {
    final newService = ServiceModel(
      id: (serviceProvider.services.length + 1).toString(),
      name: 'New Service',
      duration: Duration(hours: 1),
      price: 0,
      color: Colors.blue,
    );

    final updatedService = await Navigator.of(context).push<ServiceModel>(
      MaterialPageRoute(
        builder: (context) => EditServicePage(
            service: Service(
          id: newService.id,
          name: newService.name,
          duration: newService.duration,
          price: newService.price,
          color: newService.color,
        )),
      ),
    );

    if (updatedService != null) {
      serviceProvider.addService(ServiceModel(
        id: updatedService.id,
        name: updatedService.name,
        duration: updatedService.duration,
        price: updatedService.price,
        color: updatedService.color,
      ));
    }
  }

  void _editService(
      ServiceModel service, ServiceProvider serviceProvider) async {
    final updatedService = await Navigator.of(context).push<Service>(
      MaterialPageRoute(
        builder: (context) => EditServicePage(
            service: Service(
          id: service.id,
          name: service.name,
          duration: service.duration,
          price: service.price,
          color: service.color,
        )),
      ),
    );
    if (updatedService != null) {
      serviceProvider.updateService(ServiceModel(
        id: updatedService.id,
        name: updatedService.name,
        duration: updatedService.duration,
        price: updatedService.price,
        color: updatedService.color,
      ));
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
