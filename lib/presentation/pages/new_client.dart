// lib/presentation/pages/new_client.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/client_provider.dart';
import 'package:intl/intl.dart';

class NewClientPage extends StatefulWidget {
  @override
  _NewClientPageState createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  DateTime? _selectedBirthday;
  bool _addToContacts = false;
  bool _showMoreOptions = false;

  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _noteController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    // Add more phone validation if needed
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'New client',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: _submitForm,
            child: Text(
              'Save',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRequiredSection(),
                SizedBox(height: 24),
                _buildMoreOptionsButton(),
                if (_showMoreOptions) ..._buildMoreOptions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequiredSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'REQUIRED INFORMATION',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _nameController,
          label: 'Name',
          validator: _validateName,
          keyboardType: TextInputType.name,
          textCapitalization: TextCapitalization.words,
        ),
        SizedBox(height: 16),
        _buildTextField(
          controller: _phoneController,
          label: 'Phone number',
          validator: _validatePhone,
          keyboardType: TextInputType.phone,
          prefixText: '+964 ',
        ),
      ],
    );
  }

  Widget _buildMoreOptionsButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _showMoreOptions = !_showMoreOptions;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MORE OPTIONS',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            Icon(
              _showMoreOptions ? Icons.expand_less : Icons.expand_more,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMoreOptions() {
    return [
      SizedBox(height: 16),
      _buildTextField(
        controller: _locationController,
        label: 'Location',
        keyboardType: TextInputType.streetAddress,
      ),
      SizedBox(height: 16),
      _buildTextField(
        controller: _noteController,
        label: 'Note',
        keyboardType: TextInputType.multiline,
        maxLines: 3,
      ),
      SizedBox(height: 16),
      _buildBirthdayPicker(),
      SizedBox(height: 16),
      _buildContactsCheckbox(),
    ];
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? prefixText,
    int? maxLines,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        prefixText: prefixText,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blue),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
    );
  }

  Widget _buildBirthdayPicker() {
    String birthdayText = _selectedBirthday == null
        ? 'Select birthday'
        : DateFormat('MMM d, y').format(_selectedBirthday!);

    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedBirthday ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                  surface: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          setState(() {
            _selectedBirthday = picked;
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey[300]!),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Birthday',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            Row(
              children: [
                Text(
                  birthdayText,
                  style: TextStyle(
                    color: _selectedBirthday == null
                        ? Colors.grey[600]
                        : Colors.black,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.calendar_today, size: 20, color: Colors.grey[600]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsCheckbox() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: CheckboxListTile(
        title: Text(
          'Add to your contacts',
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 16,
          ),
        ),
        value: _addToContacts,
        onChanged: (bool? value) {
          setState(() {
            _addToContacts = value ?? false;
          });
        },
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Colors.blue,
      ),
    );
  }

  void _submitForm() {
    setState(() {
      _autoValidate = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      final clientProvider =
          Provider.of<ClientProvider>(context, listen: false);

      clientProvider.addClient(
        name: _nameController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
        note: _noteController.text.trim(),
        location: _locationController.text.trim(),
        birthday: _selectedBirthday,
        addToContacts: _addToContacts,
      );

      Navigator.pop(context, _nameController.text.trim());
    }
  }
}
