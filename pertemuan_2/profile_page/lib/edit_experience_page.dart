import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

class EditExperiencePage extends StatefulWidget {
  final Map<String, dynamic> initialData;

  const EditExperiencePage({super.key, required this.initialData});

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialData['title']);
    _descriptionController = TextEditingController(text: widget.initialData['description']);
    _imageUrl = widget.initialData['imageUrl'];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  void _save() {
    Navigator.pop(context, {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'imageUrl': _imageUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF5D5D91); // Purple-ish color from image

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Upload Pengalaman',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        actions: [
          TextButton.icon(
            onPressed: _save,
            icon: Icon(Icons.save, size: 18, color: primaryColor),
            label: Text('Simpan', style: TextStyle(color: primaryColor)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Area Upload Gambar
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F0FF), // Light purple background
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD1C4E9), width: 1),
                ),
                child: _imageUrl.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              size: 48, color: primaryColor),
                          const SizedBox(height: 8),
                          Text(
                            'Ketuk untuk pilih gambar',
                            style: TextStyle(
                                color: primaryColor, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            'dari galeri perangkat kamu',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: kIsWeb || _imageUrl.startsWith('http')
                            ? Image.network(_imageUrl,
                                fit: BoxFit.cover, width: double.infinity)
                            : Image.file(File(_imageUrl),
                                fit: BoxFit.cover, width: double.infinity),
                      ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Informasi Pengalaman',
              style: TextStyle(
                  color: primaryColor, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 16),
            // Input Judul
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul *',
                prefixIcon: const Icon(Icons.title),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Input Deskripsi
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Deskripsi',
                alignLabelWithHint: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 80), // Adjust icon position
                  child: Icon(Icons.description),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Tombol Simpan Bawah
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                icon: const Icon(Icons.save),
                label: const Text('Simpan Pengalaman'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
