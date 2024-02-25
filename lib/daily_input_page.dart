import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Data model for daily input
class DailyInput {
  final DateTime date;
  final String employeeName;
  final int emission;

  DailyInput({required this.date, required this.employeeName, required this.emission});
}

// Provider for managing daily input data
class DailyInputProvider extends ChangeNotifier {
  List<DailyInput> _dailyInputs = [];

  List<DailyInput> get dailyInputs => _dailyInputs;

  void addDailyInput(DailyInput input) {
    _dailyInputs.add(input);
    notifyListeners();
  }
}

class DailyInputPage extends StatefulWidget {
  @override
  _DailyInputPageState createState() => _DailyInputPageState();
}
class _DailyInputPageState extends State<DailyInputPage> {
  final _formKey = GlobalKey<FormState>();
  String _employeeName = '';
  int _usageDuration = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Employee Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _employeeName = value!;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Item Usage Duration (minutes)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter usage duration';
                  }
                  return null;
                },
                onSaved: (value) {
                  _usageDuration = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    // Here, you can do whatever you want with the collected data, such as calling an API to calculate emission.
                    // After calculating emission, you can add the daily input to the provider.
                    Provider.of<DailyInputProvider>(context, listen: false).addDailyInput(
                      DailyInput(
                        date: DateTime.now(),
                        employeeName: _employeeName,
                        emission: _calculateEmission(_usageDuration), // Assuming you have a method to calculate emission
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Daily input submitted successfully!'),
                    ));
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // This is a placeholder for calculating emission based on usage duration.
  int _calculateEmission(int usageDuration) {
    // You can implement your own logic here to calculate emission based on the usage duration.
    // For now, let's just return a random value.
    return usageDuration * 2;
  }
}

