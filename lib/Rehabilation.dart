
import 'package:exoskeleton_suit_app/Manual.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const Rehabilation());
}

class Rehabilation extends StatefulWidget {
  const Rehabilation({super.key});

  @override
  State<Rehabilation> createState() => _RehabilationState();
}

class _RehabilationState extends State<Rehabilation> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exoskeleton Suit App',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color.fromARGB(212, 7, 158, 213),
        appBar: AppBar(
        title: Center(child: Text('Basic Modes',
                          style: TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Golos_Text',),
                          )),
        leading: IconButton(
          icon: Icon(Icons.home_outlined),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        ),
        body: Stack(
  children: [
    // Background image
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.jpg'), // replace with your image path
          fit: BoxFit.cover,
        ),
      ),
    ),
    Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 18),
                child: ElevatedButton(onPressed: (){
                  Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Manual()),
  );
                }, child: Text("Rehabilation",style: TextStyle(
                  fontFamily: 'Pacifico',
                   fontSize: 20
                   ),
                   ),
                ),
              
                ),],
                ),
                ),
  ],
                ),
        ),
    );
  }
}


