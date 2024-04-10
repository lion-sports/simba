import 'package:flutter/material.dart';

class Profile  extends StatefulWidget {
   const Profile({super.key,required this.title});
   final String title;
   

 @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final List<String> images = [
    '../static/img_1.jpg',
    '../static/img_2.jpg',
    '../static/img_3.jpg',
    '../static/img_4.jpg',
    '../static/img_5.jpg',
    
    // Add more image paths as needed
  ];
    return Scaffold(
      
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Filippo Passalacqua'),
              background: Image.asset(
                '../static/img_3.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage('../static/img_2.jpg'),
                    ),
                    const  SizedBox(height: 16),
                    const  Text(
                      'Basketball player',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Add logout functionality here
                        Navigator.pop(context); // Navigate back to the previous screen
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                child: const  Text(
                  'My Photos',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const  EdgeInsets.all(8),
                      width: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(images[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

