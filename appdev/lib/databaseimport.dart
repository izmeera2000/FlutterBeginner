import 'package:flutter/material.dart';
import 'simpledbhelper.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future _users = DatabaseHelper.fetchUsers();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FutureBuilder (
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found.'));
          } 
          return ListView.builder(
            shrinkWrap: true,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final user = snapshot.data![index];
              return ListTile(
                title: Text(user['name']),
                subtitle: Text('Age: ${user['age']}'),
              );
            },
          );
        },
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  void _insertUser(BuildContext context) async {
    await DatabaseHelper.insertUser("test", 1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User added: test, Age: 1')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewPage()),
          ),
          child: Text("Go to New Page"),
        ),
        ElevatedButton(
          onPressed: () => _insertUser(context),
          child: Text("Insert User"),
        ),
      ],
    );
  }
}

class NewPage extends StatelessWidget {
  const NewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Main Page')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text('Some static content'),
            SizedBox(height: 20),
            Container(color: Colors.blue, height: 200),
            SizedBox(height: 20),
            Text('More static content'),
            SizedBox(height: 20),
            Container(color: Colors.green, height: 150),
          ],
        ),
      ),
    );
  }
}
