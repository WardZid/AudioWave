import 'package:audiowave6/view/secondary/AddAudio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/repositories/auth_repository_impl.dart';

class ProfilePage extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit_profile':
                  // Handle edit profile
                  break;
                case 'log_out':
                  _logout(context); // Call the logout function
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'edit_profile',
                  child: Text('Edit Profile'),
                ),
                const PopupMenuItem<String>(
                  value: 'log_out',
                  child: Text('Log Out'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/pfp_placeholder.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Username',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'user@example.com',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
                height:
                    24), // some space between the profile info and the button

            // Add button to upload new audio
            SizedBox(
              width: double.infinity, // Make the button full width
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, // To allow full-screen if needed
                    builder: (BuildContext context) {
                      return const AddAudioPage(); // add adio page
                    },
                  );
                },
                icon: const Icon(Icons.audiotrack),
                label: const Text('Add New Audio'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    // Access the AuthRepository
    final authRepository = AuthRepositoryImpl(http.Client());

    try {
      await authRepository.signOut();

      // onLogout callback to reset the index to 0 (home)
      onLogout();
    } catch (e) {
      // Handle errors (you could display a snackbar or an alert dialog here)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log out.')),
      );
    }
  }
}
