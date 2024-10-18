import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../providers/service_provider.dart';

class Service {
  final String id;
  final String name;
  final Duration duration;
  final int price;
  final Color color;
  final bool isDefaultForNewClients;
  final String priceType;

  Service({
    required this.id,
    required this.name,
    required this.duration,
    required this.price,
    required this.color,
    this.isDefaultForNewClients = false,
    this.priceType = 'Fixed price',
  });

  // Convert Service to ServiceModel
  ServiceModel toServiceModel() {
    return ServiceModel(
      id: this.id,
      name: this.name,
      duration: this.duration,
      price: this.price,
      color: this.color,
    );
  }

  // Create Service from ServiceModel
  static Service fromServiceModel(ServiceModel model) {
    return Service(
      id: model.id,
      name: model.name,
      duration: model.duration,
      price: model.price,
      color: model.color,
    );
  }
}

class EditServicePage extends StatefulWidget {
  final Service service;

  EditServicePage({Key? key, required this.service}) : super(key: key);

  @override
  _EditServicePageState createState() => _EditServicePageState();
}

class _EditServicePageState extends State<EditServicePage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late Color _selectedColor;
  late bool _isDefaultForNewClients;
  late String _priceType;
  late Duration _duration;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.service.name);
    _priceController = TextEditingController(text: widget.service.price.toString());
    _selectedColor = widget.service.color;
    _isDefaultForNewClients = widget.service.isDefaultForNewClients;
    _priceType = widget.service.priceType;
    _duration = widget.service.duration;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Edit service', style: TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: _saveService,
            child: Text('Save', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Name', _nameController),
            SizedBox(height: 16),
            _buildColorPicker(),
            SizedBox(height: 16),
            _buildDefaultServiceSwitch(),
            SizedBox(height: 24),
            Text('Price & duration', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildPriceSection(),
            SizedBox(height: 16),
            _buildDurationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildColorPicker() {
    return Row(
      children: [
        Text('Color', style: TextStyle(color: Colors.grey)),
        SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Pick a color'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: _selectedColor,
                      onColorChanged: (Color color) {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      child: const Text('Done'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: _selectedColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 8),
        Text(_getColorName(_selectedColor), style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildDefaultServiceSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Default service for new clients', style: TextStyle(color: Colors.white)),
        Switch(
          value: _isDefaultForNewClients,
          onChanged: (value) {
            setState(() {
              _isDefaultForNewClients = value;
            });
          },
          activeColor: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: _priceType,
            dropdownColor: Color(0xFF2E2E2E),
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            items: ['Fixed price', 'Variable']
                .map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _priceType = newValue!;
              });
            },
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _buildTextField('Price', _priceController),
        ),
      ],
    );
  }

  Widget _buildDurationSection() {
    return GestureDetector(
      onTap: _showDurationPicker,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Duration', style: TextStyle(color: Colors.white)),
            Text(
              '${_duration.inHours}h ${_duration.inMinutes % 60}min',
              style: TextStyle(color: Colors.blue),
            ),
          ],
        ),
      ),
    );
  }

  void _showDurationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Color(0xFF212121),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        'Select Duration',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildTimeWheel(
                            value: _duration.inHours,
                            maxValue: 23,
                            onChanged: (value) {
                              setModalState(() {
                                _duration = Duration(hours: value, minutes: _duration.inMinutes % 60);
                              });
                            },
                            label: 'hours',
                          ),
                          SizedBox(width: 16),
                          _buildTimeWheel(
                            value: _duration.inMinutes % 60,
                            maxValue: 59,
                            onChanged: (value) {
                              setModalState(() {
                                _duration = Duration(hours: _duration.inHours, minutes: value);
                              });
                            },
                            label: 'minutes',
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text('Confirm'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            setState(() {
                              // Update the main state
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTimeWheel({
    required int value,
    required int maxValue,
    required ValueChanged<int> onChanged,
    required String label,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 150,
            child: ListWheelScrollView.useDelegate(
              itemExtent: 40,
              perspective: 0.005,
              diameterRatio: 1.2,
              physics: FixedExtentScrollPhysics(),
              childDelegate: ListWheelChildBuilderDelegate(
                childCount: maxValue + 1,
                builder: (context, index) {
                  return Center(
                    child: Text(
                      index.toString().padLeft(2, '0'),
                      style: TextStyle(
                        color: index == value ? Colors.blue : Colors.white,
                        fontSize: index == value ? 24 : 18,
                      ),
                    ),
                  );
                },
              ),
              onSelectedItemChanged: onChanged,
            ),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  String _getColorName(Color color) {
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.green) return 'Green';
    if (color == Colors.red) return 'Red';
    // Add more color names as needed
    return 'Custom';
  }

void _saveService() {
    final updatedService = Service(
      id: widget.service.id,
      name: _nameController.text,
      duration: _duration,
      price: int.tryParse(_priceController.text) ?? widget.service.price,
      color: _selectedColor,
      isDefaultForNewClients: _isDefaultForNewClients,
      priceType: _priceType,
    );
    Navigator.of(context).pop(updatedService.toServiceModel());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}