import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(GetMaterialApp(
    initialRoute: "/",
    getPages: [
      GetPage(name: "/", page: () => HomeScreen()),
      GetPage(name: "/summary", page: () => SummaryScreen()),
    ]
  ));
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(child: Text("Personal Finance Tracker")),
        ),
        body: Center(
          child: Text('Personal Finance Tracker'),
        ),
        bottomNavigationBar: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                child: Text("Summary"),
                onPressed: ()  => Get.to(() => SummaryScreen()),
              ),
            ]
          ),
        ),
      ),
    );
  }
}

class SummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Summary'),
        ),
      ),
    );
  }
}
