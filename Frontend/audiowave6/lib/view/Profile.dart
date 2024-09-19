import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/repositories/auth_repository_impl.dart';
import '../data/repositories/metadata_repository_impl.dart';
import '../domain/entities/audio.dart';
import '../domain/entities/user.dart';
import '../utils/storage_utils.dart';
import '../view/secondary/AddAudio.dart';
import 'Helpers/audio_card.dart';
import 'Helpers/audio_tile.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.onLogout});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late MetadataRepositoryImpl metadataRepository;
  late AuthRepositoryImpl authRepository;
  late Future<List<Audio>> audioListFuture;
  late Future<User?> userInfoFuture;

  @override
  void initState() {
    super.initState();
    metadataRepository = MetadataRepositoryImpl(http.Client());
    authRepository = AuthRepositoryImpl(http.Client());

    userInfoFuture = fetchUserInfo();
    audioListFuture = fetchAudioList();
  }

  Future<List<Audio>> fetchAudioList() async {
  try {
    String? userId = await StorageUtils.getUserId();
    if (userId == null) {
      throw Exception("User not found");
    }

    return await metadataRepository.getAudiosByUser(int.parse(userId));
  } catch (e) {
    return [];
  }
}


  Future<User?> fetchUserInfo() async {
    try {
      String? userId = await StorageUtils.getUserId();
      if(userId == null){
        throw new Exception("user not found");
      }
      int parseUserId = int.parse(userId);
      
      return await authRepository.getUserInfo(parseUserId);


    } catch (e) {
      print("ERROR");
      print(e);
      return null;
    }
  }

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
                  _logout(context);
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
            FutureBuilder<User?>(
              future: userInfoFuture, // Fetch the user info
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Center(child: Text('Failed to load user info'));
                }

                // If user info is loaded successfully
                final user = snapshot.data!;
                return Row(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('assets/pfp_placeholder.png'),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.username, // Display username
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email, // Display emai;
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // button to upload new audio
            SizedBox(
              width: double.infinity, // full width
              child: ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true, //allow full-screen if needed
                    builder: (BuildContext context) {
                      return AddAudioPage(metadataRepository: new MetadataRepositoryImpl(http.Client()),); 
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

            const SizedBox(height: 24),

            // Fetch and display audio list
            Expanded(
              child: FutureBuilder<List<Audio>>(
                future: audioListFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError || snapshot.data == null) {
                    return const Center(child: Text('Failed to load audios'));
                  }

                  final audios = snapshot.data!;
                  if (audios.isEmpty) {
                    return const Center(child: Text('No audios available'));
                  }

                  return ListView.builder(
                    itemCount: audios.length,
                    itemBuilder: (context, index) {
                      final audio = audios[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: AudioTile(
                          audio: audio,
                          onTap: () {
                            // Handle card tap
                            print('Audio card tapped for ${audio.title}');
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final authRepository = AuthRepositoryImpl(http.Client());

    try {
      await authRepository.signOut();
      widget.onLogout(); // Trigger the onLogout callback
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log out.')),
      );
    }
  }
}
