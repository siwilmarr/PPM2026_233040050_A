import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'gallery_widget.dart';
import 'edit_profile_page.dart';
import 'edit_experience_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // State data profil
  String name = 'PADUKA SIWILLL';
  String title = 'Mahasiswa Teknik Informatika';
  String avatarUrl = 'https://avatars.githubusercontent.com/u/146063726';
  String about = 'Saya suka belajar hal baru, terutama yang berkaitan dengan teknologi dan pengembangan aplikasi mobile.';
  String education = 'Universitas Pasundan — Semester 6\nIPK: 3.99';
  String contact = 'email@example.com\n+62 812-3456-7890';
  String location = 'Bandung, Indonesia';

  // State data list pengalaman
  List<Map<String, String>> experiences = [
    {
      'title': 'Magang Web Developer',
      'description': 'Mengembangkan fitur dashboard admin menggunakan React dan Node.js selama 3 bulan.',
      'imageUrl': 'https://plus.unsplash.com/premium_photo-1661290256852-350162520539?q=80&w=2070&auto=format&fit=crop',
    }
  ];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        avatarUrl = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            const ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context); // tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryHome()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.work_history),
              title: const Text('Upload Pengalaman'),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditExperiencePage(
                      initialData: {
                        'title': '',
                        'description': '',
                        'imageUrl': '',
                      },
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    experiences.add({
                      'title': result['title'],
                      'description': result['description'],
                      'imageUrl': result['imageUrl'],
                    });
                  });
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Pengaturan'),
                    content: const Text('Halaman pengaturan belum tersedia.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === HEADER PROFIL ===
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[200],
                        ),
                        child: ClipOval(
                          child: avatarUrl.startsWith('http') || kIsWeb
                              ? Image.network(
                                  avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person, size: 50),
                                )
                              : Image.file(
                                  File(avatarUrl),
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.person, size: 50),
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // === BARIS STATISTIK (Row + Expanded) ===
            Row(
              children: [
                Expanded(child: _StatBox(label: 'Post', value: '1')),
                Expanded(child: _StatBox(label: 'Teman', value: '20')),
                Expanded(child: _StatBox(label: 'Like', value: '1.2M')),
              ],
            ),
            const SizedBox(height: 24),
            // === SECTION CARDS ===
            _SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content: about,
            ),
            _SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: education,
            ),
            _SectionCard(
              icon: Icons.location_on,
              title: 'Lokasi',
              content: location,
            ),
            _SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content: contact,
            ),
            // === TUGAS MANDIRI 3: SKILLS ===
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.blue),
                        SizedBox(width: 16),
                        Text('Skills',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: const [
                        Chip(label: Text('Flutter')),
                        Chip(label: Text('Dart')),
                        Chip(label: Text('UI Design')),
                        Chip(label: Text('Firebase')),
                        Chip(label: Text('Git')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // === SECTION PENGALAMAN (LIST) ===
            ...experiences.asMap().entries.map((entry) {
              int index = entry.key;
              Map<String, String> exp = entry.value;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditExperiencePage(
                          initialData: exp,
                        ),
                      ),
                    );
                    if (result != null) {
                      setState(() {
                        experiences[index] = {
                          'title': result['title'],
                          'description': result['description'],
                          'imageUrl': result['imageUrl'],
                        };
                      });
                    }
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (exp['imageUrl']!.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                            child: kIsWeb || exp['imageUrl']!.startsWith('http')
                                ? Image.network(
                                    exp['imageUrl']!,
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 150,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image, size: 50),
                                    ),
                                  )
                                : Image.file(
                                    File(exp['imageUrl']!),
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => Container(
                                      height: 150,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.broken_image, size: 50),
                                    ),
                                  ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.work, color: Colors.blue),
                                      SizedBox(width: 16),
                                      Text('Pengalaman',
                                          style: TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Icon(Icons.edit, size: 20, color: Colors.grey),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                exp['title']!,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                exp['description']!,
                                style: const TextStyle(height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: 80), // ruang agar FAB tidak nutupi konten
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditProfilePage(
                initialData: {
                  'name': name,
                  'title': title,
                  'avatarUrl': avatarUrl,
                  'about': about,
                  'education': education,
                  'contact': contact,
                  'location': location,
                },
              ),
            ),
          );
          if (result != null) {
            setState(() {
              name = result['name'];
              title = result['title'];
              avatarUrl = result['avatarUrl'];
              about = result['about'];
              education = result['education'];
              contact = result['contact'];
              location = result['location'];
            });
          }
        },
        child: const Icon(Icons.edit),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profil'),
          NavigationDestination(icon: Icon(Icons.message), label: 'Pesan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        onDestinationSelected: (i) {},
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.grey.shade600)),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  const _SectionCard(
      {required this.icon, required this.title, required this.content});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(content, style: const TextStyle(height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}