import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Hi, David',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.yellow,
                        size: 30,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore the world',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search places',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: Icon(Icons.filter_list),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popular places',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {},
                        child: Text('View all'),
                      ),
                      Row(
                        children: [
                          Text('Most Viewed'),
                          SizedBox(width: 16),
                          Text('Nearby'),
                          SizedBox(width: 16),
                          Text('Latest'),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Example of a place card
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: HorizontalCardList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class HorizontalCardList extends StatelessWidget {
  // Example list of image URLs (you can replace these with your own local images or assets)
  final List<String> imageUrls = [
    'assets/images/ADTEC.jpg',
    'assets/images/ADTEC.jpg',
    'assets/images/ADTEC.jpg',
    'assets/images/ADTEC.jpg',
    'assets/images/ADTEC.jpg',
 
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          200, // Adjust the height of the container based on your image size
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Makes the list horizontal
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Card(
              elevation: 5, // Card shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Rounded corners
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  imageUrls[index],
                  fit: BoxFit.cover, // Makes the image fill the space
                  width: 150, // Set the width of each card
                  height: 200, // Set the height of each card
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
