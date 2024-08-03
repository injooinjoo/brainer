import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user!;
    _nameController = TextEditingController(text: user.name);
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = image;
      });
    }
  }

  void _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final user = userProvider.user!;

    user.name = _nameController.text;

    if (_image != null) {
      // TODO: Upload image to Firebase Storage and get URL
      // user.photoUrl = uploadedImageUrl;
    }

    await userProvider.updateUser(user);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user!;

    return Scaffold(
      appBar: AppBar(
        title: Text('프로필 편집'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(File(_image!.path))
                    : (user.photoUrl != null
                            ? NetworkImage(user.photoUrl!)
                            : AssetImage('assets/default_avatar.png'))
                        as ImageProvider,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: '이름'),
            ),
          ],
        ),
      ),
    );
  }
}
