import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Client {
  final String id;
  final String name;
  final String phoneNumber;
  final String? note;
  final String? location;
  final DateTime? birthday;
  final bool addToContacts;

  Client({
    required this.id,
    required this.name,
    required this.phoneNumber,
    this.note,
    this.location,
    this.birthday,
    this.addToContacts = false,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] as String,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      note: json['note'] as String?,
      location: json['location'] as String?,
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      addToContacts: json['addToContacts'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'note': note,
      'location': location,
      'birthday': birthday?.toIso8601String(),
      'addToContacts': addToContacts,
    };
  }

  Client copyWith({
    String? id,
    String? name,
    String? phoneNumber,
    String? note,
    String? location,
    DateTime? birthday,
    bool? addToContacts,
  }) {
    return Client(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      note: note ?? this.note,
      location: location ?? this.location,
      birthday: birthday ?? this.birthday,
      addToContacts: addToContacts ?? this.addToContacts,
    );
  }
}

class ClientProvider with ChangeNotifier {
  List<Client> _clients = [];
  
  List<Client> get clients => List.unmodifiable(_clients);

  ClientProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    // Add some dummy data
    _clients = [
      Client(
        id: '1',
        name: 'Ahmed',
        phoneNumber: '+1234567890',
        location: 'Baghdad',
      ),
      Client(
        id: '2',
        name: 'Sarah',
        phoneNumber: '+9876543210',
        note: 'Regular customer',
        location: 'Erbil',
      ),
    ];
    notifyListeners();
  }

  Future<void> addClient({
    required String name,
    required String phoneNumber,
    String? note,
    String? location,
    DateTime? birthday,
    bool addToContacts = false,
  }) async {
    final newClient = Client(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      phoneNumber: phoneNumber,
      note: note,
      location: location,
      birthday: birthday,
      addToContacts: addToContacts,
    );

    _clients.add(newClient);
    notifyListeners();
  }

  Future<void> updateClient(Client updatedClient) async {
    final index = _clients.indexWhere((client) => client.id == updatedClient.id);
    if (index != -1) {
      _clients[index] = updatedClient;
      notifyListeners();
    }
  }

  Future<void> deleteClient(String clientId) async {
    _clients.removeWhere((client) => client.id == clientId);
    notifyListeners();
  }

  Client? getClientById(String id) {
    try {
      return _clients.firstWhere((client) => client.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Client> searchClients(String query) {
    if (query.isEmpty) return _clients;
    
    final lowercaseQuery = query.toLowerCase();
    return _clients.where((client) {
      return client.name.toLowerCase().contains(lowercaseQuery) ||
             client.phoneNumber.contains(query);
    }).toList();
  }
}