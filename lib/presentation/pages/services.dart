import 'package:flutter/material.dart';
import 'edit_service_page.dart';

class ServicesPage extends StatefulWidget {
  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> with SingleTickerProviderStateMixin {
  final List<Service> services = [
    Service(id: '1', name: 'Facial', duration: Duration(hours: 1), price: 50, color: Colors.blue),
    Service(id: '2', name: 'Lash lift', duration: Duration(hours: 1), price: 50, color: Colors.green),
    Service(id: '3', name: 'Eyebrow wax', duration: Duration(minutes: 25), price: 50, color: Colors.purple),
    Service(id: '4', name: 'Lip wax', duration: Duration(minutes: 20), price: 50, color: Colors.blue),
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

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
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _handlePop();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: _handlePop,
          ),
          title: Text('Services', style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: ListView.builder(
          itemCount: services.length,
          itemBuilder: (context, index) {
            return _buildServiceItem(services[index]);
          },
        ),
        floatingActionButton: ScaleTransition(
          scale: _animation,
          child: FloatingActionButton(
            onPressed: _addNewService,
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
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

  Widget _buildServiceItem(Service service) {
    return GestureDetector(
      onTap: () async {
        final updatedService = await Navigator.of(context).push<Service>(
          MaterialPageRoute(
            builder: (context) => EditServicePage(service: service),
          ),
        );
        if (updatedService != null) {
          setState(() {
            final index = services.indexWhere((s) => s.id == service.id);
            if (index != -1) {
              services[index] = updatedService;
            }
          });
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFF212121),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          leading: Container(
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

  void _addNewService() async {
    final newService = Service(
      id: (services.length + 1).toString(),
      name: 'New Service',
      duration: Duration(hours: 1),
      price: 0,
      color: Colors.blue,
    );

    final updatedService = await Navigator.of(context).push<Service>(
      MaterialPageRoute(
        builder: (context) => EditServicePage(service: newService),
      ),
    );

    if (updatedService != null) {
      setState(() {
        services.add(updatedService);
      });
    }
  }
}