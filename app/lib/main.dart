import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

void main() {
  Get.lazyPut<ExpenseController>(() => ExpenseController());
  runApp(GetMaterialApp(
    initialRoute: "/",
    getPages: [
      GetPage(name: "/", page: () => HomeScreen()),
      GetPage(name: "/entry", page: () => EntryScreen()),
      GetPage(name: "/summary", page: () => SummaryScreen()),
    ]
  ));
}

class ExpenseController {
  final expenses = <String>[].obs;
  
  void add(String expense) {
    print("add expense function");
    expenses.add(expense);
    print("adding expense: ${expense}");
    print("all expenses now: ${expenses}");
  }
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
                child: Text("Entry"),
                onPressed: ()  => Get.to(() => EntryScreen()),
              ),
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

class EntryScreen extends StatelessWidget {
  static final _formKey = GlobalKey<FormBuilderState>();
  final expenseController = Get.find<ExpenseController>();

  _submit() {
    if (_formKey.currentState!.saveAndValidate()) {
      expenseController.add(_formKey.currentState?.value["expense"]);
      //_formKey.currentState?.reset();  // _clear();
    }
  }

  /*_clear() {
    _formKey.currentState?.reset();
  }*/

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(child: Text("Personal Finance Tracker")),
        ),
        body: Column(
          children: [
            Text("Enter expense below"),
            FormBuilderTextField(
              name: 'expense',
              decoration: InputDecoration(
                hintText: 'expense',
                border: OutlineInputBorder(),
              ),
              autovalidateMode: AutovalidateMode.always,
              validator: FormBuilderValidators.compose([FormBuilderValidators.required()]),
            ),
            FormBuilderRadioGroup(
              decoration: InputDecoration(labelText: 'Spending category'),
              name: 'category',
              validator: FormBuilderValidators.required(),
              options: ['Food', 'Drink', 'Clothes', 'Eating out']
                .map((item) => FormBuilderFieldOption(value: item))
                .toList(growable: false),
            ),
            Row(children: [
              ElevatedButton(
                onPressed: _submit,
                child: Text("Save"),
              ),
              /*ElevatedButton(
                onPressed: _clear,
                child: Text("Reset"),
              ),*/
            ]),
          ],
        ),
        bottomNavigationBar: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                child: Text("Home"),
                onPressed: ()  => Get.to(() => HomeScreen()),
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Center(child: Text("Personal Finance Tracker")),
        ),
        body: Center(
          child: Text('Summary'),
        ),
        bottomNavigationBar: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                child: Text("Home"),
                onPressed: ()  => Get.to(() => HomeScreen()),
              ),
            ]
          ),
        ),
      ),
    );
  }
}
