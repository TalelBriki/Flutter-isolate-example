import 'package:flutter/material.dart';
import 'package:flutter_isolates_demo/with_isolate.dart';
import 'package:flutter_isolates_demo/without_isolate.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("This button will run example for heavy computation without isolates"),
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.blue)
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WithoutIsolate()),
                  )
                },
                child: const Text("Without Isolate"),
              ),
              SizedBox(height: 20,),
              Text("This button will run example for heavy computation with isolates"),
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.lightGreen)
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const WithIsolate()),
                  )
                },
                child: const Text("With Isolate"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
