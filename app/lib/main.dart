import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await Hive.openBox("storage");
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
  final storage = Hive.box("storage");
  RxList expenseList;

  ExpenseController() : expenseList = [].obs {
    expenseList.value = storage.get('expenseList') ?? [];
  }
  
  void add(String expense, String category) {
    var newExpense = {'expense': expense, 'category': category};
    print("new expense: ${newExpense}");
    expenseList.add(newExpense);
    storage.put('expenseList', expenseList);
    Get.to(() => HomeScreen());
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
      expenseController.add(_formKey.currentState?.value["expense"],
                            _formKey.currentState?.value["category"],);
      _formKey.currentState?.reset();
    }
  }

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
            FormBuilder(
              key: _formKey,
              child: Column(
                children: [
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
                  ]),
                ]
              ),
            ),
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
  final expenseController = Get.find<ExpenseController>();

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
            Center(child: Text("Overview of expenses", style: TextStyle(height: 3, fontSize: 30))),
            //Column(children: expenseController.expenseList.map((item) => Text(item['category'])).toList()),
            //Column(children: expenseController.expenseList.map((item) => Text(item['expense'])).toList()),
            Column(children: [
              Row(children: [Text("Food"), Text("1")]),
              Row(children: [Text("Drink"), Text("2")]),
              Row(children: [Text("Clothes"), Text("3")]),
              Row(children: [Text("Eating out"), Text("4")]),
            ])  // var newExpense = {'expense': expense, 'category': category};
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
