import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:async';

void main() {
  runApp(LeaderboardApp());
}

class Item {
  final String name;
  final int emission;

  Item({
    required this.name,
    required this.emission,
  });
}

class DailyInput {
  final DateTime date;
  final String employeeName;
  final int emission;

  DailyInput({
    required this.date,
    required this.employeeName,
    required this.emission,
  });
}

class Employee {
  final String name;
  final List<Item> items;

  Employee({
    required this.name,
    required this.items,
  });

  int get totalEmission => items.fold(0, (sum, item) => sum + item.emission);
}

class LeaderboardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CarbonCutters',
      home: LeaderboardPage(),
      theme: ThemeData(
        primaryColor: Color(0xFFE1BEE7),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xFFC8E6C9)),
        scaffoldBackgroundColor: Color(0xFFB7E4C7),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class LeaderboardPage extends StatefulWidget {
  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  int _selectedIndex = 0;
  final List<Employee> _employees = [
    Employee(name: "Employee1", items: []),
    Employee(name: "Employee2", items: []),
    Employee(name: "Employee3", items: []),
    Employee(name: "Employee4", items: []),
    Employee(name: "Employee5", items: []),
  ];

  late Timer _timer;
  late List<int> _dailyTotals = List.filled(365, 0);

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(days: 1), (_) {
      _refreshLeaderboard();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CarbonCutters'),
      ),
    body: ListView(
    children: [
    Padding(
    padding: EdgeInsets.all(16.0),
    child: AspectRatio(
    aspectRatio: 1.5,
    child: LineChart(
    _buildChart(),
    ),
    ),
    ),
    SizedBox(height: 16), // Add some spacing between the chart and leaderboard
    Container(
    height: MediaQuery.of(context).size.height * 0.5, // Adjust height as needed
      child: _selectedIndex == 0
          ? LeaderboardScreen(employees: _employees)
          : _selectedIndex == 1
          ? AddItemScreen(
        employees: _employees,
        updateLeaderboard: _updateLeaderboard,
      )
          : Container(
        child: Center(
          child: Text(_selectedIndex == 2
              ? 'Edit Item Screen'
              : 'Settings Screen'),
        ),
      ),

    ),
    ],
    ),
    bottomNavigationBar: BottomNavigationBar(
    currentIndex: _selectedIndex,
    onTap: _onItemTapped,
    backgroundColor: Theme.of(context).primaryColor,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.black,
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.leaderboard),
        label: 'Leaderboard',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.add),
    label: 'add Item',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.edit),
    label: 'Edit Item',
    ),
    BottomNavigationBarItem(
    icon: Icon(Icons.settings),
    label: 'Settings',
    ),
    ],
    ),
    );
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return LeaderboardScreen(employees: _employees);
      case 1:
        return AddItemScreen(
          employees: _employees,
          updateLeaderboard: _updateLeaderboard,
        );
      case 2:
        return Container(
          child: Center(
            child: Text('Edit Item Screen'),
          ),
        ); // Placeholder widget for Edit Item screen
      case 3:
        return Container(
          child: Center(
            child: Text('Settings Screen'),
          ),
        );
      default:
        return Container();
    }
  }

  void _updateLeaderboard() {
    setState(() {});
  }

  void _refreshLeaderboard() {
    final dailyTotal = _employees.fold(
        0, (sum, employee) => sum + employee.totalEmission);
    _dailyTotals.add(dailyTotal);
    _dailyTotals.removeAt(0);

    _employees.forEach((employee) {
      employee.items.clear();
    });
    setState(() {});
  }

  LineChartData _buildChart() {
    return LineChartData(
      titlesData: FlTitlesData(
        bottomTitles: SideTitles(
          showTitles: true,
          getTitles: (value) {
            return (value.toInt() + 1).toString();
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
        ),
      ),
      borderData: FlBorderData(show: true),
      gridData: FlGridData(show: true),
      lineBarsData: [
        LineChartBarData(
          spots: _dailyTotals
              .asMap()
              .entries
              .map((entry) => FlSpot(entry.key.toDouble(), entry.value.toDouble()))
              .toList(),
          isCurved: true,
          colors: [Colors.blue],
          barWidth: 4,
          isStrokeCapRound: true,
          belowBarData: BarAreaData(show: false),
        ),
      ],
    );
  }
}

class LeaderboardScreen extends StatelessWidget {
  final List<Employee> employees;

  LeaderboardScreen({required this.employees});

  @override
  Widget build(BuildContext context) {
    // Sort employees by emission
    employees.sort((a, b) => a.totalEmission.compareTo(b.totalEmission));

    return ListView.builder(
      itemCount: employees.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(child: Text('${index + 1}')),
          title: Text(employees[index].name),
          subtitle: Text('Emission: ${employees[index].totalEmission}'),
        );
      },
    );
  }
}

class AddItemScreen extends StatefulWidget {
  final List<Employee> employees;
  final VoidCallback updateLeaderboard;

  AddItemScreen({required this.employees, required this.updateLeaderboard});

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  late Employee _selectedEmployee;
  late String _itemName;
  late int _emission;

  @override
  void initState() {
    super.initState();
    _selectedEmployee = widget.employees.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButton<Employee>(
              value: _selectedEmployee,
              onChanged: (Employee? newValue) {
                setState(() {
                  _selectedEmployee = newValue!;
                });
              },
              items: widget.employees
                  .map<DropdownMenuItem<Employee>>((Employee value) {
                return DropdownMenuItem<Employee>(
                  value: value,
                  child: Text(value.name),
                );
              }).toList(),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _itemName = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Item Name',
              ),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  _emission = int.tryParse(value) ?? 0;
                });
              },
              decoration: InputDecoration(
                labelText: 'Emission',
              ),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () {
                // Add the item to the selected employee
                _selectedEmployee.items.add(
                    Item(name: _itemName, emission: _emission));
                // Update the leaderboard
                widget.updateLeaderboard();
                // Navigate back
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}

