import 'package:flutter/material.dart';

class NewClientPage extends StatefulWidget {
  @override
  _NewClientPageState createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('New client', style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: _saveClient,
            child: Text('Save', style: TextStyle(color: Colors.blue)),
          ),
        ],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField(_nameController, 'Name'),
            SizedBox(height: 16),
            _buildTextField(_phoneController, 'Mobile phone number'),
            SizedBox(height: 24),
            InkWell(
              onTap: () {
                // TODO: Implement more options functionality
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('More options', style: TextStyle(color: Colors.blue)),
                  Text('(Photo, Email, Notes, Location, Birthday)', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
      ),
    );
  }

  void _saveClient() {
    final name = _nameController.text;
    final phone = _phoneController.text;
    if (name.isNotEmpty) {
      Navigator.pop(context, {'name': name, 'phone': phone});
    } else {
      // Show an error message if the name is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a name for the client')),
      );
    }
  }
}