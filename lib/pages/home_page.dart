import 'package:flutter/material.dart';
import 'package:fp_games/pages/games_page.dart';
import 'package:fp_games/pages/profile_page.dart';
import 'package:fp_games/pages/review_page.dart';
import 'package:fp_games/routes/router_name.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "";

  void getUsername() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      username = pref.getString('username')!;
    });
  }

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  List<String> header = [
    "Home",
    "Reviews",
    "Profile",
  ];
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    GamesPage(),
    ReviewPage(),
    ProfilePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/profile.JPG'),
                  ),
                  SizedBox(height: 10),
                  Text(username,
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              )),
          ListTile(
            leading: Icon(Icons.book),
            title: Text("Bookmarks"),
            onTap: () => {
              Navigator.pushNamed(context, RouterName.bookmark),
            },
          ),
          ListTile(
            leading: Icon(Icons.upgrade),
            title: Text("Upgrade to Pro"),
            onTap: () => {
              Navigator.pushNamed(context, RouterName.upgrade),
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.alarm),
            title: Text("Timezone Access Now"),
            onTap: () => {
              Navigator.pushNamed(context, RouterName.timezone),
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout"),
            onTap: () async {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.remove('userId');
              pref.remove('username');
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
          ),
        ],
      )),
      appBar: AppBar(
        elevation: _selectedIndex == 2 ? 0 : 4,
        title: Text(header[_selectedIndex]),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rate_review),
            label: 'Reviews',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
