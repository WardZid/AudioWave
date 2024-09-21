// main.dart
import 'package:audiowave6/data/repositories/metadata_repository_impl.dart';
import 'package:audiowave6/domain/repositories/metadata_repository.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/playback_repository.dart';
import 'data/repositories/playback_repository_impl.dart';
import 'services/audio_player_service.dart';
import 'view/Helpers/now_playing_bar.dart';
import 'view/Home.dart';
import 'view/secondary/Login.dart';
import 'view/Explore.dart';
import 'view/PlaylistsPage.dart';
import 'view/Profile.dart';

void main() {
  final AuthRepository authRepository = AuthRepositoryImpl(http.Client());
  
  final PlaybackRepository playbackRepository =
      PlaybackRepositoryImpl(http.Client());
  final MetadataRepository metadataRepository =
      MetadataRepositoryImpl(http.Client());

  final audioPlayerService = AudioPlayerService();
  audioPlayerService.initialize(playbackRepository, metadataRepository);

  runApp(MainApp(authRepository: authRepository));
}

class MainApp extends StatelessWidget {
  final AuthRepository authRepository;

  const MainApp({Key? key, required this.authRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audiowave',
      theme: ThemeData(
        primarySwatch: Colors.lime,
      ),
      home: MyHomePage(authRepository: authRepository),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final AuthRepository authRepository;

  const MyHomePage({Key? key, required this.authRepository}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  bool _isSignedIn = false;

  late final List<Widget> _pages = <Widget>[
    const HomePage(),
    const ExplorePage(),
    PlaylistsPage(),
    ProfilePage(onLogout: _handleLogout),
  ];

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  Future<void> _checkSignInStatus() async {
    _isSignedIn = await widget.authRepository.isSignedIn();
    setState(() {});
  }

  void _handleLogout() {
    setState(() {
      _isSignedIn = false;
      _selectedIndex = 0;
    });
  }

  void _onItemTapped(int index) async {
    _isSignedIn = await widget.authRepository.isSignedIn();
    if ((index == 2 || index == 3) && !_isSignedIn) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignIn()),
      );

      if (result == true) {
        setState(() {
          _isSignedIn = true;
          _selectedIndex = index;
        });
      }
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _pages[_selectedIndex]),
          NowPlayingBar(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: 'Playlists'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
