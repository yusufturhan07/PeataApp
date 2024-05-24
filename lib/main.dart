import 'package:flutter/material.dart';
import 'package:mvc_uygun_peata_proje/controllers/adoption_controller.dart';
import 'package:provider/provider.dart';
import 'package:mvc_uygun_peata_proje/login_screen.dart';
import 'package:mvc_uygun_peata_proje/utils/global.dart';
import 'package:mvc_uygun_peata_proje/views/adoption/adoption_screen.dart';
import 'package:mvc_uygun_peata_proje/views/lost/lost_screen.dart';
import 'package:mvc_uygun_peata_proje/views/profile/profile_screen.dart';
import 'package:mvc_uygun_peata_proje/controllers/profile_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdoptionController()),
        ChangeNotifierProvider(create: (_) => ProfileController()),
      ],
      child: MaterialApp(
        home: LoginPage(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navigation Example',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    AdoptionScreen(),
    LostScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            const SliverAppBar(
              excludeHeaderSemantics: true,
              title: Align(
                alignment: Alignment.center,
                child: Text("P E A T A",
                    style: TextStyle(
                        color: Color(0xff0BDA51),
                        fontSize: 35,
                        fontWeight: FontWeight.w500)),
              ),
              automaticallyImplyLeading: false,
              floating: true,
              snap: true,
            ),
          ];
        },
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Adoption',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Lost',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: colorPeataYesili,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
