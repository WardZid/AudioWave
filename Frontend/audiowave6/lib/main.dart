import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'utils/storage_utils.dart';
import 'view/Home.dart';
import 'view/Login.dart';
import 'view/Explore.dart';
import 'view/Saved.dart';
import 'view/Profile.dart';

void main() {
  final AuthRepository authRepository = AuthRepositoryImpl(http.Client());
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

  late final List<Widget> _pages= <Widget>[
      const HomePage(),
      const ExplorePage(),
      const SavedPage(),
      ProfilePage(onLogout: _handleLogout), // Pass the logout callback
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
      _selectedIndex = 0; // Set to Home when logging out
    });
  }

  void _onItemTapped(int index) async {
    _isSignedIn = await widget.authRepository.isSignedIn();
    print('signed in: $_isSignedIn');
    if ((index == 2 || index == 3) && _isSignedIn == false) {
      // If the user is not signed in and tries to access the saved page, show login screen
      final result = await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const SignIn(),
          
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0); // Start from bottom of the screen
            const end = Offset.zero; // End at the center (no offset)
            const curve = Curves.easeInOut; // Define a smooth curve

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );

      if (result == true) {
        // Sign-in was successful, update state
        setState(() {
          _isSignedIn = true;
          _selectedIndex = index; // go to the selected index if signed in
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
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
