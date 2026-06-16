import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> initialData;

  const EditProfilePage({super.key, required this.initialData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _titleController;
  late TextEditingController _aboutController;
  late TextEditingController _educationController;
  late TextEditingController _contactController;
  late TextEditingController _locationController;
  late String _avatarPath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData['name']);
    _titleController = TextEditingController(text: widget.initialData['title']);
    _aboutController = TextEditingController(text: widget.initialData['about']);
    _educationController = TextEditingController(text: widget.initialData['education']);
    _contactController = TextEditingController(text: widget.initialData['contact']);
    _locationController = TextEditingController(text: widget.initialData['location']);
    _avatarPath = widget.initialData['avatarUrl'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _titleController.dispose();
    _aboutController.dispose();
    _educationController.dispose();
    _contactController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _avatarPath = pickedFile.path;
      });
    }
  }

  Widget _buildAvatarPreview() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      child: ClipOval(
        child: _avatarPath.startsWith('http') || kIsWeb
            ? Image.network(
                _avatarPath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 50),
              )
            : Image.file(
                File(_avatarPath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.person, size: 50),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.pop(context, {
                'name': _nameController.text,
                'title': _titleController.text,
                'about': _aboutController.text,
                'education': _educationController.text,
                'contact': _contactController.text,
                'location': _locationController.text,
                'avatarUrl': _avatarPath,
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  _buildAvatarPreview(),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Pekerjaan/Status'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _aboutController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Tentang Saya'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _educationController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Pendidikan'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contactController,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Kontak'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(labelText: 'Lokasi'),
            ),
          ],
        ),
      ),
    );
  }
}
