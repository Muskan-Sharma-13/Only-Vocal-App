
import 'package:only_vocal/firebase_options.dart';
import 'package:only_vocal/models/song.dart';
import 'package:only_vocal/resources/user_provider.dart';
import 'package:only_vocal/resources/auth_methods.dart';
import 'package:only_vocal/screens/auth_screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_vocal/screens/rating_screen.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'screens/library_screen.dart';
import 'screens/profile_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

   try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Firebase initialized");
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      print("Firebase already initialized.");
    } else {
      rethrow;
    }
  }
  print("Firebase initialized");
  //await FirebaseAuth.instance.signOut();



  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print(user);
    
  //   if (user != null) {
  //   print("🔐 Logged in user:");
  //   print("UID: ${user.uid}");
  //   print("Email: ${user.email}");
  //   print("Display Name: ${user.username}");
  //   print("Phone Number: ${user.phoneNumber}");
  // } else {
  //   print("⚠️ No user is currently logged in.");
  // }
    return MultiProvider(providers: 
    [
      ChangeNotifierProvider(
        create: (_) => UserProvider(),
      ),
    ],
    child: MaterialApp(
      title: 'OnlyVocals4U',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1A1E3F),
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFD700),
          secondary: Color(0xFFFFD700),
          background: Color(0xFF121212),
          surface: Color(0xFF1A1E3F),
        ),
        textTheme: TextTheme(
          displayLarge: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
          ),
          displayMedium: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
          displaySmall: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            fontSize: 20,
            color: Colors.white,
          ),
          headlineMedium: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.white,
          ),
          headlineSmall: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.white,
          ),
          titleLarge: GoogleFonts.roboto(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.white,
          ),
          bodyLarge: GoogleFonts.roboto(
            fontWeight: FontWeight.normal,
            fontSize: 16,
            color: Colors.white,
          ),
          bodyMedium: GoogleFonts.roboto(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: Colors.white,
          ),
          labelLarge: GoogleFonts.roboto(
            fontWeight: FontWeight.w300,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF1A1E3F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFD700),
            foregroundColor: const Color(0xFF121212),
            textStyle: GoogleFonts.roboto(
              fontWeight: FontWeight.w300,
              fontSize: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      home: user != null
    ? MainScreen()
    : const LoginScreen(),
      // home: LoginScreen(),
    )
   );
  }

}

class MainScreen extends StatefulWidget {
  // final void Function(Song? song, {bool stop}) onSongSelected;

  const MainScreen({super.key});
  // const MainScreen({super.key, required this.onSongSelected});


  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    const SearchScreen(),
    const LibraryScreen(),
    ProfileScreen(),
    RatingScreen()
  ];

    @override
  void initState() {
    super.initState();
    Future.microtask(() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.refreshUserFromAuth(); // 👈 this loads Firestore user
  });

    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // userProvider.getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          _screens[_selectedIndex],
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 40, 44, 85),
        selectedItemColor: const Color(0xFFFFD700),
        unselectedItemColor: Colors.white.withOpacity(0.6),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review_outlined),
            label: 'Rate Us',
          ),
        ],
      ),
    );
  }
}
