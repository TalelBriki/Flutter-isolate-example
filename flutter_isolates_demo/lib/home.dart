import 'package:flutter/material.dart';
import 'package:flutter_isolates_demo/background_plugin_isolates.dart';
import 'package:flutter_isolates_demo/with_isolate.dart';
import 'package:flutter_isolates_demo/without_isolate.dart';

import 'communication_isolates.dart';
import 'examples.dart';

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
              SizedBox(height: 20,),
              Text("This simple and easy-to-understand example of communication between two isolates in Flutter"),
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.indigoAccent)
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) =>  IsolateCommunicationScreen()),
                  )
                },
                child: const Text("Communnication inter-isolate"),
              ),

              SizedBox(height: 20,),

              Text("background isolate channels"),
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.greenAccent)
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const BackgroundPluginIsolates()),
                  )
                },
                child: const Text("Rbackground isolate channels"),
              ),
              SizedBox(height: 20,),

              Text("This are real life examples for isoalte"),
              ElevatedButton(
                style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.indigoAccent)
                ),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RealLifeExamples()),
                  )
                },
                child: const Text("Real life examples"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
