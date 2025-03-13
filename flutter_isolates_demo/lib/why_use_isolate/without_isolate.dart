import 'package:flutter/material.dart';

import '../widgets/custom_annimation.dart';



class WithoutIsolate extends StatefulWidget {
  const WithoutIsolate({super.key});

  @override
  State<WithoutIsolate> createState() => _WithoutIsolateState();
}

class _WithoutIsolateState extends State<WithoutIsolate> {
  String _result = "Tap a button to start";
  Color _containerColor=Colors.red;
  void _runHeavyTask() {
    setState(() {
      _result = "Processing...";
    });

    int sum = 0;
    for (int i = 0; i < 500000000; i++) {
      sum += i;
    }

    setState(() {
      _result = "Task completed! Sum: $sum";
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Isolates Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_result, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _runHeavyTask,
              child: const Text("Run Task"),
            ),
            SizedBox(height: 20,),
            CustomAnnimation(),

          ],
        ),
      ),
    );
  }
}
