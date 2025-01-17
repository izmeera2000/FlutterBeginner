import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Future<Database> initializeDatabase() async {
    final directory = await getDatabasesPath();
    final path = join(directory, 'my_database.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            age INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  static Future<void> insertUser(String name, int age) async {
    final db = await initializeDatabase();
    await db.insert(
      'users',
      {'name': name, 'age': age},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    final db = await initializeDatabase();
    return await db.query('users');
  }

}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Future<List<Map<String, dynamic>>> _users;

  @override
  void initState() {
    super.initState();
    _users = DatabaseHelper.fetchUsers(); // Fetch users on initialization

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[

    
          SizedBox(height: 20),
          // Add the ListView under the Container
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _users,  // The Future that fetches the users
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());  // Show loading indicator
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}')); // Handle error
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No users found.')); // No users found message
              } else {
                final users = snapshot.data!; // The data fetched (list of users)
                return ListView.builder(
                  shrinkWrap: true,  // Use shrinkWrap to make the ListView take only the space it needs
                  itemCount: users.length,  // Number of items in the list
                  itemBuilder: (context, index) {
                    final user = users[index];  // Get each user
                    return ListTile(
                      title: Text(user['name']),  // Display name
                      subtitle: Text('Age: ${user['age']}'),  // Display age
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  void _insertUser() async {
    await DatabaseHelper.insertUser("test", 1);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
           
          SizedBox(height: 20),
 
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Newpage(),
                  ),
                );
              },
              child: Text("sadasd")),
          
          ElevatedButton(
              onPressed: () {
                _insertUser();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('User added: test, Age: test')),
                );
              },
              child: Text("press"))
          // Add more content as needed
        ],
      ),
    );
  }
}

class Newpage extends StatefulWidget {
  const Newpage({super.key});

  @override
  State<Newpage> createState() => _NewpageState();
}

class _NewpageState extends State<Newpage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text('Some static content'),
            SizedBox(height: 20),
            Container(
              color: Colors.blue,
              height: 200,
            ),
            SizedBox(height: 20),
            Text('More static content'),
            SizedBox(height: 20),
            Container(
              color: Colors.green,
              height: 150,
            ),
            // Add more content as needed
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: _incrementCounter,
        //   tooltip: 'Increment',
        //   child: const Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
