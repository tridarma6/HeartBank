import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simpan_pinjam/screens/user_model.dart';

class EditUserPage extends StatefulWidget {
  final UserModel user;
  
  const EditUserPage({Key? key, required this.user, required Null Function(dynamic editedUser) onUserEdited}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _dateOfBirthController;
  late TextEditingController _phoneNumberController;
  final Dio _dio = Dio();
  final _storage = GetStorage();
  
Future<void> saveUser() async {
  final String? authToken = _storage.read('token');
  if (authToken == null) {
    print('Token not available');
    return;
  }

  try {
    final response = await _dio.put(
      'https://mobileapis.manpits.xyz/api/anggota/${widget.user.id}',
      options: Options(
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'nama': _nameController.text,
        'alamat': _addressController.text,
        'tgl_lahir': _dateOfBirthController.text,
        'telepon': _phoneNumberController.text,
      },
    );

    if (response.statusCode == 200) {
      // Handle successful update of user
      Navigator.pop(context); // Go back to previous screen
    } else {
      print('Failed to update user: ${response.statusCode}');
      print('Response data: ${response.data}');
    }
  } catch (e) {
    print('Error: $e');
  }
}


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _addressController = TextEditingController(text: widget.user.address);
    _dateOfBirthController = TextEditingController(text: widget.user.dateOfBirth);
    _phoneNumberController = TextEditingController(text: widget.user.phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            TextField(
              controller: _dateOfBirthController,
              decoration: InputDecoration(labelText: 'Date of Birth'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                saveUser();
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
